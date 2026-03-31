# Local Setup (QuickStart Baseline)

This document describes the current local CLI baseline used as the starting point for this lab.
It focuses on the initial QuickStart setup that establishes the base environment for later configuration and integration work.

## Purpose

This document covers the initial local CLI onboarding flow used to create a minimal OpenClaw baseline.

This baseline is intentionally limited.
During the initial QuickStart flow, provider, channel, and skill setup are skipped.
Those parts are added later in separate follow-up steps.

## What This Document Covers

This document focuses on:

- local or VM-based CLI installation
- local runtime preparation
- QuickStart onboarding
- baseline validation after onboarding

It does not attempt to cover:

- remote provider integration
- advanced channel setup
- skill configuration
- Docker-based workflow

Those areas are documented separately.

## Baseline Workflow

The current baseline workflow is:

1. install OpenClaw CLI
2. start the onboarding flow
3. choose the QuickStart path
4. skip provider setup
5. skip channel setup
6. skip skill setup
7. confirm that the local runtime is working

## Important Note

The goal of this document is to create a minimal and reproducible baseline.

A successful result at this stage does not yet mean that a remote model provider has been attached.
Remote provider integration is added later as a separate step.

For the next step after baseline setup, see:

- `docs/BASELINE_TO_REMOTE_VLLM.md`
