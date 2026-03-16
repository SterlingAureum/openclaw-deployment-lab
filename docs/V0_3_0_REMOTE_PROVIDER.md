# v0.3.0 — Remote LLM Provider Integration

This release introduces support for connecting OpenClaw to a **remote OpenAI-compatible inference backend** such as **vLLM**.

Instead of running models locally, OpenClaw can forward inference requests to a remote endpoint.

Typical architecture:

Local OpenClaw (Docker Compose)
↓
OpenClaw Gateway
↓
OpenAI-compatible provider
↓
Remote endpoint (ALB / public URL)
↓
vLLM API server
↓
GPU inference

---

## Scope of v0.3.0

This version focuses on **provider-level integration only**.

Goals:

- Connect OpenClaw to a remote OpenAI-compatible API
- Validate end-to-end inference requests
- Document connectivity verification and troubleshooting

This repository **does not provision GPU infrastructure**.

If you need a reference deployment for GPU inference infrastructure (EKS + vLLM + ALB), see:

https://github.com/SterlingAureum/ai-infra-blueprints

---

## Architecture Overview

OpenClaw UI / Chat
↓
OpenClaw Gateway
↓
Provider (openai-completions)
↓
Remote Endpoint
↓
vLLM API
↓
GPU Model Inference

---

## Requirements

Before configuring OpenClaw, ensure the remote endpoint is reachable.

The endpoint must support:

GET /v1/models
POST /v1/chat/completions

Example endpoint:

http://your-endpoint/v1

In production environments HTTPS endpoints are recommended.

---

## Connectivity Verification

Test the endpoint before integrating OpenClaw.

Example:

curl http://your-endpoint/v1/models

Expected response:

{
  "object": "list",
  "data": [
    {
      "id": "meta-llama/llama-3.1-8b-instruct"
    }
  ]
}

If this request fails, the issue is likely outside OpenClaw and should be investigated at the infrastructure or networking layer.

---

## Next Steps

Configure the OpenClaw provider:

docs/PROVIDER_VLLM.md

---

## Notes

Advanced features such as channels, routing, or skills are outside the scope of v0.3.0 and will be introduced in later versions.
