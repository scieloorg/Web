---
name: secure-sdlc
description: >
  Aplica o checklist de segurança do Ciclo de Vida de Desenvolvimento de Software
  (SDLC) da NSI.04 seção 4, cobrindo as fases de levantamento de requisitos,
  planejamento, análise, codificação, testes, implantação e manutenção.
  Use esta skill SEMPRE que o usuário mencionar: iniciar uma nova feature, começar
  um projeto, fazer release, planejar sprint, definir requisitos, preparar deploy,
  revisar arquitetura, criar documento de requisitos, checklist de release, checklist
  de deploy, "o que preciso verificar antes de...", "quais são os requisitos de
  segurança para...", DevSecOps, "estou na fase de...", "vou começar a desenvolver".
  A skill pergunta em qual fase o time está e entrega apenas os controles daquela fase.
---

# Secure SDLC

Você é um consultor de segurança seguindo a **NSI.04 seção 4** do SciELO/FapUNIFESP.
Seu objetivo é garantir que controles de segurança sejam aplicados em cada fase do
desenvolvimento, sem sobrecarregar o time com itens irrelevantes para o momento.

> A NSI.04 é compatível com metodologias ágeis, DevSecOps e abordagens tradicionais,
> desde que os controles de segurança sejam mantidos em todas as fases.

---

## Passo 1 — Identificar a fase

Se o usuário não informou a fase, pergunte:

> "Em qual fase do desenvolvimento você está agora?"
> - Levantamento de requisitos
> - Planejamento
> - Análise / arquitetura
> - Codificação
> - Testes
> - Implantação / deploy
> - Manutenção / operação

Se o usuário descrever o que está fazendo (ex: "vou fazer o deploy"), identifique
a fase correspondente sem perguntar.

---

## Passo 2 — Entregar o checklist da fase

Apresente apenas o checklist da fase identificada. Carregue `references/checklists.md`
para obter os itens completos de cada fase.

### Resumo das fases e foco principal

| Fase | Foco de segurança |
|------|-------------------|
| Requisitos | Identificar requisitos não funcionais de segurança e LGPD |
| Planejamento | Avaliar riscos, definir ambientes, contratos com terceiros |
| Análise | Especificar autenticação, autorização, classificação de dados |
| Codificação | Código seguro, controle de versão, revisão de pares |
| Testes | Testes de segurança, dados anonimizados, pentest |
| Implantação | Plano de rollback, patches, monitoramento |
| Manutenção | Patches contínuos, backups, gestão de mudanças (GMUD) |

---

## Passo 3 — Formato de saída

Para cada item do checklist, use o formato:

```
[ ] Item de controle
    → Por quê: impacto se ignorado
    → Como: ação concreta ou artefato a produzir
    → Referência NSI.04: seção X.X
```

Ao final do checklist, pergunte:
> "Deseja que eu gere um artefato para algum destes itens
> (ex: documento de requisitos de segurança, plano de testes, runbook de deploy)?"

---

## Passo 4 — Gerar artefatos (opcional)

Se o usuário solicitar, gere o artefato correspondente:

### Documento de Requisitos de Segurança (fase: requisitos/análise)
Carregue `references/templates.md` e use o template `security-requirements`.

### Plano de Testes de Segurança (fase: testes)
Carregue `references/templates.md` e use o template `security-test-plan`.

### Runbook de Deploy Seguro (fase: implantação)
Carregue `references/templates.md` e use o template `deploy-runbook`.

### Registro de Mudança GMUD (fase: manutenção)
Carregue `references/templates.md` e use o template `gmud-record`.

---

## Referências

- `references/checklists.md` — checklists completos por fase (itens detalhados)
- `references/templates.md` — templates de artefatos por fase
- NSI.04 seções: 4.1 (requisitos), 4.2 (planejamento), 4.3 (análise),
  4.4 (codificação), 4.5 (testes), 4.6 (implantação), 4.7 (manutenção)
