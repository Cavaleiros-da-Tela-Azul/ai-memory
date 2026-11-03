# PROD-001: CineFood — Sistema de Autoatendimento e Delivery para Cinemas

* **ID:** PROD-001
* **Workspace:** cavaleiros-da-tela-azul
* **Repositório de Código:** `Cavaleiros-da-Tela-Azul/cinefood`
* **Status:** Ativo
* **Cadeia do Contrato:** 02 PRODUCT (Filho de CONST-001)

---

## 1. Visão do Produto
O **CineFood** é uma plataforma moderna e integrada projetada para cinemas, permitindo que clientes peçam lanches, pipocas e bebidas diretamente pelo aplicativo ou terminais de autoatendimento (totens), recebendo o pedido em seus assentos na sala de cinema ou retirando no balcão sem enfrentar filas.

---

## 2. Personas e Atores
* **Cliente de Cinema:** Quer comprar ingressos e adicionar combos de alimentação de forma rápida, com opção de entrega no assento durante o pré-filme.
* **Atendente / Cozinha da Bomboniere:** Recebe comandas digitais com identificação de Sala, Fila e Assento, controlando o tempo de preparo.
* **Administrador do Cinema:** Gerencia catálogo de itens, combos promocionais, combos vinculados a lançamentos de filmes e relatórios de vendas.

---

## 3. Limites e Fronteiras do Sistema
* **No Escopo:**
  * Catálogo de produtos, combos e adicionais.
  * Seleção de entrega: "Retirada no Balcão" ou "Entrega na Sala/Assento".
  * Integração de pagamentos com chave de idempotência (prevenção contra cobrança duplicada).
  * Painel operacional em tempo real da cozinha/bomboniere.
* **Fora de Escopo (Out of Scope):**
  * Transmissão e exibição física do filme.
  * Sistema de hardware de projeção e som de cinema.

---

## 4. Features Previstas (Cadeia de Features)
* `F-CARDAPIO-V1`: Listagem de produtos, categorias e combos com disponibilidade em tempo real.
* `F-PEDIDO-V1`: Fluxo de montagem do carrinho, vinculação com sala/assento e checkout.
* `F-COZINHA-V1`: Painel KDS (Kitchen Display System) para visualização e atualização de status do pedido.
