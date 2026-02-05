#!/usr/bin/env bash
set -euo pipefail

echo "[1/4] Check docker compose services..."
docker compose ps || true

echo "[2/4] Check port 18789 listening..."
ss -lntp | grep 18789 || true

echo "[3/4] Verify loopback bind (expect 127.0.0.1:18789, not 0.0.0.0)..."
if ss -lntp | grep -q "0.0.0.0:18789"; then
  echo "ERROR: gateway appears to be bound to 0.0.0.0 (public). Stop and harden."
  exit 2
fi
echo "OK: not bound to 0.0.0.0"

echo "[4/4] Next: if remote server, use SSH tunnel:"
echo "ssh -N -L 18789:127.0.0.1:18789 root@<host>"

