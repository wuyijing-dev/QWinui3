# AnnotatedScrollBar

Scroll area with a value label on the vertical scrollbar.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/AnnotatedScrollBar.qml`](../../src/extras/QWinUI3/Extras/AnnotatedScrollBar.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
AnnotatedScrollBar {
    id: scroll
    anchors.fill: parent
    // labels: sampled by scrollPosition (0..1). Empty → labelFormat with percent.
    labels: ["Intro", "Body", "End"]
    labelFormat: "%1%"
    alwaysShowLabel: false
    Column {
        width: scroll.flickable.width
        Repeater {
            model: 40
            Label { text: "Row " + (index + 1); height: 36 }
        }
    }
}

// --- API ---
// read:  scroll.scrollPosition (0..1), scroll.currentLabel
// write: scroll.contentY = …  or  scroll.flickable.contentY = …
// size:  scroll.contentWidth / contentHeight / flickable
// inherits Control: padding, font, contentItem
```

## Notes

Place tall content as children (default property → Flickable).
Vertical ScrollBar shows a floating label (ElevatedChrome) while scrolling
unless alwaysShowLabel is true.
labels is a string[]; index = round(scrollPosition * (length-1)).
When labels is empty, currentLabel = labelFormat.arg(percent).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `contentData` | `alias` | Default children / content slot (hosted in the inner Flickable) |
| `contentWidth` | `alias` | Flickable content width |
| `contentHeight` | `alias` | Flickable content height |
| `contentX` | `alias` | Flickable content X |
| `contentY` | `alias` | Flickable content Y — set this (or flickable.contentY) to scroll programmatically |
| `flickable` | `alias` | Inner Flickable (bounds, contentItem, ScrollBar.vertical, …) |
| `labels` | `var` | Optional string[] sampled by scrollPosition; empty → percentage via labelFormat |
| `labelFormat` | `string` | Percent format when labels is empty (Qt arg: "%1%") |
| `alwaysShowLabel` | `bool` | Keep the floating scrollbar label visible even when idle |
| `scrollPosition` | `real` | Normalized vertical scroll position 0..1 |
| `currentLabel` | `string` | Label for the current scroll position (from labels[] or labelFormat) |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
