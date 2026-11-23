---
name: audit-log-generator
description: >
  Gera automaticamente código de instrumentação de logs de auditoria conforme
  a NSI.04 seção 3.6 do SciELO/FapUNIFESP, cobrindo eventos de acesso, operações
  em banco de dados, autenticação e execução de jobs. Use esta skill SEMPRE que
  o usuário criar um novo endpoint, serviço, função de autenticação, operação
  CRUD, job automatizado, ou quando mencionar: "adicionar logs", "instrumentar",
  "auditoria", "rastreamento", "logging", "registrar eventos", "quem fez o quê",
  "trilha de auditoria", "audit trail", "logar operações", "registrar acessos",
  "log de autenticação", "log de banco de dados". A skill gera código pronto
  para uso, sem logar dados sensíveis, seguindo o formato da NSI.04.
---

# Audit Log Generator

Você é um especialista em observabilidade e auditoria seguindo a **NSI.04 seção 3.6**
do SciELO/FapUNIFESP. Sua função é gerar código de instrumentação de logs de auditoria
pronto para uso, respeitando o que **nunca** deve ser logado.

---

## Regras invioláveis de logging (NSI.04 3.6)

### Nunca logar
- Senhas, tokens, API keys, segredos
- Dados pessoais sensíveis: CPF, número de cartão, dados de saúde
- Corpo completo de requests sem filtragem (pode conter senha)
- Variáveis de ambiente completas

### Sempre logar (por evento)
- `timestamp` — ISO 8601 com timezone
- `user_id` — identificador opaco, nunca nome/email em texto livre
- `ip_address` — IP do cliente
- `session_id` — identificador de sessão (não o token em si)
- `action` — nome da operação realizada
- `resource` — recurso afetado (tabela, endpoint, objeto)
- `resource_id` — ID do registro afetado
- `result` — sucesso / falha / não-autorizado
- `before` / `after` — para operações de alteração (sem dados sensíveis)

---

## Passo 1 — Identificar o tipo de evento

Pergunte ao usuário (ou deduza do código fornecido) qual tipo de evento instrumentar:

| Tipo | Quando usar |
|------|------------|
| `auth` | Login, logout, falha de autenticação, MFA |
| `access` | Acesso a tela, endpoint ou dado restrito |
| `data_change` | INSERT, UPDATE, DELETE em banco de dados |
| `permission_change` | Alteração de role, permissão ou perfil de acesso |
| `job` | Execução de job, task agendada, script batch |
| `system` | Erros de sistema, eventos de infraestrutura |

---

## Passo 2 — Gerar o código de instrumentação

### Python / Flask — middleware de auditoria

```python
# audit/logger.py
import logging
import json
from datetime import datetime, timezone
from typing import Optional, Any

audit_logger = logging.getLogger("audit")

def log_event(
    action: str,
    result: str,                      # "success" | "failure" | "unauthorized"
    user_id: Optional[str] = None,
    ip_address: Optional[str] = None,
    session_id: Optional[str] = None,
    resource: Optional[str] = None,
    resource_id: Optional[str] = None,
    before: Optional[dict] = None,    # estado anterior (sem campos sensíveis)
    after: Optional[dict] = None,     # estado posterior (sem campos sensíveis)
    extra: Optional[dict] = None,     # contexto adicional não sensível
) -> None:
    """
    Registra evento de auditoria conforme NSI.04 seção 3.6.
    NUNCA inclua senhas, tokens ou dados pessoais sensíveis nos parâmetros.
    """
    entry = {
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "action": action,
        "result": result,
        "user_id": user_id,
        "ip_address": ip_address,
        "session_id": session_id,
        "resource": resource,
        "resource_id": str(resource_id) if resource_id else None,
        "before": _strip_sensitive(before),
        "after": _strip_sensitive(after),
    }
    if extra:
        entry["extra"] = _strip_sensitive(extra)

    audit_logger.info(json.dumps(entry, default=str, ensure_ascii=False))


# Campos que NUNCA devem aparecer em logs
_SENSITIVE_FIELDS = {
    "password", "senha", "pwd", "token", "secret", "api_key",
    "credit_card", "cpf", "ssn", "cvv", "pin",
}

def _strip_sensitive(data: Optional[dict]) -> Optional[dict]:
    if not data:
        return data
    return {
        k: "***" if k.lower() in _SENSITIVE_FIELDS else v
        for k, v in data.items()
    }
```

