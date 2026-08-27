# CommandPalette

Ctrl+K style command launcher (fuzzy filter + keyboard).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/CommandPalette.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/CommandPalette.qml)

**Category:** Buttons & commands · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `CommandPalette` — [`src/gallery/pages/CommandPalettePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/CommandPalettePage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Popup`.

## Example

```qml
CommandPalette {
    id: palette
    commands: [
        { title: qsTr("Settings"), subtitle: qsTr("Open settings"),
          shortcut: "Ctrl+,", symbol: FluentIcons.Settings, action: openSettings }
    ]
}
palette.open()

// --- API ---
// commands: [{ title, subtitle?, shortcut?, symbol?, keywords?, action|onTriggered }]
// methods: open(), close(), toggle()
// signals: commandTriggered(var), closed()
```

## Notes

Place under Overlay.overlay (ShellWindow wires Ctrl+K / Meta+K when commandPaletteEnabled).
Keyboard: type to filter; ↑↓ move highlight; Enter runs; Esc closes.
Each row exposes Accessible.name from title (+ shortcut in description).
Large lists (2.16): filterDebounceMs + maxResults + _lastFilterKey skip.
Recent commands (2.59 / 2.87 D20): maxRecentCommands + optional command id for recentKeyRole;
persistRecents stores capped ring in Settings (recentsSettingsCategory).
Accelerator discovery (2.41): filter matches shortcut string; commandCount / filteredCount.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `commands` | `var` | — |
| `registry` | `var` | Optional CommandRegistry — auto-discovered scopes merge ahead of commands (2.68 D4) |
| `placeholderText` | `string` | — |
| `maxVisible` | `int` | — |
| `paletteWidth` | `real` | — |
| `filterDebounceMs` | `int` | Debounce filter keystrokes (2.16 — large command lists). |
| `maxResults` | `int` | Cap filtered rows before ListView bind (2.16). |
| `maxRecentCommands` | `int` | Pin recently run commands when query is empty (2.59). |
| `recentKeyRole` | `string` | — |
| `persistRecents` | `bool` | Persist recent command keys in Settings (2.87 D20). |
| `recentsSettingsCategory` | `string` | — |
| `commandCount` | `int` | — |
| `filteredCount` | `int` | — |
| `recentCommandKeys` | `var` | — |

### Signals

| Signature | Description |
| --- | --- |
| `commandTriggered(var command)` | — |

### Methods

| Signature | Description |
| --- | --- |
| `clearRecentCommands()` | — |
| `open()` | — |
| `toggle()` | — |

### Inherited from `Popup`

Also available (base type / Qt Quick Controls):

- `open()` / `close()`
- `opened()` / `closed()`
- `modal` / `focus`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
