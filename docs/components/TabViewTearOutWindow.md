# TabViewTearOutWindow

Host window for a torn-out TabView tab.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TabViewTearOutWindow.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/TabViewTearOutWindow.qml)

**Category:** Shells & windows · **Library:** v2.65

[← Component index](../components.md)

**Extends** `BlankWindow`.

## Example

```qml
Loaded at runtime via Qt.createComponent(URL) from TabView so the two types
do not form a compile-time dependency cycle.

TabView { canTearOutTabs: true; createTearOutWindow: true }

close() only hides a dynamically created ApplicationWindow. dismiss() hides
and destroy()s the host so it cannot keep running after the last tab is
closed, docked back, or the source TabView is recycled.
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `tabData` | `var` | — |
| `tabModel` | `var` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `dismiss()` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
