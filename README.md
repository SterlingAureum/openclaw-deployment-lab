# OpenClaw Deployment Lab

OpenClaw Deployment Lab is a documentation-first repository focused on OpenClaw deployment, configuration, integration, troubleshooting, and workflow validation.

Docker-based workflow remains part of the project direction and is expected to be refined in later iterations after the current deployment path, configuration model, and operational issues are better documented and understood.

## Current Focus

The current repository state is centered on:

- CLI-based deployment and operation
- local or VM-based runtime setup
- QuickStart baseline initialization
- remote vLLM integration after baseline onboarding
- skill + tool integration on top of the existing remote model workflow
- first external channel baseline with Telegram DM validation
- troubleshooting and operational notes

This repository is intended to document a practical and reproducible deployment path.
It does not aim to provide broad model recommendations or benchmark-style comparisons.
Model examples included in the documents are only used to demonstrate the validated configuration path for the current stage.

## Current Recommended Path

Follow these documents in order:

1. `docs/LOCAL_SETUP.md`
   - local CLI installation and QuickStart baseline setup

2. `docs/BASELINE_TO_REMOTE_VLLM.md`
   - transition from baseline setup to remote vLLM integration

3. `docs/V0_4_0_SKILL_TOOL_INTEGRATION.md`
   - skill + tool integration, example configuration updates, validation notes, and workflow checks

4. `docs/CHANNEL_TELEGRAM_BASELINE.md`
   - first channel integration baseline, Telegram bot setup, pairing flow, and DM validation

5. `docs/REMOTE_VLLM_SECURITY.md`
   - a minimal remote vLLM security baseline by enabling --api-key authentication

## Troubleshooting

If you run into problems during setup or validation, see:

- `docs/TROUBLESHOOTING_REMOTE_BACKEND.md`
  - provider connectivity, model path, endpoint, and remote backend troubleshooting

- `docs/TROUBLESHOOTING_SKILL_TOOL.md`
  - skill discovery, tool behavior, session refresh, and skill + tool integration troubleshooting
