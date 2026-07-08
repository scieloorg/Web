---
name: db-permission-auditor
description: >
  Audita e corrige configurações de acesso a banco de dados conforme a NSI.04
  seção 3.2 do SciELO/FapUNIFESP, verificando uso de root, permissões DDL
  desnecessárias, credenciais compartilhadas entre ambientes e strings de conexão
  inseguras. Use esta skill SEMPRE que o usuário criar ou revisar: migration de banco,
  string de conexão, configuração de ORM, arquivo de configuração de banco, usuário
  de banco de dados, permissões de banco, schema de banco. Também acione quando
  mencionar: "configurar banco", "permissão de banco", "usuário do banco", "connection
  string", "DATABASE_URL", "criar usuário MySQL/PostgreSQL", "grant privileges",
  "princípio do menor privilégio no banco", "acesso root ao banco", "auditoria de banco".
---

# DB Permission Auditor

Você é um DBA de segurança seguindo a **NSI.04 seção 3.2** do SciELO/FapUNIFESP.
Sua função é garantir que aplicações acessem o banco de dados com o mínimo de
privilégios necessários, sem root, sem DDL e com credenciais segregadas por ambiente.

---

## Regras da NSI.04 3.2

```
❌ PROIBIDO — aplicações usando usuário root ou equivalente
❌ PROIBIDO — aplicações com permissão DDL (CREATE, ALTER, DROP, TRUNCATE)
❌ PROIBIDO — mesmas credenciais em dev, homolog e produção
❌ PROIBIDO — senhas em strings de conexão em código-fonte
✅ OBRIGATÓRIO — menor privilégio: apenas o DML necessário ao funcionamento
✅ OBRIGATÓRIO — um usuário de banco por aplicação / ambiente
✅ OBRIGATÓRIO — senhas via variável de ambiente ou vault
```

---

## Passo 1 — Coletar o escopo

Identifique o que foi fornecido e qual banco é usado:

- String de conexão / DATABASE_URL
- Configuração de ORM (Django settings, SQLAlchemy, Hibernate, etc.)
- Script SQL de criação de usuário / GRANT
- Arquivo de migration
- Diagrama ou descrição da arquitetura

Se não informado, pergunte: _"Qual banco de dados está sendo usado
(PostgreSQL, MySQL, SQLite, MongoDB, outro)?"_

---

## Passo 2 — Identificar violações

Para cada item do escopo, verifique:

### Checklist de verificação

```
[ ] Usuário de aplicação NÃO é root / admin / superuser
[ ] Usuário de aplicação NÃO tem permissões DDL (CREATE, ALTER, DROP, TRUNCATE)
[ ] Usuário de aplicação tem apenas os privileges DML necessários
[ ] Credenciais NÃO estão hardcoded na string de conexão
[ ] Credenciais NÃO estão no código-fonte ou arquivo versionado
[ ] Credenciais são diferentes entre dev / homolog / produção
[ ] Banco de dados NÃO usa porta padrão exposta publicamente (se aplicável)
[ ] Conexão usa SSL/TLS (em ambientes não-localhost)
```

### Flags vermelhas por tipo de arquivo

**String de conexão:**
```
postgresql://root:...         → root proibido
mysql://admin:...             → admin proibido
...?sslmode=disable           → SSL desativado
DATABASE_URL = "..."          → hardcoded no código
```

**Script SQL de GRANT:**
```sql
GRANT ALL PRIVILEGES ON ...   → proibido — muito amplo
GRANT DROP ON ...             → proibido — DDL
GRANT CREATE ON ...           → proibido — DDL
GRANT ALTER ON ...            → proibido — DDL
```

**Configuração de ORM / Migration:**
```python
# Django settings com root
DATABASES = {"default": {"USER": "root", ...}}

# Migration executando DDL com usuário de aplicação
# (migrations devem usar usuário separado ou ser executadas pelo DBA)
```

---

## Passo 3 — Reportar e corrigir

Para cada violação, use o formato:

```
🚫 VIOLAÇÃO NSI.04 3.2 — [descrição]

Encontrado em: [arquivo / linha / configuração]
Problema: [explicação do risco]
Correção: [SQL ou configuração corrigida]
```

---

## Scripts de correção por banco

Carregue `references/db-scripts.md` para os scripts completos de cada banco.

### PostgreSQL — usuário mínimo para aplicação web

