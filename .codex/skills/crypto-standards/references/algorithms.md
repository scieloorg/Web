# Algoritmos Criptográficos — Referência Completa

Carregue este arquivo quando precisar de detalhes sobre tamanhos de chave,
modos de operação ou orientação para casos de uso específicos.

---

## Chaves simétricas

| Algoritmo | Tamanho | Status NSI.04 | Modo | Observação |
|-----------|---------|--------------|------|-----------|
| AES | 256 bits | ✅ Recomendado | GCM | Autenticado, preferido |
| AES | 256 bits | ✅ Aprovado | CBC + HMAC-SHA256 | Usar quando GCM não disponível |
| AES | 192 bits | ⚠️ Aceitável | GCM | Mínimo aceitável por NSI.04 |
| AES | 128 bits | ⚠️ Mínimo | GCM | Limite inferior NSI.04 |
| AES | qualquer | ❌ Proibido | ECB | Padrões visíveis, sem autenticação |
| DES | 56 bits | ❌ Proibido | qualquer | Quebrado por força bruta |
| 3DES | 112/168 bits | ❌ Proibido | qualquer | SWEET32, obsoleto |
| RC4 | qualquer | ❌ Proibido | stream | Bias conhecido, quebrado |
| RC2 | qualquer | ❌ Proibido | qualquer | Obsoleto |
| Blowfish | < 128 bits | ❌ Proibido | qualquer | Tamanho de bloco insuficiente |

---

## Chaves assimétricas

| Algoritmo | Tamanho | Status NSI.04 | Uso recomendado |
|-----------|---------|--------------|----------------|
| RSA | 4096 bits | ✅ Recomendado | Assinatura, troca de chave |
| RSA | 2048 bits | ⚠️ Mínimo | Legado compatível |
| RSA | < 2048 bits | ❌ Proibido | — |
| Ed25519 | 256 bits | ✅ Recomendado | Assinatura — mais rápido que RSA |
| X25519 | 256 bits | ✅ Recomendado | Troca de chave (ECDH) |
| ECDSA P-256 | 256 bits | ✅ Aprovado | Assinatura |
| ECDSA P-384 | 384 bits | ✅ Aprovado | Alta segurança |
| DSA | qualquer | ❌ Proibido | Obsoleto |

---

## Funções de hash

### Para senhas (KDF — Key Derivation Functions)

| Algoritmo | Status NSI.04 | Parâmetros mínimos | Observação |
|-----------|--------------|-------------------|-----------|
| Argon2id | ✅ Recomendado | memory=64MB, iter=3, par=4 | Vencedor PHC, resistente a GPU |
| bcrypt | ✅ Aprovado | rounds=12 | Amplamente suportado |
| scrypt | ✅ Aprovado | N=32768, r=8, p=1 | Resistente a ASIC |
| PBKDF2-SHA256 | ⚠️ Aceitável | iter≥310000 | Compatibilidade FIPS |
| MD5 | ❌ Proibido | — | Colisões triviais |
| SHA1 | ❌ Proibido | — | Colisões demonstradas |
| SHA256 sem salt | ❌ Proibido | — | Vulnerável a rainbow tables |
| Plaintext | ❌ Proibido | — | Violação direta da NSI.04 |

### Para integridade de dados (não senhas)

| Algoritmo | Status NSI.04 | Uso |
|-----------|--------------|-----|
| SHA-256 | ✅ Recomendado | Integridade geral |
| SHA-384 | ✅ Recomendado | Alta segurança |
| SHA-512 | ✅ Recomendado | Alta segurança |
| SHA-3 | ✅ Aprovado | Alternativa ao SHA-2 |
| BLAKE2b | ✅ Aprovado | Alta performance |
| HMAC-SHA256 | ✅ Recomendado | Integridade com autenticação |
| MD5 | ❌ Proibido | Colisões triviais |
| SHA1 | ❌ Proibido | Colisões conhecidas |
| MD4 | ❌ Proibido | Quebrado |
| CRC32 | ❌ Para segurança | Apenas detecção de erro, não segurança |

---

## TLS / Transporte

| Versão | Status NSI.04 | Ação |
|--------|--------------|------|
| TLS 1.3 | ✅ Recomendado | Padrão preferido |
| TLS 1.2 | ✅ Aprovado | Manter com cipher suites seguras |
| TLS 1.1 | ❌ Proibido | Desativar imediatamente |
| TLS 1.0 | ❌ Proibido | Desativar imediatamente |
| SSL 3.0 | ❌ Proibido | POODLE, desativar |
| SSL 2.0 | ❌ Proibido | Desativar |

**Cipher suites aprovadas para TLS 1.2:**
```
TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
```

**Cipher suites proibidas:**
```
*_RC4_*       — RC4 quebrado
*_NULL_*      — sem criptografia
*_EXPORT_*    — chaves fracas intencionais
*_DES_*       — DES quebrado
*_3DES_*      — SWEET32
*_anon_*      — sem autenticação
```

---

## JWT — Algoritmos

| Algoritmo | Tipo | Status | Observação |
|-----------|------|--------|-----------|
| RS256 | Assimétrico | ✅ Recomendado | RSA-PSS SHA-256 |
| RS384 | Assimétrico | ✅ Aprovado | RSA-PSS SHA-384 |
| ES256 | Assimétrico | ✅ Recomendado | ECDSA P-256 |
| EdDSA | Assimétrico | ✅ Aprovado | Ed25519 |
| HS256 | Simétrico | ⚠️ Condicional | Apenas com chave ≥ 256 bits gerada com CSPRNG |
| HS512 | Simétrico | ⚠️ Condicional | Apenas com chave forte |
| none | — | ❌ Proibido | Sem assinatura |
| RS256 com chave < 2048 | — | ❌ Proibido | Chave insuficiente |

---

## Geração de entropia

| Caso de uso | Python | Node.js | Go |
|-------------|--------|---------|-----|
| Token de sessão | `secrets.token_urlsafe(32)` | `crypto.randomBytes(32)` | `crypto/rand` |
| Salt | `os.urandom(16)` | `crypto.randomBytes(16)` | `crypto/rand` |
| Nonce AES-GCM | `os.urandom(12)` | `crypto.randomBytes(12)` | `crypto/rand` |
| UUID aleatório | `uuid.uuid4()` | `crypto.randomUUID()` | `github.com/google/uuid` |
| **PROIBIDO** | `random.random()` | `Math.random()` | `math/rand` |

---

## Tamanhos de chave — resumo NSI.04

```
Simétrico:
  Mínimo absoluto:    128 bits  (AES-128)
  Mínimo recomendado: 192 bits  (AES-192)
  Recomendado:        256 bits  (AES-256)  ← usar sempre que possível

Assimétrico (RSA):
  Mínimo absoluto:    2048 bits
  Recomendado:        4096 bits  ← usar sempre que possível

Curvas elípticas (equivalentes):
  P-256 ≈ RSA-3072
  P-384 ≈ RSA-7680
  Ed25519 ≈ RSA-3072 (mais rápido)
```
