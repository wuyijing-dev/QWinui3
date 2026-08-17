# Component capabilities expansion (2.51 → 3.00)

Plan to **大幅增强现有组件** — new properties, behaviors, and recipes on **all shipped control modules**. New public types only when compose fails ([friction-log.md](../friction-log.md)).

**Parallel tracks:** [charts-dashboard-arc.md](charts-dashboard-arc.md) (analytics) · [roadmap-strategy.md](../roadmap-strategy.md)

Validation: `python scripts/check_component_capabilities_expansion.py`

---

## Deepening matrix (by module)

### Collections & data

| Control | Capability expansion | Target slice | Doc |
|---------|---------------------|--------------|-----|
| **DataTable** | Column pin/reorder persist; row grouping header; inline edit commit | **2.64** | [data-collections.md](../../data-collections.md) |
| **ListDetailsView** | Master multi-select; detail pane toolbar; empty state | **2.64** | [data-collections.md](../../data-collections.md) |
| **TreeView** | Lazy load hooks; checkbox cascade policy doc | **2.64** | [tree-data.md](../../tree-data.md) |
| **FileTree** | Column chooser; quick filter sync tree↔table | **2.64** | [tree-data.md](../../tree-data.md) |
| **TreeDataGrid** | Column resize; frozen first column | **2.64** | experimental |
| **ItemsView** | Section sticky header; grid cell span | **2.59** | [data-collections.md](../../data-collections.md) |
| **ItemsWrapGrid** | `maxVisible` + overflow chip | **2.59** | [items-wrap-grid.md](../../items-wrap-grid.md) |
| **ItemsRepeater** | Section headers in virtualized list | **2.59** | [performance.md](../../performance.md) |
| **ListTile** | Leading/trailing action slots; swipe hint doc | **2.59** | [data-collections.md](../../data-collections.md) |
| **EmptyState** | Primary/secondary actions; illustration slot | **2.64** | [feedback.md](../../feedback.md) |

### Navigation & shell

| Control | Capability expansion | Target slice | Doc |
|---------|---------------------|--------------|-----|
| **NavigationView** | Pane pin; footer badge count; search highlight in pane | **2.56** | [navigation.md](../../navigation.md) |
| **BreadcrumbBar** | Overflow flyout; `maxItems` | **2.56** | [navigation.md](../../navigation.md) |
| **TabView** | Tear-out guard API; scrollable tab strip | **2.56** | [navigation.md](../../navigation.md) |
| **Pivot** | Header overflow; keyboard roving tabindex doc | **2.56** | [navigation.md](../../navigation.md) |
| **NavigationWindow** | Saved pane width; multi-window pane sync doc | **2.54** | [window-shells.md](../../window-shells.md) |
| **TwoPaneView** | Collapsible pane memory; narrow-mode auto-collapse | **2.56** | [adaptive-layout.md](../../adaptive-layout.md) |
| **SplitView** | Live resize preview; minimum pane guard | **2.56** | [adaptive-layout.md](../../adaptive-layout.md) |

### Forms & input

| Control | Capability expansion | Target slice | Doc |
|---------|---------------------|--------------|-----|
| **FormLayout** | Async validation state; summary anchor scroll | **2.55** | [forms.md](../../forms.md) |
| **ValidationSummary** | Live region on error count change | **2.55** | [forms.md](../../forms.md) |
| **SettingsCard** | Expandable description HTML subset | **2.66** | [forms.md](../../forms.md) |
| **SettingsExpander** | Nested group persist key | **2.66** | [forms.md](../../forms.md) |
| **TokenizingTextBox** | Paste split; max tokens | **2.66** | [forms.md](../../forms.md) |
| **NumberBox** | Spin wrap; formula display | **2.55** | [pickers.md](../../pickers.md) |
| **TextBox** / **TextArea** | Character counter; reveal password toggle doc | **2.55** | [forms.md](../../forms.md) |
| **ComboBox** | Filter-as-you-type; section headers in popup | **2.55** | [pickers.md](../../pickers.md) |
| **MultiSelectComboBox** | Select-all chip row; max selection | **2.66** | [forms.md](../../forms.md) |
| **CalendarView** | Range selection mode; blackout dates | **2.69** | [calendar-view.md](../../calendar-view.md) |

### Pickers & date/time

| Control | Capability expansion | Target slice | Doc |
|---------|---------------------|--------------|-----|
| **DatePicker** | Min/max clamp UX; placeholder format | **2.55** | [pickers.md](../../pickers.md) |
| **TimePicker** | 24h toggle persist; minute step | **2.55** | [pickers.md](../../pickers.md) |
| **CalendarDatePicker** | Blackout sync with **CalendarView** | **2.69** | [pickers.md](../../pickers.md) |
| **ColorPicker** | Recent colors strip; alpha default | **2.57** | [pickers.md](../../pickers.md) |

