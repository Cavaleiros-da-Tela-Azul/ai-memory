# Script de Execução: Geração e Sincronização de Issues dos Marcos MAR-02 a MAR-06
# Localização: ai-memory/projects/cinefood/scripts/sync-mar02-to-mar06.ps1
# Execução: pwsh ai-memory/projects/cinefood/scripts/sync-mar02-to-mar06.ps1

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Carrega a infraestrutura oficial de sync
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$scriptDir/github-backlog-sync.ps1"

Write-Output "=== Iniciando criação e sincronização de Issues (MAR-02 a MAR-06) ==="

$issues = @(
  # =========================================================================
  # MAR-02: Ingressos (Reserva 10min, Pagamento Sandbox e Meia-Entrada) [#2]
  # =========================================================================
  @{
    Title           = "[MAR-02][CMP-02] RF-03: Reserva Exclusiva de Assentos com Trava de 10 Minutos e Concorrência"
    MilestoneNumber = 2
    Labels          = @("fase:implementacao", "fase:verificacao-validacao", "modulo:CMP-02-catalogo-reserva", "role:RT", "role:RQ", "risco:alto")
    KanbanStatus    = "Ready"
    Body            = @'
### 📋 Contexto do Requisito
- **Requisito:** RF-03 (Reserva de Assentos) e RNF-03 (Integridade Transacional / Zero Overbooking)
- **Critério de Aceitação:** CA-F03 / CA-N03
- **ADRs Vinculadas:** ADR-002 (PostgreSQL como Autoridade de Trava de 10 Minutos) e ADR-004 (API Fonte Única entre Canais)
- **OpenSpec Spec:** openspec/changes/mar-02-ingressos-reserva/specs/booking/reserva-assentos/spec.md
- **Papéis RACI:** Execução RT | Verificação RQ | Aceite RP

### 🎯 Acceptance Criteria (Spec-Anchored)
- **AC-1.** Na disputa concorrente entre canais pelo mesmo assento, apenas uma reserva ativa é criada e a expiração de 10 min libera o lugar.
  @test:tests/booking/reserva.test.ts
- **AC-2.** Confirmação tardia após expiração não sobrescreve nova reserva de outro titular.
  @test:tests/booking/reserva.test.ts

### 🛠️ Cenários Obrigatórios e Tarefas
- [ ] Implementar trava condicional atômica no PostgreSQL (`UPDATE assentos_sessao SET status = 'RESERVADO', reservado_ate = NOW() + INTERVAL '10 minutes', comprador_id = :userId WHERE id = :id AND (status = 'DISPONIVEL' OR (status = 'RESERVADO' AND reservado_ate < NOW()))`).
- [ ] **Cenário 1 (Disputa simultânea):** Em requisições simultâneas de canais web, mobile ou bilheteria para o mesmo assento, exatamente uma transação é confirmada e a concorrente recebe HTTP 409 Conflict.
- [ ] **Cenário 2 (Liberação automática):** Poltrona reservada sem confirmação de pagamento após 10 minutos é liberada automaticamente para nova reserva em qualquer canal.
- [ ] **Cenário 3 (Proteção contra confirmação tardia):** Pagamento recebido após expiração da reserva de 10 minutos cujo assento já foi reservado ou ocupado por terceiro não sobrescreve o assento e sinaliza necessidade de compensação.
- [ ] Implementar suíte de testes em `tests/booking/reserva.test.ts` e serviços em `src/modules/booking/`.

### 🏁 Critério de Aceite e Saída (Definition of Done)
- Todos os testes de `tests/booking/reserva.test.ts` aprovados em `npm test` e validados por `npm run check:spec`.
'@
  },
  @{
    Title           = "[MAR-02][CMP-03] RF-04/RN-01: Checkout Gateway, Idempotência e Estorno Automático de Pix Tardio"
    MilestoneNumber = 2
    Labels          = @("fase:implementacao", "fase:integracao", "modulo:CMP-03-pagamentos", "role:RT", "role:RQ", "risco:alto")
    KanbanStatus    = "Ready"
    Body            = @'
### 📋 Contexto do Requisito
- **Requisito:** RF-04 (Pagamento com Idempotência) e Regra de Negócio RN-01 (Pix Tardio vs Expiração de 10 min)
- **Critério de Aceitação:** CA-F04 / RST-03
- **ADRs Vinculadas:** ADR-003 (Idempotência e Conciliação com Gateway Externo) e ADR-005 (Desacoplamento de Checkouts)
- **OpenSpec Spec:** openspec/changes/mar-02-ingressos-reserva/specs/payments/checkout-gateway/spec.md
- **Papéis RACI:** Execução RT | Integração/Testes RQ | Aceite RP

### 🎯 Acceptance Criteria (Spec-Anchored)
- **AC-3.** Solicitações e webhooks repetidos respeitam a idempotência sem duplicar cobranças, e eventos não autenticados são rejeitados.
  @test:tests/payments/checkout.test.ts
- **AC-4.** Pagamento confirmado após expiração com assento já ocupado aciona compensação e estorno automático.
  @test:tests/payments/checkout.test.ts

### 🛠️ Cenários Obrigatórios e Tarefas
- [ ] Implementar adaptador para gateway de pagamento em modo Sandbox (Pix e Cartão simulado) com suporte a `Idempotency-Key` obrigatória no header (ADR-003).
- [ ] **Cenário 1 (Idempotência de checkout e webhooks):** Submissão repetida da mesma chave de idempotência retorna o payload original sem criar novas cobranças no provedor.
- [ ] **Cenário 2 (Validação de webhook assinado):** Notificações de webhook sem assinatura HMAC válida ou payload adulterado são rejeitadas com HTTP 401 Unauthorized mantendo o estado da compra inalterado.
- [ ] **Cenário 3 (Compensação e estorno de Pix Tardio - RN-01):** Quando webhook de pagamento aprovado chegar após os 10 minutos de reserva e o assento já tiver sido tomado por outro comprador, persistir estado `CONFLITO_EXPIRACAO` e disparar estorno automático idempotente no gateway com notificação no histórico da conta.
- [ ] Implementar testes em `tests/payments/checkout.test.ts` e módulo em `src/modules/payments/`.

### 🏁 Critério de Aceite e Saída (Definition of Done)
- Todos os testes de `tests/payments/checkout.test.ts` aprovados e conciliação de estorno comprovada.
'@
  },
  @{
    Title           = "[MAR-02][CMP-02/CMP-03] RF-14/RF-16: Venda Assistida na Bilheteria e Categorias Legais de Meia-Entrada"
    MilestoneNumber = 2
    Labels          = @("fase:requisitos", "fase:implementacao", "modulo:CMP-02-catalogo-reserva", "modulo:CMP-03-pagamentos", "role:RT", "role:RI", "risco:moderado")
    KanbanStatus    = "Ready"
    Body            = @'
### 📋 Contexto do Requisito
- **Requisito:** RF-14 (Venda Assistida no Guichê) e RF-16 (Categorias de Ingresso e Meia-Entrada — Lei nº 12.933/2013 e Decreto nº 8.537/2015)
- **Critério de Aceitação:** CA-F14 / CA-F16
- **ADRs Vinculadas:** ADR-004 (API Fonte Única entre Bilheteria e Aplicativos)
- **OpenSpec Spec:** openspec/changes/mar-02-ingressos-reserva/specs/booking/venda-assistida-categorias/spec.md
- **Papéis RACI:** Execução RT e RI | Aceite RP | Verificação RQ

### 🎯 Acceptance Criteria (Spec-Anchored)
- **AC-5.** Venda assistida registra operador e comprador, compartilha a mesma trava de assentos e não emite ingresso antes do pagamento.
  @test:tests/booking/venda-assistida.test.ts
- **AC-6.** Categorias de inteira e meia-entrada são calculadas no servidor rejeitando adulteração de preço no payload.
  @test:tests/booking/venda-assistida.test.ts

### 🛠️ Cenários Obrigatórios e Tarefas
- [ ] Implementar endpoint de venda assistida permitindo ao operador autenticado (`OPERADOR_BILHETERIA`) selecionar assento, identificar comprador e aplicar a trava de 10 min na mesma API central.
- [ ] **Cenário 1 (Concorrência guichê vs digital):** Disputa entre atendente do guichê e comprador no app pela mesma poltrona é resolvida atomicamente sem privilégio de canal.
- [ ] **Cenário 2 (Cálculo server-side de meia-entrada):** Servidor recalcula o valor monetário da meia-entrada (50% do valor da inteira da sessão) ignorando valores enviados no payload JSON e exigindo categoria documental (estudante, idoso, PCD, jovem de baixa renda).
- [ ] Garantir bloqueio de emissão de bilhete antes da confirmação de pagamento no gateway (zero venda a prazo/sem liquidação no MVP).
- [ ] Implementar suíte de testes em `tests/booking/venda-assistida.test.ts`.

### 🏁 Critério de Aceite e Saída (Definition of Done)
- Validação completa dos cálculos legais de meia-entrada e concorrência multicanal aprovados em `npm test`.
'@
  },
  @{
    Title           = "[MAR-02][UI/UX] Interface de Mapa de Assentos, Temporizador de 10 min e Fluxo de Checkout de Ingressos"
    MilestoneNumber = 2
    Labels          = @("fase:arquitetura-design", "fase:implementacao", "role:RP", "role:RI", "risco:moderado")
    KanbanStatus    = "Ready"
    Body            = @'
### 📋 Contexto e Fundamentação (ISO/IEC/IEEE 12207 — Seções 5.1.2 e 6.4.4)
- **Requisitos Vinculados:** RF-02, RF-03, RF-04, RF-16 e RNF-04 (WCAG 2.2 Nível AA)
- **Regra de Negócio:** RN-05 (Esteira Guiada de Convite de Cantina pós-Ingresso)
- **OpenSpec Change:** openspec/changes/mar-02-ingressos-reserva/design.md
- **Papéis RACI:** Liderança/Execução RI | Validação de Usabilidade RP | Verificação RQ

### 🎯 Objetivo de Design e Interface
Projetar e implementar os componentes de interface responsivos (Web e Mobile) para seleção interativa de poltronas no mapa da sala, exibição de cronômetro regressivo com a trava de 10 minutos, seleção de categorias de ingresso (inteira/meia) e modal de checkout transparente com chave Pix/QR Code e formulário seguro de cartão.

### 🛠️ Checklist de Entregáveis de UI/UX
- [ ] **Mapa de Poltronas Interativo:** Renderização acessível dos assentos com distinção de estado (Livre, Selecionado, Reservado, Ocupado) por forma, ícone e contraste >= 4.5:1.
- [ ] **Cronômetro Regressivo de 10 Minutos:** Alerta visual persistente da expiração da reserva com aviso prévio a 2 minutos do término e modal informativo de expiração.
- [ ] **Seleção de Categorias de Ingresso:** Seletor de tipo de ingresso (Inteira / Meia-Entrada) com cálculo dinâmico transparente e campos para comprovação documental.
- [ ] **Fluxo de Pagamento Integrado:** Exibição clara de Copia-e-Cola Pix com QR Code dinâmico e formulário de cartão sandbox com feedback imediato de liquidação.
- [ ] **Gatilho de Transição para a Cantina (RN-05):** Ao confirmar o pagamento do ingresso, apresentar tela de sucesso com CTA proeminente convidando o cliente a antecipar a compra de alimentos com pré-vínculo de poltrona.

### 🏁 Critério de Aceite e Saída (Definition of Done)
- Jornada de seleção e checkout validada nos critérios essenciais de acessibilidade WCAG 2.2 AA (navegável por teclado e compatível com leitores de tela).
'@
  },

  # =========================================================================
  # MAR-03: Acesso e Histórico (QR Code, Portaria e Avaliação) [#3]
  # =========================================================================
  @{
    Title           = "[MAR-03][CMP-04] RF-05: Emissão de Ingressos Individuais com QR Code Opaco Pós-Liquidação"
    MilestoneNumber = 3
    Labels          = @("fase:implementacao", "modulo:CMP-04-ingressos-acesso", "role:RT", "role:RI", "risco:moderado")
    KanbanStatus    = "Ready"
    Body            = @'
### 📋 Contexto do Requisito
- **Requisito:** RF-05 (Emissão de Ingresso) e RNF-02 (Segurança de Tokens)
- **Critério de Aceitação:** CA-F05
- **ADRs Vinculadas:** ADR-003 e ADR-005
- **OpenSpec Spec:** openspec/changes/mar-03-acesso-historico/specs/tickets/emissao-validacao-qr/spec.md
- **Papéis RACI:** Execução RT e RI | Aceite RP | Verificação RQ

### 🎯 Acceptance Criteria (Spec-Anchored)
- **AC-1.** Compra confirmada gera um QR Code opaco distinto por assento e impede emissão antes do pagamento.
  @test:tests/tickets/qrcode.test.ts

### 🛠️ Cenários Obrigatórios e Tarefas
- [ ] Gerar token opaco criptograficamente seguro (HMAC/SHA-256 não sequencial) para cada assento de uma reserva liquidada com sucesso.
- [ ] **Cenário 1 (Multi-assentos):** Compra contendo múltiplos ingressos emite registros individuais com QR Codes distintos e identificador individual de poltrona.
- [ ] **Cenário 2 (Bloqueio pré-pagamento):** Garantir que nenhuma rota ou tentativa externa consiga gerar ou exibir QR Code de reserva em estado `PENDENTE` ou `CANCELADO`.
- [ ] Estruturar payload do bilhete contendo filme, sessão, data/horário, sala, fileira, poltrona, categoria (inteira/meia) e token QR.
- [ ] Implementar testes em `tests/tickets/qrcode.test.ts` e módulo em `src/modules/tickets/`.

### 🏁 Critério de Aceite e Saída (Definition of Done)
- Todos os cenários de emissão validados em `npm test` sem possibilidade de adivinhação de bilhete por enumeração sequencial (RNF-02).
'@
  },
  @{
    Title           = "[MAR-03][CMP-04/CMP-05] RF-06/RN-02: Validação e Consumo Atômico na Portaria e Gatilho KDS Cantina"
    MilestoneNumber = 3
    Labels          = @("fase:implementacao", "fase:verificacao-validacao", "modulo:CMP-04-ingressos-acesso", "modulo:CMP-05-cantina-alimentacao", "role:RT", "role:RQ", "risco:alto")
    KanbanStatus    = "Ready"
    Body            = @'
### 📋 Contexto do Requisito
- **Requisito:** RF-06 (Validação de Ingresso), RNF-03 (Zero Reutilização de QR Code) e Regra de Negócio RN-02 (Gatilho de Preparo na Cantina)
- **Critério de Aceitação:** CA-F06 / CA-N03 / RST-04
- **OpenSpec Spec:** openspec/changes/mar-03-acesso-historico/specs/tickets/emissao-validacao-qr/spec.md
- **Papéis RACI:** Execução RT | Verificação e Concorrência RQ | Aceite RP

### 🎯 Acceptance Criteria (Spec-Anchored)
- **AC-2.** Leitura na portaria consome o ingresso atomicamente apenas na primeira vez e aciona o preparo de pedidos vinculados.
  @test:tests/tickets/qrcode.test.ts

### 🛠️ Cenários Obrigatórios e Tarefas
- [ ] Implementar validação atômica no PostgreSQL (`UPDATE ingressos SET status = 'UTILIZADO', data_utilizacao = NOW(), operador_id = :operadorId WHERE qr_token = :token AND status = 'EMITIDO'`) exigindo perfil `OPERADOR_PORTARIA`.
- [ ] **Cenário 1 (Tentativa de reuso de QR Code):** Segunda leitura (ou leituras simultâneas concorrentes com o mesmo token) aprova estritamente a primeira e rejeita todas as subsequentes com HTTP 409 Conflict / 422 Unprocessable Entity ("Ingresso já utilizado").
- [ ] **Cenário 2 (Validação de sessão correta):** Bloquear leitura de ingressos pertencentes a outras salas, datas ou sessões expiradas.
- [ ] **Cenário 3 (Gatilho de Preparo na Cantina - RN-02):** Ao validar com sucesso a entrada na portaria, disparar evento interno de domínio `TicketValidatedEvent` que localiza pedidos da cantina vinculados àquele `ingresso_id` em estado `AGUARDANDO_CHEGADA` e os transiciona automaticamente para `EM_PREPARO` no KDS da cozinha.
- [ ] Cobrir os cenários concorrentes e de integração em `tests/tickets/qrcode.test.ts`.

### 🏁 Critério de Aceite e Saída (Definition of Done)
- Validação atômica de portaria imune a replay attack e sincronização com KDS comprovada em testes automatizados.
'@
  },
  @{
    Title           = "[MAR-03][CMP-06] RF-11/RF-13: Histórico Privado de Ingressos/Pedidos e Avaliação Pós-Sessão"
    MilestoneNumber = 3
    Labels          = @("fase:requisitos", "fase:implementacao", "modulo:CMP-06-historico-auditoria", "role:RT", "role:RI", "risco:baixo")
    KanbanStatus    = "Ready"
    Body            = @'
### 📋 Contexto do Requisito
- **Requisito:** RF-11 (Histórico Privado e Notificações) e RF-13 (Avaliação Privada Pós-Sessão)
- **Critério de Aceitação:** CA-F11 / CA-F13
- **OpenSpec Spec:** openspec/changes/mar-03-acesso-historico/specs/history/historico-avaliacao/spec.md
- **Papéis RACI:** Execução RT e RI | Aceite RP | Verificação RQ

### 🎯 Acceptance Criteria (Spec-Anchored)
- **AC-3.** Histórico exibe estados atualizados apenas ao próprio titular e falha de aviso não corrompe pagamento.
  @test:tests/history/avaliacao.test.ts
- **AC-4.** Avaliação privada aceita apenas notas de 1 a 5 após o término da sessão para ingresso com entrada validada.
  @test:tests/history/avaliacao.test.ts

### 🛠️ Cenários Obrigatórios e Tarefas
- [ ] **Cenário 1 (Isolamento de histórico privado):** Consulta a `GET /user/history` retorna exclusivamente os ingressos, pedidos de bomboniere, estornos e avisos internos pertencentes ao `userId` do token autenticado, bloqueando acesso a dados de terceiros.
- [ ] **Cenário 2 (Elegibilidade de avaliação pós-sessão):** Permitir submissão, edição ou exclusão de avaliação de 1 a 5 estrelas apenas se:
  1. O usuário for o titular do ingresso;
  2. O ingresso tiver sido validado e utilizado na portaria (`status = 'UTILIZADO'`);
  3. O horário atual for posterior ao término da sessão (`NOW() > sessao.horario_fim`).
- [ ] **Cenário 3 (Rejeição de avaliação inválida):** Tentativas de avaliação antes do encerramento do filme ou para ingressos não comparecidos/cancelados são rejeitadas com HTTP 422.
- [ ] Implementar suíte de testes em `tests/history/avaliacao.test.ts` e serviços em `src/modules/history/`.

### 🏁 Critério de Aceite e Saída (Definition of Done)
- Histórico com estrita autorização por titular e regras de avaliação comprovadas em `npm test`.
'@
  },
  @{
    Title           = "[MAR-03][UI/UX] Interface de Validação de Portaria (Leitor QR) e Exibição de Bilhete Digital"
    MilestoneNumber = 3
    Labels          = @("fase:arquitetura-design", "fase:implementacao", "role:RP", "role:RI", "risco:baixo")
    KanbanStatus    = "Ready"
    Body            = @'
### 📋 Contexto e Fundamentação (ISO/IEC/IEEE 12207 — Seções 5.1.2 e 6.4.4)
- **Requisitos Vinculados:** RF-05, RF-06, RF-11, RF-13 e RNF-04 (WCAG 2.2 AA)
- **OpenSpec Change:** openspec/changes/mar-03-acesso-historico/design.md
- **Papéis RACI:** Liderança/Execução RI | Homologação Operacional RP | Verificação RQ

### 🎯 Objetivo de Design e Interface
Projetar e construir as interfaces do bilhete digital no app do cliente (com QR Code de alto contraste otimizado para leitura em ambiente escuro), a tela de portaria para leitura por câmera/leitor óptico com feedback sonoro e visual imediato para o operador, e o componente de avaliação pós-sessão de 1 a 5 estrelas.

### 🛠️ Checklist de Entregáveis de UI/UX
- [ ] **Bilhete Digital (App/Web):** Exibição limpa do ingresso com QR Code em tamanho adequado, dados da sessão, alerta de uso único e status dinâmico (Válido, Utilizado, Cancelado).
- [ ] **Terminal de Portaria (Controle de Acesso):** Interface operacional para smartphone/tablet com câmera ativa, exibindo tela verde/positiva para acesso liberado e tela vermelha com aviso sonoro para ingresso inválido, reutilizado ou de outra sessão.
- [ ] **Painel de Histórico do Cliente:** Timeline consolidada de compras, ingressos ativos/passados e avisos de status de preparo de alimentos.
- [ ] **Modal de Avaliação com Estrelas:** Componente interativo de 1 a 5 estrelas exibido automaticamente após o término do filme para ingressos validados na portaria.

### 🏁 Critério de Aceite e Saída (Definition of Done)
- Interface de portaria com tempo de feedback imediato e contraste WCAG 2.2 AA validado.
'@
  },

  # =========================================================================
  # MAR-04: Cantina e Gestão (Cardápio, Estoque, KDS/Runner, Estorno e LGPD) [#4]
  # =========================================================================
  @{
    Title           = "[MAR-04][CMP-05] RF-07/RF-08/RN-05: Cardápio da Cantina, Recálculo Server-Side e Reserva Atômica de Estoque"
    MilestoneNumber = 4
    Labels          = @("fase:implementacao", "modulo:CMP-05-cantina-alimentacao", "role:RT", "role:RI", "risco:alto")
    KanbanStatus    = "Ready"
    Body            = @'
### 📋 Contexto do Requisito
- **Requisito:** RF-07 (Cardápio e Carrinho), RF-08 (Pedido e Estoque sem Saldo Negativo) e Regra RN-05 (Esteira Guiada pós-Ingresso)
- **Critério de Aceitação:** CA-F07 / CA-F08 / CA-N03
- **ADRs Vinculadas:** ADR-005 (Desacoplamento de Transações entre Ingressos e Alimentos)
- **OpenSpec Spec:** openspec/changes/mar-04-cantina-gestao/specs/canteen/cardapio-estoque/spec.md
- **Papéis RACI:** Execução RT e RI | Aceite RP | Verificação RQ

### 🎯 Acceptance Criteria (Spec-Anchored)
- **AC-1.** Carrinho recalcula total com adicionais no servidor, ignora preço adulterado e bloqueia item indisponível.
  @test:tests/canteen/estoque.test.ts
- **AC-2.** Disputa pela última unidade reserva estoque para apenas um checkout sem permitir saldo negativo.
  @test:tests/canteen/estoque.test.ts

### 🛠️ Cenários Obrigatórios e Tarefas
- [ ] Implementar listagem do cardápio com combos, adicionais e controle de disponibilidade por produto.
- [ ] **Cenário 1 (Recálculo estrito no servidor):** Submissão de checkout da cantina ignora preços e totais manipulados pelo cliente, recalculando valores a partir do banco e recusando itens esgotados.
- [ ] **Cenário 2 (Reserva atômica de estoque):** Decrementar estoque de forma transacional condicional (`UPDATE produtos SET estoque_disponivel = estoque_disponivel - :qtd WHERE id = :id AND estoque_disponivel >= :qtd`). Disputa simultânea pela última unidade aloca para apenas um cliente e rejeita o concorrente com HTTP 409 Conflict (zero estoque negativo).
- [ ] **Cenário 3 (Baixa definitiva ou estorno de reserva):** Confirmar baixa de estoque pós-liquidação financeira ou devolver itens ao estoque se o pagamento expirar/falhar.
- [ ] Implementar testes em `tests/canteen/estoque.test.ts` e módulo em `src/modules/canteen/`.

### 🏁 Critério de Aceite e Saída (Definition of Done)
- Todos os testes de estoque e recálculo aprovados em `npm test` sem possibilidade de saldo negativo.
'@
  },
  @{
    Title           = "[MAR-04][CMP-05] RF-09/RF-20/RN-03: KDS da Cozinha, Entrega Condicionada no Assento e Ocorrência do Runner"
    MilestoneNumber = 4
    Labels          = @("fase:implementacao", "fase:integracao", "modulo:CMP-05-cantina-alimentacao", "role:RT", "role:RI", "risco:alto")
    KanbanStatus    = "Ready"
    Body            = @'
### 📋 Contexto do Requisito
- **Requisito:** RF-09 (Atendimento da Cantina e KDS), RF-20 (Ocorrência do Runner) e Regras RN-02, RN-03 e RST-04
- **Critério de Aceitação:** CA-F09 / RST-04
- **OpenSpec Spec:** openspec/changes/mar-04-cantina-gestao/specs/canteen/kds-entrega-runner/spec.md
- **Papéis RACI:** Execução RT e RI | Homologação Operacional RP | Verificação RQ

### 🎯 Acceptance Criteria (Spec-Anchored)
- **AC-3.** Entrega no assento rejeita ingresso de terceiro ou sem entrada validada na portaria, enquanto retirada no balcão dispensa ingresso.
  @test:tests/canteen/entrega.test.ts
- **AC-4.** Registro de ocorrência pelo runner converte o pedido para retirada no balcão e notifica o titular.
  @test:tests/canteen/entrega.test.ts

### 🛠️ Cenários Obrigatórios e Tarefas
- [ ] Implementar máquina de estados da comanda KDS:
  - Balcão: `PENDENTE_PAGAMENTO` -> `EM_PREPARO` -> `PRONTO` -> `ENTREGUE`.
  - Entrega no Assento: `PENDENTE_PAGAMENTO` -> `AGUARDANDO_CHEGADA` -> (validação portaria) -> `EM_PREPARO` -> `PRONTO` -> `SAIU_PARA_ENTREGA` -> `ENTREGUE`.
- [ ] **Cenário 1 (Trava inegociável RST-04):** Bloquear saída para entrega no assento caso o ingresso vinculado pertença a outro usuário ou não tenha sido validado na portaria (`status != UTILIZADO`), retornando HTTP 422.
- [ ] **Cenário 2 (Ocorrência do Runner na sala escura - RN-03 / RF-20):** Caso o runner não localize o cliente na poltrona ou haja impedimento, permitir registrar ocorrência no app do runner, convertendo automaticamente o pedido para `RETIRADA_NO_BALCAO` e gerando notificação imediata no histórico do cliente.
- [ ] Implementar suíte de testes em `tests/canteen/entrega.test.ts`.

### 🏁 Critério de Aceite e Saída (Definition of Done)
- Fluxo KDS e contingência do runner validados sem brechas operacionais em `npm test`.
'@
  },
  @{
    Title           = "[MAR-04][CMP-02/CMP-06] RF-10/RF-15: Gestão Administrativa de Sessões/Preços e Painel de Ocupação em Tempo Real"
    MilestoneNumber = 4
    Labels          = @("fase:requisitos", "fase:implementacao", "modulo:CMP-02-catalogo-reserva", "modulo:CMP-06-historico-auditoria", "role:RT", "role:RP", "risco:moderado")
    KanbanStatus    = "Ready"
    Body            = @'
### 📋 Contexto do Requisito
- **Requisito:** RF-10 (Administração de Sessões e Cardápio) e RF-15 (Consultas Gerenciais e Taxa de Ocupação)
- **Critério de Aceitação:** CA-F10 / CA-F15
- **OpenSpec Spec:** openspec/changes/mar-04-cantina-gestao/specs/management/admin-relatorios-estorno/spec.md
- **Papéis RACI:** Execução RT | Validação RP | Verificação RQ

### 🎯 Acceptance Criteria (Spec-Anchored)
- **AC-5.** Mudança administrativa de preço preserva compras passadas e consulta de 10 assentos com 3 ativos e 1 cancelado retorna 30% de ocupação.
  @test:tests/management/ocupacao-estorno.test.ts

### 🛠️ Cenários Obrigatórios e Tarefas
- [ ] Endpoints administrativos para cadastro/edição de filmes, salas, sessões, horários, preços e itens do cardápio com controle de acesso exclusivo para `ADMIN_CINEMA`.
- [ ] **Cenário 1 (Imutabilidade de compras passadas):** Atualização de preço da sessão ou de produto não altera o valor histórico de compras ou ingressos já emitidos.
- [ ] **Cenário 2 (Cálculo determinístico de taxa de ocupação):** Fórmula oficial `ocupação = (ingressos_ativos / assentos_comercializaveis) * 100`, ignorando reservas expiradas e compras canceladas/estornadas.
- [ ] Implementar testes em `tests/management/ocupacao-estorno.test.ts` e serviços em `src/modules/management/`.

### 🏁 Critério de Aceite e Saída (Definition of Done)
- Painel administrativo e relatórios gerenciais aprovados com 100% de consistência contábil.
'@
  },
  @{
    Title           = "[MAR-04][CMP-03/CMP-04] RF-12/RN-04: Arrependimento e Cancelamento CDC com Janela de Corte de 2h e Estorno Idempotente"
    MilestoneNumber = 4
    Labels          = @("fase:implementacao", "modulo:CMP-03-pagamentos", "modulo:CMP-04-ingressos-acesso", "role:RT", "role:RQ", "risco:alto")
    KanbanStatus    = "Ready"
    Body            = @'
### 📋 Contexto do Requisito
- **Requisito:** RF-12 (Cancelamento e Estorno CDC — art. 49) e Regra RN-04 (Janela de Corte Operacional)
- **Critério de Aceitação:** CA-F12
- **ADRs Vinculadas:** ADR-003 (Idempotência no Gateway de Pagamento)
- **OpenSpec Spec:** openspec/changes/mar-04-cantina-gestao/specs/management/admin-relatorios-estorno/spec.md
- **Papéis RACI:** Execução RT | Testes de Borda RQ | Aceite RP

### 🎯 Acceptance Criteria (Spec-Anchored)
- **AC-6.** Cancelamento elegível até 2h antes da sessão realiza estorno idempotente e rejeita ingresso já utilizado na portaria.
  @test:tests/management/ocupacao-estorno.test.ts

### 🛠️ Cenários Obrigatórios e Tarefas
- [ ] **Cenário 1 (Critérios de elegibilidade do arrependimento):**
  - Compra realizada há no máximo 7 dias corridos (`NOW() <= compra.data + 7 dias`);
  - Solicitação enviada até **2 horas antes do início da sessão** (`NOW() <= sessao.inicio - 2 horas`);
  - Ingresso ainda não utilizado na portaria (`status == 'EMITIDO'`).
- [ ] **Cenário 2 (Cancelamento de cantina vinculado):** Para itens de cantina, cancelamento permitido se comanda estiver em `AGUARDANDO_CHEGADA` ou `PENDENTE_PAGAMENTO` (antes de iniciar `EM_PREPARO`).
- [ ] **Cenário 3 (Estorno financeiro idempotente):** Invalidação do ingresso no banco (`CANCELADO`), liberação da poltrona para revenda e disparo de estorno idempotente no gateway com chave única de cancelamento.
- [ ] **Cenário 4 (Bloqueio pós-leitura ou pós-corte):** Rejeitar com erro HTTP 422 qualquer tentativa de cancelamento após validação na portaria ou dentro da janela de 2 horas.
- [ ] Implementar testes em `tests/management/ocupacao-estorno.test.ts`.

### 🏁 Critério de Aceite e Saída (Definition of Done)
- Testes cobrindo limites de janela temporal e estorno idempotente aprovados em `npm test`.
'@
  },
  @{
    Title           = "[MAR-04][CMP-01/CMP-06] RF-18: Gestão de Direitos do Titular LGPD com Protocolo e Conservação Legal"
    MilestoneNumber = 4
    Labels          = @("fase:requisitos", "fase:implementacao", "modulo:CMP-01-identidade", "modulo:CMP-06-historico-auditoria", "role:RP", "role:RQ", "risco:moderado")
    KanbanStatus    = "Ready"
    Body            = @'
### 📋 Contexto do Requisito
- **Requisito:** RF-18 (Atendimento aos Direitos do Titular — Lei Geral de Proteção de Dados nº 13.709/2018)
- **Critério de Aceitação:** CA-F18
- **OpenSpec Spec:** openspec/changes/mar-04-cantina-gestao/specs/privacy/direitos-titular/spec.md
- **Papéis RACI:** Definição/Aceite RP | Implementação RT | Verificação de Conformidade RQ

### 🎯 Acceptance Criteria (Spec-Anchored)
- **AC-7.** Direitos do titular rejeitam solicitação de outra conta, eliminam dados dispensáveis e conservam registros obrigatórios com protocolo.
  @test:tests/privacy/direitos-titular.test.ts

### 🛠️ Cenários Obrigatórios e Tarefas
- [ ] Canal autenticado para abertura de solicitações do titular: confirmação de dados, acesso, retificação e eliminação.
- [ ] **Cenário 1 (Geração de protocolo autenticado):** Toda solicitação gera identificador alfanumérico único de protocolo vinculado exclusivamente à conta do requerente (rejeita solicitações sobre dados de terceiros).
- [ ] **Cenário 2 (Eliminação seletiva com conservação legal):** Em pedidos de exclusão, anonimizar/deletar dados opcionais (preferências, cookies, histórico de navegação), conservando dados transacionais e fiscais de compras concluídas com registro da base legal de retenção (art. 16 da LGPD e guarda fiscal).
- [ ] Implementar suíte de testes em `tests/privacy/direitos-titular.test.ts` e módulo em `src/modules/privacy/`.

### 🏁 Critério de Aceite e Saída (Definition of Done)
- Conformidade legal de privacidade validada sem quebra de integridade contábil.
'@
  },

  # =========================================================================
  # MAR-05: Verificação Integrada e Qualidade (RNFs e Candidata v1.0.0-rc.1) [#5]
  # =========================================================================
  @{
    Title           = "[MAR-05][QUALIDADE/RNF] RNF-01/02/03/06: Bateria Automatizada de Carga (p95 <= 2s), Segurança e Integridade Concorrente"
    MilestoneNumber = 5
    Labels          = @("fase:verificacao-validacao", "modulo:CMP-02-catalogo-reserva", "modulo:CMP-03-pagamentos", "modulo:CMP-04-ingressos-acesso", "role:RQ", "role:RT", "risco:alto")
    KanbanStatus    = "Ready"
    Body            = @'
### 📋 Contexto do Requisito
- **Requisitos Não Funcionais:** RNF-01 (Desempenho p95 <= 2s), RNF-02 (Segurança de Tráfego e Segredos), RNF-03 (Integridade Transacional Absoluta) e RNF-06 (Manutenibilidade e Cobertura >= 70%)
- **Critérios de Aceitação:** CA-N01, CA-N02, CA-N03 e CA-N06
- **OpenSpec Spec:** openspec/changes/mar-05-qualidade-rnf/specs/quality/verificacao-rnf/spec.md
- **Papéis RACI:** Liderança/Execução RQ | Suporte Arquitetural RT | Aceite RP

### 🎯 Acceptance Criteria (Spec-Anchored)
- **AC-1.** Operações internas e validações de QR Code atingem meta de desempenho p95 <= 2s sem erros inesperados.
  @test:tests/quality/rnf-integridade.test.ts
- **AC-2.** Bateria de integridade e segurança comprova zero venda duplicada, zero reuso de QR, zero estoque negativo e bloqueio de acesso cruzado.
  @test:tests/quality/rnf-integridade.test.ts

### 🛠️ Cenários Obrigatórios e Tarefas
- [ ] **Cenário 1 (Aferição de latência p95 sob 20 usuários concorrentes):** Executar bateria de 100 operações internas e 100 validações de QR Code simultâneas, calculando o percentil 95 na posição teto `ceil(0.95 * N)` e assegurando latência <= 2000 ms.
- [ ] **Cenário 2 (Integridade concorrente no banco de dados):** Disparar rajada de requisições paralelas contra:
  1. O mesmo assento na mesma sessão (garantir zero overbooking);
  2. A última unidade do estoque de um item da cantina (garantir zero estoque negativo);
  3. A mesma chave de idempotência de pagamento (garantir zero duplicidade de cobrança);
  4. O mesmo QR Code na portaria (garantir exatamente uma entrada aprovada).
- [ ] **Cenário 3 (Segurança e ausência de segredos em logs):** Verificar que nenhuma rota trafega ou registra dados completos de cartão, CVV ou senhas em texto puro. Testar bloqueio de escalonamento IDOR entre contas.
- [ ] **Cenário 4 (Cobertura de testes automatizados):** Aferir cobertura de linhas `>= 70%` nas regras de negócio da API via pipeline de CI.
- [ ] Implementar suíte integrada em `tests/quality/rnf-integridade.test.ts`.

### 🏁 Critério de Aceite e Saída (Definition of Done)
- Bateria de estresse e segurança 100% aprovada comprovando todas as metas numéricas dos RNFs.
'@
  },
  @{
    Title           = "[MAR-05][GOV/QUALIDADE] RNF-04/05: Auditoria WCAG 2.2 AA, Testes com Usuários, Ensaio de Backup e Release Candidate v1.0.0-rc.1"
    MilestoneNumber = 5
    Labels          = @("fase:verificacao-validacao", "role:RQ", "role:RP", "role:RI", "risco:moderado")
    KanbanStatus    = "Ready"
    Body            = @'
### 📋 Contexto e Fundamentação (ISO/IEC/IEEE 12207 — Seções 6.4.10, 6.4.11 e 6.4.12)
- **Requisitos Não Funcionais:** RNF-04 (Usabilidade >= 80% e Acessibilidade WCAG 2.2 AA) e RNF-05 (Backup e Recuperabilidade RPO/RTO)
- **Critérios de Aceitação:** CA-N04 / CA-N05
- **OpenSpec Change:** openspec/changes/mar-05-qualidade-rnf/
- **Papéis RACI:** Homologação RQ e RP | Suporte de Acessibilidade RI | Execução de Infra RT

### 🎯 Objetivo de Validação e Release Candidate
Conduzir os ensaios de usabilidade e auditoria de acessibilidade WCAG 2.2 AA com usuários reais, validar os procedimentos de restauração de desastre do banco PostgreSQL e congelar a versão Release Candidate `v1.0.0-rc.1`.

### 🛠️ Checklist de Atividades e Evidências
- [ ] **Auditoria de Acessibilidade (WCAG 2.2 Nível AA):** Validar contraste mínimo (4.5:1), foco navegável por teclado, rótulos ARIA e independência de cor no mapa de assentos.
- [ ] **Teste de Usabilidade com Usuários:** Conduzir ensaios de jornada com 5 participantes simulando a compra de ingressos e cantina, alcançando taxa de conclusão sem assistência >= 80% (CA-N04).
- [ ] **Ensaio de Restauração de Backup (RST-02 / CA-N05):** Simular falha de banco de dados, executar restauração a partir do dump/WAL do PostgreSQL e comprovar consistência transacional e cumprimento das metas de RPO e RTO.
- [ ] **Geração da Candidata v1.0.0-rc.1:** Gerar tag de versão candidata e documentar matriz de rastreabilidade completa vinculando requisitos às suítes de teste.

### 🏁 Critério de Aceite e Saída (Definition of Done)
- Relatório de testes de usabilidade arquivado e versão `v1.0.0-rc.1` homologada para implantação piloto.
'@
  },

  # =========================================================================
  # MAR-06: Transição, Implantação e Encerramento (Piloto v1.0.0) [#6]
  # =========================================================================
  @{
    Title           = "[MAR-06][OPERACAO] RST-01..04: Smoke Test Integrado Ponta a Ponta, Trava de Sandbox e Rotina de Fechamento de Turno"
    MilestoneNumber = 6
    Labels          = @("fase:transicao-operacao", "fase:integracao", "role:RT", "role:RQ", "risco:alto")
    KanbanStatus    = "Ready"
    Body            = @'
### 📋 Contexto do Requisito
- **Restrições Arquiteturais:** RST-01 (Unidade Piloto Única), RST-02 (API Centralizada Única), RST-03 (Homologação Sandbox Obrigatória) e RST-04 (Entrega Condicionada na Portaria)
- **Critérios de Aceitação:** AC-1 e AC-2 (OpenSpec Transição)
- **OpenSpec Spec:** openspec/changes/mar-06-transicao-operacao/specs/operations/transicao-piloto/spec.md
- **Papéis RACI:** Execução RT | Verificação de Operação RQ | Aceite RP

### 🎯 Acceptance Criteria (Spec-Anchored)
- **AC-1.** Jornada integrada ponta a ponta (smoke test) executa compra, acesso por QR, pedido na cantina e avaliação com estado consistente.
  @test:tests/operations/smoke-piloto.test.ts
- **AC-2.** Ambiente sem homologação comercial ativa mantém bloqueio de cobrança real operando estritamente em sandbox (`RST-03`).
  @test:tests/operations/smoke-piloto.test.ts

### 🛠️ Cenários Obrigatórios e Tarefas
- [ ] **Cenário 1 (Smoke test integrado pós-deploy):** Executar suíte ponta a ponta em ambiente limpo:
  1. Criação de sessão e carga de poltronas;
  2. Cadastro e login de cliente;
  3. Reserva de assento e checkout Pix sandbox;
  4. Emissão de ingresso com QR Code;
  5. Leitura e consumo atômico na portaria;
  6. Compra na cantina, transição de preparo KDS e entrega no assento;
  7. Conclusão da sessão e submissão de avaliação de 5 estrelas.
- [ ] **Cenário 2 (Trava de segurança de Sandbox - RST-03):** Garantir que na ausência de homologação formal e credenciais de produção comerciais, qualquer chamada a endpoints de pagamento opere exclusivamente em modo simulado seguro sem cobrar usuários reais.
- [ ] **Cenário 3 (Rotina de fechamento de turno e reconciliação):** Script operacional de conciliação de final de dia comparando ingressos emitidos, transações liquidadas, cancelamentos e estornos.
- [ ] Implementar suíte em `tests/operations/smoke-piloto.test.ts`.

### 🏁 Critério de Aceite e Saída (Definition of Done)
- Smoke test automatizado 100% verde e prontidão operacional validada.
'@
  },
  @{
    Title           = "[MAR-06][RELEASE] Homologação em Unidade Piloto, Ensaio de Rollback, Checklist de Transição e Aceite Final v1.0.0"
    MilestoneNumber = 6
    Labels          = @("fase:transicao-operacao", "role:RP", "role:RT", "role:RQ", "risco:moderado")
    KanbanStatus    = "Ready"
    Body            = @'
### 📋 Contexto e Fundamentação (ISO/IEC/IEEE 12207 — Seções 5.4.4, 5.5 e 6.4.13)
- **Escopo:** Encerramento do ciclo de desenvolvimento do MVP CineFood e liberação da release oficial `v1.0.0`.
- **OpenSpec Change:** openspec/changes/mar-06-transicao-operacao/
- **Papéis RACI:** Aprovação e Aceite RP | Liderança Técnica RT | Verificação e Auditoria RQ

### 🎯 Objetivo de Encerramento e Transição
Executar os procedimentos finais de transição da plataforma CineFood, validar o plano de contingência e reversão (rollback) sem corrupção de estado, publicar o checklist de abertura da unidade piloto e lavrar o Termo de Aceite Final da versão `v1.0.0`.

### 🛠️ Checklist de Entregáveis de Transição e Aceite
- [ ] **Checklist de Prontidão Operacional:** Documento de rotinas operacionais pré-sessão para equipe de portaria, bilheteria, cozinha e runners (`docs/operacao/`).
- [ ] **Ensaio de Contingência e Rollback:** Procedimento validado de reversão de versão de aplicação preservando os dados transacionais registrados no PostgreSQL.
- [ ] **Matriz de Rastreabilidade 100% Amarrada:** Comprovação documental de que todos os 18 Requisitos Funcionais, 6 RNFs, 4 Restrições e 5 ADRs possuem suítes de testes automatizados e critérios de aceite satisfeitos.
- [ ] **Publicação da Release Oficial v1.0.0:** Tag git oficial `v1.0.0`, notas de versão (*Release Notes*) detalhadas e termo formal de encerramento do MVP assinado pelas lideranças do projeto.

### 🏁 Critério de Aceite e Saída (Definition of Done)
- Termo de encerramento aprovado e release `v1.0.0` publicada no GitHub.
'@
  }
)

$createdCount = 0
$total = $issues.Count

foreach ($item in $issues) {
  $createdCount++
  Write-Output "[$createdCount/$total] Criando: $($item.Title)..."
  $res = New-CineFoodIssue -Title $item.Title -MilestoneNumber $item.MilestoneNumber -Labels $item.Labels -Body $item.Body -KanbanStatus $item.KanbanStatus
  Start-Sleep -Milliseconds 800
}

Write-Output "=== Concluído: $createdCount/$total issues processadas com sucesso! ==="
