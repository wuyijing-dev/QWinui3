# CommandBar

Primary/secondary command row (AppBar host).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/CommandBar.qml`](../../src/extras/QWinUI3/Extras/CommandBar.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
CommandBar {
    id: commandBar
    AppBarButton { text: qsTr("Add"); symbol: FluentIcons.Add }
    // JS overflow (compat):
    // overflowItems / secondaryCommands: [{ text, triggered }]
    // Real AppBar secondary host:
    // secondaryCommandsHost: AppBarButton { text: qsTr("Find"); … }
}

// --- API ---
// signals: onOpening, onClosing, onOpened, onClosed, onMoreButtonClicked
// methods: open(), close(), toggle()
// primary: default children → primaryCommands
// secondary: secondaryCommandsHost (AppBar*) and/or overflowItems / secondaryCommands
```

## Notes

Primary + secondary AppBar command row; overflow via secondary commands.
secondaryCommandsHost accepts AppBarButton / AppBarToggleButton children.
secondaryCommands / overflowItems keep the JS [{text, triggered}] API.
isDynamicOverflowEnabled moves overflowing primary commands into (…).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `contentData` | `alias` | Default children / content slot |
| `primaryCommands` | `alias` | Primary command host |
| `overflowMenu` | `alias` | Overflow Menu for secondary commands |
| `overflowItems` | `var` | [{ text: string, triggered: function() }] — MenuItem cannot parent to Menu in Qt 6 |
| `secondaryCommands` | `alias` | Compat alias of overflowItems (JS secondary list) |
| `secondaryCommandsHost` | `alias` | WinUI-style secondary AppBar elements (hidden host → overflow Menu) |
| `barSpacing` | `real` | Spacing between commands |
| `isOpen` | `bool` | Open / visible state |
| `defaultLabelPosition` | `string` | Default AppBar label position |
| `closedDisplayMode` | `string` | How labels show when closed |
| `isMoreButtonVisible` | `bool` | Show overflow (…) button |
| `isToggleButtonVisible` | `bool` | Show toggle / more button |
| `isDynamicOverflowEnabled` | `bool` | WinUI IsDynamicOverflowEnabled — move overflowing primary commands into (…) |
| `effectiveLabelPosition` | `string` | Resolved label position |

### Signals

| Signature | Description |
| --- | --- |
| `opening()` | True while opening |
| `closing()` | True while closing |
| `opened()` | Emitted when opened |
| `closed()` | Swipe content closed |
| `moreButtonClicked()` | Overflow more button clicked |

### Methods

| Signature | Description |
| --- | --- |
| `open()` | Open / show |
| `close()` | Close / dismiss |
| `toggle()` | Toggle checked / expanded state |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
