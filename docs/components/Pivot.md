# Pivot

Header tabs with sliding underline and pages.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/Pivot.qml`](../../src/extras/QWinUI3/Extras/Pivot.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
Pivot {
    id: pivot
    model: ["Overview", "Details"]
}

// --- API ---
// signals: onCurrentIndexChangedByUser, onSelectionChanged
// methods: selectIndex(index)
// pivot.selectIndex(index)
```

## Notes

Tab-like pivot headers + content; model or PivotItem children.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `var` | Data model / item list for this control |
| `currentIndex` | `int` | Selected index |
| `selectedIndex` | `alias` | Selected index alias |
| `keyboardNavigationEnabled` | `bool` | Allow arrow-key navigation |

### Signals

| Signature | Description |
| --- | --- |
| `currentIndexChangedByUser(int index)` | Selection changed by user |
| `selectionChanged(int index)` | Selection changed |

### Methods

| Signature | Description |
| --- | --- |
| `selectIndex(index)` | Select by index |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
