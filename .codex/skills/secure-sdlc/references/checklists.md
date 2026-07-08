# Checklists de Segurança por Fase do SDLC

Carregue este arquivo quando precisar dos itens completos de uma fase específica.

---

## Fase 1 — Levantamento de Requisitos (NSI.04 4.1)

```
[ ] Identificar requisitos funcionais de segurança
    → Por quê: sem isso, segurança vira afterthought
    → Como: listar casos de uso sensíveis (login, pagamento, dados pessoais)
    → Ref: NSI.04 4.1

[ ] Identificar requisitos não funcionais de segurança
    → Por quê: desempenho, disponibilidade e auditabilidade têm requisitos de segurança
    → Como: definir SLAs de autenticação, tempo de sessão, retenção de logs
    → Ref: NSI.04 4.1

[ ] Mapear dados pessoais envolvidos (LGPD)
    → Por quê: LGPD exige base legal, consentimento e proteção adequada
    → Como: listar campos coletados, finalidade, tempo de retenção, compartilhamento
    → Ref: NSI.04 regulamentação / LGPD

[ ] Realizar análise inicial de ameaças
    → Por quê: identificar riscos antes de projetar evita retrabalho caro
    → Como: aplicar STRIDE ou threat modeling simplificado nos casos de uso
    → Ref: NSI.04 4.1

[ ] Verificar conformidade com padrões aplicáveis
    → Por quê: ISO 27001, LGPD, regulações setoriais podem exigir controles específicos
    → Como: checar se o sistema envolve dados de saúde, financeiros, de menores
    → Ref: NSI.04 regulamentação

[ ] Estimar volumetria de uso
    → Por quê: arquitetura subdimensionada vira vetor de DoS involuntário
    → Como: definir usuários concorrentes, pico de requisições, volume de dados
    → Ref: NSI.04 4.1

[ ] Validar requisitos de segurança com stakeholders
    → Por quê: requisitos não validados são ignorados na prática
    → Como: revisão formal com responsável pelo produto e área de segurança
    → Ref: NSI.04 4.1
```

---

## Fase 2 — Planejamento (NSI.04 4.2)

```
[ ] Incluir riscos de segurança no plano de projeto
    → Por quê: riscos não planejados viram surpresas em produção
    → Como: adicionar coluna "risco de segurança" na matriz de riscos do projeto
    → Ref: NSI.04 4.2

[ ] Definir e provisionar ambientes segregados
    → Por quê: mudança em dev não pode afetar produção (NSI.04 3.1)
    → Como: criar ambientes dev / homolog / prod com credenciais distintas
    → Ref: NSI.04 3.1, 4.2

[ ] Definir processo de provisionamento de acesso
    → Por quê: acesso sem processo vira acesso sem rastreabilidade
    → Como: documentar quem aprova, como é concedido e como é revogado
    → Ref: NSI.04 4.2

[ ] Firmar contratos com terceiros (se aplicável)
    → Por quê: terceiros sem contrato podem tratar seus dados sem proteção
    → Como: incluir cláusulas de confidencialidade, propriedade intelectual e segurança
    → Ref: NSI.04 4.2, 6

[ ] Avaliar riscos de comunicação interna e externa
    → Por quê: APIs e integrações são superfícies de ataque
    → Como: mapear todas as integrações e classificar por criticidade
    → Ref: NSI.04 4.2
```

---

## Fase 3 — Análise (NSI.04 4.3)

```
[ ] Especificar requisitos de autenticação e autorização
    → Por quê: autenticação fraca é a principal causa de brechas
    → Como: definir mecanismo (OAuth2, SAML, local), MFA se necessário, roles
    → Ref: NSI.04 4.3, 3.3

[ ] Classificar dados por sensibilidade
    → Por quê: dados sem classificação recebem proteção inadequada
    → Como: aplicar classificação: público / interno / restrito / sigiloso
    → Ref: NSI.04 4.3

[ ] Especificar requisitos de confidencialidade, integridade e disponibilidade
    → Por quê: triade CIA define os controles necessários por dado
    → Como: para cada tipo de dado, definir: criptografado em repouso? em trânsito?
    → Ref: NSI.04 4.3

[ ] Definir interfaces com sistemas de log e monitoramento
    → Por quê: sem integração prévia, log vira retrofit caro
    → Como: especificar eventos a auditar e formato dos registros (ver seção 3.6)
    → Ref: NSI.04 4.3, 3.6

[ ] Garantir separação de ambientes na arquitetura
    → Por quê: dev com acesso a dados de prod é incidente aguardando
    → Como: redes separadas, credenciais separadas, dados anonimizados em dev
    → Ref: NSI.04 4.3
```

---

## Fase 4 — Codificação (NSI.04 4.4)

