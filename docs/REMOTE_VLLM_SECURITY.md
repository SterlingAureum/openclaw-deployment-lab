# Remote vLLM Security Baseline

This document records the v0.6.0 security baseline for connecting OpenClaw to a remote vLLM OpenAI-compatible endpoint.

It is based on the actual issue found during the lab: the OpenClaw provider had an `apiKey` field, but the remote vLLM server was not enforcing API key authentication. In that state, the key in OpenClaw was only a placeholder and did not provide real access control.

## Background

In the earlier OpenClaw remote vLLM integration, the provider configuration contained an `apiKey` value similar to this:

```json
{
  "provider": "vllm",
  "baseUrl": "http://<YOUR_VLLM_ENDPOINT>/v1",
  "apiKey": "<PLACEHOLDER_API_KEY>"
```

However, the vLLM backend itself was not started with API key enforcement enabled.

That meant:

```text
OpenClaw had an apiKey field.
But vLLM did not check the key.
So the endpoint was still effectively unauthenticated.
```

This matters because if the vLLM endpoint is reachable through a load balancer, public IP, internal network, or leaked URL, anyone who can reach the endpoint may be able to call the model API unless another access control layer blocks them.

## Recommended token format

Generate a random token instead of using a weak test value:

```bash
openssl rand -hex 32
```

## Enable API key enforcement on vLLM

Add `--api-key` to the vLLM server startup arguments.

Example direct command:

```bash
vllm serve <model-path-or-name> \
  --served-model-name qwen25-14b-awq \
  --host 0.0.0.0 \
  --port 8000 \
  --api-key <YOUR_VLLM_API_KEY>
```

For Kubernetes or Helm deployments, add the API key argument according to the chart or manifest structure used by the deployment.

Conceptual example:

```yaml
extraArgs:
  - --api-key
  - <YOUR_VLLM_API_KEY>
```

The exact field name may vary depending on the vLLM chart or deployment template. Always verify the final pod command or arguments after applying the change.

## Kubernetes Secret option

For a cleaner Kubernetes setup, store the token in a Kubernetes Secret instead of hardcoding it in a committed values file.

Example:

```bash
kubectl create secret generic vllm-api-key \
  --from-literal=api-key='<YOUR_VLLM_API_KEY>' \
  -n <namespace>
```

Then reference the secret in the Deployment or Helm values according to the chart structure.

If the current chart does not support referencing a Secret cleanly, a short-term lab-only fallback is to store the real value in a private local values file such as:

```text
values.local.yaml
values-secret.yaml
```

Those files must be excluded from Git.

## Verify the running vLLM arguments

After the rollout, confirm that the running pod actually contains the API key argument.

```bash
kubectl describe pod -n <namespace> <vllm-pod-name> | grep -A 40 -E "Command:|Args:"
```

Or:

```bash
kubectl get pod -n <namespace> <vllm-pod-name> -o yaml | grep -A 30 -E "command:|args:"
```

The important point is not only that the values file was edited, but that the final running vLLM process is enforcing the token.

## Validate unauthorized access

Test the endpoint without a token:

```bash
curl -i http://<YOUR_VLLM_ENDPOINT>/v1/models
```

A typical result is:

```text
401 Unauthorized
```

The exact response body may vary by vLLM version.

## Validate authorized access

Test the same endpoint with the token:

```bash
curl -i http://<YOUR_VLLM_ENDPOINT>/v1/models \
  -H "Authorization: Bearer <YOUR_VLLM_API_KEY>"
```

A typical result is:

```text
200 OK
```

This confirms that the vLLM server is no longer accepting anonymous model API requests.

## Validate chat completions

After `/v1/models` works with the token, test an actual completion request:

```bash
curl -i http://<YOUR_VLLM_ENDPOINT>/v1/chat/completions \
  -H "Authorization: Bearer <YOUR_VLLM_API_KEY>" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen25-14b-awq",
    "messages": [
      {
        "role": "user",
        "content": "hello"
      }
    ],
    "max_tokens": 32
  }'
```

Expected result:

```text
The server should return a valid chat completion response.
```

## Configure the OpenClaw provider

The OpenClaw provider must use the same API key configured on the vLLM server.

Sanitized provider example:

```json
{
  "provider": "vllm",
  "baseUrl": "http://<YOUR_VLLM_ENDPOINT>/v1",
  "apiKey": "<YOUR_VLLM_API_KEY>"
}
```

Common local runtime location:

```text
~/.openclaw/openclaw.json
```

After updating OpenClaw configuration:

```bash
openclaw config validate
openclaw gateway restart
openclaw models status
```

Start a new OpenClaw session before testing:

```text
/new
```

Do not rely on an old session when validating provider authentication changes.

## Limitations

The vLLM API key provides a minimal authentication layer for the OpenAI-compatible endpoint.

For production-like environments, combine API key authentication with network restrictions, TLS, controlled secret storage, and operational monitoring.
