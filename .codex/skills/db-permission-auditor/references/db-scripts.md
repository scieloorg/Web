# Scripts de Banco de Dados — Referência Completa

Carregue este arquivo para scripts completos e prontos para uso.

---

## PostgreSQL

### Verificar permissões atuais de um usuário

```sql
-- Permissões do usuário em tabelas
SELECT
    grantee,
    table_schema,
    table_name,
    string_agg(privilege_type, ', ' ORDER BY privilege_type) AS privileges
FROM information_schema.role_table_grants
WHERE grantee = 'app_scielo_prod'
GROUP BY grantee, table_schema, table_name
ORDER BY table_schema, table_name;

-- Verificar se é superuser ou tem createdb
SELECT
    usename,
    usesuper,
    usecreatedb,
    usecreaterole,
    usebypassrls
FROM pg_user
WHERE usename = 'app_scielo_prod';

-- Conexões ativas por usuário
SELECT
    usename,
    count(*) as connections,
    max(backend_start) as oldest_connection
FROM pg_stat_activity
WHERE usename != 'postgres'
GROUP BY usename;
```

### Revogar permissões excessivas

```sql
-- Revogar DDL concedido indevidamente
REVOKE CREATE ON SCHEMA public FROM app_scielo_prod;
REVOKE ALL ON DATABASE scielo_prod FROM app_scielo_prod;

-- Revogar SUPERUSER
ALTER USER app_scielo_prod NOSUPERUSER;
ALTER USER app_scielo_prod NOCREATEDB;
ALTER USER app_scielo_prod NOCREATEROLE;

-- Re-conceder apenas o necessário
GRANT CONNECT ON DATABASE scielo_prod TO app_scielo_prod;
GRANT USAGE ON SCHEMA public TO app_scielo_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_scielo_prod;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO app_scielo_prod;
```

### Auditoria de permissões — relatório completo

```sql
-- Relatório: usuários com mais privilégios do que deveriam
SELECT
    r.rolname AS role,
    r.rolsuper AS is_superuser,
    r.rolcreatedb AS can_create_db,
    r.rolcreaterole AS can_create_role,
    r.rolcanlogin AS can_login,
    r.rolconnlimit AS conn_limit,
    ARRAY(
        SELECT b.rolname
        FROM pg_catalog.pg_auth_members m
        JOIN pg_catalog.pg_roles b ON m.roleid = b.oid
        WHERE m.member = r.oid
    ) AS member_of
FROM pg_catalog.pg_roles r
WHERE r.rolcanlogin = true
ORDER BY r.rolname;

-- Tabelas sem owner definido (potencial risco)
SELECT
    schemaname,
    tablename,
    tableowner
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tableowner, tablename;
```

### SSL — verificar e forçar

```sql
-- Verificar se SSL está ativo
SHOW ssl;

-- Forçar SSL para usuário de aplicação no pg_hba.conf:
-- hostssl  scielo_prod  app_scielo_prod  10.0.0.0/8  scram-sha-256

-- Verificar conexões SSL ativas
SELECT
    usename,
    ssl,
    cipher,
    client_addr
FROM pg_stat_ssl
JOIN pg_stat_activity ON pg_stat_ssl.pid = pg_stat_activity.pid
WHERE usename IS NOT NULL;
```

---

## MySQL / MariaDB

### Verificar permissões atuais

```sql
-- Permissões de um usuário específico
SHOW GRANTS FOR 'app_scielo_prod'@'%';

-- Todos os usuários e seus hosts
SELECT user, host, plugin, authentication_string != '' as has_password
FROM mysql.user
ORDER BY user;

-- Usuários com ALL PRIVILEGES (flag vermelha)
SELECT GRANTEE, PRIVILEGE_TYPE, IS_GRANTABLE
FROM information_schema.USER_PRIVILEGES
WHERE PRIVILEGE_TYPE IN ('SUPER', 'FILE', 'PROCESS', 'SHUTDOWN', 'ALL')
ORDER BY GRANTEE;
```

### Revogar e reconfigurar

