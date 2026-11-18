# Secure Development Context

This project should be worked on under the SciELO/FapUNIFESP secure development posture summarized from the provided NSI.04 context. Keep this as operational guidance for future Codex sessions; do not copy internal policy text verbatim into public outputs unless explicitly authorized.

## Core Requirements

- Preserve strict separation between development, test, homologation, and production.
- Apply least privilege to users, processes, SSH accounts, database connections, API tokens, and Proxmox credentials.
- Keep software and dependencies patched; run dependency/CVE checks before release when feasible.
- Keep all code and non-sensitive configuration under version control.
- Never version secrets, passwords, tokens, private keys, production hostnames, or sensitive data.
- Prefer secrets managers or injected environment variables for credentials.
- Do not log secrets, tokens, passwords, private keys, or sensitive operational data.
- Protect audit logs against tampering and restrict access to them.
- Use HTTPS for web access and secure internal communication; prefer VPN or mTLS for sensitive service-to-service paths.
- Use parameterized queries for all database access.
- Avoid insecure cryptography: no MD5, SHA1, DES, 3DES, RC4, RC2, MD4, or ECB mode.
- Document security-relevant decisions when making non-obvious tradeoffs.

## Project-Specific Application

- `POST /webhook/alertmanager` must remain authenticated with `ORCH_WEBHOOK_TOKEN`.
- Token comparisons must remain timing-safe.
- Compose examples must use placeholders and `.env`; never commit real tokens or private key paths that reveal sensitive infrastructure.
- SSH must use public-key authentication; password auth remains disabled by default.
- The `rundeck` or automation user should have tightly scoped sudo permissions only for required service checks/restarts.
- Proxmox tokens should have the narrowest role needed for the configured VM reboot action.
- SQLite is acceptable for MVP audit/state, but production should consider encrypted storage, restricted filesystem permissions, retention policy, and PostgreSQL with least-privilege DML-only credentials.
- Audit events should include enough for postmortem but must not include secrets.
- Real infrastructure hostnames should not be reintroduced into public docs, tests, or default config.

## Review Checklist

Before committing security-sensitive changes, check:

- No arbitrary command execution or shell command construction from payload fields.
- No secrets in source, docs, tests, logs, docker-compose, `.env.example`, or YAML config.
- All external input is validated with Pydantic or equivalent.
- Database calls remain parameterized.
- Auth failure paths are closed by default.
- Circuit breakers still execute before actions.
- Post-action validation and audit recording still happen.
- Docker runs as non-root and required writable paths have explicit ownership.
- Tests cover authentication, authorization/allowlist, circuit breaker, and blocked unsafe paths.
- README/runbooks mention rollback and backup expectations for production deployment where relevant.
