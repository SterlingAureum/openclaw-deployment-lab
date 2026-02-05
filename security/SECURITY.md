# Security Notes

## Defaults
- Loopback bind only (127.0.0.1)
- Token-based auth
- No public exposure

## Token Handling
- Treat UI token as a password
- Never commit or share tokens
- Rotate if exposure is suspected

## Public Access
Do NOT bind gateway to 0.0.0.0 directly.
Use SSH tunnel, VPN, or reverse proxy with TLS and auth.

## Skills
Skills are disabled in baseline.
Enable selectively after review.
