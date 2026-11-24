---
name: infra-autoheal-orchestrator
description: "Work on the infra-autoheal-orchestrator Python/FastAPI project. Use when Codex needs to inspect, modify, test, deploy, troubleshoot, or explain this repository: a secure infrastructure auto-healing orchestrator for Alertmanager webhooks, allowlisted SSH runbooks, circuit breakers, SQLite audit logs, optional OpenSearch indexing, and protected Proxmox VM reboot actions."
---

# Infra Autoheal Orchestrator

## Start Here

Use this skill for the repository at:

```text
/Users/rondinelisaad/Downloads/repo-scielo/infra-autoheal-orchestrator
```

If the repo has moved, locate it by searching for `orchestrator/app/main.py` and `orchestrator/pyproject.toml`.

Read `references/project-context.md` when you need project-specific architecture, safety invariants, test commands, Docker notes, or known operational details.

Read `references/secure-development-context.md` before making security-sensitive changes, especially authentication, authorization, logging, persistence, deployment, dependency, or infrastructure automation changes.

## Operating Rules

Preserve these invariants unless the user explicitly asks to change the security model:

- Follow the secure development context summarized from SciELO/FapUNIFESP NSI.04.
- Never execute arbitrary commands from Alertmanager payloads.
- Keep action dispatch allowlisted: `restart_apache`, `restart_mariadb`, `collect_evidence`, `reboot_vm`.
- Keep remote commands defined in code, not in alert payloads.
- Keep webhook authentication required via `ORCH_WEBHOOK_TOKEN`.
- Keep SSH password authentication disabled by default.
- Keep circuit breakers before restart/reboot actions.
- Keep post-action validation and audit persistence.
- Keep Proxmox reboot protected by multiple failed availability checks.

## Common Workflow

1. Inspect local changes first:

```bash
git status --short
```

2. For code changes, prefer narrow edits matching the existing module layout under `orchestrator/app`.

3. Validate from:

```text
/Users/rondinelisaad/Downloads/repo-scielo/infra-autoheal-orchestrator/orchestrator
```

Run:

```bash
.venv/bin/python -m pytest -p no:cacheprovider
.venv/bin/python -m ruff check . --no-cache
```

If `.venv` is missing, use Python 3.12:

```bash
python3.12 -m venv .venv
source .venv/bin/activate
pip install -e ".[dev]"
```

## Deployment Notes

Use root compose from the repository root:

```bash
cp .env.example .env
docker compose up --build
```

Required `.env` values:

- `ORCH_WEBHOOK_TOKEN`
- `SSH_PRIVATE_KEY_PATH`

If SQLite startup fails with `unable to open database file`, check `/app/data` volume ownership and the Dockerfile data-directory setup.

## References

- `references/project-context.md`: concise project memory and architecture map.
- `references/secure-development-context.md`: secure development guardrails summarized from the provided SciELO/FapUNIFESP context.
