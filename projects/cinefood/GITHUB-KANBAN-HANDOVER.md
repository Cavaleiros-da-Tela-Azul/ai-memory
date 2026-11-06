# Handover de Geração de Issues e Sincronização com Kanban (`MAR-01` a `MAR-06`)

Este documento consolida o estado completo do backlog no GitHub (`Cavaleiros-da-Tela-Azul/cinefood`), o catálogo de 24 Issues criadas rigorosamente alinhadas à norma ISO/IEC/IEEE 12207:2021, PROD-001 e OpenSpec changes, e os procedimentos de sincronização automática com o Kanban Project #1.

---

## 1. Estado Atual no GitHub (`Cavaleiros-da-Tela-Azul/cinefood`)

- **Project V2 (Kanban Oficial):** [Current iteration · @Matheus-slvmr's untitled project](https://github.com/orgs/Cavaleiros-da-Tela-Azul/projects/1/views/1)
  - `ProjectId`: `PVT_kwDOFKkS8M4BqZhD`
  - `StatusFieldId`: `PVTSSF_lADOFKkS8M4BqZhDzhow0xQ` (`Backlog` = `f75ad846`, `Ready` = `e18bf179`, `In progress` = `47fc9ee4`, `In review` = `aba860b9`, `Done` = `98236657`)
  - `IterationFieldId`: `PVTIF_lADOFKkS8M4BqZhDzhow02A` (`Iteration 1` = `381c7c80`, início `2026-11-05`)
  - **Regra Obrigatória:** Toda Issue criada DEVE ser vinculada ao Project `PVT_kwDOFKkS8M4BqZhD` com `Iteration = Iteration 1 (381c7c80)` para exibição imediata na view [Current iteration (`views/1`)](https://github.com/orgs/Cavaleiros-da-Tela-Azul/projects/1/views/1).

- **Milestones Criados e Estado de Conclusão das Issues:**
  1. `#1` — `MAR-01: Fundamentos (Conta, Catálogo e LGPD)` — **100% Criado (Issues `#1` a `#7`)**
  2. `#2` — `MAR-02: Ingressos (Reserva 10min, Pagamento Sandbox e Meia-Entrada)` — **100% Criado (Issues `#8` a `#11`)**
  3. `#3` — `MAR-03: Acesso e Histórico (QR Code, Portaria e Avaliação)` — **100% Criado (Issues `#12` a `#15`)**
  4. `#4` — `MAR-04: Cantina e Gestão (Cardápio, Estoque, KDS/Runner, Estorno e LGPD)` — **100% Criado (Issues `#16` a `#20`)**
  5. `#5` — `MAR-05: Verificação Integrada e Qualidade (RNFs e Candidata v1.0.0-rc.1)` — **100% Criado (Issues `#21` a `#22`)**
  6. `#6` — `MAR-06: Transição, Implantação e Encerramento (Piloto v1.0.0)` — **100% Criado (Issues `#23` a `#24`)**

---

## 2. Catálogo Oficial das 24 Issues Criadas no Repositório

| # | Milestone | Node ID | Título | Módulos & RACI | Risco |
|---|---|---|---|---|---|
| **#1** | `MAR-01` (#1) | `I_kwDOVg0CMc8AAAABc64R1A` | `[MAR-01][ARQ/CI] Setup do Monólito Modular, Schema Inicial PostgreSQL e Pipeline CI` | `role:RT`, `role:RQ` | Moderado |
| **#2** | `MAR-01` (#1) | `I_kwDOVg0CMc8AAAABc64SVQ` | `[MAR-01][CMP-01] RF-01: Cadastro de Usuário, Hashing de Senha e Autenticação JWT` | `CMP-01`, `role:RT`, `role:RI` | Alto |
| **#3** | `MAR-01` (#1) | `I_kwDOVg0CMc8AAAABc64S3A` | `[MAR-01][CMP-01] RF-01: Controle de Acesso Baseado em Papéis (RBAC) e Isolamento de Perfis` | `CMP-01`, `role:RT`, `role:RQ` | Alto |
| **#4** | `MAR-01` (#1) | `I_kwDOVg0CMc8AAAABc64TZQ` | `[MAR-01][CMP-02] RF-02: Catálogo de Filmes, Salas, Sessões Ativas e Filtros de Programação` | `CMP-02`, `role:RT`, `role:RI` | Baixo |
| **#5** | `MAR-01` (#1) | `I_kwDOVg0CMc8AAAABc64UAQ` | `[MAR-01][CMP-02] RF-02: Consulta do Mapa de Assentos por Sessão em Tempo Real` | `CMP-02`, `role:RT`, `role:RI` | Moderado |
| **#6** | `MAR-01` (#1) | `I_kwDOVg0CMc8AAAABc64UoA` | `[MAR-01][CMP-01/CMP-06] RF-17: Aviso de Privacidade, Finalidades LGPD e Consentimento Opcional` | `CMP-01`, `CMP-06`, `role:RP`, `role:RQ` | Moderado |
| **#7** | `MAR-01` (#1) | `I_kwDOVg0CMc8AAAABc68N2g` | `[MAR-01][UI/UX] Definição de Identidade Visual Dark-First, Design Tokens e Protótipos Figma (WCAG 2.2 AA)` | `role:RP`, `role:RI` | Baixo |
| **#8** | `MAR-02` (#2) | `I_kwDOVg0CMc8AAAABc7TkEQ` | `[MAR-02][CMP-02] RF-03: Reserva Exclusiva de Assentos com Trava de 10 Minutos e Concorrência` | `CMP-02`, `role:RT`, `role:RQ` | Alto |
| **#9** | `MAR-02` (#2) | `I_kwDOVg0CMc8AAAABc7Tlkw` | `[MAR-02][CMP-03] RF-04/RN-01: Checkout Gateway, Idempotência e Estorno Automático de Pix Tardio` | `CMP-03`, `role:RT`, `role:RQ` | Alto |
| **#10** | `MAR-02` (#2) | `I_kwDOVg0CMc8AAAABc7TnIw` | `[MAR-02][CMP-02/CMP-03] RF-14/RF-16: Venda Assistida na Bilheteria e Categorias Legais de Meia-Entrada` | `CMP-02`, `CMP-03`, `role:RT`, `role:RI` | Moderado |
| **#11** | `MAR-02` (#2) | `I_kwDOVg0CMc8AAAABc7ToXQ` | `[MAR-02][UI/UX] Interface de Mapa de Assentos, Temporizador de 10 min e Fluxo de Checkout de Ingressos` | `role:RP`, `role:RI` | Moderado |
| **#12** | `MAR-03` (#3) | `I_kwDOVg0CMc8AAAABc7Tp4Q` | `[MAR-03][CMP-04] RF-05: Emissão de Ingressos Individuais com QR Code Opaco Pós-Liquidação` | `CMP-04`, `role:RT`, `role:RI` | Moderado |
| **#13** | `MAR-03` (#3) | `I_kwDOVg0CMc8AAAABc7TrKw` | `[MAR-03][CMP-04/CMP-05] RF-06/RN-02: Validação e Consumo Atômico na Portaria e Gatilho KDS Cantina` | `CMP-04`, `CMP-05`, `role:RT`, `role:RQ` | Alto |
| **#14** | `MAR-03` (#3) | `I_kwDOVg0CMc8AAAABc7Ts0A` | `[MAR-03][CMP-06] RF-11/RF-13: Histórico Privado de Ingressos/Pedidos e Avaliação Pós-Sessão` | `CMP-06`, `role:RT`, `role:RI` | Baixo |
| **#15** | `MAR-03` (#3) | `I_kwDOVg0CMc8AAAABc7Tudg` | `[MAR-03][UI/UX] Interface de Validação de Portaria (Leitor QR) e Exibição de Bilhete Digital` | `role:RP`, `role:RI` | Baixo |
| **#16** | `MAR-04` (#4) | `I_kwDOVg0CMc8AAAABc7TwFQ` | `[MAR-04][CMP-05] RF-07/RF-08/RN-05: Cardápio da Cantina, Recálculo Server-Side e Reserva Atômica de Estoque` | `CMP-05`, `role:RT`, `role:RI` | Alto |
| **#17** | `MAR-04` (#4) | `I_kwDOVg0CMc8AAAABc7TxYg` | `[MAR-04][CMP-05] RF-09/RF-20/RN-03: KDS da Cozinha, Entrega Condicionada no Assento e Ocorrência do Runner` | `CMP-05`, `role:RT`, `role:RI` | Alto |
| **#18** | `MAR-04` (#4) | `I_kwDOVg0CMc8AAAABc7Tyxg` | `[MAR-04][CMP-02/CMP-06] RF-10/RF-15: Gestão Administrativa de Sessões/Preços e Painel de Ocupação em Tempo Real` | `CMP-02`, `CMP-06`, `role:RT`, `role:RP` | Moderado |
| **#19** | `MAR-04` (#4) | `I_kwDOVg0CMc8AAAABc7T0JQ` | `[MAR-04][CMP-03/CMP-04] RF-12/RN-04: Arrependimento e Cancelamento CDC com Janela de Corte de 2h e Estorno Idempotente` | `CMP-03`, `CMP-04`, `role:RT`, `role:RQ` | Alto |
| **#20** | `MAR-04` (#4) | `I_kwDOVg0CMc8AAAABc7T1wQ` | `[MAR-04][CMP-01/CMP-06] RF-18: Gestão de Direitos do Titular LGPD com Protocolo e Conservação Legal` | `CMP-01`, `CMP-06`, `role:RP`, `role:RQ` | Moderado |
| **#21** | `MAR-05` (#5) | `I_kwDOVg0CMc8AAAABc7T3Vg` | `[MAR-05][QUALIDADE/RNF] RNF-01/02/03/06: Bateria Automatizada de Carga (p95 <= 2s), Segurança e Integridade Concorrente` | `CMP-02`, `CMP-03`, `CMP-04`, `role:RQ`, `role:RT` | Alto |
| **#22** | `MAR-05` (#5) | `I_kwDOVg0CMc8AAAABc7T4qg` | `[MAR-05][GOV/QUALIDADE] RNF-04/05: Auditoria WCAG 2.2 AA, Testes com Usuários, Ensaio de Backup e Release Candidate v1.0.0-rc.1` | `role:RP`, `role:RI`, `role:RQ` | Moderado |
| **#23** | `MAR-06` (#6) | `I_kwDOVg0CMc8AAAABc7T55g` | `[MAR-06][OPERACAO] RST-01..04: Smoke Test Integrado Ponta a Ponta, Trava de Sandbox e Rotina de Fechamento de Turno` | `role:RT`, `role:RQ` | Alto |
| **#24** | `MAR-06` (#6) | `I_kwDOVg0CMc8AAAABc7T7eA` | `[MAR-06][RELEASE] Homologação em Unidade Piloto, Ensaio de Rollback, Checklist de Transição e Aceite Final v1.0.0` | `role:RP`, `role:RT`, `role:RQ` | Moderado |

---

## 3. Catálogo de 19 Labels Já Existentes no Repositório

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

## 4. Scripts e Instruções de Sincronização com o Kanban Project #1

A sincronização de itens com o GitHub Projects V2 requer privilégios GraphQL com o escopo `project` (ou `write:org`). Em ambientes remotos com autenticação baseada em GitHub App que possuam restrição em Organization Projects, o script `github-backlog-sync.ps1` já conta com a função automatizada `Sync-AllIssuesToKanbanProject`.

### Como Sincronizar em Máquina Local (Windows / Linux / macOS):

```powershell
# 1. Defina o Personal Access Token com escopo 'project' e 'repo'
$env:GITHUB_PERSONAL_ACCESS_TOKEN = "ghp_SEU_TOKEN_AQUI"

# 2. Execute a sincronização automática de todas as 24 Issues para o Kanban
pwsh -Command '
. ./ai-memory/projects/cinefood/scripts/github-backlog-sync.ps1
Sync-AllIssuesToKanbanProject -KanbanStatus "Ready"
'
```

O comando executará as 3 mutações GraphQL para cada uma das 24 Issues:
1. `addProjectV2ItemById` (Adiciona ao Project #1);
2. `updateProjectV2ItemFieldValue` (Define coluna como `Ready`);
3. `updateProjectV2ItemFieldValue` (Vincula à `Iteration 1` para aparecer imediatamente na View 1).
