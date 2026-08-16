# Accessibility (1.02+)

High-traffic product path: **NavigationView**, **settings cards**, **ContentDialog**, **InfoBar** / **Toast**.

Authoring rules: [`conventions.md`](conventions.md). Live checklist: Gallery **Accessibility** page.

---

## Fixed in 1.02

| Surface | Behavior |
|---------|----------|
| `SettingsCard` / `SettingsToggleCard` | Toggle rows are one Tab stop; Space/Enter toggles; `Accessible.CheckBox` uses `title`; Switch is `Accessible.ignored` |
| `NavigationView` | Back, pane expand/collapse, nav items, nested children, Settings footer expose `Accessible.name` |
| `ContentDialog` | Accessible name = title (no duplicate description); Esc / default Enter already wired |
| `InfoBar` / `Toast` | Severity in description; Esc dismiss; Close has Button role + keyboard activate |

`Theme.duration()` / `Theme.reducedMotion` already collapse most Behaviors and dialog transitions on this path.

---

## Data collections (1.07)

| Surface | Behavior |
|---------|----------|
| `DataTable` | Table role; filter Accessible name; column headers expose sort state + press action; Tab / Down from filter into rows |
| `ListDetailsView` | List Accessible name; SinglePane **Back** named; Esc returns to list |
| `ItemsView` | Existing roving focus; PageUp/Down parity with DataTable |

Recipe doc: [`data-collections.md`](data-collections.md).

---

## Forms & settings (1.08)

| Surface | Behavior |
|---------|----------|
| `FormLayout` | `clearErrors` walks the same tree as `collectErrors` |
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

## Severity-tracked (not 1.02)

| Item | Severity | Notes |
|------|----------|-------|
| Charts / gauges Accessible completeness | Low | Deferred; use Graphic + label when shipping dashboards |
| Full keyboard audit of every Extra | Medium | Track per control as pages are touched |
| Linux AT backends (Orca) | Medium | Follows Qt; validate on Wayland after packaging smoke |
| Live region announcements for toast stacks | Low | Host roles are AlertMessage; OS polish later |

---

## App author checklist

1. Prefer types in [`stable-api.md`](stable-api.md).
2. Icon-only controls: set `toolTipText` or `Accessible.name`.
3. Wire Gallery/Settings “Follow system accessibility” or copy `WindowHelper` SPI into `Theme.*`.
4. Do not attach `Accessible` to `Window` / `Popup` / `Dialog` hosts — name chrome items instead.