```sql
-- Revogar tudo e reconfigurar
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'app_scielo_prod'@'%';

-- Conceder apenas DML
GRANT SELECT, INSERT, UPDATE, DELETE ON scielo_prod.* TO 'app_scielo_prod'@'10.0.1.%';
FLUSH PRIVILEGES;

-- Verificar resultado
SHOW GRANTS FOR 'app_scielo_prod'@'10.0.1.%';
```

### Restrição por host

```sql
-- CORRETO — restringir por sub-rede
CREATE USER 'app_scielo_prod'@'10.0.1.%' IDENTIFIED BY 'senha-do-vault';

-- EVITAR — acesso de qualquer host
CREATE USER 'app_scielo_prod'@'%' ...;  -- só se necessário e documentado

-- PROIBIDO para aplicação
CREATE USER 'root'@'%' ...;
```

### SSL obrigatório

```sql
-- Forçar SSL para o usuário
ALTER USER 'app_scielo_prod'@'10.0.1.%' REQUIRE SSL;

-- Verificar
SELECT user, host, ssl_type FROM mysql.user WHERE user = 'app_scielo_prod';
```

---

## MongoDB

### Verificar roles de um usuário

```javascript
// Listar usuários e roles
db.getUsers()

// Usuário específico
db.getUser("app_scielo_prod")

// Usuários com role dbAdmin ou dbOwner (flags vermelhas para aplicação)
db.system.users.find({
  "roles.role": { $in: ["dbAdmin", "dbOwner", "root", "userAdmin"] }
})
```

### Reconfigurar roles

```javascript
// Revogar role excessiva
db.revokeRolesFromUser("app_scielo_prod", [
  { role: "dbAdmin", db: "scielo_prod" }
]);

// Conceder apenas readWrite
db.grantRolesToUser("app_scielo_prod", [
  { role: "readWrite", db: "scielo_prod" }
]);

// Verificar
db.getUser("app_scielo_prod")
```

### Roles permitidas para aplicação

```
✅ readWrite         → leitura e escrita nas collections
✅ read              → somente leitura (se aplicação for read-only)
❌ dbAdmin           → administração do banco
❌ dbOwner           → owner do banco
❌ userAdmin         → gestão de usuários
❌ root              → superuser
❌ clusterAdmin      → administração de cluster
```

---

## SQLite (apenas para desenvolvimento local)

SQLite não tem sistema de usuários. Por isso:

```
✅ Usar SQLite apenas em desenvolvimento local
❌ NUNCA usar SQLite em produção para dados sensíveis
❌ NUNCA versionar o arquivo .sqlite no repositório

# .gitignore
*.sqlite
*.db
*.sqlite3
```

---

## Checklist de revisão — pronto para usar

```
AUDITORIA DE PERMISSÕES DE BANCO — [SISTEMA] — [DATA]

Banco: [ ] PostgreSQL  [ ] MySQL  [ ] MongoDB  [ ] Outro: ___
Ambiente: [ ] Dev  [ ] Homolog  [ ] Produção

USUÁRIO DE APLICAÇÃO
[ ] Usuário dedicado criado (não root/admin)
[ ] NOSUPERUSER / sem equivalente
[ ] Sem CREATE, DROP, ALTER, TRUNCATE
[ ] Apenas SELECT, INSERT, UPDATE, DELETE nas tabelas necessárias
[ ] Limite de conexões configurado
[ ] SSL/TLS obrigatório (non-localhost)

USUÁRIO DE MIGRATION
[ ] Usuário separado do usuário de aplicação
[ ] Usado apenas no pipeline de CI/CD
[ ] Não disponível em runtime da aplicação

CREDENCIAIS
[ ] Senha não está hardcoded em código-fonte
[ ] Senha não está em arquivo versionado
[ ] Senha diferente de outros ambientes
[ ] Senha segue política NSI.04 (≥ 8 chars, maiúsc+minúsc+símbolo)
[ ] Senha armazenada em vault / variável de ambiente segura

RESULTADO
[ ] APROVADO — configuração conforme NSI.04 3.2
[ ] REPROVADO — itens acima marcados para correção
```
