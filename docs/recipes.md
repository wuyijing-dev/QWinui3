# Recipes hub (1.36)

LoB how-tos for shipping with QWinUI3. Prefer these over inventing a second stack. Generated **control** pages live under [Component API](components.md). **Gallery:** category **Recipes** → **Recipes hub** opens every related demo.

**Stable API:** prefer types on [stable-api.md](stable-api.md). **1.37** promote / defer tables live there.  
**1.xx freeze (1.40):** [compatibility-1xx.md](compatibility-1xx.md) · [upgrade-notes.md](upgrade-notes.md).  
**1.xx maturity (1.51):** [maturity-1xx.md](maturity-1xx.md) — prefer harden; not 2.00.

---

## Start building

| Recipe | One-liner |
|--------|-----------|
| [Qt Creator](qt-creator.md) | Open root CMakeLists → Gallery or example (no `.pro`) |
| [Consumer packaging](packaging-consumer.md) | Shared vs static / windeploy / strip (1.46) |
| [1.xx compatibility](compatibility-1xx.md) | Will-not-break Theme / shells / stable controls (1.40 / 1.51) |
| [1.xx maturity checkpoint](maturity-1xx.md) | Where we are; harden-first posture (**1.51**) |
| [Upgrade notes](upgrade-notes.md) | Consumer checklist + template (1.40) |
| [Qt version compat](qt-version-compat.md) | 6.5+ / 6.8 LTS / CI matrix |
| [Conventions](conventions.md) | Radius, Accessible, Extras import |

---

## App shells & chrome

| Recipe | One-liner |
|--------|-----------|
| [Window shells](window-shells.md) | ShellWindow vs StandardWindow · Win/Linux matrix |
| [Window chrome](window-chrome.md) | DPI / backdrop / geometry failure modes |
| [WindowHelper](window-helper.md) | Geometry persistence, backdrop, platform APIs |
| [AppWindow](window-appwindow.md) | Presenters / title-bar height |
| [Linux / Wayland](platform-linux-wayland.md) | CSD, Solid, portals, field matrix (1.38) |
| [Graphics backend](graphics-backend.md) | RHI ship table · OpenGL for frost |
| [Transparency / DWM](window-transparency-dwm.md) | Gallery Solid policy · Mica notes |

---

## Navigation, forms, data

| Recipe | One-liner |
|--------|-----------|
| [Navigation & TabView](navigation.md) | Pane modes, Back, footer |
| [Forms & settings](forms.md) | FormLayout validation + SettingsCard |
| [Data collections](data-collections.md) | DataTable / ItemsView / ListDetailsView |
| [Tree & hierarchical](tree-data.md) | TreeView expand / a11y |
| [Input & pickers](pickers.md) | Number / date / time / color |
| [Density & responsive](density.md) | Compact metrics, narrow shells |
| [Adaptive layout](adaptive-layout.md) | TwoPaneView / ListDetailsView breakpoints (1.42) |
| [Theme overrides](theme-overrides.md) | Accent / density / branding |
| [Color & contrast](color-contrast.md) | AA diagnostics / high contrast (1.43) |
| [Icons & FluentIcons](icons.md) | Symbol font + micro-motion (1.49) |
| [i18n / RTL](i18n-rtl.md) | qsTr + zh_CN seed + LayoutMirroring (1.45) |

---

## Feedback, dialogs, commands

| Recipe | One-liner |
|--------|-----------|
| [Feedback surfaces](feedback.md) | InfoBar / Toast / TeachingTip / Progress |
| [Dialogs & flyouts](dialogs-flyouts.md) | ContentDialogQueue FIFO / Esc (1.48) |
| [Commands & menus](commands.md) | CommandPalette / CommandBar / MenuFlyout |
| [Keyboard-first](keyboard.md) | Global chords → palette → dialogs → lists (1.44) |
| [Accessibility](accessibility.md) | Focus / names checklist |

---

## Platform & media

| Recipe | One-liner |
|--------|-----------|
| [System integration](system-integration.md) | FilePicker / Tray / NotificationBridge |
| [Drag-drop & clipboard](drag-drop.md) | FileDropZone / CopyButton / WindowHelper (1.41) |
| [Shell extras](shell-extras.md) | Snap / taskbar / attention / reveal (1.47) |
| [WebView2](webview2.md) | Stable Edge host (Windows) |
| [Media](media.md) | Optional Multimedia / MediaPlayerElement |
| [Charts & gauges](charts.md) | Stable chart subset + gauges |
| [Animations](animations.md) | ConnectedAnimation / reducedMotion |
| [Performance](performance.md) | Lists, models, chart budgets, Gallery cold start (1.39) |

---

## Quality & Gallery

| Recipe | One-liner |
|--------|-----------|
| [CI smoke](ci-smoke.md) | Gallery `--smoke` + docs links + catalog (**1.52**) |
| [Gallery CatalogPage](gallery-catalog-page.md) | Page host slots (Item not Page) |

---

## Examples (in repo)

| Example | Recipe pair |
|---------|-------------|
| [`examples/gallery-shell`](../examples/gallery-shell/) | [window-shells.md](window-shells.md) / [navigation.md](navigation.md) (**1.50**) |
| [`examples/nav-settings`](../examples/nav-settings/) | [navigation.md](navigation.md) |
| [`examples/settings-cards`](../examples/settings-cards/) | [forms.md](forms.md) / theme |
| [`examples/dashboard`](../examples/dashboard/) | [charts.md](charts.md) |
| [`examples/master-detail`](../examples/master-detail/) | [data-collections.md](data-collections.md) |
| [`examples/form-settings`](../examples/form-settings/) | [forms.md](forms.md) |

Build from Creator or presets: [qt-creator.md](qt-creator.md) · [examples/README.md](../examples/README.md).
