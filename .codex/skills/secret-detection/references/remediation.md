# Guia de Remediação por Tipo de Segredo

Carregue este arquivo quando precisar orientar a correção de um segredo detectado.
Para cada tipo, a remediação tem sempre duas etapas obrigatórias:
1. **Rotacionar** — invalidar o segredo exposto e gerar um novo
2. **Remover** — retirar do código e do histórico git

---

## Regra de ouro

> Um segredo que já foi commitado deve ser tratado como **comprometido**,
> independentemente de o repositório ser privado. Remover do histórico
> não é suficiente — a rotação é obrigatória.

---

## Senha de banco de dados

**Rotação:**
```sql
-- PostgreSQL
ALTER USER app_scielo_prod WITH PASSWORD 'nova-senha-gerada-pelo-vault';

-- MySQL
ALTER USER 'app_scielo_prod'@'%' IDENTIFIED BY 'nova-senha-gerada-pelo-vault';
```

**Remoção do código:**
```python
# ANTES
DATABASE_URL = "postgresql://app:SENHA_EXPOSTA@host/db"

# DEPOIS
import os
DATABASE_URL = os.environ["DATABASE_URL"]
```

**Remoção do histórico git:**
```bash
# Opção 1 — BFG Repo Cleaner (mais simples)
java -jar bfg.jar --replace-text senhas-a-remover.txt meu-repo.git
git reflog expire --expire=now --all
git gc --prune=now --aggressive
git push --force

# Opção 2 — git filter-repo
pip install git-filter-repo
git filter-repo --path arquivo-com-senha --invert-paths
git push --force

# APÓS qualquer reescrita de histórico:
# - Notificar todos os colaboradores para re-clonar o repositório
# - Invalidar todos os forks se o repo for público
```

---

## Token de API (AWS, Stripe, GitHub, etc.)

**Rotação — AWS:**
```bash
# Criar nova access key
aws iam create-access-key --user-name nome-do-usuario

# Atualizar no vault/secrets manager
aws secretsmanager update-secret \
  --secret-id "scielo/aws-access-key" \
  --secret-string '{"key":"NOVA_KEY","secret":"NOVO_SECRET"}'

# Desativar a key exposta
aws iam update-access-key \
  --access-key-id AKIA_KEY_EXPOSTA \
  --status Inactive \
  --user-name nome-do-usuario

# Deletar após confirmar que nova key está funcionando
aws iam delete-access-key \
  --access-key-id AKIA_KEY_EXPOSTA \
  --user-name nome-do-usuario
```

**Rotação — GitHub Token:**
```
1. Acesse github.com → Settings → Developer settings → Personal access tokens
2. Revogue o token exposto
3. Gere um novo com os mesmos escopos
4. Atualize no vault ou GitHub Secrets
```

**Rotação — Stripe:**
```
1. Acesse dashboard.stripe.com → Developers → API keys
2. Role a chave exposta (Roll key)
3. Atualize no vault
```

**Substituição no código:**
```python
# ANTES
import stripe
stripe.api_key = "sk_live_abc123xyz"

# DEPOIS
import os
import stripe
stripe.api_key = os.environ["STRIPE_API_KEY"]
```

---

## Chave privada (RSA, SSH, certificado)

**Rotação:**
```bash
# Gerar novo par de chaves RSA-4096
openssl genrsa -out nova-chave-privada.pem 4096
openssl rsa -in nova-chave-privada.pem -pubout -out nova-chave-publica.pem

# Gerar novo par SSH Ed25519
ssh-keygen -t ed25519 -C "deploy-scielo-prod" -f ~/.ssh/nova-chave-deploy

# Atualizar a chave pública em todos os servidores que usavam a antiga
# Revogar a chave antiga nos servidores / CA
```

**Nunca versionar chaves privadas:**
```bash
# .gitignore
*.pem
*.key
*.p12
*.pfx
id_rsa
id_ed25519
*_private_key*

# Verificar se já foi commitado
git log --all --full-history -- "*.pem"
git log --all --full-history -- "*.key"
```

**Armazenamento correto:**
```bash
# Vault (HashiCorp)
vault kv put secret/scielo/tls private_key=@nova-chave-privada.pem

# AWS Secrets Manager
aws secretsmanager create-secret \
  --name "scielo/tls-private-key" \
  --secret-string file://nova-chave-privada.pem

# GitHub Actions Secret
# Settings → Secrets → New secret → colar conteúdo do .pem
```

---

## JWT Secret / Session Secret

**Rotação:**
```python
# Gerar novo secret com entropia adequada (256 bits)
import secrets
novo_secret = secrets.token_hex(32)
print(novo_secret)  # copiar para o vault
```

