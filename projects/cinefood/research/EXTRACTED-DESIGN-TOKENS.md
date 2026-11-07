# Extração Técnica de Design Tokens: Benchmarking Direto dos Sites de Cinema

**Data da Extração:** 07 de Novembro de 2026  
**Origem dos Dados:** Varredura e extração automatizada de folhas de estilo (CSS), variáveis customizadas (`--*`), paletas hexadecimais e fontes tipográficas dos portais oficiais:
- 🇧🇷 **Cinemark Brasil** (`https://www.cinemark.com.br`)
- 🇧🇷 **Ingresso.com** (`https://www.ingresso.com`)
- 🇺🇸 **Alamo Drafthouse** (`https://drafthouse.com`)
- 🇬🇧 **Everyman Cinemas** (`https://www.everymancinema.com`)

---

## 1. Tabela Comparativa de Tokens Extraídos

| Parâmetro de Design | Cinemark Brasil 🇧🇷 | Ingresso.com 🇧🇷 | Alamo Drafthouse 🇺🇸 | Everyman Cinemas 🇬🇧 | Síntese Aplicada no CineFood |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Canvas / Fundo Base** | `#12100D` (*Warm Near-Black*) | `#041218` (*Deep Petroleum*) / `#161B22` | `#090909` / `#0A0B0B` (*Pure Charcoal*) | `#212020` (*Soft Boutique Black*) | **`#12100D`** (Canvas geral com elevação HSL e OLED `#000000` em sala) |
| **Superfície Nível 1 (Cards)** | `#1A202C` / `#2D3748` | `#252525` / `#21262D` | `#222222` / `#333333` | `#3C3C3B` / `#4F4E4E` | **`#1A202C`** (Cards de filmes e sessões) |
| **Acento de Marca Primário** | `#FF3939` (*Electric Cinema Red*) | `#00A651` / `#25D366` (*Action Green*) | `#F5B324` / `#F0B323` (*Schoolbus Amber PMS 7409*) | `#EE9CA6` / `#EFCFD3` (*Blush Velvet*) | **`#FF3939`** (Vermelho de marca) + **`#F5B324`** (Âmbar gastronômico) |
| **Ação / Checkout / Assentos** | `rgba(66, 153, 225, 0.6)` (*Chakra Ring*) | `#00A651` (*Confirmação / WhatsApp*) | `#996600` (*Focused Gold*) | `#212020` / `#007AFF` | **`#00E054`** (Contraste 9.8:1) e **`#00A651`** (Transacional) |
| **Tipografia de Títulos (Display)** | `'Oswald', 'Oswald Fallback'` (*Condensada, alta, impacto de letreiro*) | `UOL_BOLD_TEXT`, `UOL_TEXT` | `"futura-pt-bold", sans-serif` (*Geométrica em caixa alta*) | `'Playfair Display', serif` (*Hospitalidade luxo*) | **`'Oswald'`** (Letreiros e filmes) + **`'Playfair Display'`** (Harmonizações) |
| **Tipografia de UI / Textos** | `'Work Sans', sans-serif` | `-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto` | `"adobe-garamond-pro", serif` | `'Roboto', sans-serif` | **`'Work Sans'`** e **`'Inter'`** (Alta densidade e legibilidade) |
| **Tipografia Monospace (Preços/Assentos)** | `SFMono-Regular, Menlo, Monaco, Consolas` | `ui-monospace, SFMono-Regular, Menlo` | Native Mono | Native Mono | **`SFMono-Regular, Menlo, Consolas`** |

---

## 2. Detalhamento dos Tokens Extraídos por Portal

### 2.1 Cinemark Brasil (`cinemark.com.br`)
A Cinemark Brasil estrutura seu frontend em **Next.js** com a biblioteca de componentes **Chakra UI** (`--chakra-*`):
* **Cores de Superfície:**
  * `--chakra-colors-black: #12100D` (Preto quente característico com leve inflexão marrom, que evita o aspecto artificial do `#000000` em telas LCD/LED comuns).
  * Escala neutra de elevação: `#1A202C` $\rightarrow$ `#2D3748` $\rightarrow$ `#4A5568`.
