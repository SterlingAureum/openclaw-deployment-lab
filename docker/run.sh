#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../vendor/openclaw"

# Write tokens and configurations to ~/.openclaw on the host machine (this is also how the official scripts are implemented).
./docker-setup.sh

