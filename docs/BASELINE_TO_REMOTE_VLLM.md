# Baseline to Remote vLLM Integration

## Purpose

This document describes how to move from the local CLI baseline in `docs/LOCAL_SETUP.md` to a working OpenClaw setup backed by a remote OpenAI-compatible vLLM endpoint.

It assumes the initial QuickStart baseline has already been completed.
In that baseline, provider, channel, and skill setup were intentionally skipped during onboarding.
The goal of this step is to extend that baseline with a usable remote provider and model configuration for end-to-end chat validation.

## Starting Point

This document starts from the baseline state produced by `docs/LOCAL_SETUP.md`.

At that stage:

- OpenClaw CLI has already been installed
- the initial QuickStart onboarding flow has already been completed
- the local runtime is already available
- provider,channel,skill setup were skipped during the initial baseline flow

This is expected for the baseline path.

## Goal

The goal of this step is to extend the baseline setup with a working remote OpenAI-compatible vLLM provider.

At the end of this step, OpenClaw should be able to use the intended remote model and complete basic chat validation successfully.

## Configuration Strategy

The current validated path does not depend on rebuilding everything manually from scratch.

Instead, the current path is based on:

- completing the QuickStart baseline first
- then adding remote vLLM provider-related configuration afterward

This keeps the workflow closer to the actual validated deployment path and makes troubleshooting easier.

## Files to Review and Update

For the current validated path, the main file to review and update is:

- `~/.openclaw/openclaw.json`

The current transition is documented around changes to this file only.

## Validated Post-Baseline Example

The following example shows a validated post-baseline configuration fragment after remote vLLM integration has been added.

Only the relevant sections are shown here.
This is not intended to be a full dump of every local state field.

Validated configuration example:

```text
{
...
  "models": {
    "mode": "merge",
    "providers": {
      "vllm": {
        "baseUrl": "http://k8s-openclaw-openclaw-9101096edc-5349cecfcee28953.elb.us-east-1.amazonaws.com/v1",
        "apiKey": "VLLM_API_KEY",
        "api": "openai-completions",
        "models": [
          {
            "id": "meta-llama/llama-3.1-8b-instruct",
            "name": "meta-llama/llama-3.1-8b-instruct",
            "reasoning": false,
            "input": [
              "text"
            ],
            "cost": {
              "input": 0,
              "output": 0,
              "cacheRead": 0,
              "cacheWrite": 0
            },
            "contextWindow": 16384,
            "maxTokens": 2048
          }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "vllm/meta-llama/llama-3.1-8b-instruct"
      },
      "workspace": "/home/sterling/.openclaw/workspace"
    }
  }
...
}
```

This example reflects the current validated remote vLLM path used in this lab.

Important notes:

- `baseUrl` points to the remote OpenAI-compatible vLLM endpoint
- `api` is set to `openai-completions` for the current provider path
- the configured model identifier must match the model exposed by the remote backend
- `apiKey` is currently used as a placeholder on the OpenClaw side
- in the current lab setup, the backend does not enforce API key validation
- even when backend-side API key enforcement is not enabled, the OpenClaw configuration may still keep a structurally valid `apiKey` field
- `agents.defaults.model.primary` should point to the provider-qualified model name expected by the current runtime
- the default agent model should be aligned with the newly added remote model
- `workspace` should remain aligned with the actual local runtime environment
- update only the active configuration source for your current runtime

## Optional Auth Profile Step

In the current validated path, an auth profile was also added on the OpenClaw side.

This step is structurally useful even though the current lab backend does not actively enforce API key validation.

Example commands:
```bash
openclaw models auth add
```

During the interactive flow, use values like the following:

- select `custom`
- in `type provider id`, enter `vllm`
- set `provider id` to `vllm`
- set `default model ref` to `vllm/meta-llama/llama-3.1-8b-instruct`

This step should be documented as part of the current validated lab path, but it should also be noted that backend-side enforcement is not currently enabled in this setup.

## Applying the Changes

After updating the local configuration:

1. validate the configuration
2. restart the OpenClaw gateway
3. confirm that the gateway is healthy
4. confirm that the model configuration is visible to the runtime
5. reopen the CLI workflow and run a simple chat test

Example commands:
```bash
openclaw config validate
systemctl --user restart openclaw-gateway
openclaw gateway status
openclaw models status
openclaw models list
```

Only document the restart path you actually validated in this environment.

## Common Failure Points

When debugging this transition, check the following first:

- the remote endpoint is correct and reachable
- the configured model identifier matches the backend
- the default agent model is aligned with the intended remote model
- the correct local configuration file was updated
- the runtime has reloaded the updated configuration successfully

## Relationship to Other Documents

Use the related documents as follows:

- `docs/LOCAL_SETUP.md`
  - initial local CLI baseline

## Scope Note

This document focuses only on the transition from the local QuickStart baseline to a remote vLLM-backed setup.

It does not cover:

- the full local baseline flow
- other provider types
- channel or skill setup
- Docker-based deployment
- later feature expansion

Those areas should be documented separately.
