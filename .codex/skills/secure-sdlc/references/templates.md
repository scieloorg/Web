# Templates de Artefatos por Fase

---

## Template: security-requirements

Use na fase de Requisitos / Análise.

```markdown
# Requisitos de Segurança — [Nome do Sistema]

**Versão:** 1.0  
**Data:** [DATA]  
**Responsável:** [NOME]  
**Classificação:** Interna (NSI.04)

## 1. Dados pessoais envolvidos (LGPD)

| Campo | Finalidade | Base Legal | Retenção | Compartilhamento |
|-------|-----------|------------|----------|-----------------|
|       |           |            |          |                 |

## 2. Classificação dos dados

| Tipo de dado | Classificação | Criptografado em repouso | Criptografado em trânsito |
|-------------|--------------|--------------------------|--------------------------|
|             | Interno       |                          |                          |

## 3. Requisitos de autenticação e autorização

- Mecanismo: [ ] Local  [ ] Active Directory  [ ] OAuth2  [ ] SAML
- MFA obrigatório: [ ] Sim  [ ] Não  — Justificativa: ___
- Roles necessárias: ___
- Timeout de sessão: ___ minutos
- Tentativas antes de bloqueio: ___ (NSI.04: máx 5)

## 4. Requisitos não funcionais de segurança

| Requisito | Valor-alvo | Observação |
|-----------|-----------|------------|
| Disponibilidade | ___% | |
| Tempo de resposta máximo | ___ ms | |
| Retenção de logs | ___ dias | |
| RTO (Recovery Time Objective) | ___ horas | |
| RPO (Recovery Point Objective) | ___ horas | |

## 5. Ameaças identificadas (STRIDE simplificado)

| Ameaça | Ativo afetado | Probabilidade | Impacto | Controle |
|--------|--------------|--------------|---------|----------|
|        |              |              |         |          |

## 6. Padrões e regulações aplicáveis

- [ ] NSI.04 - Norma de Desenvolvimento Seguro (SciELO/FapUNIFESP)
- [ ] LGPD
- [ ] ISO/IEC 27001:2022
- [ ] Outro: ___

## 7. Aprovação

| Nome | Cargo | Data | Assinatura |
|------|-------|------|-----------|
|      |       |      |           |
```

---

## Template: security-test-plan

Use na fase de Testes.

```markdown
# Plano de Testes de Segurança — [Nome do Sistema]

**Versão:** 1.0  
**Release:** [versão]  
**Data:** [DATA]

## 1. Escopo

Mudanças neste release que requerem teste de segurança:
- [ ] Nova tela de login / autenticação
- [ ] Novo formulário com entrada de usuário
- [ ] Novo endpoint de API (autenticado / não autenticado)
- [ ] Alteração em controle de acesso
- [ ] Novo upload de arquivo
- [ ] Outro: ___

## 2. Testes manuais obrigatórios

| Teste | Responsável | Resultado | Data |
|-------|-------------|-----------|------|
| Tentar acessar recurso sem autenticação | | [ ] Pass [ ] Fail | |
| Tentar acessar recurso de outro usuário (IDOR) | | [ ] Pass [ ] Fail | |
| Injetar SQL em todos os campos de entrada | | [ ] Pass [ ] Fail | |
| Inserir payload XSS em campos de texto | | [ ] Pass [ ] Fail | |
| Tentar brute force no login (verificar bloqueio) | | [ ] Pass [ ] Fail | |
| Verificar headers de segurança HTTP | | [ ] Pass [ ] Fail | |

## 3. Testes automatizados

| Ferramenta | Escopo | Status | Resultado |
|-----------|--------|--------|-----------|
| pip audit / npm audit | Dependências | | |
| bandit / semgrep | SAST — código Python/JS | | |
| OWASP ZAP | DAST — endpoints HTTP | | |
| trivy | Imagens de container | | |

## 4. Dados de teste

- [ ] Confirmado: dados fictícios ou anonimizados em uso (NSI.04 4.5)
- Responsável pela anonimização: ___

## 5. Critério de aprovação

- Zero achados CRÍTICOS ou ALTOS sem mitigação documentada
- Todos os testes manuais marcados como Pass
- Ferramentas automatizadas sem novos CVEs CRÍTICOS

## 6. Resultado final

- [ ] APROVADO para deploy
- [ ] APROVADO COM RESSALVAS — itens pendentes: ___
- [ ] REPROVADO — bloquear release
```