* **Cor de Destaque:**
  * `#FF3939` com 144 ocorrências no CSS principal (vermelho vivo e dinâmico, mais enérgico que o vermelho institucional tradicional).
* **Anel de Foco de Acessibilidade:**
  * `--chakra-ring-color: rgba(66, 153, 225, 0.6)`.
* **Tipografia:**
  * Títulos: `'Oswald', 'Oswald Fallback'` (Letreiro marquee clássico, verticalizado e imponente).
  * Corpo e UI: `'Work Sans', sans-serif` (Grotesca neutra de alta legibilidade para tabelas de horários).

### 2.2 Ingresso.com (`ingresso.com`)
O portal da Ingresso.com é desenvolvido em **Next.js** com estilização via **Tailwind CSS v4** (`--tw-*`):
* **Cores de Ação e Confirmação:**
  * `#00A651` e `#25D366` (Verdes herdados do ecossistema transacional e WhatsApp de alta familiaridade no Brasil).
  * `#041218` (Fundo petróleo escuro usado em headers e modais de compra).
* **Tipografia:**
  * Família proprietária `UOL_TEXT` e `UOL_BOLD_TEXT` para identidade corporativa.

### 2.3 Alamo Drafthouse (`drafthouse.com`)
O aplicativo e site da Alamo Drafthouse utilizam o framework **Ionic** (`--ion-*`) com tipografia distribuída pela **Adobe Typekit**:
* **Cores de Acento:**
  * `#F5B324` e `#F0B323` (O tom exato do **PMS 7409 "Schoolbus Yellow"**, o mais famoso acento culinário e de marquee dos EUA).
  * `#996600` (`--highlight-color-focused`).
  * `#090909` e `#0A0B0B` para backgrounds escuros.
* **Tipografia:**
  * Headlines: `"futura-pt-bold", sans-serif`.
  * Sinopses e Notas Editoriais: `"adobe-garamond-pro", serif`.

### 2.4 Everyman Cinemas (`everymancinema.com`)
A rede britânica de luxo Everyman opera sobre uma arquitetura **Theme-UI** com forte foco em hospitalidade:
* **Paleta Cromática de Conforto:**
  * `--theme-ui-colors-accent: #212020` (Carvão aveludado).
  * `--theme-ui-colors-footerBackground: #3C3C3B`.
  * `#EE9CA6` e `#EFCFD3` (Tons de rosa aveludado e blush que transmitem o clima de lounge com sofás de veludo).
* **Tipografia:**
  * Títulos editoriais: `'Playfair Display', serif` e `'BaskervilleStd'`.

---

## 3. Decisões Arquiteturais no CineFood

1. **Adoção do Canvas `#12100D` (Cinemark) & `#1A202C`:**
   - Substituição do cinza genérico pelo preto quente `#12100D`, conferindo peso e elegância autêntica de cinema.
2. **Adoção do Vermelho `#FF3939` (Cinemark):**
   - Utilizado em badges de formato (IMAX 3D, VIP, Dolby) e logotipo.
3. **Adoção do Âmbar `#F5B324` (Alamo Drafthouse):**
   - Utilizado em todos os pontos de contato da gastronomia de poltrona, preços de combos e mesas bistrô.
4. **Tipografia Híbrida de Alta Performance:**
   - **Títulos em Oswald (Cinemark):** Transforma o visual do catálogo, trazendo a força dos letreiros clássicos.
   - **Harmonizações em Playfair Display (Everyman):** Traz o refinamento gastronômico de lounge.
   - **Textos em Work Sans (Cinemark) e Inter:** Cristalinos para seleção de assentos e ingressos.
