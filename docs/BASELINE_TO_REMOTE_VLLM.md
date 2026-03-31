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
- provider setup was skipped during the initial baseline flow
- channel setup was also skipped during the initial baseline flow
- skill setup was also skipped during the initial baseline flow

This is expected for the baseline path.

## Goal

The goal of this step is to turn the baseline setup into a working OpenClaw deployment that can:

- connect to a remote OpenAI-compatible vLLM backend
- use the intended remote model
- send chat requests successfully
- receive valid responses from the remote backend

## Configuration Strategy

The current validated path does not depend on rebuilding everything manually from scratch.

Instead, the current path is based on:

- completing the QuickStart baseline first
- then adding remote vLLM provider-related configuration afterward

This keeps the workflow closer to the actual validated deployment path and makes troubleshooting easier.

## What Changes After Baseline

The baseline setup gives you a working local OpenClaw runtime, but it does not yet include a usable remote provider configuration.

To enable remote vLLM integration, the follow-up work usually includes:

- adding or updating the remote provider definition
- setting the remote vLLM endpoint
- defining the provider API mode
- adding the intended model entry
- making sure the configured model identifier matches the backend
- aligning the default agent model with the intended remote model
- optionally adding auth-related configuration on the OpenClaw side

## Files to Review and Update

The exact local files may vary depending on the workflow version and the way the runtime state has been initialized.

For the current validated path, inspect the local OpenClaw state and confirm which file is acting as the source of truth before editing anything.

In practice, the current workflow commonly involves reviewing:

- `~/.openclaw/openclaw.json`
- local model registry or agent-related state files if applicable

Before making any change:

- inspect the current local state
- identify the active configuration source
- back up the existing file if needed

Add a `bash` code block here like this:

openclaw config validate
vim ~/.openclaw/openclaw.json

## Validated Post-Baseline Example

The following example shows a validated post-baseline configuration fragment after remote vLLM integration has been added.

Only the relevant sections are shown here.
This is not intended to be a full dump of every local state field.

Add a `json` code block here like this:

{
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
}

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

## What Changed

Compared with the baseline-only state, this transition adds the minimum configuration required for a usable remote provider path.

The main changes are:

- the `models` configuration now includes a provider entry for `vllm`
- the remote vLLM endpoint is introduced through `baseUrl`
- the provider API mode is explicitly set to `openai-completions`
- a remote model entry is added under the `vllm` provider
- the model identifier is aligned with the model exposed by the backend
- the default agent model is aligned with the newly added remote model
- the local baseline is extended into a usable remote chat path

In the current validated workflow, this configuration is added after the initial QuickStart baseline has already been completed.

## Optional Auth Profile Step

In the current validated path, an auth profile was also added on the OpenClaw side.

This step is structurally useful even though the current lab backend does not actively enforce API key validation.

Add a `bash` code block here like this:

openclaw models auth add

During the interactive flow, use values like the following:

- select `custom`
- in `type provider id`, enter `vllm`
- set `provider id` to `vllm`
- set `default model ref` to `vllm/meta-llama/llama-3.1-8b-instruct`

This step should be documented as part of the current validated lab path, but it should also be noted that backend-side enforcement is not currently enabled in this setup.

## Note on API Key and Auth Handling

In the current lab setup, the `apiKey` field is retained in the OpenClaw configuration as a placeholder value.

At the time of validation, the remote vLLM backend did not enforce API key authentication.
As a result, the configured value is structurally present on the OpenClaw side, but it is not being actively validated by the backend.

Similarly, the auth profile step was completed on the OpenClaw side for configuration completeness, but it is not currently acting as an enforced backend authentication gate in this setup.

This behavior should be treated as a lab-specific characteristic of the current environment.
If backend-side authentication is enabled in a later iteration, the placeholder value and auth profile behavior should be reviewed again.

## Applying the Changes

After updating the local configuration:

1. validate the configuration
2. restart the OpenClaw gateway
3. confirm that the gateway is healthy
4. confirm that the model configuration is visible to the runtime
5. reopen the CLI workflow and run a simple chat test

Add a `bash` code block here like this:

openclaw config validate
systemctl --user restart openclaw-gateway
openclaw gateway status
openclaw models status
openclaw models list

Only document the restart path you actually validated in this environment.

## Validation

A successful transition from the baseline setup to remote vLLM integration should result in the following:

- the remote `vllm` provider is active in the current workflow
- the expected model can be selected or used
- the gateway restarts cleanly after the configuration is updated
- chat requests are sent to the remote backend
- responses are returned successfully

Recommended validation steps:

- run configuration validation before restart
- restart the user-level gateway service
- confirm gateway health
- confirm model status
- confirm that the configured model appears in the model list
- confirm that the default agent model is pointing to the intended remote model
- reopen the CLI workflow and run a short chat test
- verify that the response is coming from the remote vLLM backend

Add a `bash` or `text` code block here like this:

openclaw config validate
systemctl --user restart openclaw-gateway
openclaw gateway status
openclaw models status
openclaw models list

If all of the above checks succeed, proceed to a short chat validation in the CLI workflow.

## Common Failure Points

Typical problems in this transition include:

- baseline setup completed, but provider config was never added afterward
- remote endpoint configured incorrectly
- model identifier does not match the backend
- the default agent model is not aligned with the remote model
- configuration was edited in the wrong file
- process was not restarted cleanly after configuration changes
- stale local state caused the runtime to continue using an older configuration

When debugging this stage, always confirm these in order:

1. local runtime is healthy
2. active configuration file is the one you edited
3. remote endpoint is reachable
4. model identifier matches the backend
5. the default agent model is aligned with the intended remote model
6. the runtime has actually reloaded the updated configuration

## Note on Editing Method

In the current validated path, the local configuration file was edited directly with `vim`.

The specific editor is not important to the workflow.
What matters is that the active local configuration source is updated correctly and then validated before restart.

You may mention `vim` in example commands if you want the document to stay close to the real lab steps, but it does not need a dedicated workflow explanation.

## Relationship to Other Documents

Use the related documents as follows:

- `docs/LOCAL_SETUP.md`
  - initial local CLI baseline

- `docs/PROVIDER_VLLM.md`
  - provider-specific field explanations and vLLM-specific notes

- `ops/HANDOVER.md`
  - current repository state and next-step priorities

## Scope Note

This document focuses on the transition from a minimal local baseline to a remote vLLM-backed OpenClaw setup.

It does not attempt to cover:

- the full local onboarding baseline
- all possible provider types
- advanced channel setup
- skill configuration
- Docker-based deployment flow
- broader runtime feature expansion

Those areas should be documented separately as the project evolves.
