# ADR-001: Arquitetura em Monólito Modular

* **Data:** 2026-10-29
* **Status:** Aceito
* **Decisores:** RT (Responsável Técnico), RP (Responsável pelo Produto)
* **Cadeia do Contrato:** Transversal (Referência: Seção 4.4 do Manual de Processos v2.0)
* **Requisitos Relacionados:** RNF-06 (Manutenibilidade), RNF-01 (Desempenho), CMP-01 a CMP-06

---

## 1. Contexto e Declaração do Problema
O CineFood é uma plataforma projetada para operar em uma unidade piloto de cinema com cantina própria integrada. O sistema precisa gerenciar identidade, catálogo, reserva de assentos, pagamentos, emissão/validação de ingressos por QR Code e pedidos na cantina. 
A equipe é enxuta (4 desenvolvedores com dedicação semanal limitada) e o prazo de lançamento é restrito. Era necessário definir um padrão arquitetural que equilibrasse facilidade operacional, simplicidade de testes e separação clara de responsabilidades, evitando a complexidade distribuída precoce.

---

## 2. Opções Consideradas
Conforme avaliação multicritério da Seção 4.4.1 do manual (pesos: Operação 35%, Integração 30%, Aprendizado 20%, Escala Independente 15%):

1. **Monólito Modular (Nota: 4,35 - Escolhida):**
   * *Operação (5/5):* Deploy único, banco único, sem necessidade de service mesh ou observabilidade distribuída.
   * *Integração (5/5):* Chamadas internas tipadas entre módulos em TypeScript em memória, sem latência de rede entre serviços.
   * *Aprendizado (4/5):* Rápida capacitação da equipe sem necessidade de gerenciar múltiplos pipelines.
   * *Escala Independente (2/5):* Escalonamento vertical ou horizontal conjunto da aplicação.
2. **Microsserviços Distribuídos (Nota: 2,45):**
   * *Prós:* Escalonamento granular por domínio.
   * *Contras:* Complexidade operacional excessiva para 1 unidade piloto, consistência eventual complexa para reserva de assentos e estoque, alto custo de infraestrutura.
3. **Funções em Nuvem Serverless por Módulo (Nota: 2,95):**
   * *Prós:* Custo sob demanda.
   * *Contras:* Cold starts imprevisíveis (risco para RNF-01 p95 ≤ 2s na portaria), orquestração de transações distribuídas (Sagas) para reservas e checkouts.

---

## 3. Decisão Tomada
Adota-se a arquitetura de **Monólito Modular** em Node.js/TypeScript com PostgreSQL. A aplicação é organizada internamente em 6 módulos lógicos coesos com interfaces bem definidas:
* **CMP-01:** Identidade e Acesso
* **CMP-02:** Catálogo e Reserva de Assentos
* **CMP-03:** Pagamentos e Integração com Gateway
* **CMP-04:** Ingressos e Acesso (Portaria)
* **CMP-05:** Cantina e Alimentação (Cozinha e Runner)
* **CMP-06:** Histórico, Avaliações e Auditoria

Módulos não acessam tabelas de outros módulos diretamente; o tráfego ocorre via contratos e serviços explícitos no próprio monólito.

---

## 4. Consequências
### Positivas:
* Processo de CI/CD único, simplificando testes ponta a ponta e unitários.
* Garantia de integridade referencial e transacional ACID diretamente no PostgreSQL.
* Zero latência de rede nas comunicações internas entre módulos de negócio.

### Negativas / Riscos Mitigados:
* *Risco:* Acoplamento acidental de código entre módulos.
* *Mitigação:* Estrutura de diretórios estrita em `src/modules/<modulo>`, contratos de interfaces explícitos e lint proibindo importações cruzadas não autorizadas.
