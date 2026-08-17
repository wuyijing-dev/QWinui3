# CommandPalette

Ctrl+K style command launcher (fuzzy filter + keyboard).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/CommandPalette.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/CommandPalette.qml)

**Category:** Buttons & commands · **Library:** v2.64

[← Component index](../components.md)

**Gallery:** `CommandPalette` — [`src/gallery/pages/CommandPalettePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/CommandPalettePage.qml)

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
Recent commands (2.59): maxRecentCommands + optional command id for recentKeyRole.
Accelerator discovery (2.41): filter matches shortcut string; commandCount / filteredCount.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `commands` | `var` | — |
| `placeholderText` | `string` | — |
| `maxVisible` | `int` | — |
| `paletteWidth` | `real` | — |
| `filterDebounceMs` | `int` | Debounce filter keystrokes (2.16 — large command lists). |
| `maxResults` | `int` | Cap filtered rows before ListView bind (2.16). |
| `maxRecentCommands` | `int` | Pin recently run commands when query is empty (2.59). |
| `recentKeyRole` | `string` | — |
| `commandCount` | `int` | — |
| `filteredCount` | `int` | — |

### Signals

| Signature | Description |
| --- | --- |
| `commandTriggered(var command)` | — |

### Methods

| Signature | Description |
| --- | --- |
| `open()` | — |
| `toggle()` | — |

### Inherited from `Popup`

Also available (base type / Qt Quick Controls):

- `open()` / `close()`
- `opened()` / `closed()`
- `modal` / `focus`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
