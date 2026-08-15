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
- `ready: bool` — Ready
- `eased: real` — Eased
- `travel: real` — Travel
- `stretch: real` — Stretch factor / stretch pip
- `contentCenterY: real` — Content Center Y
- `visualHeight: real` — Visual Height
- `contentY: real` — Flickable content Y

## Methods

- `contentYForIndex(index)` — Content YFor Index
- `currentContentY()` — Current Content Y
- `moveTo(index, forceInstant, retries)` — Move To
- `onContentYChanged()`
- `onHeightChanged()`
- `onCountChanged()`
- `snapTo(index)`
- `animateTo(index)`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
