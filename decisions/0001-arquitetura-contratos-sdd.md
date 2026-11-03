# ADR-001: Adoção da Cadeia do Contrato, OpenSpec e ai-memory

* **Data:** 2026-11-02
* **Status:** Aceito
* **Decisores:** Equipe Cavaleiros da Tela Azul
* **Cadeia do Contrato:** Transversal (aplica-se a todos os projetos da organização)

---

## 1. Contexto e Declaração do Problema
O desenvolvimento assistido por agentes de IA sofre com três dívidas principais: técnica (código duplicado), cognitiva (falta de clareza do time sobre regras) e de intenção (o motivo das decisões se perde com o tempo). O "vibe coding" gera alucinações e regressões frequentes. Era necessário adotar uma arquitetura de governança rigorosa, sem incorrer no consumo excessivo de tokens e rigidez burocrática de frameworks puramente acadêmicos.

---

## 2. Opções Consideradas
* **Opção 1: Vibe Coding com Prompts Livres:** Rápido inicialmente, mas gera código inconsistente, complexidade desgovernada e quebra de regras em poucas semanas.
* **Opção 2: SDLC-Template Monolítico Puro:** Rigoroso, mas consome $3\times$ a $5\times$ mais tokens a cada tarefa e impõe atrito extremo no fluxo diário de IDEs.
* **Opção 3 (Escolhida): Tríade Híbrida — Cadeia do Contrato (CEIA/UFG) + OpenSpec + ai-memory:**
  * **ai-memory:** Repositório perene de Constituição, ADRs, Gotchas e Memória Multi-User rastreada no Git/Obsidian.
  * **OpenSpec:** Esteira leve e atômica de deltas (`ADDED/MODIFIED/REMOVED`), com BDD e baixo consumo de tokens.
  * **Verificadores Mecânicos:** Hooks de Git simples que cobram a anotação `@test:<caminho>` em cada AC antes do merge.

---

## 3. Decisão Tomada
Adotou-se a Opção 3. Todos os repositórios da organização (iniciando por `Cavaleiros-da-Tela-Azul/cinefood`) deverão:
1. Ter o `openspec` inicializado para gerenciar mudanças ativas em `openspec/changes/`.
2. Conectar-se ao `ai-memory` para consultar a Constituição (`CONST-001`) e registrar ADRs em `decisions/`.
3. Ancorar toda Acceptance Criteria com a tag `@test:<caminho>`.
4. Tratar qualquer bug como uma atualização de spec (Invariante do CEIA: "Bug vira mudança de spec, não hotfix").

---

## 4. Consequências
### Positivas:
* Rastreabilidade total de ponta a ponta: do teste unitário até a Constituição do sistema.
* Economia drástica de tokens em relação ao SDLC-Template puro, mantendo o mesmo nível de segurança.
* Acesso visual a todas as decisões e contratos via Obsidian.

### Riscos e Mitigações:
* **Risco:** Desenvolvedor ou agente tentar alterar código sem atualizar spec.
* **Mitigação:** Hook de pre-commit no repositório de código que verifica a presença do `@test:` e barra o commit caso o código divirja do contrato.
