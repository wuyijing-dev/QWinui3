# Commands & menus (1.15 · 2.16 wave 2 · 2.41 wave 3)

Keyboard / focus recipes for **command launchers**, **command bars**, and **menus**. Prefer these over inventing a parallel ribbon. Surfaces below are **stable as of 1.37** — [stable-api.md](stable-api.md).

**End-to-end keyboard app story (1.44):** [keyboard.md](keyboard.md) — global shortcuts → palette → dialogs → lists.

| Surface | Use when | Gallery |
|---------|----------|---------|
| [`CommandPalette`](components/CommandPalette.md) | Global “type to run” (Ctrl+K) | CommandPalette |
| [`CommandBar`](components/CommandBar.md) + [`AppBarButton`](components/AppBarButton.md) | Page / context tool strip | CommandBar |
| [`CommandBarFlyout`](components/CommandBarFlyout.md) | Contextual AppBar in a flyout | CommandBarFlyout |
| [`MenuFlyout`](components/MenuFlyout.md) + [`MenuFlyoutItem`](components/MenuFlyoutItem.md) | Context / overflow menu | MenuFlyout |
| Style [`MenuBar`](components/MenuBar.md) | Classic window menu bar | MenuBar |

Shell helper: `ShellWindow.commandPaletteEnabled` + `commandPaletteCommands` wires **Ctrl+K** / **Meta+K**.

---

## CommandPalette

