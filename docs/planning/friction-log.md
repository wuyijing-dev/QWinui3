# User friction log (2.xx gate)

**Purpose:** Record **real** kit pain — what WinUI 3 / QWinUI3 app authors hit in production or serious prototypes. A **`2.xx` tag (especially 2.51+)** needs a row here **before** it lands on [roadmap.md](../roadmap.md).

**Not for:** WinUI parity shopping, “we lack control X”, internal refactors with no user impact, perf micro-opts without a named slow flow.

---

## Row template (copy per pain)

```markdown
### FL-NNN — Short title

| Field | Value |
|-------|--------|
| **Severity** | P0 / P1 / P2 |
| **Source** | GitHub issue / Gallery soak / example author / field app |
| **Pain** | What feels broken or unusable (one paragraph) |
| **Workaround today** | What teams do instead |
| **Proposed slice** | Roadmap tag or “fix in place” |
| **Status** | open / scheduled / fixed in X.YY / withdrawn |
```

---

## Open / recent (seed from field)

### FL-001 — Title-bar FPS badge invisible when enabled

| Field | Value |
|-------|--------|
| **Severity** | P1 |
| **Source** | Gallery Settings soak |
| **Pain** | “Show FPS” + Title bar placement ON but nothing visible — layout squeezed `rightHeader`. |
| **Workaround today** | `--show-fps` or Overlay mode only. |
| **Proposed slice** | Fix in **1.92** / **2.04** diagnostics · retail guidance **2.44** |
| **Status** | fixed in master (PlatformTitleBar `rightHeader`, Settings toggle) · **2.44** [developer-diagnostics.md](../developer-diagnostics.md) |

### FL-002 — Linux client shell unlike Windows DWM

| Field | Value |
|-------|--------|
| **Severity** | P1 |
| **Source** | Wayland field request |
| **Pain** | No rounded corners / drop shadow on Linux Fluent shell; looks unfinished vs Win11. |
| **Workaround today** | Solid opaque window or compositor defaults. |
| **Proposed slice** | **2.03** compositor polish + **2.68** if residual |
| **Status** | partial — **1.92** + **2.03** client CSD; **2.53** top-3 shell fixes — [linux-top3-253.md](../linux-top3-253.md); **2.68** if field gaps remain |

### FL-012 — Explorer apps blocked without tree + file metadata

| Field | Value |
|-------|--------|
| **Severity** | P1 |
| **Source** | Gallery / example authors (TreeView recipe + DataTable compose) |
| **Pain** | Explorer-style LoB needs folder hierarchy plus Name/Type/Size/Modified columns. Hand-wiring `TreeView` + `DataTable` duplicates selection sync, Tab focus, and folder→file catalog glue; easy to ship broken caption or empty panes. |
| **Workaround today** | Custom `RowLayout` + manual `onCurrentRowChanged` + separate DataTable `rows` binding. |
| **Proposed slice** | **2.06** `FileTree` |
| **Status** | fixed in master (**2.06**) |

### FL-003 — Consumer CMake / import path friction

| Field | Value |
|-------|--------|
| **Severity** | P1 |
| **Source** | packaging-consumer / example authors |
| **Pain** | Every new app struggles with `add_subdirectory` vs zip vs `find_package` sketch. |
| **Workaround today** | Copy Gallery tree, hand-wire import paths, or use **2.11** vcpkg/Conan overlay. |
| **Proposed slice** | **2.02** productize Path C · **2.11** vcpkg/Conan (shipped) · **2.68** residual |
| **Status** | partial — **2.11** ports shipped; **2.47** path picker; **2.52** first-app quickstart — [first-app-252.md](../first-app-252.md); **2.02** still scheduled |

### FL-004 — Experimental vs stable confusion

| Field | Value |
|-------|--------|
| **Severity** | P1 |
| **Source** | stable-api / Pitfalls |
| **Pain** | Teams ship OSK, charts, media, or shell extras thinking they are stable. Charts compose + media verdict closed in **2.08** / **2.09**. |
| **Workaround today** | Read [stable-api.md](../stable-api.md) + [charts.md](../charts.md) + [media.md](../media.md). |
| **Proposed slice** | **2.45** sweep + **2.51** clarity + **2.67** wave 2 |
| **Status** | partial — charts **2.08**, media **2.09**; **2.45** sweep + Gallery badges; **2.47** import guard; **2.51** lint + Pitfalls — [stable-clarity-251.md](../stable-clarity-251.md) (**FL-004 queue closed**); **2.67** wave 2 |

