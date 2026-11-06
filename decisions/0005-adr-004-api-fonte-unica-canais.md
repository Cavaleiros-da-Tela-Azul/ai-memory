# ADR-004: API Centralizada como Fonte Única da Verdade para Todos os Canais (Web, Mobile e Venda Assistida)

* **Data:** 2026-10-29
* **Status:** Aceito
* **Decisores:** RT (Responsável Técnico), RP (Responsável pelo Produto)
* **Cadeia do Contrato:** Transversal (Referência: Seção 4.4 do Manual de Processos v2.0)
* **Requisitos Relacionados:** RF-02 (Catálogo), RF-03 (Reserva), RF-08 (Estoque), RF-14 (Venda Assistida), RST-02 (Fonte Única)

---

## 1. Contexto e Declaração do Problema
Tradicionalmente, cinemas operam com silos tecnológicos: o sistema de bilheteria física (PDV local do caixa) funciona separado do aplicativo web/móvel de autoatendimento, sincronizando dados por lote ou bancos duplicados.
Essa fragmentação causa frequentes conflitos de assentos vendidos na bilheteria física ao mesmo tempo em que eram comprados no app, além de descompasso de estoque da bomboniere.

---

## 2. Opções Consideradas
1. **Bancos Separados com Sincronização Periódica:**
   * *Contras:* Janelas de inconsistência inevitáveis; alta chance de colisão de poltronas vendidas simultaneamente.
2. **PDV Offline com Sincronização Posterior:**
   * *Contras:* Inviável para assentos marcados numerados; o risco de overbooking é imediato.
3. **API Única Online como Autoridade Central (Escolhida):**
   * Todos os canais de interação (Web responsivo, App Android do cliente, Totem de autoatendimento, Terminal de Venda Assistida do operador da bilheteria e App do Runner/Portaria) consomem a mesmíssima API HTTP/REST e o mesmo banco PostgreSQL.

---

## 3. Decisão Tomada
1. **Fonte Única:** A API do monólito modular é a autoridade central indiscutível para o inventário de poltronas de cinema e estoque de produtos.
2. **Venda Assistida sem Privilégio de Estado (`RF-14`):** Quando o operador da bilheteria física atende um cliente no guichê, ele utiliza uma interface conectada à mesma API. O bloqueio temporário do assento segue exatamente o mesmo endpoint e as mesmas regras de concorrência do aplicativo móvel.
3. **Premissa de Conectividade (`RST-02`):** As transações de compra e reserva exigem conectividade ativa com a API. Venda sem conexão está explicitamente fora do escopo do MVP.

---

## 4. Consequências
### Positivas:
* Elimina 100% dos conflitos de dados entre os guichês físicos e os aplicativos digitais.
* Redução drástica de complexidade: uma única base de código de backend para manter e testar.
* Auditoria unificada: toda venda registra o canal de origem e o identificador do operador ou cliente.

### Negativas / Riscos Mitigados:
* *Dependência de conectividade:* Se a internet da unidade cair, a venda digital e assistida ficam bloqueadas.
* *Mitigação:* Aceito para o MVP da unidade piloto; sugestão futura de cache de leitura/validação para portaria em caso de contingência.
