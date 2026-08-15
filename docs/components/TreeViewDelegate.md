# TreeViewDelegate

Fluent styled TreeViewDelegate.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/TreeViewDelegate.qml`](../../src/style/QWinUI3/TreeViewDelegate.qml)

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
```

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
