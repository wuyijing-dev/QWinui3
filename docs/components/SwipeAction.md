# SwipeAction

Action revealed by SwipeControl.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SwipeAction.qml`](../../src/extras/QWinUI3/Extras/SwipeAction.qml)

[← Component index](../components.md)

## Usage

```qml
SwipeAction { text: qsTr("Delete"); onTriggered: remove() }
```

## Properties

- `text: string` — Display / input text
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `color: color` — Color
- `textColor: color` — Badge / content text color
- `leading: bool` — Leading content slot
- `effectiveGlyph: string` — Resolved glyph string

## Signals

- `clicked()` — Emitted when clicked

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