### Primitives & commands

| Control | Capability expansion | Target slice | Doc |
|---------|---------------------|--------------|-----|
| **Button** / **AccentButton** | Loading state; width policy doc | **2.59** | [commands.md](../../commands.md) |
| **SplitButton** | Primary action vs menu split persist | **2.59** | [commands.md](../../commands.md) |
| **ToggleButton** / **ToggleSwitch** | Indeterminate doc; tri-state binding | **2.55** | [forms.md](../../forms.md) |
| **HyperlinkButton** | External link icon + security note | **2.59** | [commands.md](../../commands.md) |
| **CommandBar** | Overflow measure; keyboard focus order | **2.59** | [commands.md](../../commands.md) |
| **AppBar** | Dynamic title truncation; back stack sync | **2.56** | [navigation.md](../../navigation.md) |
| **CommandPalette** | Recent commands; fuzzy rank tuning | **2.59** | [commands.md](../../commands.md) |
| **MenuFlyout** | Submenu delay; checkbox items batch | **2.59** | [commands.md](../../commands.md) |
| **TeachingTip** | Target highlight ring; sequential coach | **2.55** | [feedback.md](../../feedback.md) |

### Dialogs & feedback

| Control | Capability expansion | Target slice | Doc |
|---------|---------------------|--------------|-----|
| **ContentDialog** | Queue priority; default button on Enter | **2.55** | [dialogs-flyouts.md](../../dialogs-flyouts.md) |
| **Dialog** / **DialogWindow** | Size grip policy; parent modal chain doc | **2.55** | [dialogs-flyouts.md](../../dialogs-flyouts.md) |
| **Flyout** | Light dismiss edge cases doc | **2.55** | [dialogs-flyouts.md](../../dialogs-flyouts.md) |
| **InfoBar** | Action button stack; auto-dismiss policy | **2.63** | [feedback.md](../../feedback.md) |
| **ToastHost** | Priority queue; dedupe by id | **2.63** | [feedback.md](../../feedback.md) |
| **ProgressRing** / **ProgressBar** | Indeterminate vs determinate swap | **2.59** | [feedback.md](../../feedback.md) |

### OSK / IME / keyboard (**2.58**)

| Control | Capability expansion | Target slice | Doc |
|---------|---------------------|--------------|-----|
| **OnScreenKeyboard** | App-embedded dock recipe; focus return | **2.58** | [on-screen-keyboard.md](../../on-screen-keyboard.md) |
| **KeyboardEngine** | Layout hot-swap; candidate bar placement | **2.58** | [on-screen-keyboard.md](../../on-screen-keyboard.md) |
| **ImeCandidateBar** | Inline vs floating; dark theme sync | **2.58** | [on-screen-keyboard.md](../../on-screen-keyboard.md) |
| **AnnotatedScrollBar** | IME composition scroll hint | **2.58** | [on-screen-keyboard.md](../../on-screen-keyboard.md) |

### Theme, density & visual

| Control | Capability expansion | Target slice | Doc |
|---------|---------------------|--------------|-----|
| **ThemeOverrides** | Accent ramp presets; density bundle export | **2.59** | [theme-overrides.md](../../theme-overrides.md) |
| **ThemePrefs** | System vs app scope doc | **2.54** | [theme-overrides.md](../../theme-overrides.md) |
| **FontIcon** / **AnimatedIcon** | Dashboard symbol sizing; reducedMotion | **2.65** | [icons.md](../../icons.md) |
| **AcrylicSurface** | Fallback solid on low-end GPU doc | **2.54** | [window-chrome.md](../../window-chrome.md) |
| **SwipeControl** | Threshold tuning; nested scroll guard | **2.59** | [carousel-recipes.md](../../carousel-recipes.md) |
| **PipsPager** / **FlipView** | Reduced motion cross-fade | **2.59** | [carousel-recipes.md](../../carousel-recipes.md) |

### Platform, search & media

| Control | Capability expansion | Target slice | Doc |
|---------|---------------------|--------------|-----|
| **WindowHelper** | Per-monitor geometry JSON schema v2 | **2.54** | [window-helper.md](../../window-helper.md) |
| **PlatformTitleBar** | Custom right-header measure; FPS slot doc | **2.54** | [window-chrome.md](../../window-chrome.md) |
| **FilePicker** | Multi-select summary label | **2.57** | [system-integration.md](../../system-integration.md) |
| **FileDropZone** | Filter mime types; hover highlight | **2.57** | [drag-drop.md](../../drag-drop.md) |
| **AutoSuggestBox** | Debounce policy; highlight match range | **2.59** | [search.md](../../search.md) |
| **WebView2Host** | Download policy presets | **2.57** | [webview2.md](../../webview2.md) |
| **MediaPlayerElement** | Transport bar presets; permanent defer unless field app | **2.67** | [media.md](../../media.md) |
| **FrameStatsMonitor** | Snapshot export (dev only) | **2.59** | [developer-diagnostics.md](../../developer-diagnostics.md) |

