# AI Memory - Cavaleiros da Tela Azul 🧠

Repositório central de **memória de longo prazo para agentes de IA** e documentação viva da organização **Cavaleiros da Tela Azul**, baseado na arquitetura do [akitaonrails/ai-memory](https://github.com/akitaonrails/ai-memory).

---

## 🏛️ Estrutura da Wiki

A base de conhecimento segue o padrão de **LLM Wiki versionada em Git**, sendo 100% legível por humanos e compatível com **Obsidian**:

```text
├── index.md                  # Mapa de Conteúdo (MOC) e índice central
├── log.md                    # Histórico cronológico de sessões e consolidações
├── _rules/                   # Regras e restrições obrigatórias (Authority Máxima)
│   ├── README.md
│   └── diretrizes-gerais.md
├── decisions/                # Registros de Decisões de Arquitetura (ADRs)
│   ├── README.md
│   └── adr-template.md
├── concepts/                 # Conceitos de domínio, entidades e arquitetura
│   └── README.md
├── procedures/               # Procedimentos, playbooks e guias passo a passo
│   └── README.md
├── gotchas/                  # Armadilhas, bugs conhecidos e lições aprendidas
│   └── README.md
├── _global/                  # Configurações e regras compartilhadas entre projetos
│   └── _rules/
│       └── README.md
└── projects/                 # Espaço para wikis dedicadas de projetos da organização
    └── README.md
```

---

## 🚀 Como Utilizar

### 1. No Obsidian (Visualização e Curadoria Humana)
1. Clone este repositório na sua máquina:
   ```bash
   git clone https://github.com/Cavaleiros-da-Tela-Azul/ai-memory.git
   ```
2. Abra o **Obsidian** e selecione **"Open folder as vault"**, escolhendo a pasta clonada.
3. Utilize os links internos no formato `[[caminho/arquivo|Texto]]` para navegar e enriquecer o grafo de conhecimento.
4. (Recomendado) Instale o plugin **Obsidian Git** para sincronização automática via `git pull` e `git push`.

### 2. Com Agentes de IA (`ai-memory` & MCP)
* **Reindexação Local:** Após puxar atualizações do Git, atualize o índice SQLite FTS5 executando:
  ```bash
  ai-memory reindex
  ```
* **Orquestração de Sessões:** Inicie seus agentes com o orquestrador para compartilhar contexto de sessão:
  ```bash
  ai-memory run claude
  # ou
  ai-memory run codex
  ```
* **IDE (Antigravity / Cursor):** Conecte o `ai-memory` via servidor **MCP** (`ai-memory install-mcp`) para que o chat da IDE consulte automaticamente as regras e decisões documentadas aqui.

---

## 🛡️ Níveis de Autoridade (Authority-Aware Recall)
O algoritmo do `ai-memory` prioriza o conhecimento nesta ordem de autoridade:
1. `_rules/` & `_global/_rules/` (Mandatórias — agentes devem obedecer rigorosamente)
2. `decisions/` (Decisões arquiteturais acordadas)
3. `procedures/` (Padrões de execução estabelecidos)
4. `concepts/` & `gotchas/` (Conhecimento contextual e prevenção de falhas)
5. `log.md` & sessões passadas (Contexto episódico)
