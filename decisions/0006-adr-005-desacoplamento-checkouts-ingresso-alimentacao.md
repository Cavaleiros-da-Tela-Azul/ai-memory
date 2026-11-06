# ADR-005: Desacoplamento dos Checkouts e Pagamentos de Ingressos e Cantina

* **Data:** 2026-10-29
* **Status:** Aceito
* **Decisores:** RT (Responsável Técnico), RP (Responsável pelo Produto)
* **Cadeia do Contrato:** Transversal (Referência: Seção 4.4 do Manual de Processos v2.0)
* **Requisitos Relacionados:** RF-04 (Pagamento Ingressos), RF-08 (Pedido Alimentos), RF-12 (Cancelamento e Estorno), CMP-03, CMP-04, CMP-05

---

## 1. Contexto e Declaração do Problema
O CineFood integra a jornada de compra de ingressos para sessões de cinema com a venda de alimentos da cantina (pipocas, bebidas, combos).
Surgiu o dilema de design: devemos processar a compra de ingressos e produtos da cantina em um único pagamento agrupado (*carrinho único*) ou em pagamentos independentes (*checkouts desacoplados*)?

---

## 2. Opções Consideradas
1. **Carrinho Único com Pagamento Agrupado:**
   * *Prós:* Menos etapas de pagamento no fluxo inicial para o cliente que compra ambos juntos.
   * *Contras:* 
     * Complexidade extrema em caso de falha parcial ou cancelamento: se o cliente quiser cancelar o refrigerante que não foi entregue, mas manter o ingresso de cinema da sessão que já vai começar, o estorno financeiro agrupado exige compensação contábil fracionada no gateway.
     * Se o estoque de um combo esgotar no momento do pagamento, a compra do ingresso de cinema também falharia ou ficaria bloqueada.
     * Impede que o cliente compre alimentos durante ou após entrar na sala de forma fluida sem alterar o pedido de ingresso original.
2. **Checkouts e Transações Independentes (Escolhida):**
   * A compra de ingressos tem seu próprio fluxo de reserva de assento e transação de pagamento.
   * O pedido de alimentação tem seu próprio carrinho, reserva de estoque e transação de pagamento.
   * Se o cliente optar por "Entrega no Assento", o pedido de alimentação apenas referencia o identificador do ingresso já emitido e pago.

---

## 3. Decisão Tomada
Adota-se o **desacoplamento estrito entre os checkouts de ingresso e de alimentação**:
1. O ingresso é liquidado de forma independente. Uma vez pago, o QR Code é emitido e o assento é garantido.
2. O pedido de cantina é uma transação financeira separada. Uma falha de estoque na cozinha ou na cobrança do combo de pipoca jamais invalida ou bloqueia o ingresso de cinema já adquirido.
3. No caso de entrega na poltrona (`RF-09`), o cliente seleciona a opção informando/vinculando seu ingresso ativo da sessão; a comanda da cantina armazena `ingresso_vinculado_id` para orientar a entrega pelo runner.
4. O estorno de alimentos segue ciclo próprio e não cancela o ingresso de exibição do filme, e vice-versa.

---

## 4. Consequências
### Positivas:
* Alta resiliência de negócio: problemas na cantina não impactam a bilheteria.
* Arquitetura de microsserviços/módulos desacoplada: `CMP-04` e `CMP-05` interagem apenas por referências fracas e regras de domínio.
* Clareza contábil e de estorno conforme o CDC (cancelamento de produto perecível em preparo vs cancelamento de ingresso pré-sessão).

### Negativas / Riscos Mitigados:
* *Dois pagamentos caso o cliente compre ambos:* O cliente que compra ingresso e combo no mesmo acesso precisará autorizar duas cobranças distintas.
* *Mitigação:* Interfaces com navegação fluida ("Ingresso garantido! Deseja pedir sua pipoca para retirar no balcão ou receber no assento?") e suporte a Pix rápido/salvar cartão no gateway para diminuir o atrito.
