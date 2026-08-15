# SelectionPip

Navigation selection pip indicator.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/SelectionPip.qml`](../../src/style/QWinUI3/SelectionPip.qml)

[← Component index](../components.md)

> Internal / support type — not part of the public Gallery surface.

## Usage

```qml
SelectionPip { }
```

## Properties

- `listView: var` — ListView this pip tracks
- `targetIndex: int` — Index the pip should track
- `baseHeight: real` — Pip rest height
- `leftMargin: real` — Pip left inset
- `instant: bool` — Skip motion when true
- `contentFromY: real` — Scroll animation start
- `contentToY: real` — Scroll animation end
- `progress: real` — 0..1 animation / progress
- `ready: bool` — True when the control is ready
- `eased: real` — Eased 0..1 animation progress
- `travel: real` — Absolute travel distance for the pip
- `stretch: real` — Stretch factor / stretch pip
- `contentCenterY: real` — Animated content center Y
- `visualHeight: real` — Current visual height (stretch / animation)
- `contentY: real` — Flickable content Y

## Methods

- `contentYForIndex(index)` — contentY that scrolls index into view
- `currentContentY()` — Current Flickable contentY
- `moveTo(index, forceInstant, retries)` — Move to the given index / position
- `onContentYChanged()`
- `onHeightChanged()`
- `onCountChanged()`
- `snapTo(index)`
- `animateTo(index)`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
