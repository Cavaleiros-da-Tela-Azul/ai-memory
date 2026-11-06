# PROD-001: CineFood — Plataforma de Cinema e Cantina Integrada (MVP)

* **ID:** PROD-001
* **Workspace:** cavaleiros-da-tela-azul
* **Repositório de Código:** `Cavaleiros-da-Tela-Azul/cinefood`
* **Status:** Aprovado / Linha de Base
* **Cadeia do Contrato:** 02 PRODUCT (Filho de CONST-001)
* **Referencial de Processo:** ABNT NBR ISO/IEC/IEEE 12207:2021 (Manual de Processos v2.0)
* **ADRs Relacionadas:** [ADR-001], [ADR-002], [ADR-003], [ADR-004], [ADR-005]

---

## 1. Visão do Produto e Problema Atendido
O **CineFood** é uma plataforma desenvolvida para uma unidade piloto de cinema e sua cantina própria integrada.
Historicamente, o público enfrenta filas e sistemas fragmentados: compra de ingressos na bilheteria física ou app terceiro e compra de pipocas em filas separadas na bomboniere.
O CineFood unifica a experiência em uma **jornada digital integrada**:
1. **Antes da sessão:** O usuário consulta a programação, seleciona assentos numerados em mapa interativo, adquire ingressos (inteira/meia) e pode adiantar o pedido de alimentos.
2. **No cinema:** Apresenta um QR Code opaco na portaria para validação atômica de uso único. Se solicitou entrega no assento, o pedido é preparado pela cozinha e entregue diretamente em sua poltrona pelo *runner* antes do início do filme (condicionado à validação física de sua entrada).
3. **Depois da exibição:** O cliente avalia a sessão (1 a 5 estrelas) em seu histórico privado e gerencia suas preferências de privacidade e direitos LGPD.

---

## 2. Atores e Personas do Sistema
* **ST-01 / Usuário Final (Cliente):** Acessa via Web Responsiva ou App Android para comprar ingressos, reservar assentos, pedir alimentos, acompanhar status em tempo real e registrar avaliações.
* **ST-02 / Operador de Portaria (Controle de Acesso):** Utiliza terminal ou dispositivo com câmera para validar e consumir atomicamente o QR Code do ingresso.
* **ST-02 / Operador de Bilheteria (Venda Assistida):** Realiza a venda presencial de ingressos no guichê utilizando a mesma API e trava concorrente de assentos.
* **ST-03 / Atendente de Cantina / Cozinha (KDS):** Controla a fila de comandas digitais, preparando pedidos e despachando para retirada no balcão ou entrega na sala.
* **ST-03 / Runner (Entregador de Sala):** Localiza a sala, fileira e assento do cliente na sala escura para realizar a entrega física do pedido antes da exibição.
* **ST-04 / Administrador do Cinema:** Gerencia filmes, salas, sessões, preços, estoque, categorias de meia-entrada e consulta taxas de ocupação e vendas.
* **ST-05 / Equipe Técnica & Suporte:** Responsável pela integridade, observabilidade, rotinas de backup/recuperação e manutenção preventiva/corretiva.
* **ST-06 / Gateway de Pagamento:** Processador externo de Pix e Cartão via sandbox/produção com suporte a idempotência e webhooks autenticados.

---

## 3. Limites de Escopo e Fronteiras

### No Escopo (MVP):
* Autenticação e perfis com controle de acesso baseado em papéis (RBAC).
* Gestão de programação, catálogo de filmes, salas e sessões com mapa de assentos.
* Reserva atômica de assentos com trava temporária de 10 minutos (ADR-002).
* Checkout e pagamentos com idempotência e conciliação (ADR-003).
* Emissão de ingresso digital com QR Code opaco e consumo único na portaria.
* Venda assistida na bilheteria conectada à mesma API central (ADR-004).
* Cardápio da bomboniere, reserva atômica de estoque e painel operacional KDS.
* Entrega no assento estritamente condicionada a ingresso pago e entrada validada na portaria (ADR-005 / RST-04).
* Histórico privado de pedidos e ingressos.
* Avaliação pós-sessão de 1 a 5 estrelas restrita a ingressos validados após o término do filme.
* Cancelamento e estorno financeiro em conformidade com o Código de Defesa do Consumidor (CDC art. 49).
* Política de transparência, termo de consentimento e atendimento aos direitos do titular (LGPD).

