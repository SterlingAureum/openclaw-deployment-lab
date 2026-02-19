#!/usr/bin/env bash
set -euo pipefail

# ---- root-safe state dir policy ----
if [ "${EUID:-$(id -u)}" -eq 0 ]; then
  if [ -z "${OPENCLAW_CONFIG_DIR:-}" ]; then
    echo "ERROR: Running as root requires OPENCLAW_CONFIG_DIR (do not rely on ~ => /root)."
    echo "Example:"
    echo "  OPENCLAW_CONFIG_DIR=/var/lib/openclaw OPENCLAW_WORKSPACE_DIR=/var/lib/openclaw/workspace bash docker/run.sh"
    exit 1
  fi
fi

export OPENCLAW_CONFIG_DIR="${OPENCLAW_CONFIG_DIR:-$HOME/.openclaw}"
export OPENCLAW_WORKSPACE_DIR="${OPENCLAW_WORKSPACE_DIR:-$OPENCLAW_CONFIG_DIR/workspace}"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# --- submodule sanity check (minimal, no logic change) ---
OPENCLAW_DIR="$ROOT/vendor/openclaw"

if [[ ! -d "$OPENCLAW_DIR" ]]; then
  cat >&2 <<'EOF'
[ERROR] Missing submodule directory: vendor/openclaw

You likely cloned the repo without initializing submodules.

Fix:
  git submodule update --init --recursive

If you already ran it, verify:
  ls -la vendor/openclaw
EOF
  exit 1
fi

# optional: ensure it's really a git checkout (not empty dir)
if [[ ! -e "$OPENCLAW_DIR/.git" && ! -e "$OPENCLAW_DIR/.gitmodules" && ! -e "$ROOT/.gitmodules" ]]; then
  echo "[WARN] vendor/openclaw exists but does not look like a git submodule checkout." >&2
  echo "       If compose fails, re-run: git submodule update --init --recursive" >&2
fi
# --- end submodule check ---

cd "$ROOT/vendor/openclaw"

DOCKER="docker"
if ! docker ps >/dev/null 2>&1; then
  DOCKER="sudo docker"
fi

echo "[info] OPENCLAW_CONFIG_DIR=$OPENCLAW_CONFIG_DIR"
echo "[info] OPENCLAW_WORKSPACE_DIR=$OPENCLAW_WORKSPACE_DIR"

echo "[run] starting OpenClaw gateway"
$DOCKER compose up -d openclaw-gateway

echo
echo "[run] status:"
$DOCKER compose ps

echo
echo "[run] UI (local): http://localhost:18789/"
echo "[run] remote (recommended): ssh -N -L 18789:127.0.0.1:18789 user@server"

