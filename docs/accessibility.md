# Accessibility (1.02+)

High-traffic product path: **NavigationView**, **settings cards**, **ContentDialog**, **InfoBar** / **Toast**.

Wave 2 (1.19): **DataTable** / **ListDetailsView** / **ItemsView** / **FormLayout** / **CommandPalette** / dialogs & flyouts.

Wave 3 (**1.85**): dialog / flyout **focus return**; `InfoBar` / `ImeCandidateBar` live-region announce.

Wave 4 (**2.07**): **DataTable** / **ListDetailsView** / **NavigationView** live-region announces; shell title-bar description.

Wave 5 (**2.29**): **TreeDataGrid** / **FileTree** / **ItemsWrapGrid** / **BreadcrumbBar** keyboard names + live regions for **2.21…2.24** surfaces.

Authoring rules: [`conventions.md`](conventions.md). Live checklist: Gallery **Accessibility** page (includes keyboard tour **1.44** and wave 3 **1.85**).

**Keyboard-first cookbook:** [keyboard.md](keyboard.md) (**1.44**). Touch PCs still need chords — see also [touch-pointer.md](touch-pointer.md) (**1.57**).

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

## Wave 3 checklist (1.85 — Done)

| Surface | Status | Behavior |
|---------|--------|----------|
| `ContentDialog` | **Done** | On close, focus returns to the item that had focus when the dialog opened |
| `Flyout` / `CommandBarFlyout` | **Done** | On close, focus returns to the opener (`activeFocusItem`) or `target` |
| `TeachingTip` | **Done** | Already returned focus to `target` (1.34) |
| `InfoBar` | **Done** | `AlertMessage`; Qt 6.8+ `Accessible.announce` of title + message + severity on open; 6.5 keeps role + description |
| `ImeCandidateBar` | **Done** | Announces paged candidates (or preedit) on `composeChanged` without taking focus |

Gallery **Accessibility** page has a live dialog / flyout / InfoBar sample. IME live region is on **On-screen keyboard**.

---

## Wave 4 checklist (2.07 — Done)

| Surface | Status | Behavior |
|---------|--------|----------|
| `DataTable` | **Done** | `announceChanges` (default true): `Accessible.announce` on row selection, column sort, debounced filter row count (Qt 6.8+); **2.64** group headers **StaticText**; pinned headers announce **", pinned"** |
| `ListDetailsView` | **Done** | Announces selected item / **Details for …** in SinglePane; **Returned to list** on Back / Esc; **2.64** multi-select checkbox names |
| `NavigationView` | **Done** | Announces **Navigated to …** on `selectKey` / footer; pane expand/collapse announce; public `announce(text)`; opt-in `announcePinChanges` / `announcePaneSearchChanges` (**3.56** D32) |
| Shell `PlatformTitleBar` | **Done** | `Accessible.description` = window `title`; caption Min/Max/Restore/Close named |

Set `announceChanges: false` on collection controls when a page already announces the same state (rare).

Gallery **Accessibility** page includes a wave 4 collection sample.

---

## Wave 5 checklist (2.29 — Done)

| Surface | Status | Behavior |
|---------|--------|----------|
| `TreeDataGrid` | **Done** | `accessibleName`; filter named; column headers sort state + press; **TreeItem** rows with level / row index; `announceChanges` on selection / sort / filter / expand |
| `FileTree` | **Done** | Pane name; **Tree** role on folder tree; `treeAccessibleName` / `tableAccessibleName`; Tab tree ↔ table; folder change live region (`announceChanges`) |
| `ItemsWrapGrid` | **Done** | `accessibleName`; list role + item count; filter count live region; delegates should set per-chip `Accessible.name` |
| `BreadcrumbBar` | **Done** | `accessibleName`; roving Left/Right + Enter/Space; **Navigated to …** live region (`announceChanges`); overflow **More breadcrumbs** |

Set `announceChanges: false` when a host page already announces the same navigation (same pattern as wave 4).

Gallery **Accessibility** page includes a wave 5 tree + breadcrumb sample.

---

## Data collections (1.07 / 1.19 / 2.07)

| Surface | Behavior |
|---------|----------|
| `DataTable` | Table role; `accessibleName`; filter Accessible name; column headers expose sort state + press action; row ListItems; Tab / Down from filter into rows; **live region** on selection / sort / filter (**2.07**); **group headers StaticText**, pinned headers announce (**2.64**) |
| `ListDetailsView` | `accessibleName` / `listAccessibleName`; list rows named; SinglePane **Back** named; Esc returns to list; **live region** on selection / pane (**2.07**); multi-select checkbox names (**2.64**) |
| `ItemsView` | `accessibleName`; roving focus; PageUp/Down; multi-select CheckBox ignored |
| `NavigationView` | Back / pane / items / footer names (**1.02**); **live region** on nav selection / pane toggle (**2.07**) |

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
| `ContentDialog` | Esc uses close/`requestClose` (honors `onClosing` cancel); Enter → defaultButton; **focus returns to the opener** (1.85) |
| `Flyout` / `TeachingTip` | Light-dismiss; Accessible name from title; TeachingTip description = subtitle; **focus returns to opener / target** (1.85 / 1.34) |
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

Recipe doc: [`shell-extras.md`](shell-extras.md) (**1.47**).

---

## WebView2 (1.18)

| Topic | Note |
|-------|------|
| Focus | Tab / `focusBrowser()` moves into the HWND browser; set `Accessible.name` on the host |
| Runtime missing | Prefer EmptyState + Retry over a blank HWND |
| Screen readers | Browser content uses Edge a11y tree — pair with in-app chrome labels |

Recipe doc: [`webview2.md`](webview2.md).

---

## Media (1.21 / deferred 1.67)

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
| Live region announcements for toast stacks | Low | InfoBar announces on open (1.85); Toast host roles stay AlertMessage |

---

## App author checklist

1. Prefer types in [`stable-api.md`](stable-api.md).
2. Icon-only controls: set `toolTipText` or `Accessible.name`. See [icons.md](icons.md) (1.29).
3. Override `accessibleName` on DataTable / ItemsView / ListDetailsView / FormLayout when multiple instances share a page.
4. Brand accent contrast: [color-contrast.md](color-contrast.md) (**1.43**) — Gallery Theme overrides AA table.
5. Keyboard-first shell: [keyboard.md](keyboard.md) (**1.44**) — Ctrl+K, dialogs, list arrows. After ContentDialog / Flyout, focus should return to the opener (**1.85**).
6. Touch / finger targets: [touch-pointer.md](touch-pointer.md) (**1.57**) — prefer standard density; no hover-only UI.
7. Wire Gallery/Settings “Follow system accessibility” or copy `WindowHelper` SPI into `Theme.*`.
8. Do not attach `Accessible` to `Window` / `Popup` / `Dialog` hosts — name chrome items instead.