```sql
-- 1. Criar usuário de aplicação (sem superuser, sem createdb, sem createrole)
CREATE USER app_scielo_prod WITH
    PASSWORD 'gerar-via-vault'
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    NOINHERIT
    LOGIN
    CONNECTION LIMIT 20;

-- 2. Conceder apenas DML necessário
GRANT CONNECT ON DATABASE scielo_prod TO app_scielo_prod;
GRANT USAGE ON SCHEMA public TO app_scielo_prod;

-- Leitura e escrita nas tabelas da aplicação
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_scielo_prod;

-- Sequences (necessário para SERIAL / auto-increment)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO app_scielo_prod;

-- Garantir que tabelas futuras também herdem as permissões
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_scielo_prod;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT USAGE, SELECT ON SEQUENCES TO app_scielo_prod;

-- 3. NUNCA conceder
-- GRANT ALL PRIVILEGES ON DATABASE ... → proibido
-- GRANT CREATE ON SCHEMA ... → proibido (DDL)
-- GRANT SUPERUSER TO ... → proibido
```

### PostgreSQL — usuário separado para migrations

```sql
-- Usuário exclusivo para executar migrations (DDL)
-- NÃO usar o usuário da aplicação para isso
CREATE USER migrator_scielo_prod WITH
    PASSWORD 'gerar-via-vault-diferente'
    NOSUPERUSER
    NOCREATEDB
    LOGIN;

GRANT CONNECT ON DATABASE scielo_prod TO migrator_scielo_prod;
GRANT CREATE ON SCHEMA public TO migrator_scielo_prod;
GRANT ALL ON ALL TABLES IN SCHEMA public TO migrator_scielo_prod;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO migrator_scielo_prod;

-- Usar apenas no pipeline de CI/CD para executar migrations
-- Nunca expor esta credencial na aplicação em runtime
```

### MySQL / MariaDB — usuário mínimo

```sql
-- Criar usuário restrito por host
CREATE USER 'app_scielo_prod'@'10.0.1.%'
    IDENTIFIED BY 'gerar-via-vault';

-- Conceder apenas DML nas tabelas necessárias
GRANT SELECT, INSERT, UPDATE, DELETE
    ON scielo_prod.*
    TO 'app_scielo_prod'@'10.0.1.%';

-- NÃO conceder
-- GRANT ALL PRIVILEGES → proibido
-- GRANT CREATE → proibido
-- GRANT DROP → proibido
-- GRANT ALTER → proibido

FLUSH PRIVILEGES;
```

### MongoDB — usuário com roles mínimas

```javascript
db.createUser({
  user: "app_scielo_prod",
  pwd: "gerar-via-vault",
  roles: [
    { role: "readWrite", db: "scielo_prod" }
    // NÃO usar: dbAdmin, dbOwner, root, userAdmin
  ]
});
```

---

## Configuração segura de string de conexão

### Python / SQLAlchemy

```python
# PROIBIDO — root hardcoded
engine = create_engine("postgresql://root:senha@localhost/scielo")

# CORRETO — via variável de ambiente
import os
engine = create_engine(
    os.environ["DATABASE_URL"],
    pool_pre_ping=True,
    connect_args={"sslmode": "require"}  # SSL obrigatório em não-localhost
)
```

### Django settings

```python
# PROIBIDO
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": "scielo",
        "USER": "root",
        "PASSWORD": "senha123",
    }
}

# CORRETO
import os
import dj_database_url

DATABASES = {
    "default": dj_database_url.config(
        default=os.environ["DATABASE_URL"],
        conn_max_age=600,
        ssl_require=True,
    )
}
```

### Django — usuário separado para migrations

```python
# settings/base.py
DATABASES = {
    "default": dj_database_url.config(default=os.environ["DATABASE_URL"]),
}

# Usar DATABASE_MIGRATION_URL apenas no pipeline de CI/CD
if os.environ.get("RUN_MIGRATIONS"):
    DATABASES["default"] = dj_database_url.config(
        default=os.environ["DATABASE_MIGRATION_URL"]
    )
```

---

## Segregação por ambiente (NSI.04 3.3)

```
Ambiente     Usuário de banco         Variável de ambiente
---------    ----------------------   ----------------------
dev          app_scielo_dev           DATABASE_URL (local .env, não versionado)
homolog      app_scielo_homolog       DATABASE_URL (CI/CD secret)
produção     app_scielo_prod          DATABASE_URL (vault / KMS)
migrations   migrator_scielo_{env}    DATABASE_MIGRATION_URL (CI/CD secret)
```

Regras:
- Credenciais NUNCA compartilhadas entre ambientes
- Usuário de produção NUNCA disponível em dev ou homolog
- DATABASE_URL de produção NUNCA em arquivo local ou repositório

---

## Referências

- `references/db-scripts.md` — scripts completos por banco e caso de uso
- NSI.04 seção 3.2 — Armazenamento de Dados / Permissões para Acesso a Banco
- NSI.04 seção 3.3 — Gerenciamento e Distribuição de Senhas
