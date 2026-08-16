# Commands & menus (1.15)

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

**Accessible:** dialog name “Command palette”; search field; list rows use `title` (+ shortcut in description).

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
| Always-visible page actions | **CommandBar** |
| Few actions on a control | **MenuFlyout** / context menu |
| Document-style File/Edit/Help | **MenuBar** |

---

## Out of scope

Ribbon redesign, VS tool windows, auto-binding every `keyboardAcceleratorText` to a global `Shortcut`.
