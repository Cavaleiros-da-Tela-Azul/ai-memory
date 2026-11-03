# CONST-001: Constituição Global da Organização Cavaleiros da Tela Azul

* **Versão:** 1.0.0
* **Status:** Aprovada e Obrigatória
* **Escopo:** Herdado globalmente por todos os agentes em todos os workspaces

Consulte a íntegra em [[_rules/CONST-001-constitution|CONST-001-constitution.md]].

---

### Resumo Executivo para Agentes de IA:
1. **Spec-Anchored:** A especificação em `openspec/` é a autoridade máxima. Se o código divergir da spec, o código está incorreto.
2. **Cadeia do Contrato:** `Constitution` ➔ `Product` ➔ `Feature Spec` ➔ `Component` ➔ `Tasks` ➔ `Tests` (com `ADRs` vinculadas via `related_adrs`).
3. **Regra `@test:`:** Toda Acceptance Criteria (AC) exige teste físico correspondente indicado por `@test:<caminho>`.
4. **Bug vira Spec:** Nenhum bug é corrigido com patch cego; a AC é corrigida primeiro, o teste falha, e o código é ajustado depois.
