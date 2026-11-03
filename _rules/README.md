# Regras e Restrições (`_rules/`)

Nesta pasta ficam as **regras mandatórias** que os agentes de IA devem obedecer a qualquer custo durante a geração de código e tomada de decisão.

Na arquitetura do `ai-memory`, esta pasta possui o maior nível de prioridade (**Authority-Aware Recall**). O que for definido aqui se sobrepõe a conversas passadas e sugestões automáticas.

---

## 📌 Convenções
1. Crie arquivos temáticos (ex.: `seguranca.md`, `padroes-codigo.md`, `banco-de-dados.md`).
2. Utilize comandos afirmativos e claros (ex.: *"Nunca use credenciais expostas no código"*, *"Todo endpoint deve conter validação Zod"*).
3. Revise periodicamente para evitar regras conflitantes.