### Uso — autenticação

```python
# routes/auth.py
from audit.logger import log_event
from flask import request
from flask_login import current_user

@app.route("/login", methods=["POST"])
def login():
    email = request.json.get("email")
    password = request.json.get("password")  # NUNCA logar isso

    user = User.query.filter_by(email=email).first()

    if not user or not bcrypt.checkpw(password.encode(), user.password_hash):
        log_event(
            action="auth.login",
            result="failure",
            ip_address=request.remote_addr,
            resource="user",
            extra={"reason": "invalid_credentials"}
        )
        return {"error": "Credenciais inválidas"}, 401

    session_id = create_session(user)

    log_event(
        action="auth.login",
        result="success",
        user_id=str(user.id),
        ip_address=request.remote_addr,
        session_id=session_id,
        resource="user",
        resource_id=user.id,
    )
    return {"token": session_id}, 200


@app.route("/logout", methods=["POST"])
@login_required
def logout():
    log_event(
        action="auth.logout",
        result="success",
        user_id=str(current_user.id),
        ip_address=request.remote_addr,
        session_id=session.get("session_id"),
    )
    session.clear()
    return {}, 204
```

### Uso — operação CRUD com before/after

```python
# routes/articles.py
from audit.logger import log_event

@app.route("/articles/<int:article_id>", methods=["PUT"])
@login_required
def update_article(article_id):
    article = Article.query.filter_by(
        id=article_id, owner_id=current_user.id
    ).first_or_404()

    # Capturar estado anterior (apenas campos não sensíveis)
    before_state = {
        "title": article.title,
        "status": article.status,
        "updated_at": article.updated_at.isoformat(),
    }

    data = request.json
    article.title = data.get("title", article.title)
    article.status = data.get("status", article.status)
    db.session.commit()

    log_event(
        action="article.update",
        result="success",
        user_id=str(current_user.id),
        ip_address=request.remote_addr,
        session_id=session.get("session_id"),
        resource="article",
        resource_id=article_id,
        before=before_state,
        after={
            "title": article.title,
            "status": article.status,
            "updated_at": article.updated_at.isoformat(),
        },
    )
    return article.to_dict(), 200
```

### Uso — acesso a dado restrito

```python
@app.route("/relatorios/financeiro")
@login_required
@require_role("financeiro")
def relatorio_financeiro():
    log_event(
        action="access.restricted_report",
        result="success",
        user_id=str(current_user.id),
        ip_address=request.remote_addr,
        session_id=session.get("session_id"),
        resource="report.financeiro",
    )
    return generate_report()
```

### Uso — job automatizado

```python
# jobs/sync_journals.py
from audit.logger import log_event
import time

def sync_journals():
    start = time.time()
    errors = []

    try:
        count = do_sync()
        duration_ms = int((time.time() - start) * 1000)

        log_event(
            action="job.sync_journals",
            result="success",
            resource="journal",
            extra={
                "records_processed": count,
                "duration_ms": duration_ms,
            }
        )
    except Exception as e:
        log_event(
            action="job.sync_journals",
            result="failure",
            resource="journal",
            extra={
                "error_type": type(e).__name__,
                "error_message": str(e)[:200],  # truncar para evitar log bombing
                "duration_ms": int((time.time() - start) * 1000),
            }
        )
        raise
```

---

## Passo 3 — Configurar o handler de log

```python
# config/logging.py
import logging
import logging.handlers

def configure_audit_logging():
    audit_logger = logging.getLogger("audit")
    audit_logger.setLevel(logging.INFO)
    audit_logger.propagate = False  # não vazar para root logger

    # Arquivo rotativo — append only é suficiente para auditoria básica
    handler = logging.handlers.TimedRotatingFileHandler(
        filename="logs/audit.log",
        when="midnight",
        backupCount=90,  # 90 dias de retenção mínima
        encoding="utf-8",
    )
    handler.setFormatter(logging.Formatter("%(message)s"))  # JSON já formatado
    audit_logger.addHandler(handler)

    # Opcional: enviar também para SIEM/ELK
    # audit_logger.addHandler(SIEMHandler(...))
```

---

## Referências

- `references/event-catalog.md` — catálogo completo de ações e recursos padrão
- NSI.04 seção 3.6 — Auditoria, Rastreamento e Logs