```
[ ] Validar e sanitizar toda entrada de dados externos
    → Por quê: toda entrada não validada é potencial vetor de injeção
    → Como: validar tipo, tamanho, formato; usar prepared statements para SQL
    → Ref: NSI.04 4.4

[ ] Não armazenar segredos no código-fonte
    → Por quê: segredos em código vazam via git, logs, erros
    → Como: usar variáveis de ambiente ou vault; rodar secret-detection antes do commit
    → Ref: NSI.04 3.3

[ ] Usar algoritmos de criptografia aprovados
    → Por quê: algoritmos obsoletos (MD5, SHA1, DES) são quebráveis
    → Como: seguir tabela da NSI.04 3.8; usar skill crypto-standards
    → Ref: NSI.04 3.8, 4.4

[ ] Realizar revisão de código por par qualificado
    → Por quê: o autor não vê seus próprios erros de segurança
    → Como: PR obrigatório com reviewer designado antes do merge
    → Ref: NSI.04 4.4

[ ] Auditar dependências contra CVEs conhecidos
    → Por quê: bibliotecas desatualizadas são o vetor #1 de ataques modernos
    → Como: pip audit / npm audit / trivy no pipeline de CI
    → Ref: NSI.04 4.4

[ ] Implementar controle de acesso adequado
    → Por quê: autorização no frontend é facilmente burlada
    → Como: verificar permissão no backend em toda rota e operação
    → Ref: NSI.04 4.4

[ ] Utilizar sistema de controle de versão com política de acesso
    → Por quê: código sem versionamento não tem rastreabilidade de mudanças
    → Como: Git com branch protection, aprovação obrigatória de PR
    → Ref: NSI.04 4.4
```

---

## Fase 5 — Testes (NSI.04 4.5)

```
[ ] Usar dados fictícios ou anonimizados no ambiente de teste
    → Por quê: dados reais em teste violam LGPD e expõem usuários
    → Como: gerar massa de dados fake; anonimizar dump de produção se necessário
    → Ref: NSI.04 4.5

[ ] Realizar testes manuais de segurança antes de cada release
    → Por quê: testes automatizados não cobrem lógica de negócio
    → Como: testar login, formulários novos, APIs sem autenticação
    → Ref: NSI.04 3.7

[ ] Executar testes automatizados de segurança no CI
    → Por quê: regressões de segurança passam despercebidas sem automação
    → Como: SAST (bandit, semgrep), DAST (OWASP ZAP), dependency check
    → Ref: NSI.04 3.7, 4.5

[ ] Submeter sistema a ferramenta de pentest (se alterou superfície)
    → Por quê: login novo, formulário novo, API nova = nova superfície de ataque
    → Como: usar OWASP ZAP, Burp Suite ou contratar pentest externo
    → Ref: NSI.04 3.5

[ ] Manter testes em ambiente separado de produção
    → Por quê: testes em produção podem expor dados reais ou derrubar o serviço
    → Como: ambiente de homologação com dados anonimizados e monitoramento
    → Ref: NSI.04 4.5
```

---

## Fase 6 — Implantação (NSI.04 4.6)

```
[ ] Documentar plano de implantação com procedimento de rollback
    → Por quê: deploy sem rollback é roleta-russa
    → Como: runbook com passos, responsáveis, critérios de sucesso e de rollback
    → Ref: NSI.04 4.6

[ ] Realizar backup antes do deploy
    → Por quê: problema pós-deploy pode exigir restauração imediata
    → Como: backup de banco e snapshot do ambiente antes de qualquer mudança
    → Ref: NSI.04 4.6, 3.7

[ ] Aplicar patches de segurança (app + infraestrutura)
    → Por quê: deploy de sistema atualizado em infra desatualizada anula o esforço
    → Como: atualizar SO, runtime, dependências antes do deploy
    → Ref: NSI.04 4.6

[ ] Ativar monitoramento e detecção de intrusão
    → Por quê: sem monitoramento, incidentes só são descobertos tardiamente
    → Como: configurar alertas de anomalia, falhas de autenticação, erros 5xx
    → Ref: NSI.04 4.6

[ ] Executar testes de validação pós-deploy em produção
    → Por quê: comportamento em produção pode diferir do ambiente de homolog
    → Como: smoke tests focados em autenticação, fluxos críticos e integrações
    → Ref: NSI.04 4.6

[ ] Registrar a mudança conforme Procedimento da GMUD
    → Por quê: rastreabilidade de mudanças é requisito da ISO 27001
    → Como: abrir registro de mudança com: o quê, quem, quando, impacto, rollback
    → Ref: NSI.04 5
```

---

## Fase 7 — Manutenção (NSI.04 4.7)

```
[ ] Aplicar patches de segurança continuamente
    → Por quê: CVEs são publicados diariamente; janela de exposição importa
    → Como: monitorar boletins de segurança das dependências; política de SLA para patches
    → Ref: NSI.04 4.7

[ ] Manter dependências atualizadas
    → Por quê: versões antigas acumulam CVEs conhecidos
    → Como: renovar dependências a cada sprint ou mensalmente no mínimo
    → Ref: NSI.04 4.7

[ ] Realizar backups regulares e testar restauração
    → Por quê: backup não testado não é backup
    → Como: backup diário + teste de restauração mensal documentado
    → Ref: NSI.04 3.7, 4.7

[ ] Documentar toda mudança conforme GMUD
    → Por quê: mudança não documentada impede diagnóstico de incidentes
    → Como: registro com: o quê mudou, quem autorizou, quando foi feito, como reverter
    → Ref: NSI.04 4.7, 5

[ ] Realizar avaliações periódicas de risco (pentest, análise de vulnerabilidade)
    → Por quê: o cenário de ameaças muda; a avaliação de risco deve acompanhar
    → Como: análise de vulnerabilidade semestral; pentest anual ou após mudança estrutural
    → Ref: NSI.04 4.7

[ ] Manter treinamento da equipe sobre segurança
    → Por quê: rotatividade de pessoas dilui o conhecimento de segurança
    → Como: onboarding com NSI.04; atualizações periódicas sobre ameaças relevantes
    → Ref: NSI.04 3.1
```
