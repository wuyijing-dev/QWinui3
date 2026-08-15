# CommandBar

Primary/secondary command row (AppBar host).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/CommandBar.qml`](../../src/extras/QWinUI3/Extras/CommandBar.qml)

[← Component index](../components.md)

## Usage

```qml
CommandBar {
    AppBarButton { text: qsTr("Add"); symbol: FluentIcons.Add }
}
```

## Properties

- `contentData: alias` — Default children / content slot
- `primaryCommands: alias` — Primary command host
- `overflowMenu: alias` — Overflow Menu for secondary commands
- `overflowItems: var` — [{ text: string, triggered: function() }] — MenuItem cannot parent to Menu in Qt 6
- `secondaryCommands: alias` — Secondary command host
- `barSpacing: real` — Spacing between commands
- `isOpen: bool` — Open / visible state
- `defaultLabelPosition: string` — Default AppBar label position
- `closedDisplayMode: string` — How labels show when closed
- `isMoreButtonVisible: bool` — Show overflow (…) button
- `isToggleButtonVisible: bool` — Show toggle / more button
- `effectiveLabelPosition: string` — Resolved label position
- `modelData: var`

## Signals

- `opening()` — True while opening
- `closing()` — True while closing
- `opened()` — Emitted when opened
- `closed()` — Swipe content closed
- `moreButtonClicked()` — Overflow more button clicked

## Methods

- `open()` — Open
- `close()` — Close
- `toggle()` — Toggle

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
