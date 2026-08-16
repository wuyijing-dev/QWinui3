# RadioButtons

Grouped radio options from a model (WinUI RadioButtons).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/RadioButtons.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/RadioButtons.qml)

**Category:** Buttons & commands · **Library:** v1.00

[← Component index](../components.md)

**Gallery:** `RadioButtons` — [`src/gallery/pages/RadioButtonsPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/RadioButtonsPage.qml)

**Extends** `Control`.

## Example

```qml
RadioButtons {
    header: qsTr("Theme")
    model: [qsTr("Light"), qsTr("Dark"), qsTr("System")]
    selectedIndex: 0
    onSelected: function (index, item) { … }
}
```

## Notes

Grouped RadioButton column/grid from model; selectedIndex / selectedItem.
maxColumns wraps the grid (WinUI MaxColumns); horizontal=true is one row.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `header` | `string` | Header label above the control |
| `description` | `string` | Supporting description text |
| `model` | `var` | Data model / item list for this control |
| `itemsSource` | `alias` | WinUI ItemsSource alias of model |
| `currentIndex` | `int` | Selected index |
| `selectedIndex` | `alias` | Selected index alias |
| `maxColumns` | `int` | WinUI MaxColumns — 0/1 = single column; >1 wraps into a grid |
| `horizontal` | `bool` | Horizontal orientation when true (all items in one row) |
| `selectedItem` | `var` | Currently selected model item (WinUI SelectedItem) |

### Signals

| Signature | Description |
| --- | --- |
| `selected(int index, var item)` | Selected state |
| `selectionChanged(int index)` | Selection changed |

### Methods

| Signature | Description |
| --- | --- |
| `select(index)` | Select item by index |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
