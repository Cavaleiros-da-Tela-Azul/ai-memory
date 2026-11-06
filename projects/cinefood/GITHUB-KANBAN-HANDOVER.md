# Handover de Geração de Issues e Sincronização com Kanban (`MAR-02` a `MAR-06`)

Este documento consolida o estado atual do backlog no GitHub e as instruções exatas para continuar a criação de Issues dos marcos **`MAR-02` a `MAR-06`** em qualquer sessão (incluindo *Remote Project*).

---

## 1. Estado Atual no GitHub (`Cavaleiros-da-Tela-Azul/cinefood`)

- **Project V2 (Kanban Oficial):** [Current iteration · @Matheus-slvmr's untitled project](https://github.com/orgs/Cavaleiros-da-Tela-Azul/projects/1/views/1)
  - `ProjectId`: `PVT_kwDOFKkS8M4BqZhD`
  - `StatusFieldId`: `PVTSSF_lADOFKkS8M4BqZhDzhow0xQ` (`Backlog` = `f75ad846`, `Ready` = `e18bf179`, `In progress` = `47fc9ee4`, `In review` = `aba860b9`, `Done` = `98236657`)
  - `IterationFieldId`: `PVTIF_lADOFKkS8M4BqZhDzhow02A` (`Iteration 1` = `381c7c80`, início `2026-11-05`)
  - **Regra Obrigatória:** Toda Issue criada DEVE ser adicionada ao Project `PVT_kwDOFKkS8M4BqZhD` com `Iteration = Iteration 1 (381c7c80)` para aparecer imediatamente na view [Current iteration (`views/1`)](https://github.com/orgs/Cavaleiros-da-Tela-Azul/projects/1/views/1).
- **Milestones Criados (`#1` a `#6`):**
  1. `#1` — `MAR-01: Fundamentos (Conta, Catálogo e LGPD)` — **Concluído no backlog (Issues `#1` a `#7` criadas e alocadas em `Ready` na `Iteration 1`)**
  2. `#2` — `MAR-02: Ingressos (Reserva 10min, Pagamento Sandbox e Meia-Entrada)` — **Pendente criar Issues**
  3. `#3` — `MAR-03: Acesso e Histórico (QR Code, Portaria e Avaliação)` — **Pendente criar Issues**
  4. `#4` — `MAR-04: Cantina e Gestão (Cardápio, Estoque, KDS/Runner, Estorno e LGPD)` — **Pendente criar Issues**
  5. `#5` — `MAR-05: Verificação Integrada e Qualidade (RNFs e Candidata v1.0.0-rc.1)` — **Pendente criar Issues**
  6. `#6` — `MAR-06: Transição, Implantação e Encerramento (Piloto v1.0.0)` — **Pendente criar Issues**

---

## 2. Catálogo de 19 Labels Já Existentes no Repositório

- **Fases ISO/IEC/IEEE 12207:2021:**
  - `fase:requisitos`
  - `fase:arquitetura-design`
  - `fase:implementacao`
  - `fase:integracao`
  - `fase:verificacao-validacao`
  - `fase:transicao-operacao`
- **Módulos Arquiteturais (`ADR-001`):**
  - `modulo:CMP-01-identidade`
  - `modulo:CMP-02-catalogo-reserva`
  - `modulo:CMP-03-pagamentos`
  - `modulo:CMP-04-ingressos-acesso`
  - `modulo:CMP-05-cantina-alimentacao`
  - `modulo:CMP-06-historico-auditoria`
- **Papéis RACI:** `role:RP`, `role:RT`, `role:RI`, `role:RQ`
- **Risco:** `risco:alto`, `risco:moderado`, `risco:baixo`

---

## 3. Fonte da Verdade para Gerar as Issues (`MAR-02` a `MAR-06`)

Todas as especificações OpenSpec já estão prontas e validadas no repositório `cinefood`:

1. **`MAR-02` (Milestone `#2`):** Ler `cinefood/openspec/changes/mar-02-ingressos-reserva/`
   - `RF-03`: Reserva exclusiva concorrente de 10 min (`@test:tests/booking/reserva.test.ts`)
   - `RF-04` + `RN-01`: Pagamento Pix/Cartão em sandbox com idempotência + compensação e estorno automático de Pix Tardio (`@test:tests/payments/checkout.test.ts`)
   - `RF-14` + `RF-16`: Venda assistida na bilheteria e cálculo de meia-entrada com teto de 40% (`@test:tests/booking/venda-assistida.test.ts`)
   - UI/UX de Reserva + Checkout de Ingresso (`role:RI`)
2. **`MAR-03` (Milestone `#3`):** Ler `cinefood/openspec/changes/mar-03-acesso-historico/`
   - `RF-05`: Emissão de ingresso individual e QR Code opaco (`@test:tests/tickets/qrcode.test.ts`)
   - `RF-06` + `RN-02`: Validação e consumo atômico único na portaria + gatilho automático `AGUARDANDO_CHEGADA -> EM_PREPARO` na cantina (`@test:tests/tickets/qrcode.test.ts`)
   - `RF-11` + `RF-13`: Histórico privado da conta e avaliação única pós-sessão (`@test:tests/history/avaliacao.test.ts`)
3. **`MAR-04` (Milestone `#4`):** Ler `cinefood/openspec/changes/mar-04-cantina-gestao/`
   - `RF-07` + `RF-08` + `RN-05`: Cardápio da cantina, reserva atômica de estoque (`zero estoque negativo`) e CTA pós-ingresso (`@test:tests/canteen/estoque.test.ts`)
   - `RF-09` + `RF-20` + `RN-03`: KDS da cozinha, entrega no assento e ocorrência do Runner na sala escura convertendo para `RETIRADA_NO_BALCAO` (`@test:tests/canteen/entrega.test.ts`)
   - `RF-10` + `RF-15`: Administração de sessões/cardápio e painel de ocupação por sessão (`@test:tests/management/ocupacao-estorno.test.ts`)
   - `RF-12` + `RN-04`: Cancelamento e estorno CDC com janela de corte de 2h antes da sessão (`@test:tests/management/ocupacao-estorno.test.ts`)
   - `RF-18`: Direitos do titular LGPD com protocolo e conservação legal (`@test:tests/privacy/direitos-titular.test.ts`)
4. **`MAR-05` (Milestone `#5`):** Ler `cinefood/openspec/changes/mar-05-qualidade-rnf/`
   - `RNF-01` a `RNF-06`: Bateria de carga (`p95 <= 2s`), segurança, integridade concorrente, acessibilidade `WCAG 2.2 AA`, ensaio de backup e candidata `v1.0.0-rc.1` (`@test:tests/quality/rnf-integridade.test.ts`)
5. **`MAR-06` (Milestone `#6`):** Ler `cinefood/openspec/changes/mar-06-transicao-operacao/`
   - `RST-01` a `RST-04`: Smoke test integrado ponta a ponta, trava de segurança de sandbox (`RST-03`), ensaio de rollback e aceite final da release `v1.0.0` (`@test:tests/operations/smoke-piloto.test.ts`)

---

## 4. Como Usar o Script Helper (`github-backlog-sync.ps1`)

Basta carregar a função `New-CineFoodIssue` de `ai-memory/projects/cinefood/scripts/github-backlog-sync.ps1` (ela cria a Issue via REST UTF-8 e já executa as 3 mutações GraphQL para incluí-la no Kanban `PVT_kwDOFKkS8M4BqZhD` na `Iteration 1`).