---

## Template: deploy-runbook

Use na fase de Implantação.

```markdown
# Runbook de Deploy Seguro — [Nome do Sistema] v[X.Y.Z]

**Data planejada:** [DATA]  
**Responsável pelo deploy:** [NOME]  
**Janela de manutenção:** [HH:MM] – [HH:MM]  
**Aprovação GMUD:** [NÚMERO]

## Pré-deploy (obrigatório)

- [ ] Backup do banco de dados realizado — Local: ___ — Verificado: [ ] Sim
- [ ] Snapshot do ambiente de produção realizado
- [ ] Patches de SO e runtime aplicados
- [ ] Patches de dependências aplicados
- [ ] Plano de testes de validação preparado
- [ ] Equipe de suporte notificada

## Passos do deploy

| # | Passo | Comando / Ação | Responsável | Status |
|---|-------|---------------|-------------|--------|
| 1 | | | | [ ] |
| 2 | | | | [ ] |
| 3 | | | | [ ] |

## Validação pós-deploy

- [ ] Smoke test de autenticação — Resultado: ___
- [ ] Smoke test dos fluxos críticos — Resultado: ___
- [ ] Verificar logs de erro (primeiros 15 min) — Resultado: ___
- [ ] Verificar métricas de latência e erro — Resultado: ___
- [ ] Monitoramento e alertas ativos — Confirmado: [ ] Sim

## Plano de rollback

**Critério para acionar rollback:**
- Taxa de erro > ___% por ___ minutos
- Falha em qualquer smoke test crítico
- Incidente de segurança detectado

**Passos de rollback:**

| # | Passo | Comando / Ação | Tempo estimado |
|---|-------|---------------|----------------|
| 1 | Reverter deploy | | ___ min |
| 2 | Restaurar banco (se necessário) | | ___ min |
| 3 | Validar ambiente anterior | | ___ min |

**Tempo máximo antes de acionar rollback:** ___ minutos após deploy

## Registro de execução

| Etapa | Horário | Responsável | Observação |
|-------|---------|-------------|-----------|
| Início do deploy | | | |
| Fim do deploy | | | |
| Validação concluída | | | |
| Deploy confirmado / Rollback acionado | | | |
```

---

## Template: gmud-record

Use na fase de Manutenção para registrar mudanças conforme Procedimento da GMUD.

```markdown
# Registro de Mudança (GMUD) — [ID]

**Data de abertura:** [DATA]  
**Solicitante:** [NOME]  
**Sistema afetado:** [NOME DO SISTEMA]  
**Tipo de mudança:** [ ] Normal  [ ] Emergencial  [ ] Padrão

## Descrição da mudança

**O que será alterado:**

**Motivo / justificativa:**

**Impacto esperado:**

## Análise de risco

| Risco | Probabilidade | Impacto | Mitigação |
|-------|--------------|---------|-----------|
| | | | |

**Nível de risco geral:** [ ] Baixo  [ ] Médio  [ ] Alto

## Plano de implementação

| # | Passo | Responsável | Duração |
|---|-------|-------------|---------|
| | | | |

**Janela de manutenção:** [DATA] [HH:MM] – [HH:MM]

## Plano de rollback

**Critério para rollback:**

**Passos:**

## Aprovações

| Nome | Cargo | Data | Aprovação |
|------|-------|------|-----------|
| | | | [ ] Aprovado  [ ] Reprovado |
| | | | [ ] Aprovado  [ ] Reprovado |

## Resultado da implementação

- [ ] Implementado com sucesso
- [ ] Implementado com desvios — Desvios: ___
- [ ] Revertido — Motivo: ___

**Data de fechamento:** ___  
**Responsável pelo fechamento:** ___
```
