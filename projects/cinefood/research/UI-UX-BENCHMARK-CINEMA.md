# Benchmark Técnico de UI/UX e Design de Produto para Plataformas Cinematográficas (CineFood)

Documento consolidado a partir da análise de 70 fontes globais de exibição cinematográfica (Alamo Drafthouse, Everyman, AMC Theatres, Cinemark, Cinépolis, Letterboxd e Apple TV). 

---

## 1. Diretrizes Estratégicas e Arquitetura Visual

### 1.1 Identidade Visual Dark-First & Zero AI Slop
- **Fundo Base:** Rejeita preto puro fora de exibição para mitigar o halamento. Base neutra azulada `#0D0E12` (HSL: `225, 19%, 6%`).
- **Elevação por Luminância HSL:**
  - Canvas / Fundo Geral: `#0D0E12`
  - Superfície Nível 1 (Cards e Seções): `#16181F`
  - Superfície Nível 2 (Modais e Drawers): `#202430`
  - Superfície Nível 3 (Tooltips e Menus): `#2A3040`
  - Bordas e Divisores: `#2B303C`
- **Ações e Semântica:**
  - Ação Primária / Selecionado: `#00E054` (Verde de alto contraste, razão `9.8:1` contra fundo escuro).
  - Acessibilidade / PCD: `#2563EB` (Azul internacional de acessibilidade).
  - Marca / Destaques: `#E50914` (Vermelho institucional).
  - Alerta Crítico (Timer < 2m): `#EF4444`.
  - Anel de Foco (WCAG 1.4.11): `#60A5FA` (Anel visível em todos os controles).
- **Proporção Poster-First 2:3:** Cartazes estritamente na proporção 2:3 com keyline border para evitar sangramento visual.
- **Micro-interações:** Respostas entre 150ms e 250ms com curva `cubic-bezier(0.16, 1, 0.3, 1)`.

---

## 2. Padrões de Interação e Fluxo de Compra

### 2.1 Paradigma de Entrada Dupla
- Alternância imediata no topo da Home entre **"Por Filme"** e **"Por Cinema / Unidade"** sem recarregamento de página.

### 2.2 Sticky Date-Strip com Scroll-Snap
- Seletor horizontal de datas fixo no topo com scroll-snap, contendo dia da semana, dia numérico, mês e micro-indicador de ocupação global.

### 2.3 Horários com Indicador de Ocupação em Tempo Real
- Cards de horários exibindo porcentagem de ocupação e micro-barra (ex.: `19:30 • [||||||....] 65%`) para evitar cliques em salas já lotadas.

### 2.4 Mapa de Assentos com Codificação Tripla (WCAG 2.2 AA)
- Renderização vetorial SVG com WAI-ARIA Data Grid (`role="grid"`, `role="row"`, `role="gridcell"` com roving tabindex).
- Tela em arco côncavo com gradiente radial sutil.
- **Codificação Tripla Obrigatória:**
  1. *Disponível:* `#1E222D` + borda `#2B303C` + número legível.
  2. *Selecionado:* `#00E054` + texto escuro `#0D0E12` + ícone de checkmark (✓).
  3. *Reservado (10 min):* `#2C2013` + borda pulsante `#D97706` + ícone de relógio/cadeado.
  4. *Ocupado:* `#16181F` + ícone de cruz (✕).
  5. *PCD Cadeirante:* `#2563EB` + ícone de acessibilidade (♿).
  6. *PCD Obeso:* `#2563EB` + largura $1.5\times$.
  7. *Acompanhante PCD:* Borda dupla `#60A5FA` + ícone de elo de conexão.
- **Sticky Bottom-Bar com Trava de 10 min (OCC):**
  - Quando faltar $\le 120\text{ s}$ (2 minutos), migra para `#EF4444` e aciona vibração háptica: `navigator.vibrate([100, 50, 100])`.

---

## 3. Cantina Dine-In & Protocolo In-Theater Dark UI

### 3.1 Fluxo Opcional com Atalho Direto
- A cantina aparece imediatamente após os assentos como passo opcional, com botão claro de desvio: *"Pular Alimentação / Ir para o Pagamento"*.
- Metadados do pedido vinculados diretamente à poltrona (`reserva_id -> sala_id -> assento_id`).
- Customização de combos via **Bottom-Sheet Drawer** sem perda de contexto da tela.

### 3.2 Protocolo In-Theater Dark UI (Sony/Alamo Drafthouse & AFCA)
- Para uso dentro da sala escura durante a sessão (pelo cliente ou pelo *Runner*):
  - Fundo Preto Absoluto (`#000000` - OLED desligado).
  - Texto Atenuado em Cinza (`#6B7280`).
  - Supressão de áudio com confirmação estrita via vibração háptica (`navigator.vibrate`).