### FL-005 — Rich text blocked for mail / template apps

| Field | Value |
|-------|--------|
| **Severity** | P1 (when confirmed) |
| **Source** | Roadmap professional backlog — awaiting field app |
| **Pain** | Mail editors, long notes, and template authoring need basic formatting; plain `TextArea` or WebView2 hacks fail a11y/IME integration. |
| **Workaround today** | Embed WebView2 or third-party editor; lose Fluent chrome. |
| **Proposed slice** | **2.61** **(conditional)** `RichEdit` |
| **Status** | open — **conditional**; needs named app |

### FL-006 — Contacts / album dual-view blocked

| Field | Value |
|-------|--------|
| **Severity** | P1 (when confirmed) |
| **Source** | Roadmap professional backlog — awaiting field app |
| **Pain** | Thumbnail grid ↔ letter-index zoom needs shared selection and keyboard; two `ItemsView`s duplicate state and break WinUI mental model. |
| **Workaround today** | Custom toggle + two views + manual sync. |
| **Proposed slice** | **2.62** **(conditional)** `SemanticZoom` |
| **Status** | open — **conditional**; needs named app |

### FL-007 — In-app notification history + grouping

| Field | Value |
|-------|--------|
| **Severity** | P1 (when confirmed) |
| **Source** | Roadmap professional backlog — awaiting field app |
| **Pain** | Toast-only flow loses dismissible history and grouped categories; LoB apps need a notification drawer/center. |
| **Workaround today** | Custom `ListView` + local store beside `InfoBar` / Toast. |
| **Proposed slice** | **2.27** / **2.63** **(conditional)** notification center |
| **Status** | addressed — **2.27** `NotificationCenter` (experimental) |

### FL-008 — Collection controls sluggish at scale

| Field | Value |
|-------|--------|
| **Severity** | P1 (when confirmed) |
| **Source** | Roadmap professional backlog — awaiting field metrics |
| **Pain** | **DataTable** / **ListDetailsView** / **NavigationView** feel slow with large models — filter typing stalls UI or rebuilds entire view rows. |
| **Workaround today** | Smaller pages, custom proxies, or drop kit controls. |
| **Proposed slice** | **2.18** / **2.40** / **2.49** / **2.64** collection perf |
| **Status** | partial — **2.18** wave 5 + **2.28** wave 6 + **2.40** wave 7; **2.49** tranche-1 sign-off — [perf-signoff-2xx.md](../perf-signoff-2xx.md); **2.64** if field metrics return |

### FL-009 — Dashboard / chart compose confusion

| Field | Value |
|-------|--------|
| **Severity** | P2 |
| **Source** | charts.md / example authors |
| **Pain** | Teams unsure whether to use deferred `AreaChart` / `Sparkline` or stable compose paths; dashboard layouts ad hoc. |
| **Workaround today** | Copy Gallery piecemeal; guess stable vs experimental. |
| **Proposed slice** | **2.08** / **2.22** / **2.26** / **2.48** / **2.65** product wave + [charts-dashboard-arc.md](expansion/charts-dashboard-arc.md) |
| **Status** | partial — **2.08** + **2.22** + **2.26** recipes shipped; **2.48** compose decision tree — [dashboard-compose-decision.md](../dashboard-compose-decision.md); **2.65** closes APIs + **DashboardShell** |

### FL-014 — Real-time KPI dashboards blocked

| Field | Value |
|-------|--------|
| **Severity** | P1 (when confirmed) |
| **Source** | Dashboard / ops field apps — awaiting named app |
| **Pain** | LoB dashboards need rolling KPI rows with live sparkline refresh; stable **KpiTile** + manual timers duplicate state and miss compare-period semantics. |
| **Workaround today** | Custom `Timer` + **KpiTile** + deferred **Sparkline** in Gallery only. |
| **Proposed slice** | **2.65** partial (**KpiTile** compare + refresh hooks) · **3.01** **(conditional)** `LiveMetricStrip` |
| **Status** | open — scheduled **2.65** / **3.01** — [charts-dashboard-arc.md](expansion/charts-dashboard-arc.md) |

### FL-015 — Distribution / histogram apps need bins

| Field | Value |
|-------|--------|
| **Severity** | P1 (when confirmed) |
| **Source** | Analytics / reporting field apps — awaiting named app |
| **Pain** | Histogram / distribution views blocked — **BarChart** lacks bin API; teams hand-roll Canvas or import deferred Gallery charts. |
| **Workaround today** | Pre-aggregate bins in model; use **BarChart** with fixed categories. |
| **Proposed slice** | **2.69** **(conditional)** — **BarChart** bin API first · **HistogramChart** if compose fails |
| **Status** | open — **conditional** — [charts-dashboard-arc.md](expansion/charts-dashboard-arc.md) wave B |