### Fora de Escopo do MVP:
* Aplicativo nativo iOS.
* Parcerias com restaurantes/estabelecimentos externos e divisão de repasses.
* Integração legada com PDV de terceiros.
* Pagamento em dinheiro físico na venda assistida (transações restritas ao gateway).
* Notificações push via serviços externos (Push Notifications).
* Programa de fidelidade, gamificação e colecionáveis.
* Transmissão ou streaming de vídeo.
* Operação e compras em modo offline sem conexão (RST-02).

---

## 4. Arquitetura Modular (Componentes CMP-01 a CMP-06)
Em conformidade com a ADR-001 (Monólito Modular):

* **CMP-01 (Identidade e Acesso):** Contas de usuários, autenticação JWT/sessão, RBAC e gestão de consentimento/direitos do titular.
* **CMP-02 (Catálogo e Reserva):** Filmes, salas, sessões, horários, categorias de assentos e trava concorrente de 10 minutos.
* **CMP-03 (Pagamentos):** Adaptador do gateway de pagamento, emissão de Pix/Cartão, webhooks assinados, conciliação e estornos.
* **CMP-04 (Ingressos e Acesso):** Emissão de bilhete digital, geração de token opaco/QR Code, leitor de portaria e consumo atômico de ingresso.
* **CMP-05 (Cantina e Alimentação):** Catálogo de itens da bomboniere, combos, controle de estoque atômico, fila KDS da cozinha e controle de entrega/runner.
* **CMP-06 (Histórico, Auditoria e Gestão):** Histórico do cliente, avaliações pós-sessão, relatórios gerenciais de ocupação e logs de auditoria imutáveis.

---

## 5. Catálogo Oficial de Requisitos

### Requisitos Funcionais (RF-01 a RF-18):
* **RF-01 (Conta e Acesso):** Cadastrar, autenticar, recuperar senha e gerenciar perfil próprio com RBAC. `[CA-F01]` `[CMP-01]`
* **RF-02 (Programação):** Consultar filmes, sinopse, duração, classificação, sala, horários, preços e assentos livres/ocupados. `[CA-F02]` `[CMP-02]`
* **RF-03 (Reserva de Assentos):** Reservar poltronas com exclusividade concorrente e expiração de 10 min. `[CA-F03]` `[CMP-02]`
* **RF-04 (Pagamento):** Processar Pix/cartão no gateway com chave de idempotência e reconciliação de webhooks. `[CA-F04]` `[CMP-03]`
* **RF-05 (Emissão de Ingresso):** Emitir ingresso e QR Code opaco individual por assento após liquidação financeira. `[CA-F05]` `[CMP-04]`
* **RF-06 (Validação de Ingresso):** Operador de portaria consome o QR Code atomicamente, impedindo segundo uso. `[CA-F06]` `[CMP-04]`
* **RF-07 (Cardápio e Carrinho):** Exibir itens, adicionais, combos e recalcular valores estritamente no servidor. `[CA-F07]` `[CMP-05]`
* **RF-08 (Pedido e Estoque):** Reserva atômica de estoque no checkout e baixa definitiva pós-pagamento, prevenindo saldo negativo. `[CA-F08]` `[CMP-05]`
* **RF-09 (Atendimento da Cantina):** Controle de status (Pendente, Preparo, Pronto, Entregue). Entrega no assento exige ingresso pago e entrada física validada na portaria. `[CA-F09]` `[CMP-05]`
* **RF-10 (Administração):** Gestão de salas, sessões, preços, produtos da bomboniere e operadores autorizados. `[CA-F10]` `[CMP-01, CMP-02, CMP-05]`
* **RF-11 (Histórico e Avisos):** Consulta privada de compras, ingressos e pedidos com atualização de estados. `[CA-F11]` `[CMP-06]`
* **RF-12 (Cancelamento e Estorno):** Fluxo de cancelamento e arrependimento (art. 49 CDC) com estorno idempotente no gateway. `[CA-F12]` `[CMP-03, CMP-04, CMP-05]`
* **RF-13 (Avaliação Privada):** Avaliação de 1 a 5 estrelas liberada apenas após o término do filme para usuário com entrada validada. `[CA-F13]` `[CMP-06]`
* **RF-14 (Venda Assistida):** Operador físico vende ingressos utilizando a mesma API e trava concorrente do app. `[CA-F14]` `[CMP-02, CMP-03]`
* **RF-15 (Consultas Básicas):** Relatórios de vendas confirmadas, estornos e taxa de ocupação por sessão (`ocupação = ingressos ativos ÷ assentos totais × 100`). `[CA-F15]` `[CMP-06]`
* **RF-16 (Categorias de Ingresso):** Inteira, benefícios de meia-entrada e comprovação legal (Lei 12.933/2013). `[CA-F16]` `[CMP-02]`
* **RF-17 (Transparência e LGPD):** Termo de privacidade, finalidades do tratamento e gestão de consentimento opcional. `[CA-F17]` `[CMP-01, CMP-06]`
* **RF-18 (Direitos do Titular):** Protocolo de atendimento a solicitações de acesso, correção e eliminação com política de retenção. `[CA-F18]` `[CMP-01, CMP-06]`

