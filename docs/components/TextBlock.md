# TextBlock

Fluent typography styles (title, body, caption…).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TextBlock.qml`](../../src/extras/QWinUI3/Extras/TextBlock.qml)

[← Component index](../components.md)

## Usage

```qml
TextBlock { text: qsTr("Title"); style: title }
```

## Properties

- `caption: int` — Caption under / beside the value
- `body: int` — Body style
- `bodyStrong: int` — Body strong style
- `subtitle: int` — Secondary subtitle text
- `title: int` — Primary title text
- `titleLarge: int` — Title large style
- `display: int` — Display typography style
- `text: string` — Display / input text
- `style: int` — Typography style token
- `isTextSelectionEnabled: bool` — WinUI IsTextSelectionEnabled — uses TextEdit when true (Label has no selectByMouse)
- `textTrimming: string` — none | characterEllipsis | wordEllipsis
- `maxLines: int` — Maximum wrapped line count
- `color: color` — Primary color
- `styleName: string` — Current style name

## Methods

- `setStyleName(name)` — Set style by name

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