### FL-016 — DataTable grouping / pinning for ops apps

| Field | Value |
|-------|--------|
| **Severity** | P1 (when confirmed) |
| **Source** | Collection perf / ops LoB — field metrics pending |
| **Pain** | Ops dashboards need pinned columns and row grouping headers; **DataTable** feels spreadsheet-limited vs WinUI **DataGrid**. |
| **Workaround today** | Split views, custom headers, or drop kit grid. |
| **Proposed slice** | **2.64** collection wave 9 — [component-capabilities-expansion.md](expansion/component-capabilities-expansion.md) |
| **Status** | open — scheduled **2.64**

### FL-017 — OSK unusable outside Gallery dock

| Field | Value |
|-------|--------|
| **Severity** | P1 (when confirmed) |
| **Source** | Field apps / **2.01** promote follow-up |
| **Pain** | Floating OSK works in Gallery but app authors cannot embed dock, restore focus, or route IME candidates in real forms. |
| **Workaround today** | Copy Gallery **floating-osk** example piecemeal; system keyboard only. |
| **Proposed slice** | **2.58** — [component-capabilities-expansion.md](expansion/component-capabilities-expansion.md) OSK module |
| **Status** | open — scheduled **2.58** |

### FL-018 — Dialog queue / validation unlike WinUI

| Field | Value |
|-------|--------|
| **Severity** | P2 |
| **Source** | forms.md / Gallery form-settings authors |
| **Pain** | **ContentDialog** queue priority, Enter default button, and **FormLayout** async validation timing differ from WinUI — teams ship confusing modal stacks. |
| **Workaround today** | Single dialog at a time; sync validation only. |
| **Proposed slice** | **2.55** — [component-capabilities-expansion.md](expansion/component-capabilities-expansion.md) forms + dialogs |
| **Status** | open — scheduled **2.55**

### FL-010 — Forms lack industry-ready templates

| Field | Value |
|-------|--------|
| **Severity** | P2 |
| **Source** | forms.md / Gallery authors |
| **Pain** | Controls exist (`FormLayout`, `SettingsCard`, `TokenizingTextBox`, …) but no end-to-end LoB form pages to copy. |
| **Workaround today** | Rebuild from Gallery atom pages. |
| **Proposed slice** | **2.25** / **2.66** industry templates |
| **Status** | addressed — **2.25** industry template pages |

### FL-013 — Scheduling apps blocked by pickers-only

| Field | Value |
|-------|--------|
| **Severity** | P2 |
| **Source** | Gallery **Calendar** / pickers authors |
| **Pain** | Booking / PTO / room schedules need a full month grid — **CalendarDatePicker** flyout and **DatePicker** tumblers are the wrong UX. |
| **Workaround today** | Hand-compose **MonthGrid** + **DayOfWeekRow** (Gallery **Calendar** page). |
| **Proposed slice** | **2.31** **`CalendarView`** |
| **Status** | addressed — **2.31** experimental `CalendarView` |

### FL-011 — Python / PySide6 teams blocked on C++-only kit

| Field | Value |
|-------|--------|
| **Severity** | P1 (when confirmed) |
| **Source** | Roadmap Python tranche — awaiting field app / prototype author |
| **Pain** | Teams standardize on **PySide6** but QWinUI3 docs and artifacts assume CMake/C++ — no import path, no minimal Python example, no pip story. |
| **Workaround today** | Stay on C++ / QML split repo; hand-wire `QQmlApplicationEngine` and QML paths from forum snippets. |
| **Proposed slice** | **2.71** PySide6 · **2.72** PyPI · **2.73** checkpoint (requires **2.02** first) |
| **Status** | open — scheduled **2.71** / **2.72** |

---

## Rules

1. **2.51…2.60:** no open P0/P1 row → **skip the tag** (empty queue is OK).
2. **Conditional controls (2.06, 2.21, 2.27, 2.61, …):** must cite a row proving composition failed.
3. **Close rows** when shipped; link commit / version in **Status**.
4. Checkpoints **2.20 / 2.30 / 2.50 / 2.60 / 2.70 / 2.73** review this file before reordering roadmap.

See [roadmap.md](../roadmap.md) · [ROADMAP.md](../../ROADMAP.md).
