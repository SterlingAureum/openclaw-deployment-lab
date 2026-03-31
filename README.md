# OpenClaw Deployment Lab

OpenClaw Deployment Lab is a documentation-first repository focused on OpenClaw deployment, configuration, integration, troubleshooting, and workflow validation.

The current validated version is centered on a CLI-based deployment path in a local or VM-based environment. The current successful path starts from a QuickStart baseline, skips provider, channel, and skill setup during initial onboarding, and then adds a remote vLLM provider afterward.

Docker-based workflow remains part of the project direction and is expected to be refined in later iterations after the current deployment path, configuration model, and operational issues are better documented and understood.

## Purpose

This repository focuses on studying and documenting practical OpenClaw deployment workflows.

The current phase prioritizes:

- CLI-based deployment and operation
- local or VM-based runtime setup
- QuickStart baseline initialization
- post-baseline remote vLLM integration
- troubleshooting and operational notes

Later iterations may expand the repository with:

- Docker-based deployment workflow
- additional provider examples
- channel and skill-related configuration
- security and operational constraints
- more structured troubleshooting cases

## What Is Currently Validated

The current validated path in this repository includes:

- OpenClaw operated through CLI
- local or VM-based shell environment
- QuickStart baseline onboarding
- provider, channel, and skill setup skipped during baseline initialization
- remote OpenAI-compatible provider configuration added afterward
- remote vLLM model integration
- successful chat validation against the remote backend

## Current Recommended Path

At the current stage, the recommended workflow is the CLI-based deployment path.

Follow these documents in order:

1. `docs/LOCAL_SETUP.md`
   - local CLI installation and QuickStart baseline setup

2. `docs/BASELINE_TO_REMOTE_VLLM.md`
   - transition from baseline setup to remote vLLM integration

3. `docs/PROVIDER_VLLM.md`
   - provider-specific vLLM configuration notes

4. `ops/HANDOVER.md`
   - current project state and operational handover notes

## Repository Layout

Main areas in this repository:

- `docs/`
  - setup guides, transition notes, provider notes, and troubleshooting references

- `ops/`
  - operational handover notes and project state tracking

- `docker/`
  - Docker-related materials for later workflow refinement and comparison

## Scope

Included in the current scope:

- CLI-based deployment path
- local or VM-based operation
- QuickStart baseline setup
- remote vLLM integration after baseline onboarding
- validated chat behavior on the current path
- deployment notes and troubleshooting records

Not yet a main focus:

- advanced channel design
- skill ecosystem integration
- routing strategies
- multi-provider orchestration
- fully standardized Docker deployment workflow

## Notes

- This repository is focused on OpenClaw deployment rather than only one runtime mode.
- The current validated version is CLI-based.
- The current validated path begins with a minimal QuickStart baseline.
- Provider, channel, and skill setup are intentionally skipped during the initial onboarding phase of this path.
- Remote vLLM integration is added afterward as a separate step.
- Docker is still part of the planned project direction and is not being abandoned.

## Next Direction

The current priority is to keep the validated CLI plus remote vLLM path clear, reproducible, and well documented.

After that, future work may include:

- Docker workflow refinement
- side-by-side CLI and Docker deployment guidance
- additional provider examples
- channel and skill-related examples
- more complete troubleshooting cases
