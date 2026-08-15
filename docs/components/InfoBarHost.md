# InfoBarHost

Stacks InfoBars in a host region.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/InfoBarHost.qml`](../../src/extras/QWinUI3/Extras/InfoBarHost.qml)

[← Component index](../components.md)

## Usage

```qml
InfoBarHost { id: bars }
// bars.enqueue({ title: "Hi", severity: InfoBar.Informational })
```

## Properties

- `maxVisible: int` — Max visible items before overflow
- `count: int` — Item count
- `openCount: int` — Number of open items

## Methods

- `closeAll()` — Close all open items
- `clearAll()` — Clear all items
- `openAll()` — Expand / open all items

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
