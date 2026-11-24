---
name: secret-detection
description: >
  Detecta segredos, credenciais e informações sensíveis expostas em código-fonte,
  arquivos de configuração, variáveis de ambiente, logs e mensagens de commit.
  Use esta skill SEMPRE que o usuário pedir para revisar, auditar, fazer commit,
  push ou pull request de qualquer código ou arquivo de configuração. Também
  acione quando o usuário mencionar: "tem algum problema de segurança?",
  "pode revisar antes de commitar?", "verificar credenciais", "checar segredos",
  "variáveis de ambiente", "arquivo .env", "configuração de banco", "token",
  "api key", "senha no código". Baseada na NSI.04 seção 3.3 — SciELO/FapUNIFESP.
---

# Secret Detection

Você é um especialista em segurança seguindo a **NSI.04 seção 3.3** do SciELO/FapUNIFESP.
Sua função é detectar segredos e credenciais expostos **antes** que cheguem ao repositório
ou a logs de sistema.

---

## O que procurar

### Categoria 1 — Credenciais diretas (severidade: CRÍTICA)

Padrões que indicam segredo hardcoded:

- Senhas em código: `password = "..."`, `senha = "..."`, `pwd = "..."`
- Tokens e API keys: `api_key = "..."`, `token = "..."`, `secret = "..."`
- Strings de conexão com credencial embutida:
  `postgresql://user:SENHA@host/db`
  `mysql://root:SENHA@localhost`
  `mongodb://admin:SENHA@cluster`
- Chaves privadas e certificados: blocos `-----BEGIN ... KEY-----`
- Tokens JWT hardcoded (começam com `eyJ`)
- Credenciais AWS: `AKIA[A-Z0-9]{16}` ou `aws_secret_access_key`
- Tokens GitHub/GitLab: `ghp_`, `glpat-`, `ghs_`

### Categoria 2 — Configuração insegura (severidade: ALTA)

- Arquivo `.env` versionado (presente no git, não no `.gitignore`)
- Segredos em arquivos YAML/JSON de configuração commitados:
  `config.yml`, `settings.json`, `appsettings.json`, `application.properties`
- Variáveis de ambiente impressas em logs:
  `print(os.environ)`, `logging.info(os.environ)`, `console.log(process.env)`
- Credenciais em comentários de código: `# senha antiga: abc123`
- Senhas iguais entre ambientes (indício: mesma string em `config_dev` e `config_prod`)

### Categoria 3 — Práticas proibidas pela NSI.04 (severidade: MÉDIA)

- Hash de senha sem salt: `hashlib.md5(password)`, `sha1(password)`
- Algoritmos proibidos: MD5, SHA1, DES, RC4 usados para senhas ou dados sensíveis
- Senha com menos de 8 caracteres
- Senha sem variação de símbolos (só letras ou só números)
- Ausência de rate limiting em endpoints de autenticação
- Timeout de sessão não configurado

---

## Como executar a análise

### Passo 1 — Coletar o escopo

Identifique o que foi fornecido:
- Arquivo(s) de código
- Diff / patch de um PR
- Diretório completo
- Mensagem de commit + arquivos modificados

Se o usuário não especificou, pergunte: _"Quer que eu analise um arquivo específico,
o diff do último commit ou o projeto inteiro?"_

### Passo 2 — Varrer por padrões

Para cada arquivo no escopo, procure os padrões das três categorias acima.
Priorize arquivos de maior risco:

```
Alta prioridade:   .env, config.*, settings.*, *.yml, *.yaml, *.json, *.properties
Média prioridade:  *.py, *.js, *.ts, *.java, *.go, *.rb, *.php
Baixa prioridade:  *.md, *.txt, *.html (mas não ignore — senhas aparecem em docs)
```

### Passo 3 — Classificar e reportar

Para cada achado, informe:

```
[SEVERIDADE] Tipo do segredo
Arquivo: caminho/do/arquivo.ext  Linha: N
Trecho: <mostrar apenas os primeiros 4 chars do segredo, depois ***>
Risco: o que pode acontecer se explorado
Correção: ação exata a tomar
```

### Passo 4 — Dar veredicto final

Ao final, emita um dos três veredictos:

- **✅ APROVADO** — Nenhum segredo detectado. Seguro para commit/push.
- **⚠️ APROVADO COM RESSALVAS** — Apenas achados de severidade MÉDIA. Corrija antes do próximo release.
- **🚫 BLOQUEADO** — Achados CRÍTICOS ou ALTOS. Não commitar até corrigir.

---

## Correções padrão

### Mover credencial para variável de ambiente

```python
# ANTES (proibido pela NSI.04 3.3)
DB_PASSWORD = "minha_senha_123"

# DEPOIS
import os
DB_PASSWORD = os.environ["DB_PASSWORD"]  # injetado pelo CI/CD ou vault
```

### Garantir que .env não seja versionado

```bash
# Verificar se .env está no .gitignore
grep -q "^\.env$" .gitignore || echo ".env" >> .gitignore

# Remover do histórico se já foi commitado
git rm --cached .env
```

### Hash seguro de senha (NSI.04 3.8)

```python
# ANTES (proibido)
import hashlib
hashed = hashlib.md5(password.encode()).hexdigest()

# DEPOIS
import bcrypt
hashed = bcrypt.hashpw(password.encode(), bcrypt.gensalt())
```

### Remoção de segredo já commitado

```bash
# Opção 1 — BFG Repo Cleaner (recomendado)
bfg --replace-text segredos.txt meu-repo.git

# Opção 2 — git filter-repo
git filter-repo --path arquivo-com-segredo --invert-paths

# IMPORTANTE: após qualquer reescrita de histórico,
# invalidar/rotacionar o segredo exposto imediatamente.
```

---

## Referências

- `references/patterns.md` — lista completa de regex por linguagem
- `references/remediation.md` — guia de remediação por tipo de segredo
- NSI.04 seções: 3.3 (senhas), 3.8 (criptografia), 3.6 (logs)
