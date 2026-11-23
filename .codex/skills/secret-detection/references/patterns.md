# Padrões de Detecção por Linguagem

Referência de padrões regex e exemplos para cada categoria de segredo.
Carregue este arquivo quando precisar de maior precisão na detecção
ou quando o usuário perguntar "como você detecta X".

---

## Padrões universais (qualquer linguagem)

```
# Chaves privadas
-----BEGIN (RSA|EC|DSA|OPENSSH) PRIVATE KEY-----

# JWT hardcoded
eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}

# AWS
AKIA[A-Z0-9]{16}
aws_secret_access_key\s*=\s*[A-Za-z0-9/+=]{40}

# GitHub
ghp_[A-Za-z0-9]{36}
ghs_[A-Za-z0-9]{36}
github_pat_[A-Za-z0-9_]{82}

# Stripe
sk_live_[A-Za-z0-9]{24,}
pk_live_[A-Za-z0-9]{24,}

# Slack
xoxb-[0-9]{11}-[0-9]{11}-[A-Za-z0-9]{24}
xoxp-[0-9]{11}-[0-9]{11}-[0-9]{11}-[A-Za-z0-9]{32}

# Google API
AIza[A-Za-z0-9_-]{35}

# Strings de conexão com senha embutida
(postgres|mysql|mongodb|redis|amqp)://[^:]+:[^@]{3,}@
```

---

## Python

```python
# PROIBIDO — senha hardcoded
password = "abc123"
DB_PASS  = 'secret'
SECRET_KEY = "django-insecure-xxxx"

# PROIBIDO — hash inseguro de senha
hashlib.md5(password)
hashlib.sha1(pwd.encode())

# PROIBIDO — logar ambiente completo
print(os.environ)
logger.debug(os.environ.copy())

# PROIBIDO — credencial em string de conexão
engine = create_engine("postgresql://app:SENHA@db/mydb")

# CORRETO
password = os.environ["DB_PASSWORD"]
engine   = create_engine(os.environ["DATABASE_URL"])
```

---

## JavaScript / TypeScript

```javascript
// PROIBIDO
const apiKey = "sk-abc123xyz";
const token  = "Bearer eyJhb...";
process.env.SECRET = "valor_hardcoded";   // irônico mas acontece

// PROIBIDO — expor todo o env em log
console.log(process.env);

// CORRETO
const apiKey = process.env.API_KEY;
```

---

## Java / Spring

```java
// PROIBIDO
@Value("minha_senha_hardcoded")
private String password;

String url = "jdbc:postgresql://host/db?user=app&password=SENHA";

// PROIBIDO em application.properties commitado
spring.datasource.password=minha_senha

// CORRETO — usar variável de ambiente ou vault
spring.datasource.password=${DB_PASSWORD}
```

---

## Go

```go
// PROIBIDO
const dbPassword = "minha_senha"
os.Setenv("SECRET", "hardcoded")  // ainda proibido

// CORRETO
dbPassword := os.Getenv("DB_PASSWORD")
```

---

## Shell / Bash

```bash
# PROIBIDO
export DB_PASSWORD="minha_senha"
curl -H "Authorization: Bearer abc123token" ...

# PROIBIDO — imprimir todas as variáveis de ambiente
env
printenv
set  # em alguns shells expõe tudo

# CORRETO — usar arquivo de segredos fora do repo
source /etc/app/secrets.env
curl -H "Authorization: Bearer ${API_TOKEN}" ...
```

---

## Docker / Docker Compose

```yaml
# PROIBIDO em docker-compose.yml commitado
environment:
  - DB_PASSWORD=minha_senha
  - API_KEY=sk-abc123

# CORRETO — usar arquivo .env (não versionado) ou secrets
environment:
  - DB_PASSWORD=${DB_PASSWORD}
secrets:
  - db_password
```

---

## Kubernetes

```yaml
# PROIBIDO — secret em base64 direto no YAML commitado
apiVersion: v1
kind: Secret
data:
  password: bWluaGFfc2VuaGE=   # "minha_senha" em base64

# CORRETO — referenciar de vault externo (ex: External Secrets Operator)
# ou usar SealedSecrets para versionar de forma segura
```

---

## Arquivos de configuração

```ini
# PROIBIDO — settings.ini, config.cfg commitados com valor real
[database]
password = minha_senha_real

# CORRETO — usar placeholder e documentar no README
[database]
password = ${DB_PASSWORD}
```

```json
// PROIBIDO — appsettings.json com valor real
{
  "ConnectionStrings": {
    "Default": "Server=host;Password=minha_senha;"
  }
}

// CORRETO
{
  "ConnectionStrings": {
    "Default": "Server=host;Password=#{DB_PASSWORD}#;"
  }
}
```

---

## Falsos positivos comuns

Estes padrões se parecem com segredos mas geralmente não são:

| Padrão | Motivo para ignorar |
|--------|---------------------|
| `password = ""` | String vazia — sem risco |
| `password = os.environ[...]` | Referência segura |
| `password = getpass.getpass()` | Leitura interativa |
| `password = vault.get_secret(...)` | Uso de vault |
| `# exemplo: password = "abc"` | Comentário de documentação |
| `test_password = "test123"` | Em arquivos `test_*.py` com dados fictícios |

Confirme com o usuário quando houver dúvida sobre falsos positivos.
