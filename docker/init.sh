#!/usr/bin/env bash
set -euo pipefail

# ---- root-safe state dir policy ----
if [ "${EUID:-$(id -u)}" -eq 0 ]; then
  if [ -z "${OPENCLAW_CONFIG_DIR:-}" ]; then
    echo "ERROR: Running as root requires OPENCLAW_CONFIG_DIR (do not rely on ~ => /root)."
    echo "Example:"
    echo "  OPENCLAW_CONFIG_DIR=/var/lib/openclaw OPENCLAW_WORKSPACE_DIR=/var/lib/openclaw/workspace bash docker/init.sh"
    exit 1
  fi
fi

OPENCLAW_CONFIG_DIR="${OPENCLAW_CONFIG_DIR:-$HOME/.openclaw}"
OPENCLAW_WORKSPACE_DIR="${OPENCLAW_WORKSPACE_DIR:-$OPENCLAW_CONFIG_DIR/workspace}"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE="$ROOT/config/openclaw.baseline.json"
OUT="$OPENCLAW_CONFIG_DIR/openclaw.json"

# docker command (supports systems where docker requires sudo)
DOCKER="docker"
if ! docker ps >/dev/null 2>&1; then
  DOCKER="sudo docker"
fi

echo "[info] OPENCLAW_CONFIG_DIR=$OPENCLAW_CONFIG_DIR"
echo "[info] OPENCLAW_WORKSPACE_DIR=$OPENCLAW_WORKSPACE_DIR"

mkdir -p "$OPENCLAW_CONFIG_DIR" "$OPENCLAW_WORKSPACE_DIR"

# --- token generation with fallbacks (minimal change) ---

generate_token() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex 32
    return 0
  fi

  if command -v python3 >/dev/null 2>&1; then
    python3 - <<'PY'
import secrets
print(secrets.token_hex(32))
PY
    return 0
  fi

  if [[ -r /dev/urandom ]] && command -v xxd >/dev/null 2>&1; then
    head -c 32 /dev/urandom | xxd -p -c 256
    return 0
  fi

  return 1
}

TOKEN="$(generate_token)" || {
  echo "[ERROR] Cannot generate token: need openssl or python3 (or /dev/urandom + xxd)." >&2
  exit 1
}
# --- end token generation ---

# Generate token (64 hex chars)
#TOKEN="$(python3 - <<'PY'
#import secrets
#print(secrets.token_hex(32))
#PY
#)"

# Render template (no jq dependency)
sed \
  -e "s|{{OPENCLAW_WORKSPACE_DIR}}|$OPENCLAW_WORKSPACE_DIR|g" \
  -e "s|{{OPENCLAW_GATEWAY_TOKEN}}|$TOKEN|g" \
  "$TEMPLATE" > "$OUT"

# Ensure container user (node uid=1000) can read/write host state dir
# (safe if sudo not available)
sudo chown -R 1000:1000 "$OPENCLAW_CONFIG_DIR" >/dev/null 2>&1 || true

# Prevent dual token sources: disable OPENCLAW_GATEWAY_TOKEN in upstream .env if present
UPSTREAM_ENV="$ROOT/vendor/openclaw/.env"
if [ -f "$UPSTREAM_ENV" ]; then
  # comment out (do not delete) to keep it reversible
  if grep -q '^OPENCLAW_GATEWAY_TOKEN=' "$UPSTREAM_ENV"; then
    cp -a "$UPSTREAM_ENV" "${UPSTREAM_ENV}.bak" 2>/dev/null || true
    sed -i 's/^OPENCLAW_GATEWAY_TOKEN=/# OPENCLAW_GATEWAY_TOKEN=/' "$UPSTREAM_ENV"
    echo "[init] disabled OPENCLAW_GATEWAY_TOKEN in $UPSTREAM_ENV (backup: ${UPSTREAM_ENV}.bak)"
  fi
fi

echo "[init] wrote config: $OUT"
echo "[init] token stored at: $OUT (gateway.auth.token)"
echo "[init] next: bash docker/run.sh"

