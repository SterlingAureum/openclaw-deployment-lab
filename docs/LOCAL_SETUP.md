# Local Setup (QuickStart Baseline)

This document describes the reproducible QuickStart baseline used in this lab.

## Baseline Choices
- Gateway bind: 127.0.0.1 (loopback)
- Gateway auth: Token
- Gateway port: 18789
- Model provider: Skipped
- Channels: Skipped
- Skills: Skipped

## Prerequisites
- Linux / macOS / Windows (WSL recommended on Windows)
- Node.js >= 22
- npm

## Install CLI
npm install -g openclaw@latest

## Run Onboarding
openclaw onboard --install-daemon

Choose:
- QuickStart
- Skip provider
- Skip channels
- Skip skills

## Verify Port Binding
ss -lntp | grep 18789

Expected:
127.0.0.1:18789

## Access Control UI
Local:
http://127.0.0.1:18789/

Remote:
ssh -N -L 18789:127.0.0.1:18789 root@<host>
Then open:
http://localhost:18789/
