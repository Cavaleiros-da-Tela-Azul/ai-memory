# CONST-001: Constituição da Organização Cavaleiros da Tela Azul

* **Versão:** 1.0.0
* **Status:** Aprovada e Obrigatória
* **Escopo:** Universal (Todos os repositórios e projetos da organização)
* **Origem:** Princípios de Spec-Driven Development (SDD) e ai-4sdlc-platform (CEIA/UFG)

---

## 1. O Princípio Fundamental: A Spec é a Fonte da Verdade
1. **Spec é a fonte; código é apenas um artefato derivado.** 
   O comportamento do sistema começa e é documentado na especificação antes de ser gerado em código.
2. **Spec Anchored:** Se o código diz uma coisa e a especificação diz outra, **o código está errado**.
3. **Instrução não é controle; controle é o que barra o merge:** Regras em arquivos de agentes são pedidos; barreiras mecânicas de pré-commit e CI que impedem o avanço do código são controle.

---

## 2. A Cadeia do Contrato (Rastreabilidade Total)
Toda mudança no software deve ser rastreável ao longo da cadeia:

```text
[01 CONSTITUTION] ──► [02 PRODUCT] ──► [03 FEATURE SPEC] ──► [04 COMPONENT] ──► [05 TASKS] ──► [06 TESTS]
       │                                       ▲
       └─────────────────► [ADRs] ─────────────┘ (Transversais: citadas em related_adrs)
```

1. **`01 CONSTITUTION`:** Princípios invioláveis que valem para a organização inteira (este documento).
2. **`02 PRODUCT`:** Visão, público-alvo, fronteiras e escopo geral do produto (ex.: `PROD-001-cinefood`).
3. **`03 FEATURE SPEC`:** Capacidade funcional visível ao usuário, estruturada com Acceptance Criteria (ACs).
4. **`04 COMPONENT`:** Contratos de módulos técnicos, schemas e bibliotecas com ciclo próprio.
5. **`05 TASKS`:** Passos atômicos de implementação que citam explicitamente a AC que atendem (`T-01 -> atende AC-1`).
6. **`06 TESTS`:** Arquivos de testes automatizados fisicamente ancorados à AC correspondente.
7. **`ADRs (Transversais)`:** Decisões de arquitetura (mudança de dependência, estado persistente ou contrato) registradas na pasta `decisions/` e citadas no frontmatter (`related_adrs: [ADR-XXX]`).

---

## 3. A Regra do `@test:<caminho>`
* **AC sem teste ancorado é intenção, não contrato.**
* Toda Acceptance Criteria deve ser observável (entrada e saída claras), evitar adjetivos vagos e conter na linha imediatamente inferior a anotação:
  ```markdown
  - **AC-1.** Ao selecionar um combo, o carrinho exibe o resumo com valor e assento vinculado.
    @test:tests/pedidos/carrinho.test.ts
  ```
* O verificador mecânico do repositório recusa qualquer AC sem `@test:` ou apontando para teste inexistente.

---

## 4. Invariante do Incidente: "Bug vira mudança de spec, NÃO hotfix"
Quando um erro for relatado ou descoberto:
1. **Identifique a AC:** O erro viola uma AC existente ou a AC estava incompleta?
2. **Atualize a Spec Primeiro:** Crie ou ajuste a AC na especificação (`versão 1.0.0 -> 1.1.0`).
3. **Escreva o Teste que Falha:** O teste ancorado à nova AC deve falhar no código atual.
4. **Corrija o Código:** Faça a implementação mínima para o teste passar.
5. **Nenhum hotfix é aplicado diretamente no código sem o ciclo acima.**

---

## 5. As Três Dívidas: Tolerância Zero ao Vibe Coding
* **Dívida Técnica:** Evitada com barreiras automáticas de lint, testes e spec-drift.
* **Dívida Cognitiva:** Toda alteração de spec deve ser clara o suficiente para que qualquer desenvolvedor humano entenda e possa discordar.
* **Dívida de Intenção:** O motivo de cada escolha técnica deve ser preservado nos ADRs do `ai-memory`, garantindo que ninguém desfaça uma regra de segurança futura por esquecimento.
