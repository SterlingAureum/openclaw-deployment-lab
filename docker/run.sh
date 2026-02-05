#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT/vendor/openclaw"

# Write tokens and configurations to ~/.openclaw on the host machine (this is also how the official scripts are implemented).
./docker-setup.sh

