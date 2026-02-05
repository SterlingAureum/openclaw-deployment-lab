#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT/vendor/openclaw"

git pull --rebase || true
git submodule update --init --recursive || true

# Re-run the official script (which handles build/compose processes)
./docker-setup.sh

