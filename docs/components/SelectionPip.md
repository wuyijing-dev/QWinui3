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

## Methods

- `snapTo(index)` — Snap the selection pip instantly
- `animateTo(index)` — Animate the selection pip to the target

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
