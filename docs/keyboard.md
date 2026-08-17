# Keyboard-first app cookbook (1.44)

End-to-end keyboard story for a QWinUI3 LoB shell: **global chords → CommandPalette → dialogs → lists → focus rings**. Prefer this over scattering one-off `Shortcut` / Tab hacks.

| Layer | Doc / surface |
|-------|----------------|
| Commands & menus | [commands.md](commands.md) |
| In-app search / suggest | [search.md](search.md) (**1.59**) |
| Dialogs Esc/Enter | [dialogs-flyouts.md](dialogs-flyouts.md) |
| Lists / tables | [data-collections.md](data-collections.md) · [tree-data.md](tree-data.md) |
| Names / a11y | [accessibility.md](accessibility.md) · [conventions.md](conventions.md) |
| Touch / pen | [touch-pointer.md](touch-pointer.md) (**1.57**) |
| On-screen keyboard | [on-screen-keyboard.md](on-screen-keyboard.md) (**1.70…1.73** shipped; **1.74…1.76** planned) — OSK → IME soak / extra packs / MIT deepen, not Qt Virtual Keyboard |
| Focus chrome | `FocusStroke` / Theme focus tokens |

Gallery tour: **Accessibility** (checklist) · **Touch & pointer** · **CommandPalette** · **CommandBar** · **ContentDialog** · **DataTable** / **ListDetailsView** · Settings (page transition / a11y).

---

## Supported app shape

```text
Shortcut Ctrl+K  →  CommandPalette (searchable actions)
MenuBar Actions  →  StandardKey / explicit shortcut:
CommandBar       →  Tab into strip; Space/Enter; F10 overflow
ContentDialog    →  Esc close · Enter default
Lists / tables   →  Arrows · Home/End · Enter · Esc (where documented)
Focus            →  Theme focus rings; icon-only needs Accessible.name
```

Do **not**: invent a second ribbon; auto-bind every `keyboardAcceleratorText` without a real `Shortcut`/`Action`; skip names on icon-only buttons.

---

## 1. Global shortcuts

```qml
import QtQuick
import QWinUI3.Extras

Shortcut {
    sequences: [StandardKey.Find, "Ctrl+K"]
    onActivated: palette.open()
}

Shortcut {
    sequence: StandardKey.Preferences  // Ctrl+, on many platforms
    onActivated: openSettings()
}
```

| Tip | Detail |
|-----|--------|
| Prefer `StandardKey.*` | Survives platform chord differences |
| One owner | Shell (`ShellWindow.commandPaletteEnabled`) **or** page-level `Shortcut` — not both fighting |
| Document in palette | Put the same chord string in `commands[].shortcut` for discovery |
| Visible hints | `KeyChordVisual` / `AppBarButton.keyboardAcceleratorText` — still add a real `Shortcut` |

---

## 2. CommandPalette (hub)

```qml
CommandPalette {
    id: palette
    parent: Overlay.overlay
    commands: [
        {
            title: qsTr("Settings"),
            shortcut: "Ctrl+,",
            symbol: FluentIcons.Settings,
            keywords: "prefs options",
            action: openSettings
        }
    ]
}
Shortcut { sequences: ["Ctrl+K"]; onActivated: palette.open() }
```

| Key | Behavior |
|-----|----------|
| **Ctrl+K** / **Meta+K** | Open / toggle |
| Type | Filter `title` / `subtitle` / `keywords` |
| **↑** / **↓** | Move highlight |
| **Enter** | Run command |
| **Esc** | Close |

Full tables: [commands.md](commands.md). ShellWindow can wire Ctrl+K for you.

---

## 3. CommandBar / MenuFlyout / MenuBar

| Surface | Keyboard |
|---------|----------|
| **CommandBar** | Tab into bar; Space/Enter activate; **F10** / **Alt+↓** overflow; Esc closes overflow |
| **MenuFlyout** | Esc / light-dismiss; arrows / Enter / Space |
| **MenuBar** | Alt/F10; `Action { shortcut: … }` for real chords |

`keyboardAcceleratorText` is **visual only** — bind `Shortcut` or `Action.shortcut` yourself.

---

## 4. Dialogs & flyouts

| Surface | Esc | Enter |
|---------|-----|-------|
| **ContentDialog** | `requestClose` (honors `onClosing`) | `activateDefault()` |
| **Flyout** / light-dismiss | Esc + outside (when enabled) | Activate focused control |
| **TeachingTip** | Dismiss path + focus return — [feedback.md](feedback.md) |
| **Onboarding coach** | Sequenced tips: Esc ends tour; Next/Done after Close focus — [feedback.md](feedback.md) (**1.55**) |
| **Drawer** | Esc / scrim (Qt Drawer) | — |

Always set a **default** button on confirm dialogs so Enter is meaningful.

---

## 5. Lists, tables, trees (roving focus)

| Surface | Model |
|---------|--------|
| **DataTable** | Tab in (or ↓ from filter); arrows / Home/End / PageUp/Down; Enter activates; Esc clears |
| **ItemsView** | Roving focus; PageUp/Down; Space / Ctrl+A when multi-select |
| **ListDetailsView** | Arrows / Home/End; Enter opens details (SinglePane); Esc / Back → list |
| **TreeView** | ←/→ expand-collapse — [tree-data.md](tree-data.md) |
| **NavigationView** | Pane keys / type-ahead; compact flyout ↑↓ Enter Esc |

Treat the list as **one Tab stop** with arrow roving inside — don’t Tab every row.

---

## 6. Focus rings & names

| Do | Avoid |
|----|--------|
| Rely on Style / `FocusStroke` + Theme focus tokens | Custom 1px rings that ignore `Theme.highContrast` |
| `toolTipText` / `Accessible.name` on icon-only | Glyph-only buttons |
| `accessibleName` on DataTable / FormLayout / ItemsView when several share a page | Duplicate empty “ListItem” |
| Honor `Theme.reducedMotion` | Long focus animations that ignore reduced motion |

---

## Critical Gallery flows (checklist)

Complete **without a mouse** (Release Gallery):

- [ ] **Ctrl+K** opens CommandPalette; type + Enter runs a command; Esc closes  
- [ ] Title-bar / pane search: type and activate a result (or Tab to nav)  
- [ ] Open **ContentDialog** sample: Esc closes; Enter hits default  
- [ ] **DataTable** or **ListDetailsView**: arrows move selection; Enter / Esc as documented  
- [ ] **Settings** toggle card: Tab focuses row; Space toggles  
- [ ] **InfoBar** / Toast (when shown): Esc dismisses if closable  
- [ ] Icon-only **IconButton** still announces via ToolTip / Accessible name  

Smoke CI instantiates critical pages — it does **not** replace this manual keyboard pass.

---

## App wiring sketch

```qml
StandardWindow {
    // …
    Shortcut {
        sequences: ["Ctrl+K"]
        onActivated: commandPalette.open()
    }
    // NavigationView + page stack…
    // CatalogPage.overlay / Overlay.overlay hosts CommandPalette + dialogs
}
```

Or ship `ShellWindow { commandPaletteEnabled: true; commandPaletteCommands: […] }`.

---

## Out of scope (1.44)

- Custom shortcut-editor control as a product  
- Auto-binding every accelerator label to a global Shortcut  
- Full audit of every Extra (track via [accessibility.md](accessibility.md) severity table)
- On-screen / touch keyboard and in-app IME — that is **1.70…1.76** ([on-screen-keyboard.md](on-screen-keyboard.md)), not this cookbook
