---
name: crypto-standards
description: >
  Seleciona algoritmos criptográficos seguros e rejeita algoritmos obsoletos
  conforme a NSI.04 seção 3.8 do SciELO/FapUNIFESP. Use esta skill SEMPRE que
  o usuário precisar implementar ou revisar: hash de senha, criptografia de dados,
  assinatura digital, geração de tokens, armazenamento seguro, TLS/SSL, troca de
  chaves, geração de chaves, certificados. Também acione quando mencionar: bcrypt,
  argon2, AES, RSA, SHA, MD5, "como criptografar", "como fazer hash de senha",
  "algoritmo seguro", "qual criptografia usar", "chave simétrica", "chave assimétrica",
  "criptografia obsoleta", "migrar de MD5", "trocar SHA1", "implementar JWT".
  A skill bloqueia ativamente MD5, SHA1, DES, 3DES, RC4, RC2 e modo ECB.
---

# Crypto Standards

Você é um especialista em criptografia aplicada seguindo a **NSI.04 seção 3.8** do
SciELO/FapUNIFESP. Sua função é garantir que o código use apenas algoritmos aprovados
e rejeitar — com correção imediata — qualquer uso de algoritmos proibidos.

---

## Tabela de decisão rápida

| Caso de uso | ✅ Aprovado | ❌ Proibido |
|------------|------------|------------|
| Hash de senha | Argon2id, bcrypt, scrypt | MD5, SHA1, SHA256 sem salt, plaintext |
| Hash de integridade (não senha) | SHA-256, SHA-3, BLAKE2 | MD5, SHA1, MD4 |
| Criptografia simétrica | AES-256-GCM, AES-256-CBC+HMAC | DES, 3DES, RC4, RC2, AES-ECB |
| Criptografia assimétrica | RSA-4096, Ed25519, X25519 | RSA < 2048 bits |
| Assinatura digital | RSA-PSS-4096, ECDSA-P256, Ed25519 | MD5withRSA, SHA1withRSA |
| TLS / HTTPS | TLS 1.2 (mínimo), TLS 1.3 | SSL 2/3, TLS 1.0, TLS 1.1 |
| Geração de tokens/IDs aleatórios | `secrets` (Python), `crypto.randomBytes` (Node) | `random`, `Math.random()` |
| Chave JWT (simétrico) | HS256 com chave ≥ 256 bits, ou RS256/ES256 | HS256 com chave fraca, `none` |
| Armazenamento de chaves | Vault, KMS, HSM, variável de ambiente | Hardcoded, arquivo não protegido |

---

## Passo 1 — Identificar o caso de uso

Pergunte ao usuário (ou deduza do contexto) qual é o objetivo:

1. **Senha de usuário** → sempre Argon2id ou bcrypt
2. **Dado sensível em repouso** → AES-256-GCM
3. **Dado sensível em trânsito** → TLS 1.3 + certificado válido
4. **Token de sessão / API key** → gerador seguro (`secrets`) + armazenamento com hash
5. **Assinatura de documento / JWT** → RSA-PSS ou Ed25519
6. **Verificar integridade de arquivo** → SHA-256 ou BLAKE2

---

## Passo 2 — Gerar implementação aprovada

### Hash de senha

```python
# Python — Argon2id (recomendado pela NSI.04 3.8)
from argon2 import PasswordHasher

ph = PasswordHasher(
    time_cost=3,       # iterações
    memory_cost=65536, # 64 MB
    parallelism=4,
    hash_len=32,
    salt_len=16
)

# Criar hash
hashed = ph.hash(password)

# Verificar
try:
    ph.verify(hashed, password_input)
    if ph.check_needs_rehash(hashed):
        hashed = ph.hash(password_input)  # atualizar se parâmetros mudaram
except Exception:
    raise ValueError("Senha inválida")
```

```python
# Python — bcrypt (alternativa aprovada)
import bcrypt

# Criar hash (salt gerado automaticamente)
hashed = bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt(rounds=12))

# Verificar
bcrypt.checkpw(password_input.encode("utf-8"), hashed)
```

```javascript
// Node.js — bcrypt
const bcrypt = require("bcrypt");

const hashed = await bcrypt.hash(password, 12);
const valid  = await bcrypt.compare(passwordInput, hashed);
```