### Accessibility & focus

| Control | Capability expansion | Target slice | Doc |
|---------|---------------------|--------------|-----|
| **FocusStroke** | High-contrast ring width | **2.64** | [accessibility.md](../../accessibility.md) |
| **Accessible** helpers | Live region patterns catalog | **2.64** | [accessibility.md](../../accessibility.md) |

### Charts & dashboard (see [charts-dashboard-arc.md](charts-dashboard-arc.md))

| Control | Capability expansion | Target slice |
|---------|---------------------|--------------|
| **LineChart** | Crosshair, zoom brush, axis labels | **2.65** |
| **BarChart** | Stacked groups, horizontal mode, bin API | **2.65** / **2.69** |
| **DonutChart** | Center label, explode slice | **2.65** |
| **KpiTile** | Compare period, formatted delta | **2.65** |
| **ChartCard** | Footer actions, export hook | **2.65** |
| **Sparkline** | Promote vs defer | **2.67** |

### Conditional types (friction-gated)

| Control | Capability expansion | Target slice | Friction |
|---------|---------------------|--------------|----------|
| **RichEdit** | Basic formatting + IME | **2.61** | FL-005 |
| **SemanticZoom** | Grid ↔ index shared selection | **2.62** | FL-006 |
| **NotificationCenter** | History + grouping | **2.63** | FL-007 |
| **HistogramChart** | Bin API or thin type | **2.69** | FL-015 |
| **BulletChart** | Compose on KPI + gauge | **2.69** | FL-014 |

---

## Slice bundling (2.51 → 3.00)

| Slice | Primary deepen theme | Modules |
|-------|---------------------|---------|
| **2.51** | Stable vs experimental clarity | Gallery badges · import guard follow-up |
| **2.54** | Window chrome + geometry | **WindowHelper**, **ThemePrefs**, **AcrylicSurface**, **NavigationWindow** |
| **2.55** | Forms + dialogs + teaching | **FormLayout**, pickers, **ContentDialog**, **TeachingTip**, toggles |
| **2.56** | Navigation + layout | **NavigationView**, **TabView**, **BreadcrumbBar**, **SplitView**, **AppBar** |
| **2.57** | Linux files + pickers + WebView | **FilePicker**, **FileDropZone**, **ColorPicker**, **WebView2Host** |
| **2.58** | OSK / IME in real apps | **OnScreenKeyboard**, **KeyboardEngine**, **ImeCandidateBar** |
| **2.59** | App perf + command UX + carousel | **CommandPalette**, **ItemsView**, **AutoSuggestBox**, **SwipeControl**, **Button** loading |
| **2.61–2.63** | Conditional professional surfaces | **RichEdit**, **SemanticZoom**, notification productize |
| **2.64** | Collection wave 9 + a11y | **DataTable**, **ListDetailsView**, trees, **FocusStroke** |
| **2.65** | Charts **Wave A** + **DashboardShell** | Stable six + dashboard hosts |
| **2.66** | Forms industry v2 | **SettingsCard**, **TokenizingTextBox**, **MultiSelectComboBox** |
| **2.67** | Experimental promote wave 2 | **Sparkline**, **MediaPlayerElement** verdict |
| **2.68** | Platform integration harden | Consumer CMake residual · stable badges |
| **2.69** | Analytics **Wave B** + field buffer | **CalendarView** range, histogram/bullet conditional |
| **3.01+** | Friction-only deepen on **3.xx** stable | Linked charts, export, live KPI strip |

---

## Friction rows (deepen & analytics)

| ID | Pain | Proposed slice |
|----|------|----------------|
| **FL-009** | Dashboard compose confusion | **2.48** partial · **2.65** close |
| **FL-014** | Real-time KPI dashboards blocked | **2.65** / **3.01** `LiveMetricStrip` |
| **FL-015** | Distribution/histogram apps need bins | **2.69** **BarChart** bins **or** **HistogramChart** |
| **FL-016** | DataTable grouping/pinning for ops apps | **2.64** |
| **FL-017** | OSK unusable outside Gallery dock | **2.58** |
| **FL-018** | Dialog queue / validation unlike WinUI | **2.55** |

Log updates: [friction-log.md](../friction-log.md)

---

## 3.00 impact

- Deepened APIs on stable controls become the **3.xx** contract ([compatibility-3xx.md](../../compatibility-3xx.md)).
- **Removed:** undeferred sibling charts not promoted by **2.67**.
- **New types** promoted in **2.61…2.69** stay stable in **3.xx** unless deprecated in upgrade notes.

**Out:** WebGL rewrites; Hub revival; million-row GPU grid engine.
