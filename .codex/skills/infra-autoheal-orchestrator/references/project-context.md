# Project Context

## Purpose

`infra-autoheal-orchestrator` is a Python 3.12+ FastAPI service that receives Alertmanager webhooks, chooses safe local runbooks, executes allowlisted SSH actions or protected Proxmox API operations, validates recovery, and stores full audit evidence.

## Repository

Default local path:

```text
/Users/rondinelisaad/Downloads/repo-scielo/infra-autoheal-orchestrator
```

Remote:

```text
https://github.com/scieloorg/infra-autoheal-orchestrator.git
```

Main app path:

```text
orchestrator/
```

## Key Files

- `orchestrator/app/main.py`: FastAPI app, startup/lifespan.
- `orchestrator/app/routes/alertmanager.py`: `POST /webhook/alertmanager`.
- `orchestrator/app/security.py`: webhook token validation.
- `orchestrator/app/config.py`: settings and YAML config models.
- `orchestrator/app/runner.py`: orchestration flow.
- `orchestrator/app/rules/router.py`: alert-to-action routing and allowed hosts.
- `orchestrator/app/rules/policies.py`: circuit breaker.
- `orchestrator/app/actions/ssh.py`: SSH executor and command allowlist.
- `orchestrator/app/actions/apache.py`: Apache restart runbook.
- `orchestrator/app/actions/mariadb.py`: MariaDB restart runbook.
- `orchestrator/app/actions/proxmox.py`: protected VM reboot via Proxmox API.
- `orchestrator/app/actions/evidence.py`: Linux evidence collection.
- `orchestrator/app/storage/events.py`: SQLite audit events.
- `orchestrator/app/storage/state.py`: SQLite circuit-breaker state.
- `orchestrator/config/hosts.yaml`: host/service/proxmox mappings.
- `orchestrator/config/policies.yaml`: circuit-breaker limits and timeouts.
- `docker-compose.yml`: root compose for running from repo root.
- `.env.example`: required local environment values.

## Security Invariants

- Alertmanager payloads must never provide shell commands.
- Only configured alert/action mappings are accepted.
- Unknown alert names are recorded as `ignored`.
- Unauthorized host/action combinations are recorded as `blocked`.
- Webhook calls require `ORCH_WEBHOOK_TOKEN`.
- SSH uses public-key authentication, with password auth disabled by default.
- Commands are allowlisted in `actions/ssh.py`.
- Restart circuit breaker: max 2 restarts for same service/host in 15 minutes.
- Reboot circuit breaker: max 1 reboot per VM in 60 minutes.
- Reboot requires `HostUnreachable`, alert active for at least 5 minutes, SSH unavailable, blackbox unavailable, and Proxmox mapping.
- Every processed alert must generate an auditable record.

## Generic Hosts Used In Repo

The repository intentionally uses generic names:

- `app-node-01.example.local`
- `db-node-01.example.local`

Do not reintroduce real infrastructure names into examples, tests, README, or default config unless explicitly requested.

## Validation

From `orchestrator/`:

```bash
.venv/bin/python -m pytest -p no:cacheprovider
.venv/bin/python -m ruff check . --no-cache
```

If `.venv` does not exist:

```bash
python3.12 -m venv .venv
source .venv/bin/activate
pip install -e ".[dev]"
```

## Docker

From repo root:

```bash
cp .env.example .env
docker compose up --build
```

Required:

- `ORCH_WEBHOOK_TOKEN`
- `SSH_PRIVATE_KEY_PATH`

The service runs as non-root user `orchestrator`. The Dockerfile creates `/app/data` and sets ownership so SQLite can create `/app/data/orchestrator.sqlite3`.

If a previously-created named volume has bad permissions, use:

```bash
docker compose down -v
docker compose up --build
```

This deletes the local audit SQLite volume.

## Common Change Patterns

- Add a new safe action: update `ActionName`, `ALERT_ACTION_MAP`, host allowlist, action module, runner dispatch, tests, README.
- Add a new SSH command: add a fixed `AllowedCommand` in `actions/ssh.py`; do not assemble commands from payload fields.
- Add a new host: update `config/hosts.yaml`, `ALERT_ALLOWED_HOSTS`, tests, and docs.
- Change circuit-breaker limits: prefer `config/policies.yaml`; keep tests for blocked third restart/second reboot.
- Touch webhook auth: update `security.py`, route tests, README curl examples, and compose environment.

## Current Test Coverage Themes

Tests cover:

- ApacheDown only restarts Apache on allowed app host.
- MariaDBDown only restarts MariaDB on allowed DB/app hosts.
- Unknown alert is ignored and recorded.
- Unauthorized host is blocked.
- Payload cannot swap runbook action.
- Restart circuit breaker blocks third attempt.
- Reboot requires preconditions.
- Proxmox reboot happens only when preconditions pass.
- Reboot circuit breaker blocks second attempt.
- Webhook endpoint requires token.
- SSH command allowlist rejects unknown commands.
