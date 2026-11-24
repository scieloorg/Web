# Vulnerabilidades — Critérios Detalhados

Carregue este arquivo quando precisar de critérios completos para um domínio específico
ou quando o usuário perguntar sobre uma vulnerabilidade em detalhe.

---

## Domínio 1 — Injeção

### SQL Injection

**Detectar:**
- Concatenação de string com entrada do usuário em query SQL
- Uso de `format()`, f-string, `%` ou `+` para montar SQL
- `execute(query)` sem parâmetro separado
- Escape manual (insuficiente — usar prepared statements)

**Verificar também:**
- Stored procedures que constroem SQL dinâmico internamente
- Queries em ORMs usando `.raw()`, `.extra()`, `text()` com interpolação
- Filtros construídos dinamicamente: `WHERE campo_{user_input} = valor`

**Correção:**
- Prepared statements / queries parametrizadas em 100% dos casos
- Para queries que não podem ser parametrizadas (nomes de tabelas, ORDER BY dinâmico):
  usar allowlist explícita, nunca confiar no input diretamente

```python
# allowlist para ORDER BY dinâmico
ALLOWED_COLUMNS = {"name", "created_at", "email"}
if sort_col not in ALLOWED_COLUMNS:
    sort_col = "created_at"
query = f"SELECT * FROM users ORDER BY {sort_col}"
```

### NoSQL Injection (MongoDB, etc.)

```python
# PROIBIDO
db.users.find({"$where": f"this.name == '{name}'"})

# PROIBIDO — operadores não sanitizados
filter = request.json  # {"$gt": ""} bypassa autenticação
db.users.find(filter)

# CORRETO — validar tipo e estrutura do input
if not isinstance(name, str):
    abort(400)
db.users.find({"name": name})
```

### Injeção de Comando de OS

```python
# PROIBIDO
import os
os.system(f"convert {filename} output.pdf")
subprocess.call(f"grep {pattern} arquivo.txt", shell=True)

# CORRETO — passar como lista, nunca shell=True com input do usuário
subprocess.run(["convert", filename, "output.pdf"], check=True)
subprocess.run(["grep", pattern, "arquivo.txt"], check=True)
```

### Path Traversal

```python
# PROIBIDO
filepath = os.path.join(BASE_DIR, user_input)
with open(filepath) as f: ...

# CORRETO — validar que o caminho final está dentro do diretório esperado
import os
filepath = os.path.realpath(os.path.join(BASE_DIR, user_input))
if not filepath.startswith(os.path.realpath(BASE_DIR)):
    abort(403)
```

---

## Domínio 2 — Autenticação e Sessão

**Verificar:**
- Senha armazenada com hash seguro + salt (bcrypt, Argon2, scrypt)
- Timeout de sessão configurado
- Token JWT com campo `exp` definido
- Invalidação de sessão no logout (não apenas no cliente)
- Rate limiting em endpoints de login (NSI.04: máx 5 tentativas/minuto)
- Bloqueio após 5 erros consecutivos (NSI.04 seção 3.8)
- HTTPS obrigatório (cookies com `Secure` e `HttpOnly`)
- CSRF protection em formulários e mutações

**Flags vermelhas:**
```python
# Sem expiração de token
jwt.encode({"user_id": id}, key)

# Cookie sem Secure/HttpOnly
response.set_cookie("session", token)

# Login sem rate limiting
@app.route("/login", methods=["POST"])
def login():
    # sem nenhuma proteção contra brute force
    user = User.query.filter_by(email=email, password=password).first()

# Senha em texto plano
User.query.filter_by(email=email, password=password)  # compara plaintext
```

---

## Domínio 3 — XSS

### XSS Refletido
Input do usuário retornado diretamente na resposta HTML sem escape.

### XSS Armazenado (mais grave)
Input do usuário salvo no banco e depois renderizado em HTML sem escape.

```python
# Detectar: render de campo do banco em template sem escape
# Flask/Jinja2: {{ campo | safe }} ou Markup(campo) são flags vermelhas
# Django: {{ campo | safe }} ou mark_safe() são flags vermelhas
```

