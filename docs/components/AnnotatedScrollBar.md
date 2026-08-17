# AnnotatedScrollBar

Scroll area with a value label on the vertical scrollbar.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/AnnotatedScrollBar.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/AnnotatedScrollBar.qml)

**Category:** Other · **Library:** v1.81

[← Component index](../components.md)

**Gallery:** `AnnotatedScrollBar` — [`src/gallery/pages/AnnotatedScrollBarPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/AnnotatedScrollBarPage.qml)

**Extends** `Control`.

## Example

```qml
AnnotatedScrollBar {
    id: scroll
    anchors.fill: parent
    // string[] (even spacing) OR [{ content|text, scrollOffset }]
    // scrollOffset: 0..1 normalized, or >=1 absolute contentY
    labels: [
        { content: "Intro", scrollOffset: 0 },
        { content: "Body", scrollOffset: 0.45 },
        { content: "End", scrollOffset: 0.9 }
    ]
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
// read:  scroll.scrollPosition, scroll.currentLabel, scroll.detailLabel, scroll.activeLabelIndex
// write: scroll.contentY = …  or  scroll.jumpToLabel(index)
// size:  scroll.contentWidth / contentHeight / flickable
```

## Notes

Place tall content as children (default property → Flickable).
Vertical ScrollBar is AlwaysOn when content overflows; floating label
(ElevatedChrome) shows while scrolling / hovering / pressing the bar,
or when alwaysShowLabel is true.
labels: string[] (even sample) or AnnotatedScrollBarLabel-like
{ content|text, scrollOffset }. scrollOffset 0..1 or absolute contentY (>=1).

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
| `labels` | `var` | string[] or [{ content\|text, scrollOffset }] |
| `labelFormat` | `string` | Percent format when labels is empty (Qt arg: "%1%") |
| `detailLabel` | `string` | Optional secondary line under currentLabel (e.g. chapter detail) |
| `alwaysShowLabel` | `bool` | Keep the floating scrollbar label visible even when idle |
| `labelsInteractive` | `bool` | When true, clicking a label marker jumps to that offset |
| `scrollPosition` | `real` | Normalized vertical scroll position 0..1 |
| `activeLabelIndex` | `int` | Index of the nearest label for the current scroll position |
| `currentLabel` | `string` | Label for the current scroll position (from labels[] or labelFormat) |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `jumpToLabel(index)` | Jump to a label by index |
| `scrollToPosition(norm)` | Scroll so the given normalized 0..1 position is shown |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
