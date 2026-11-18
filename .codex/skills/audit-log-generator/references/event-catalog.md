# Catálogo de Eventos de Auditoria

Padronização de nomes de `action` e `resource` para consistência nos logs.
Carregue este arquivo quando precisar do nome canônico de um evento.

---

## Convenção de nomenclatura

```
action  = "{domínio}.{operação}"        ex: "auth.login", "article.delete"
resource = "{entidade}" ou "{entidade}.{subtipo}"   ex: "user", "report.financeiro"
```

Use snake_case. Evite nomes genéricos como "update" sem contexto.

---

## Domínio: auth — Autenticação

| action | result esperado | Descrição |
|--------|----------------|-----------|
| `auth.login` | success / failure | Tentativa de login |
| `auth.logout` | success | Encerramento de sessão |
| `auth.login_blocked` | failure | Login bloqueado por excesso de tentativas |
| `auth.password_reset_request` | success / failure | Solicitação de reset de senha |
| `auth.password_reset` | success / failure | Redefinição de senha concluída |
| `auth.mfa_challenge` | success / failure | Verificação de MFA |
| `auth.session_expired` | failure | Sessão expirada automaticamente |
| `auth.token_refresh` | success / failure | Renovação de token de acesso |

---

## Domínio: access — Acesso a recursos restritos

| action | Descrição |
|--------|-----------|
| `access.restricted_page` | Acesso a tela com restrição de perfil |
| `access.restricted_report` | Acesso a relatório restrito |
| `access.personal_data` | Acesso a dados pessoais de terceiro |
| `access.admin_panel` | Acesso ao painel administrativo |
| `access.denied` | Tentativa de acesso negada (403) |

---

## Domínio: data — Operações em banco de dados

| action | Descrição |
|--------|-----------|
| `data.create` | INSERT — criação de registro |
| `data.read` | SELECT em dado sensível ou restrito |
| `data.update` | UPDATE — alteração de registro |
| `data.delete` | DELETE — exclusão de registro |
| `data.bulk_export` | Exportação em massa de dados |
| `data.import` | Importação de dados externos |

---

## Domínio: permission — Controle de acesso

| action | Descrição |
|--------|-----------|
| `permission.role_assigned` | Role atribuída a usuário |
| `permission.role_removed` | Role removida de usuário |
| `permission.user_created` | Novo usuário criado |
| `permission.user_deactivated` | Usuário desativado |
| `permission.user_reactivated` | Usuário reativado |
| `permission.group_modified` | Grupo de permissão alterado |

---

## Domínio: job — Tarefas automatizadas

| action | Descrição |
|--------|-----------|
| `job.{nome_do_job}` | Execução do job — usar nome descritivo |
| `job.sync_journals` | Sincronização de periódicos |
| `job.index_articles` | Indexação de artigos |
| `job.backup` | Execução de backup |
| `job.cleanup` | Limpeza de dados expirados |

---

## Domínio: file — Operações com arquivos

| action | Descrição |
|--------|-----------|
| `file.upload` | Upload de arquivo pelo usuário |
| `file.download` | Download de arquivo restrito |
| `file.delete` | Exclusão de arquivo |
| `file.virus_detected` | Malware detectado em upload |

---

## Domínio: system — Eventos de sistema

| action | Descrição |
|--------|-----------|
| `system.config_changed` | Configuração de sistema alterada |
| `system.error` | Erro não tratado registrado |
| `system.startup` | Inicialização do serviço |
| `system.shutdown` | Encerramento do serviço |

---

## Resources padrão por entidade (SciELO)

| resource | Descrição |
|----------|-----------|
| `user` | Usuário do sistema |
| `journal` | Periódico científico |
| `article` | Artigo científico |
| `collection` | Coleção SciELO |
| `report` | Relatório gerado |
| `report.financeiro` | Relatório financeiro restrito |
| `report.usage` | Relatório de uso/métricas |
| `config` | Configuração de sistema |
| `backup` | Operação de backup |

---

## Campos opcionais por tipo de evento

### Para auth.login (failure)
```json
{
  "extra": {
    "reason": "invalid_credentials | account_blocked | mfa_failed",
    "attempt_count": 3
  }
}
```

### Para data.update
```json
{
  "before": { "status": "draft", "title": "Título antigo" },
  "after":  { "status": "published", "title": "Título novo" }
}
```

### Para job.*
```json
{
  "extra": {
    "records_processed": 1500,
    "duration_ms": 3200,
    "error_type": null,
    "scheduled": true
  }
}
```

### Para access.denied
```json
{
  "extra": {
    "required_role": "admin",
    "user_role": "editor",
    "attempted_resource": "/admin/users"
  }
}
```