```bash
# Gerar via linha de comando
openssl rand -hex 32
```

**Impacto da rotação:** todas as sessões ativas serão invalidadas — usuários precisarão fazer login novamente. Planejar janela de manutenção ou implementar rotação gradual com dois secrets válidos simultaneamente.

**Substituição no código:**
```python
# ANTES — Django
SECRET_KEY = "django-insecure-abc123xyz"

# DEPOIS
import os
SECRET_KEY = os.environ["DJANGO_SECRET_KEY"]
```

```javascript
// ANTES — Express
app.use(session({ secret: "meu-secret-hardcoded" }))

// DEPOIS
app.use(session({ secret: process.env.SESSION_SECRET }))
```

---

## Credencial em arquivo de configuração versionado

**Problema:** arquivo `.env`, `config.yml`, `settings.json` ou similar foi commitado com valores reais.

**Remediação:**

```bash
# 1. Adicionar ao .gitignore ANTES de qualquer outra coisa
echo ".env" >> .gitignore
echo "config.local.yml" >> .gitignore
git add .gitignore
git commit -m "chore: add sensitive config files to .gitignore"

# 2. Remover o arquivo do tracking (mantém localmente)
git rm --cached .env
git rm --cached config.local.yml
git commit -m "chore: remove tracked sensitive config files"

# 3. Remover do histórico (se já tinha sido commitado antes)
bfg --delete-files .env meu-repo.git
# ou
git filter-repo --path .env --invert-paths

# 4. Criar arquivo de exemplo sem valores reais
cp .env .env.example
# editar .env.example substituindo valores reais por placeholders
# ex: DB_PASSWORD=<gerar-via-vault>
git add .env.example
git commit -m "docs: add .env.example with placeholder values"
```

**Estrutura recomendada:**
```
repositório/
├── .env.example        ← versionado, sem valores reais
├── .env                ← NÃO versionado (.gitignore)
├── .gitignore          ← inclui .env
└── README.md           ← instrui como configurar o .env local
```

---

## Senha hardcoded em código-fonte

**Substituição por variável de ambiente:**
```python
# Python
import os
password = os.environ["DB_PASSWORD"]  # obrigatório — levanta KeyError se ausente
password = os.environ.get("DB_PASSWORD", "")  # opcional — retorna "" se ausente
```

```javascript
// Node.js
const password = process.env.DB_PASSWORD;
if (!password) throw new Error("DB_PASSWORD não configurado");
```

```java
// Java / Spring
@Value("${DB_PASSWORD}")
private String dbPassword;
// ou via application.properties: db.password=${DB_PASSWORD}
```

**Substituição por vault:**
```python
# HashiCorp Vault
import hvac
client = hvac.Client(url=os.environ["VAULT_ADDR"], token=os.environ["VAULT_TOKEN"])
secret = client.secrets.kv.read_secret_version(path="scielo/db")
password = secret["data"]["data"]["password"]
```

---

## Credencial em log / saída de sistema

**Problema:** senha ou token aparece em logs de aplicação ou saída de terminal.

**Remediação imediata:**
```bash
# Identificar onde os logs são armazenados e rotacioná-los / purgá-los
# se contiverem credenciais reais

# Verificar se logs são enviados para serviço externo (Datadog, ELK, etc.)
# e acionar rotação do segredo exposto imediatamente
```

**Correção no código:**
```python
# ANTES
logger.info(f"Conectando ao banco: {connection_string}")  # expõe senha na URL

# DEPOIS — mascarar credencial na URL de conexão
from urllib.parse import urlparse, urlunparse
def mask_db_url(url: str) -> str:
    parsed = urlparse(url)
    masked = parsed._replace(netloc=f"{parsed.username}:***@{parsed.hostname}")
    return urlunparse(masked)

logger.info("Conectando ao banco: %s", mask_db_url(connection_string))
```

---

## Checklist pós-remediação

Após corrigir qualquer segredo exposto, confirme:

```
[ ] Segredo rotacionado (novo valor gerado e distribuído via vault/secret manager)
[ ] Segredo antigo revogado / invalidado
[ ] Código atualizado para usar variável de ambiente ou vault
[ ] Arquivo removido do tracking git (git rm --cached)
[ ] Histórico git reescrito se o segredo foi commitado (BFG ou filter-repo)
[ ] .gitignore atualizado para prevenir reincidência
[ ] Todos os colaboradores notificados para re-clonar o repositório
[ ] Forks públicos verificados / notificados (se aplicável)
[ ] Logs contendo o segredo purgados ou rotacionados
[ ] Serviços externos que usavam o segredo antigo atualizados
[ ] Incidente registrado conforme procedimento da NSI.04 3.7
```