### XSS baseado em DOM
```javascript
// PROIBIDO
document.getElementById("out").innerHTML = location.hash.slice(1);
eval(userInput);
setTimeout(userInput, 1000);
new Function(userInput)();
```

**Headers de segurança obrigatórios:**
```
Content-Security-Policy: default-src 'self'
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
```

---

## Domínio 4 — Controle de Acesso

**Verificar:**
- Toda rota/endpoint verifica autenticação no backend
- Verificação de ownership: o usuário A não pode acessar recursos do usuário B
- Autorização baseada em roles verificada no servidor (não só no frontend)
- Parâmetros de ID não são confiados diretamente: usar IDs opacos ou UUIDs

**IDOR (Insecure Direct Object Reference):**
```python
# PROIBIDO
@app.route("/fatura/<int:fatura_id>")
def get_fatura(fatura_id):
    return Fatura.query.get(fatura_id)  # qualquer usuário acessa

# CORRETO
@app.route("/fatura/<int:fatura_id>")
@login_required
def get_fatura(fatura_id):
    return Fatura.query.filter_by(
        id=fatura_id,
        usuario_id=current_user.id
    ).first_or_404()
```

---

## Domínio 5 — Validação de Entrada

**Verificar:**
- Validação de tipo, tamanho, formato e range de todos os inputs
- Validação no backend (não confiar só na validação do frontend)
- Rejeição de campos inesperados (mass assignment)

```python
# PROIBIDO — mass assignment
user = User(**request.json)  # usuário pode passar "is_admin": true

# CORRETO — allowlist de campos aceitos
allowed = {"name", "email", "bio"}
data = {k: v for k, v in request.json.items() if k in allowed}
user = User(**data)
```

**Upload de arquivos:**
```python
# PROIBIDO
filename = request.files["file"].filename
file.save(os.path.join(UPLOAD_DIR, filename))

# CORRETO
from werkzeug.utils import secure_filename
import magic

file = request.files["file"]
filename = secure_filename(file.filename)

# Validar tipo real pelo conteúdo, não pela extensão
mime = magic.from_buffer(file.read(2048), mime=True)
if mime not in ALLOWED_MIME_TYPES:
    abort(400)
file.seek(0)
file.save(os.path.join(UPLOAD_DIR, filename))
```

---

## Domínio 6 — Criptografia

**Proibido (NSI.04 3.8):**
- MD5, SHA1 para senhas ou integridade de dados sensíveis
- DES, 3DES, RC4, RC2
- AES no modo ECB
- Chaves simétricas < 128 bits
- Chaves assimétricas < 2048 bits
- Hash sem salt

**Correto:**
- Senhas: bcrypt, Argon2id ou scrypt (com salt automático)
- Dados em repouso: AES-256-GCM
- Dados em trânsito: TLS 1.2+ (idealmente 1.3)
- Assinatura: RSA-4096 ou Ed25519
- Hash de integridade: SHA-256 ou SHA-3

---

## Domínio 7 — Configuração de Segurança

**Verificar:**
- Debug mode desativado em produção
- Stack traces não expostos ao usuário final
- Headers de segurança HTTP configurados
- CORS restrito a origens conhecidas (não `*` em produção)
- Versões de dependências sem CVEs conhecidos

```python
# PROIBIDO em produção
app.run(debug=True)
DEBUG = True

# PROIBIDO — CORS aberto
CORS(app, origins="*")

# CORRETO
CORS(app, origins=["https://app.scielo.br", "https://admin.scielo.br"])
```

---

## Domínio 8 — Logging Inseguro

**Nunca logar (NSI.04 3.6):**
- Senhas, tokens, API keys
- Dados pessoais sensíveis (CPF, número de cartão, dados de saúde)
- Corpo completo de requests sem filtragem
- Variáveis de ambiente completas

**Sempre logar:**
- Quem fez a ação (user_id, não username com dados pessoais)
- Quando (timestamp ISO 8601)
- De onde (IP, session_id)
- O quê (ação, recurso, ID do objeto)
- Resultado (sucesso, falha, motivo)

```python
# PROIBIDO
logger.error(f"Falha no login: {request.json}")

# CORRETO
logger.warning(
    "login_failure user=%s ip=%s attempts=%d",
    user_id, request.remote_addr, attempt_count
)
```