### Requisitos Não Funcionais (RNF-01 a RNF-06):
* **RNF-01 (Desempenho):** p95 ≤ 2 segundos para operações internas e resposta imediata na validação de QR Code em homologação com 20 usuários concorrentes. `[CA-N01]`
* **RNF-02 (Segurança):** Tráfego HTTPS obrigatório, hashing seguro (Argon2/bcrypt), RBAC no backend e zero armazenamento de dados completos de cartão de crédito. `[CA-N02]`
* **RNF-03 (Integridade Transacional):** Zero duplicidade de venda de assento, zero reutilização de QR Code e prevenção contra estoque negativo. `[CA-N03]`
* **RNF-04 (Usabilidade e Acessibilidade):** Taxa de sucesso ≥ 80% em testes com 5 usuários nas jornadas principais; aderência aos critérios essenciais de WCAG 2.2 AA. `[CA-N04]`
* **RNF-05 (Recuperabilidade e Backup):** Rotinas diárias de backup no PostgreSQL, teste mensal de restauração e metas acordadas de RPO e RTO. `[CA-N05]`
* **RNF-06 (Manutenibilidade):** Cobertura de testes automatizados ≥ 70% nas regras de negócio da API e pipeline de CI que barra commits em desconformidade. `[CA-N06]`

### Restrições Inegociáveis (RST-01 a RST-04):
* **RST-01 (Unidade Piloto Única):** Escopo delimitado a uma unidade e cantina própria.
* **RST-02 (Conectividade e Fonte Única):** Compras e validações dependem de conexão com a API centralizada; todos os canais compartilham o mesmo estado.
* **RST-03 (Homologação e Sandbox):** Até a homologação oficial com contratante e adquirente, os pagamentos operam estritamente em sandbox e os dados são fictícios.
* **RST-04 (Entrega no Assento Vinculada):** A entrega na sala escura exige ingresso próprio, válido e entrada física previamente confirmada na portaria.

---

## 6. Mapeamento de Marcos de Desenvolvimento (MAR-01 a MAR-06)
1. **MAR-01 (S1–S6 / Fundamentos):** `RF-01`, `RF-02`, `RF-17` (`CMP-01`, `CMP-02`, `CMP-06`).
2. **MAR-02 (S7–S10 / Ingressos):** `RF-03`, `RF-04`, `RF-14`, `RF-16` (`CMP-02`, `CMP-03`, `CMP-04`).
3. **MAR-03 (S11–S13 / Acesso e Histórico):** `RF-05`, `RF-06`, `RF-11`, `RF-13` (`CMP-04`, `CMP-06`).
4. **MAR-04 (S14–S18 / Cantina e Gestão):** `RF-07`, `RF-08`, `RF-09`, `RF-10`, `RF-12`, `RF-15`, `RF-18` (`CMP-03`, `CMP-05`, `CMP-06`).
5. **MAR-05 (S19–S22 / Verificação Integrada):** Homologação dos RNFs (`RNF-01` a `RNF-06`) e suíte de regressão ponta a ponta (`v1.0.0-rc.1`).
6. **MAR-06 (S23–S24 / Transição e Piloto):** Implantação assistida na unidade piloto e encerramento com aceite operacional (`v1.0.0`).
