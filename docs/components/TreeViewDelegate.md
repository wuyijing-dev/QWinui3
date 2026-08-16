# TreeViewDelegate

Fluent TreeView row with chevron expand / indent.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/TreeViewDelegate.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/TreeViewDelegate.qml)

**Category:** Styled controls · **Library:** v1.13

[← Component index](../components.md)

## Example

```qml
TreeView {
    id: tree
    model: treeModel
    delegate: TreeViewDelegate {
        // indentation / expansion affordance from style
    }
}
// --- API ---
// inherits TreeViewDelegate: treeView, expanded, depth, indentation
// --- API ---
// inherits TreeViewDelegate: treeView, expanded, depth, indentation
```

## Notes

Style-only Fluent chrome for Qt Quick Controls TreeViewDelegate.
Public API is the Qt Quick Controls TreeViewDelegate type; this file supplies visuals/metrics only.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `row` | `int` | — |
| `model` | `var` | Data model |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
