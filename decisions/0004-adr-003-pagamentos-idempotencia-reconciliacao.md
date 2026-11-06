# ADR-003: Integração de Pagamento com Adaptador Externo, Idempotência e Reconciliação Assíncrona

* **Data:** 2026-10-29
* **Status:** Aceito
* **Decisores:** RT (Responsável Técnico), RP (Responsável pelo Produto)
* **Cadeia do Contrato:** Transversal (Referência: Seção 4.4 do Manual de Processos v2.0)
* **Requisitos Relacionados:** RF-04 (Pagamento Externo), RF-12 (Cancelamento e Estorno), CMP-03

---

## 1. Contexto e Declaração do Problema
O processamento financeiro do CineFood é delegado a um gateway externo (Pix e Cartão de Crédito).
Problemas comuns de integração incluem:
* Usuário clicar múltiplas vezes no botão "Pagar" gerando cobranças duplicadas.
* Quedas de conexão ou timeouts na resposta HTTP síncrona do gateway.
* Webhooks de notificação de pagamento recebidos fora de ordem ou reenviados pelo gateway repetidas vezes.
* Confirmação baseada apenas na tela de sucesso do frontend, suscetível a fraudes.

---

## 2. Opções Consideradas
1. **Confirmação Síncrona Baseada no Redirecionamento da Interface:**
   * *Contras:* Extremamente inseguro; o cliente pode fechar a janela antes do retorno ou simular a requisição de sucesso.
2. **Arquitetura Baseada em Adaptador com Chave de Idempotência e Webhook Autenticado (Escolhida):**
   * Toda solicitação de pagamento gera uma chave única UUIDv4 (`idempotency_key`).
   * A chamada de cobrança ao gateway ocorre fora da transação do banco de dados para não segurar locks.
   * O gateway notifica a API via webhook assinado e autenticado por HMAC/Secret.
   * A API confere e registra o evento na mesma transação local que converte a reserva em ingresso ou confirma o pedido.

---

## 3. Decisão Tomada
1. **Padrão Adaptador (Gateway Adapter):** O módulo `CMP-03` expõe uma interface abstrata (`IPagamentoGateway`), desacoplando o core do sistema do provedor concreto (Asaas, Mercado Pago, Stripe, etc.) e permitindo uso de mock/sandbox robusto nos testes.
2. **Chaves de Idempotência Obrigatórias:** Nenhuma transação financeira é submetida sem `idempotency_key`. Repetições com a mesma chave retornam o status da transação original sem nova cobrança.
3. **Webhook como Autoridade de Confirmação:** O ingresso só transiciona para `EMITIDO` e o pedido para `CONFIRMADO` após a validação criptográfica do webhook do gateway ou consulta de conciliação.
4. **Tratamento de Timeouts:** Se a comunicação com o gateway sofrer timeout, a compra permanece `PENDENTE`. Um job de conciliação periódica consulta a API do gateway para resolver incertezas antes de cancelar ou liberar a reserva.
5. **Estorno Repetível:** O fluxo de estorno (`RF-12`) obedece à mesma regra de idempotência, garantindo que reiterações da requisição de cancelamento não realizem estornos em duplicidade.

---

## 4. Consequências
### Positivas:
* Cumprimento estrito do critério `CA-N03` (Zero cobrança duplicada e conciliação consistente).
* Segurança contra fraudes de manipulação de requisições de frontend.
* Facilidade de testes locais com simulação completa de eventos e falhas em sandbox.

### Negativas / Riscos Mitigados:
* *Complexidade de estados intermediários:* A interface precisa lidar com o estado "Aguardando confirmação de pagamento".
* *Mitigação:* Polling leve ou WebSockets/SSE no frontend para atualizar a UI assim que o webhook for processado.
