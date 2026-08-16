# Accessibility (1.02+)

High-traffic product path: **NavigationView**, **settings cards**, **ContentDialog**, **InfoBar** / **Toast**.

Wave 2 (1.19): **DataTable** / **ListDetailsView** / **ItemsView** / **FormLayout** / **CommandPalette** / dialogs & flyouts.

Authoring rules: [`conventions.md`](conventions.md). Live checklist: Gallery **Accessibility** page.

---

## Fixed in 1.02

| Surface | Behavior |
|---------|----------|
| `SettingsCard` / `SettingsToggleCard` | Toggle rows are one Tab stop; Space/Enter toggles; `Accessible.CheckBox` uses `title`; Switch is `Accessible.ignored` |
| `NavigationView` | Back, pane expand/collapse, nav items, nested children, Settings footer expose `Accessible.name` — recipe [navigation.md](navigation.md) (1.27) |
| `ContentDialog` | Accessible name = title (no duplicate description); Esc / default Enter already wired |
| `InfoBar` / `Toast` | Severity in description; Esc dismiss; Close has Button role + keyboard activate |

`Theme.duration()` / `Theme.reducedMotion` already collapse most Behaviors and dialog transitions on this path.

---

## Wave 2 checklist (1.19 — Done)

| Surface | Status | Behavior |
|---------|--------|----------|
| `DataTable` | **Done** | Table role; `accessibleName`; filter named; headers sort state; **rows** announce first cell + selection; Tab/arrows |
| `ListDetailsView` | **Done** | Pane/`accessibleName`; list + **row** names from title/subtitle; Esc → list in SinglePane; Back named |
| `ItemsView` | **Done** | List/`accessibleName` + count/selection description; ListTile names; multi CheckBox ignored; PageUp/Down / Space / Ctrl+A |
| `FormLayout` + headered fields | **Done** | Form/`accessibleName`; error count in description; fields put `errorMessage` in Accessible.description |
| `ValidationSummary` | **Done** | AlertMessage; title + joined errors |
| `CommandPalette` / CommandBar / MenuFlyout | **Done** | See [commands.md](commands.md) (1.15) |
| `ContentDialog` / Flyout / TeachingTip / Drawer | **Done** | Dialogs recipe (1.16) + TeachingTip subtitle description; Drawer Pane name (1.19) |

---

## Data collections (1.07 / 1.19)

| Surface | Behavior |
|---------|----------|
| `DataTable` | Table role; `accessibleName`; filter Accessible name; column headers expose sort state + press action; row ListItems; Tab / Down from filter into rows |
| `ListDetailsView` | `accessibleName` / `listAccessibleName`; list rows named; SinglePane **Back** named; Esc returns to list |
| `ItemsView` | `accessibleName`; roving focus; PageUp/Down; multi-select CheckBox ignored |

Recipe doc: [`data-collections.md`](data-collections.md).

---

## Forms & settings (1.08 / 1.19)

| Surface | Behavior |
|---------|----------|
| `FormLayout` | `accessibleName`; Form role; description = validation error count |
| Headered fields / `RadioButtons` | `errorMessage` in Accessible.description; combo matches text error chrome |
| `SettingsExpander` | `header` alias; nested cards without wrapper |

Recipe doc: [`forms.md`](forms.md).

---

## Commands & menus (1.15)

| Surface | Behavior |
|---------|----------|
| `CommandPalette` | Dialog + search names; list rows announce `title` (+ shortcut); ↑↓ / Enter / Esc |
| `CommandBar` | ToolBar role; more/toggle buttons named; F10 / Alt+Down opens overflow |
| `MenuFlyout` / `MenuFlyoutItem` | Menu `title`; item name = `text`; accelerator → description |
| `MenuBar` | Style exposes MenuBar name; prefer `Action.shortcut` |

Recipe doc: [`commands.md`](commands.md).

---

## Dialogs & flyouts (1.16 / 1.19)

| Surface | Behavior |
|---------|----------|
| `ContentDialog` | Esc uses close/`requestClose` (honors `onClosing` cancel); Enter → defaultButton |
| `Flyout` / `TeachingTip` | Light-dismiss; Accessible name from title; TeachingTip description = subtitle |
| `Drawer` | Style modal edge panel; Accessible Pane name; parent window Overlay |

Recipe doc: [`dialogs-flyouts.md`](dialogs-flyouts.md).

---

## Shell extras (1.17)

| Helper | A11y note |
|--------|-----------|
| Taskbar progress / badge | Visual-only OS chrome; pair with in-app ProgressBar / InfoBadge |
| `requestUserAttention` | Not a screen-reader announcement — also toast / InfoBar |
| `revealFileInFolder` | External Explorer/FM; announce success/failure in-app |
| Idle inhibit | Prefer an explicit Switch / status label (`idleInhibited`) |

Recipe doc: [`shell-extras.md`](shell-extras.md).

---

## WebView2 (1.18)

| Topic | Note |
|-------|------|
| Focus | Tab / `focusBrowser()` moves into the HWND browser; set `Accessible.name` on the host |
| Runtime missing | Prefer EmptyState + Retry over a blank HWND |
| Screen readers | Browser content uses Edge a11y tree — pair with in-app chrome labels |

Recipe doc: [`webview2.md`](webview2.md).

---

## Media (1.21)

| Topic | Note |
|-------|------|
| Optional dep | Stub when Multimedia missing — check `available` |
| Keyboard | Space / Enter toggles play on the host |
| Screen readers | Transport ToolButtons named; prefer `accessibleName` |

Recipe doc: [`media.md`](media.md).

---

## Severity-tracked (after 1.19)

| Item | Severity | Owner / notes |
|------|----------|---------------|
| Charts / gauges Accessible completeness | Low | Deferred to charts promote (roadmap ~1.23); use Graphic + label |
| Full keyboard audit of every Extra | Medium | Wave-2 surfaces Done; remaining Extras as pages are touched |
| Linux AT backends (Orca) | Medium | Follows Qt; validate on Wayland after packaging smoke |
| Live region announcements for toast stacks | Low | Host roles are AlertMessage; OS polish later |

---

## App author checklist

1. Prefer types in [`stable-api.md`](stable-api.md).
2. Icon-only controls: set `toolTipText` or `Accessible.name`. See [icons.md](icons.md) (1.29).
3. Override `accessibleName` on DataTable / ItemsView / ListDetailsView / FormLayout when multiple instances share a page.
4. Wire Gallery/Settings “Follow system accessibility” or copy `WindowHelper` SPI into `Theme.*`.
5. Do not attach `Accessible` to `Window` / `Popup` / `Dialog` hosts — name chrome items instead.
