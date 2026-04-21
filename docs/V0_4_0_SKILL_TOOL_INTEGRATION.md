# v0.4.0 - Skill + Tool Integration

## Purpose

This document describes the next step after the remote vLLM baseline:
integrating skill and tool support into the existing OpenClaw workflow.

The goal of this version is not to present a perfect or fully constrained agent workflow.
The goal is to document a practical and reproducible integration path that works in a real setup,
while also being clear about the limitations observed during testing.

Compared with the v0.3.x stage, this version adds:

- skill integration
- tool integration
- updated model examples based on Qwen
- troubleshooting notes collected during the integration process

---

## Prerequisites

Before using this document, the following should already be working:

- OpenClaw is installed and usable through CLI / local UI
- baseline onboarding has been completed
- remote vLLM provider integration is already working
- chat requests can already reach the remote model successfully

If you have not completed those steps yet, read these first:

1. `docs/LOCAL_SETUP.md`
2. `docs/BASELINE_TO_REMOTE_VLLM.md`

---

## How Skill Works In This Setup

In this repository, a skill is best understood as a guidance layer.

A skill can help shape:

- what the model is expected to do
- how it should structure the task
- what type of output is preferred
- how certain repeated tasks should be framed

However, a skill is not a hard guarantee.

In practice, whether a skill is followed consistently depends on several factors:

- the model itself
- the active session state
- how much context has already accumulated
- whether the necessary tools are actually available
- how clearly the task is framed

Because of this, "skill discovered" should not be treated as the same thing as
"skill will be followed strictly in every response".

---

## How Tool Works In This Setup

A tool is the execution layer.

If skill defines the intended behavior,
tool defines what the model can actually do.

For example, tasks such as:

- checking environment state
- reading files
- running shell commands
- collecting real runtime information

depend on tool access rather than skill text alone.

Without tool support, many operational tasks can only be described but not truly executed.

This is why the `v0.4.0` stage focuses on both parts together:

- skill for guidance
- tool for execution

---

## Practical Integration Notes

At a practical level, this version is meant to validate that:

- skill can be loaded / discovered in the current setup
- tool access can be exposed in a usable way
- the model can call tools under the right conditions
- the overall workflow can produce useful real output instead of only describing actions

---

## Known Limitations

The current setup still has important limits.

### 1. Skill is not a strict workflow engine

Skill text can influence behavior,
but it does not force strict compliance.

### 2. Tool calling quality still depends on the model

Even when the tool is available,
the model may not always invoke it consistently.

### 3. Session state matters

After config changes, stale sessions may continue to behave as if the old state is still active.
Starting a new session is often necessary.

### 4. Context budget affects reliability

As conversation length grows,
instruction quality and tool selection can degrade.
This is especially visible in smaller or weaker models.

### 5. Better integration does not mean perfect integration

Moving to Qwen improved the practical path for this repository,
but it does not eliminate all instability or ambiguity.

---

## What This Version Should Be Used For

Use this version if you want to understand:

- how to extend a remote vLLM-based OpenClaw setup toward skill + tool usage
- how to think about skill as guidance instead of magic
- why tool exposure matters for operational tasks
- how model choice can affect integration quality
- what kinds of issues are normal during this stage

This version is intended as a practical reference,
not as a final word on agent reliability.

## Additional Configuration For Skill And Tool

This stage adds a small set of configuration changes on top of the existing remote vLLM baseline.

Only the items directly related to skill + tool validation are shown here.

### 1. Allow the required tool

Add the following section near the top-level `tools` block in `openclaw.json`:

```json
"tools": {
  "allow": ["exec"]
}
```

#### What it does

This allows the `exec` tool to be exposed for the current setup.

In this repository, the purpose of enabling `exec` is to support practical validation tasks that require real execution instead of text-only answers.

Typical examples include:

- checking runtime state
- running simple shell commands
- validating whether the model can actually execute a requested action

Without this, the model may still describe what it wants to do, but it cannot complete execution through the tool layer.

---

### 2. Add model compatibility flags

Under the model entry used for this stage, add:

```json
"compat": {
  "requiresStringContent": true,
  "supportsTools": true
}
```

Example placement:

```json
{
  "id": "qwen25-14b-awq",
  "name": "qwen25-14b-awq",
  "reasoning": false,
  "input": ["text"],
  "cost": {
    "input": 0,
    "output": 0,
    "cacheRead": 0,
    "cacheWrite": 0
  },
  "contextWindow": 32768,
  "maxTokens": 1024,
  "compat": {
    "requiresStringContent": true,
    "supportsTools": true
  }
}
```

#### What it does

`requiresStringContent: true`

- tells OpenClaw to use string-style content handling for this model path
- helps avoid formatting mismatches for models or provider paths that expect plain string content rather than richer message content structures

`supportsTools: true`

- tells OpenClaw that this model path is expected to support tool calling
- this is necessary for skill + tool validation, because without it the model path may behave as a normal text-only path even if tool-related logic exists elsewhere

These flags do not guarantee perfect tool behavior. They only ensure that the current model path is configured in a way that allows tool usage to be attempted correctly.

---

### 3. Skill example location

In this setup, the workspace points to:

```text
/home/sterling/.openclaw/workspace
```

The example skill directory is located under:

```text
/home/sterling/.openclaw/workspace/skills/openclaw_ops
```

Example check:

```bash
ls ~/.openclaw/workspace/skills/openclaw_ops
```

Example output:

```text
SKILL.md
```

---

## After Updating The Config

After modifying `openclaw.json`, do not assume the current session will immediately reflect the new behavior.

### What to do

1. Save the config file.
2. Restart OpenClaw gateway if needed in your current setup.
3. Open a fresh session.
4. Run a small validation task.

The most important point is to use a new session after config changes. An older session may continue behaving as if the previous config is still active.

