# Troubleshooting Remote LLM Backends

Common issues when connecting OpenClaw to a remote inference backend.

---

## Step 1 — Verify Endpoint Availability

Run:

curl http://endpoint/v1/models

If this fails, the issue is likely:

- ALB/NLB configuration
- Security group rules
- DNS resolution
- Backend service unavailable

---

## Step 2 — Verify Authentication (Optional)

Some deployments enforce API authentication.

Example:

curl http://endpoint/v1/models \
  -H "Authorization: Bearer TOKEN"

However many vLLM deployments do not require authentication.

In that case simply run:

curl http://endpoint/v1/models

---

## Step 3 — Verify Model Name

Retrieve available models:

curl http://endpoint/v1/models

Ensure the configured model id matches exactly.

---

## Step 4 — Verify OpenClaw Gateway

Check gateway logs:

docker compose logs openclaw-gateway

Common issues:

- pairing required
- provider configuration not loaded
- gateway connection issues

---

## Step 5 — Test from Inside the Container

docker compose exec openclaw-gateway curl http://endpoint/v1/models

If this fails while the host succeeds, the issue may be container networking.
