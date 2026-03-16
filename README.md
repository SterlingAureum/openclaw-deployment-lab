# OpenClaw Deployment Lab

A reproducible **deployment & security blueprint** for running OpenClaw in a clean, repeatable, production‑oriented baseline mode.

This project focuses on:

- deterministic deployment
- secure defaults
- operational clarity
- handover‑ready documentation

It is designed for **client environments, DevOps handoff, and repeatable setups**.

---

## Version Scope

This repository started with a `v0.2.x` baseline focused on deterministic
OpenClaw gateway deployment, secure defaults, and config-first initialization.

The current `v0.3.0` release extends that baseline with **remote provider
integration**, allowing OpenClaw to connect to a remote OpenAI-compatible
backend such as vLLM.

Scope split:

- `v0.2.x` — baseline gateway deployment
- `v0.3.0` — remote provider integration
- later versions — channels, routing, skills, and higher-level runtime features

---

## Purpose

This lab removes the complexity of the interactive onboarding flow and replaces it with a:

- config‑first initialization  
- single source of truth for authentication  
- secure gateway defaults  
- automation‑friendly deployment flow  

This allows consistent deployment across multiple servers and clients.

---

## Current Operating Modes

This repository currently covers two layers:

### Baseline Layer (v0.2.x)
- Gateway deployment (Docker)
- Token authentication enabled
- Loopback binding (127.0.0.1)
- Secure defaults validated
- Config-first initialization
- Repeatable run workflow

### Remote Provider Layer (v0.3.0)
- OpenClaw connected to a remote OpenAI-compatible backend
- vLLM-oriented provider examples
- Endpoint verification workflow
- Remote backend troubleshooting guidance

### Still Out of Scope
- Chat channels
- Skills / nodes
- Routing logic
- Production reverse proxy / TLS termination patterns
- Web search integration

---

## Prerequisites

This repo uses a git submodule for the upstream OpenClaw source.

After cloning, initialize submodules:

```bash
git submodule update --init --recursive
```
If you pulled new changes and the submodule is out of date:

```bash
git submodule sync --recursive
git submodule update --init --recursive
```

## Deployment Workflow

### 1 Initialize (first time only)

Generates configuration and gateway token.

```bash
bash docker/init.sh
```

### 2 Start Gateway

```bash
bash docker/run.sh
```

Open locally:

http://localhost:18789/

### 3 Remote Access (recommended)

```bash
ssh -N -L 18789:127.0.0.1:18789 user@server
```

Then open:

http://localhost:18789/

---

## Remote Provider Extension

Starting from `v0.3.0`, this lab can also connect to a remote
OpenAI-compatible inference backend such as vLLM.

This extends the baseline deployment without changing the core local
gateway workflow.

See:

- `docs/V0_3_0_REMOTE_PROVIDER.md`
- `docs/PROVIDER_VLLM.md`
- `docs/TROUBLESHOOTING_REMOTE_BACKEND.md`

---

## Authentication & Token Source of Truth

This lab uses **config‑first authentication**.

Gateway token is stored in:

```
~/.openclaw/openclaw.json
```

Upstream `.env` token variables are disabled to avoid dual token sources.

If the UI shows `token mismatch`, verify:

- gateway restarted after init
- browser cache cleared
- tokenized URL used

---

## State Directory

Default state directory:

```
~/.openclaw
```

This stores:

- configuration
- workspace
- sessions
- agent state

### ⚠️ Running as root

If running as root, you **must** define a state directory to avoid using `/root/.openclaw`:

```bash
OPENCLAW_CONFIG_DIR=/var/lib/openclaw OPENCLAW_WORKSPACE_DIR=/var/lib/openclaw/workspace bash docker/init.sh
```

Running as a normal user is recommended.

---

## Docker Permissions

If Docker requires sudo on your system, the scripts automatically fall back to:

```
sudo docker
```

No additional configuration required.

---

## Security Defaults

- Gateway bound to localhost  
- Token authentication required  
- No public exposure  
- No channels enabled by default
- Pairing behavior remains unchanged from the baseline deployment
- Remote provider integration does not remove the need to handle pairing separately

These defaults are suitable for controlled deployment environments.

---

## ⚠️ Pairing & Chat Behavior

Dashboard access uses token authentication.

Direct chat requires pairing and a configured channel.

If you see:

```
pairing required
```

This is expected in baseline mode.

---

## Documentation

Baseline deployment:
- `docs/LOCAL_SETUP.md`
- `docs/ONBOARDING_LOG.md`
- `security/SECURITY.md`
- `ops/HANDOVER.md`

Remote provider integration:
- `docs/V0_3_0_REMOTE_PROVIDER.md`
- `docs/PROVIDER_VLLM.md`
- `docs/TROUBLESHOOTING_REMOTE_BACKEND.md`

---

## Upstream Project

OpenClaw official repository:

https://github.com/openclaw/openclaw

---

## Why This Lab Exists

The upstream onboarding process is interactive and developer‑oriented.

This lab provides:

- automation‑friendly initialization
- reproducible deployment
- security‑first defaults
- operational clarity for client handoff

---

## Versioning

This repository follows semantic versioning.

**v0.1.0**
- onboarding and documentation baseline

**v0.2.0**
- config-first initialization
- deterministic gateway startup
- single token source of truth
- root-safe state directory handling
- production-oriented baseline deployment workflow

**v0.3.0**
- remote OpenAI-compatible provider integration
- vLLM-oriented provider configuration guidance
- endpoint verification workflow
- remote backend troubleshooting documentation

---

## Next Phases

Planned enhancements:
- channel enablement and pairing flow refinement
- reverse proxy and TLS patterns
- systemd / supervisor deployment
- token rotation utilities
- more complete runtime features such as routing and skills

---

## License

This repository is a deployment blueprint and documentation layer built on top of the OpenClaw project.
