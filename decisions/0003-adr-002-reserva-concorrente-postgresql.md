# ADR-002: Reserva de Assentos com PostgreSQL como Autoridade Central e Trava Temporária de 10 Minutos

* **Data:** 2026-10-29
* **Status:** Aceito
* **Decisores:** RT (Responsável Técnico), RP (Responsável pelo Produto)
* **Cadeia do Contrato:** Transversal (Referência: Seção 4.4 do Manual de Processos v2.0)
* **Requisitos Relacionados:** RF-03 (Reserva de Assentos), RNF-03 (Integridade Transacional), CMP-02

---

## 1. Contexto e Declaração do Problema
Em cinemas com venda concorrente em múltiplos canais (app móvel, web e bilheteria física assistida), assentos concorridos podem ser selecionados simultaneamente por diferentes usuários.
É inadmissível permitir a venda duplicada da mesma poltrona (*overbooking*), o que geraria conflito físico entre clientes na sala e violação do Código de Defesa do Consumidor. Além disso, assentos selecionados não podem ficar bloqueados indefinidamente caso o cliente desista ou feche o aplicativo.

---

## 2. Opções Consideradas
1. **Controle em Memória / Cache Distribuído (ex.: Redis com TTL):**
   * *Prós:* Resposta rápida em milissegundos.
   * *Contras:* Risco de inconsistência entre cache e banco relacional se ocorrer queda da instância; complexidade de manter dois sistemas sincronizados sob carga e falha de rede.
2. **Controle no Frontend / Telas:**
   * *Contras:* Totalmente vulnerável a concorrência e manipulação maliciosa. Rejeitado sumariamente.
3. **PostgreSQL como Autoridade Central com Bloqueio Transacional (Escolhida):**
   * *Prós:* Isolamento transacional nativo (`SELECT FOR UPDATE` ou atualização condicional atômica `UPDATE assento SET estado = 'RESERVADO', reservado_ate = NOW() + INTERVAL '10 min' WHERE id = :id AND estado = 'DISPONIVEL'`).
   * *Garantia:* Zero probabilidade de venda duplicada, mesmo com requisições concorrentes disparadas no mesmo milissegundo.

---

## 3. Decisão Tomada
O **PostgreSQL é a autoridade central e exclusiva** para o estado das poltronas de cada sessão:
1. Ao selecionar poltronas para checkout, a API executa uma transação atômica que marca o assento como `RESERVADO` com expiração de **10 minutos** (`reservado_ate = NOW() + INTERVAL '10 min'`).
2. Se o pagamento não for confirmado dentro desse intervalo, o assento é considerado expirado e pode ser imediatamente reservado por outro cliente.
3. Confirmações tardias de pagamento recebidas após a expiração não sobrescrevem uma nova reserva legítima de outro usuário; o sistema detecta o conflito e aciona o fluxo de compensação/estorno financeiro.

---

## 4. Consequências
### Positivas:
* Cumprimento absoluto do critério `CA-N03` (Zero venda duplicada de assentos).
* Concorrência resolvida com ACID nativo do banco relacional sem dependências extras.

### Negativas / Riscos Mitigados:
* *Custo computacional:* Consultas de disponibilidade precisam considerar `estado = 'DISPONIVEL' OR (estado = 'RESERVADO' AND reservado_ate < NOW())`.
* *Mitigação:* Índices parciais e compostos no PostgreSQL cobrindo `(sessao_id, estado, reservado_ate)`.
