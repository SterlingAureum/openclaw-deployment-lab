# Configuring OpenClaw to Use a vLLM Backend

This guide shows how to configure OpenClaw to use a remote **vLLM OpenAI-compatible endpoint**.

---

## Provider Configuration

Only the provider configuration is relevant for remote inference integration.

Example structure:

{
  ...
  "providers": {
    "vllm": {
      "baseUrl": "http://your-endpoint/v1",
      "apiKey": "dummy",
      "api": "openai-completions",
      "models": [
        {
          "id": "meta-llama/llama-3.1-8b-instruct",
          "name": "meta-llama/llama-3.1-8b-instruct",
          ...
        }
      ]
    }
  }
  ...
}

Only the `providers` section is shown above. The surrounding configuration
structure may vary depending on the OpenClaw version or agent configuration.

---

## Field Explanation

baseUrl
Remote OpenAI-compatible endpoint.

Example:

http://your-endpoint/v1

---

apiKey

OpenClaw requires an apiKey field in the provider configuration.

Many vLLM deployments do **not enforce authentication**, so this value may simply be a placeholder:

"apiKey": "dummy"

If the backend enforces authentication (for example via the vLLM --api-key option), this value must match the configured token.

---

api

Defines the API adapter used by OpenClaw.

For vLLM deployments use:

"api": "openai-completions"

---

models

Defines the models exposed to OpenClaw.

The model `id` should match the identifier returned by:

curl http://your-endpoint/v1/models

---

## Testing the Configuration

After updating the configuration, restart OpenClaw and open the chat interface.

Send a simple prompt to verify the request is forwarded to the vLLM backend.

---

## Debugging

If inference fails, check:

1. Endpoint connectivity
2. Model identifier correctness
3. Gateway logs
