# Timeline

Vertical event timeline.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/Timeline.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/Timeline.qml)

**Category:** Collections & data · **Library:** v1.77

[← Component index](../components.md)

**Gallery:** `Timeline` — [`src/gallery/pages/TimelinePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/TimelinePage.qml)

**Extends** `Control`.

## Example

```qml
Timeline {
    id: timeline
    model: events
}

// --- API ---
// signals: onItemClicked, onSelectionChanged
// methods: select(index), next(), previous()
// timeline.select(index)
// timeline.next()
// timeline.previous()
```

## Notes

Vertical timeline of events; model items with title/time/description.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `var` | Data model / item list for this control |
| `currentIndex` | `int` | Selected index |
| `selectedIndex` | `alias` | Selected index alias |
| `railWidth` | `real` | Track / rail width |
| `nodeSize` | `real` | Node / marker size |
| `isInteractive` | `bool` | Alias of interactive |

### Signals

| Signature | Description |
| --- | --- |
| `itemClicked(int index)` | Emitted when an item is clicked |
| `selectionChanged(int index)` | Selection changed |

### Methods

| Signature | Description |
| --- | --- |
| `select(index)` | Select item by index |
| `next()` | Advance to next |
| `previous()` | Go to previous |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
