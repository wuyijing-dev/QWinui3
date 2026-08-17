# Recipes hub (1.36)

LoB how-tos for shipping with QWinUI3. Prefer these over inventing a second stack. Generated **control** pages live under [Component API](components.md). **Gallery:** last pane group **Recipes** → **Recipes hub** (also motion, a11y, system, media how-tos).

**Stable API:** prefer types on [stable-api.md](stable-api.md). **1.37** promote / defer tables live there.  
**1.xx freeze (1.40):** [compatibility-1xx.md](compatibility-1xx.md) · [upgrade-notes.md](upgrade-notes.md).  
**1.xx maturity (1.51):** [maturity-1xx.md](maturity-1xx.md) — prefer harden; not 2.00.  
**Mid-horizon (1.60):** [checkpoint-160.md](checkpoint-160.md). **Long-horizon (1.78):** [checkpoint-178.md](checkpoint-178.md) — still 1.xx; prefer field harden / pause; OSK stays experimental ([on-screen-keyboard.md](on-screen-keyboard.md)).

---

## Start building

| Recipe | One-liner |
|--------|-----------|
| [Qt Creator](qt-creator.md) | Open root CMakeLists → Gallery or example (no `.pro`) |
| [Consumer packaging](packaging-consumer.md) | Shared vs static / windeploy / strip (1.46) · `find_package` sketch (**1.61**) |
| [1.xx compatibility](compatibility-1xx.md) | Will-not-break Theme / shells / stable controls (1.40 / 1.51) |
| [1.xx maturity checkpoint](maturity-1xx.md) | Where we are; harden-first posture (**1.51**) |
| [Mid-horizon checkpoint](checkpoint-160.md) | Halfway audit; 1.61+ confirmed (**1.60**) |
| [Long-horizon checkpoint](checkpoint-178.md) | 1.49…1.78 close-out; field harden / pause (**1.78**) |
| [Upgrade notes](upgrade-notes.md) | Consumer checklist + template (1.40) |
| [Qt version compat](qt-version-compat.md) | 6.5+ / 6.8 LTS / CI matrix |
| [Conventions](conventions.md) | Radius, Accessible, Extras import |

---

## App shells & chrome

| Recipe | One-liner |
|--------|-----------|
| [Window shells](window-shells.md) | ShellWindow vs StandardWindow · multi-window (1.56) · Win/Linux matrix |
| [Window chrome](window-chrome.md) | DPI / backdrop / geometry failure modes |
| [High-DPI & multi-monitor](high-dpi.md) | DPR matrix · geometry clamp + setScreen (**1.58**) |
| [WindowHelper](window-helper.md) | Geometry persistence, backdrop, platform APIs |
| [AppWindow](window-appwindow.md) | Presenters / title-bar height |
| [Linux / Wayland](platform-linux-wayland.md) | CSD, Solid, portals, field matrix (1.38 / 1.68 / **1.79**) |
| [Graphics backend](graphics-backend.md) | RHI ship table · OpenGL for frost |
| [Transparency / DWM](window-transparency-dwm.md) | Gallery Solid policy · Mica notes |

---

## Navigation, forms, data

| Recipe | One-liner |
|--------|-----------|
| [Navigation & TabView](navigation.md) | Pane modes, Back, footer |
| [Forms & settings](forms.md) | FormLayout validation + SettingsCard |
| [Settings persistence](settings-persistence.md) | QSettings / Settings · portable Ini · schemaVersion (**1.65**) |
| [Data collections](data-collections.md) | DataTable / ItemsView / ListDetailsView |
| [Tree & hierarchical](tree-data.md) | TreeView expand / a11y |
| [Input & pickers](pickers.md) | Number / date / time / color |
| [Density & responsive](density.md) | Compact metrics, narrow shells |
| [Touch, pen & pointer](touch-pointer.md) | Targets · scroll vs drag · pen notes (**1.57**) |
| [Adaptive layout](adaptive-layout.md) | TwoPaneView / ListDetailsView breakpoints (1.42) |
| [Theme overrides](theme-overrides.md) | Accent / density / branding · copy recipe (**1.69**) |
| [Color & contrast](color-contrast.md) | AA diagnostics / high contrast (1.43) |
| [Icons & FluentIcons](icons.md) | Symbol font + micro-motion + AnimatedIcon (1.53) |
| [i18n / RTL](i18n-rtl.md) | qsTr + zh_CN seed + LayoutMirroring (1.45) |

---

## Feedback, dialogs, commands

| Recipe | One-liner |
|--------|-----------|
| [Feedback surfaces](feedback.md) | InfoBar / Toast / TeachingTip / onboarding coach / Progress |
| [Dialogs & flyouts](dialogs-flyouts.md) | ContentDialogQueue FIFO / Esc (1.48) |
| [Commands & menus](commands.md) | CommandPalette / CommandBar / MenuFlyout |
| [Keyboard-first](keyboard.md) | Global chords → palette → dialogs → lists (1.44) |
| [On-screen keyboard](on-screen-keyboard.md) | Floating Win11 OSK (**1.82**) + opt-in Windows system-wide; still experimental |
| [In-app search & AutoSuggest](search.md) | Suggest · filter-above · catalog jump (**1.59**) |
| [Accessibility](accessibility.md) | Focus / names checklist |

---

## Platform & media

| Recipe | One-liner |
|--------|-----------|
| [System integration](system-integration.md) | FilePicker / Tray / NotificationBridge (**1.68** / **1.79** portal) |
| [Print, share & export](print-share.md) | grabToImage · save · reveal · PrintSupport notes (**1.63**) |
| [Security & trust](security-trust.md) | WebView2 / drop / picker boundaries (**1.64**) |
| [Drag-drop & clipboard](drag-drop.md) | FileDropZone / CopyButton / WindowHelper (1.41) |
| [Shell extras](shell-extras.md) | Snap / taskbar / attention / reveal (1.47) |
| [WebView2](webview2.md) | Stable Edge host (Windows) |
| [Media](media.md) | Optional Multimedia — **deferred 1.67** |
| [Charts & gauges](charts.md) | Stable six + deferred remaining (**1.66**) |
| [Animations](animations.md) | ConnectedAnimation / reducedMotion |
| [Performance](performance.md) | Lists, models, chart budgets, Gallery cold start (1.39) |

---

## Quality & Gallery

| Recipe | One-liner |
|--------|-----------|
| [CI smoke](ci-smoke.md) | Gallery `--smoke` + opt-in visual subset (**1.62**) |
| [Gallery CatalogPage](gallery-catalog-page.md) | Page host slots (Item not Page) |

---

## Examples (in repo)

| Example | Recipe pair |
|---------|-------------|
| [`examples/gallery-shell`](../examples/gallery-shell/) | [window-shells.md](window-shells.md) / [navigation.md](navigation.md) (**1.50**) |
| [`examples/multi-window`](../examples/multi-window/) | [window-shells.md](window-shells.md) multi-window (**1.56**) |
| [`examples/nav-settings`](../examples/nav-settings/) | [navigation.md](navigation.md) |
| [`examples/settings-cards`](../examples/settings-cards/) | [forms.md](forms.md) / theme |
| [`examples/dashboard`](../examples/dashboard/) | [charts.md](charts.md) (**1.66** stable six) |
| [`examples/master-detail`](../examples/master-detail/) | [data-collections.md](data-collections.md) |
| [`examples/form-settings`](../examples/form-settings/) | [forms.md](forms.md) |

Build from Creator or presets: [qt-creator.md](qt-creator.md) · [examples/README.md](../examples/README.md).