```qml
CommandPalette {
    id: palette
    parent: Overlay.overlay
    commands: [
        {
            title: qsTr("Settings"),
            subtitle: qsTr("Open settings"),
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
| **Ctrl+K** / **Meta+K** | Open / toggle (ShellWindow or your `Shortcut`) |
| Type | Fuzzy filter on `title` / `subtitle` / `keywords` |
| **↑** / **↓** | Move highlight |
| **Enter** | Run highlighted command |
| **Esc** | Close |

**Performance (2.16):** `filterDebounceMs` (default **80**) debounces filter keystrokes; `maxResults` (default **64**) caps rows before the ListView binds. Empty query rebuilds immediately on `open()`. Identical queries skip rebuild.

**Accessible:** dialog name “Command palette”; search field; list rows use `title` (+ shortcut in description).

---

## Wave 2 — large command lists (2.16)

| Property | Default | Use |
|----------|---------|-----|
| `filterDebounceMs` | 80 | Avoid rebuilding on every key for hundreds of commands |
| `maxResults` | 64 | Cap filtered rows; tune down for very slow devices |

```qml
CommandPalette {
    filterDebounceMs: 80
    maxResults: 48
    commands: largeCommandArray
}
```


---

## Wave 3 — accelerator discovery + large lists (2.41)

**Friction:** teams ship MenuBar `Action.shortcut` chords but users cannot discover them. **Goal:** large-model CommandPalette + MenuBar accelerator recipes on the **2.x** floor — not OS-global shortcut hooks.

### Large-model CommandPalette

| Property | Default | Use |
|----------|---------|-----|
| `commandCount` | readonly | Source array size — log in dev |
| `filteredCount` | readonly | Rows after filter — footer shows “N of M” while typing |
| `filterDebounceMs` | 80 | Required for **300+** commands |
| `maxResults` | 64 | Cap ListView bind; tune down on slow devices |
| `keywords` | optional | Synonyms when title alone is ambiguous |
| `shortcut` | optional | **Also searched** — type `ctrl+c` to find Copy |

```qml
CommandPalette {
    filterDebounceMs: 80
    maxResults: 48
    commands: appCommandModel   // 500+ plain objects OK with debounce + cap
}
```

**App pattern:** build `commands` once per locale/theme change — do not rebuild the array on every filter keystroke. For dynamic backends, swap `commands` and call `open()` to reset filter state.

### MenuBar accelerators (2.x floor)

| # | Check | Pattern |
|---|--------|---------|
| 1 | Real chords | `Action { shortcut: StandardKey.Copy }` — works when menu is closed |
| 2 | Custom chords | `Action { shortcut: "Ctrl+Shift+P" }` — same string in palette `shortcut` for discovery |
| 3 | Palette mirror | Duplicate high-value MenuBar actions in `CommandPalette.commands` with the **same** `shortcut` text |
| 4 | Visual-only hints | `keyboardAcceleratorText` on CommandBar does **not** bind shortcuts — use `Action.shortcut` or `Shortcut` |
| 5 | Focus | Alt / F10 focuses MenuBar (Qt); arrows / Enter navigate open menu |

```qml
MenuBar {
    Menu {
        title: qsTr("Edit")
        Action {
            text: qsTr("Copy")
            shortcut: StandardKey.Copy
            onTriggered: copySelection()
        }
    }
}
// Discovery hub — same chord string:
CommandPalette {
    commands: [
        { title: qsTr("Copy"), shortcut: "Ctrl+C", action: copySelection }
    ]
}
```


**Out:** OS-global shortcut registration product; auto-binding every `keyboardAcceleratorText`.

---

## CommandBar

```qml
CommandBar {
    AppBarButton {
        text: qsTr("Copy")
        symbol: FluentIcons.Copy
        keyboardAcceleratorText: "Ctrl+C"
        onClicked: { /* … */ }
    }
    secondaryCommands: [
        { text: qsTr("Select all"), triggered: function () { /* … */ } }
    ]
}
```

| Key / focus | Behavior |
|-------------|----------|
| **Tab** | Moves into the bar (`focusPolicy: StrongFocus`) |
| **Space** / **Enter** | Activate focused AppBar / more / toggle button |
| **F10** or **Alt+↓** | Open overflow (**…**) when present |
| **Esc** | Close open overflow `Menu` |

Give every icon-only `AppBarButton` a `text` or `Accessible.name`. Use `keyboardAcceleratorText` for a visible chord hint (does not auto-bind a `Shortcut` — add one yourself if needed).

---

## MenuFlyout

```qml
Button {
    id: anchor
    text: qsTr("Actions")
    onClicked: flyout.showAt(anchor)
}
MenuFlyout {
    id: flyout
    title: qsTr("Actions")
    MenuFlyoutItem {
        text: qsTr("Copy")
        symbol: FluentIcons.Copy
        keyboardAcceleratorText: "Ctrl+C"
        onTriggered: { /* … */ }
    }
}
```

| Key | Behavior |
|-----|----------|
| **Esc** / outside click | Close when `isLightDismissEnabled` (default) |
| Arrows / **Enter** / **Space** | Standard `Menu` navigation |

Set `title:` for the menu’s Accessible chrome. Item `Accessible.name` follows `text`; accelerator text goes to `Accessible.description`.

---

## MenuBar

Styled `QtQuick.Controls` `MenuBar` — keyboard model is Qt’s (Alt/F10 focus, arrows, mnemonics where provided). Prefer `Action { shortcut: … }` for real chords:

```qml
MenuBar {
    Menu {
        title: qsTr("Edit")
        Action { text: qsTr("Copy"); shortcut: StandardKey.Copy; onTriggered: { /* … */ } }
    }
}
```

---

## Choosing a surface

| Need | Prefer |
|------|--------|
| App-wide searchable commands | **CommandPalette** |
| Content / form suggestions | **AutoSuggestBox** / **SearchBox** — [search.md](search.md) (**1.59**) |
| Filter an on-page list | Filter-above + model — [search.md](search.md) |
| Always-visible page actions | **CommandBar** |
| Few actions on a control | **MenuFlyout** / context menu |
| Document-style File/Edit/Help | **MenuBar** |

---

## Out of scope

Ribbon redesign, VS tool windows, auto-binding every `keyboardAcceleratorText` to a global `Shortcut`. Content search engines — [search.md](search.md).