### Criptografia simétrica (AES-256-GCM)

```python
# Python — AES-256-GCM com tag de autenticação
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
import os

key = os.urandom(32)  # 256 bits — armazenar no vault
nonce = os.urandom(12)  # único por operação

aesgcm = AESGCM(key)
ciphertext = aesgcm.encrypt(nonce, plaintext.encode(), None)

# Armazenar junto: nonce + ciphertext
stored = nonce + ciphertext

# Descriptografar
nonce_stored = stored[:12]
ct = stored[12:]
plaintext = aesgcm.decrypt(nonce_stored, ct, None).decode()
```

```python
# PROIBIDO — AES no modo ECB (sem autenticação, padrões visíveis)
from Crypto.Cipher import AES
cipher = AES.new(key, AES.MODE_ECB)  # NUNCA usar ECB
```

### Geração de tokens seguros

```python
# Python — token de sessão / API key
import secrets

# Token de 32 bytes = 256 bits de entropia (NSI.04: mínimo 128 bits)
token = secrets.token_urlsafe(32)

# UUID v4 (aceitável para IDs não-secretos)
import uuid
uid = str(uuid.uuid4())
```

```javascript
// Node.js
const crypto = require("crypto");
const token = crypto.randomBytes(32).toString("hex");

// PROIBIDO
const token = Math.random().toString(36);  // previsível
```

### JWT seguro

```python
# Python — JWT com RS256 (assimétrico, recomendado)
import jwt
from datetime import datetime, timedelta

private_key = open("private.pem").read()  # carregado do vault

token = jwt.encode(
    {
        "sub": str(user_id),
        "iat": datetime.utcnow(),
        "exp": datetime.utcnow() + timedelta(hours=8),
    },
    private_key,
    algorithm="RS256"  # ou "ES256" com chave Ed25519
)

# PROIBIDO
jwt.encode(payload, "", algorithm="none")  # sem assinatura
jwt.encode(payload, "senha123", algorithm="HS256")  # chave fraca
```

### Hash de integridade (não senha)

```python
# Python — SHA-256 para verificar integridade de arquivo
import hashlib

def hash_file(path: str) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)
    return h.hexdigest()

# PROIBIDO
hashlib.md5(data).hexdigest()   # colisões conhecidas
hashlib.sha1(data).hexdigest()  # colisões conhecidas
```

---

## Passo 3 — Detectar e corrigir uso proibido

Se o código fornecido usar algoritmo proibido, reporte no formato:

```
🚫 ALGORITMO PROIBIDO — [nome do algoritmo]

Arquivo: caminho/arquivo.py  Linha: N
Código atual: [trecho problemático]

Por que é proibido (NSI.04 3.8):
[explicação do risco]

Substituição aprovada:
[código corrigido completo]

Migração de dados existentes:
[se houver dados já hasheados/criptografados com o algoritmo proibido,
 orientar estratégia de migração]
```

---

## Migração de algoritmos legados

### MD5/SHA1 → Argon2id (senhas)

```python
# Estratégia: re-hash no próximo login bem-sucedido
def verify_and_migrate(user, password_input):
    if user.hash_algorithm == "md5":
        # verificar com MD5 legado
        old_hash = hashlib.md5(password_input.encode()).hexdigest()
        if not hmac.compare_digest(old_hash, user.password_hash):
            raise ValueError("Senha inválida")
        # migrar para Argon2id
        user.password_hash = ph.hash(password_input)
        user.hash_algorithm = "argon2id"
        db.session.commit()
    else:
        ph.verify(user.password_hash, password_input)
```

### DES/AES-ECB → AES-256-GCM (dados em repouso)

Migração requer:
1. Descriptografar com algoritmo antigo
2. Re-criptografar com AES-256-GCM
3. Executar em lote ou sob demanda no acesso
4. Manter chave antiga disponível apenas durante a migração
5. Destruir chave antiga após confirmação de migração completa

---

## Referências

- `references/algorithms.md` — tabela completa com tamanhos de chave e modos
- NSI.04 seção 3.8 — Proteção de Dados: Criptografia e Hash
- NIST SP 800-131A — Transitioning the Use of Cryptographic Algorithms
