# SemanticZoom

Shared-selection dual view (grid ↔ index) for contacts / albums (2.62).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SemanticZoom.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SemanticZoom.qml)

**Category:** Other · **Library:** v2.80

[← Component index](../components.md)

**Gallery:** `SemanticZoom` — [`src/gallery/pages/SemanticZoomPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SemanticZoomPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
SemanticZoom {
    id: zoom
    model: contacts
    groupRole: "letter"
    GridView { /* zoomed-in grid */ }
    zoomedOut: GridView { /* A–Z index */ }
}
zoom.selectGroup("M")
zoom.toggleZoom()
```

## Notes

Experimental — one model + selectedIndex across zoomed-in / zoomed-out hosts (FL-006).
Not generic pinch/map zoom. See docs/semantic-zoom-262.md.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `var` | — |
| `groupRole` | `string` | — |
| `selectedIndex` | `int` | — |
| `selectedGroup` | `string` | — |
| `isZoomedOut` | `bool` | — |
| `canChangeViews` | `bool` | — |
| `showZoomButton` | `bool` | — |
| `zoomInLabel` | `string` | — |
| `zoomOutLabel` | `string` | — |
| `accessibleName` | `string` | — |
| `nestedInScrollView` | `bool` | Forward wheel to parent ScrollView when the inner grid cannot scroll further |
| `zoomedIn` | `alias` | — |
| `zoomedOut` | `alias` | — |
| `groupKeys` | `var` | — |

### Signals

| Signature | Description |
| --- | --- |
| `zoomChanged(bool zoomedOut)` | — |
| `selectionChanged(int index, var item)` | — |
| `groupActivated(string group)` | — |

### Methods

| Signature | Description |
| --- | --- |
| `toggleZoom()` | — |
| `zoomIn()` | — |
| `zoomOut()` | — |
| `itemAt(index)` | — |
| `selectIndex(index)` | — |
| `indexForGroup(key)` | — |
| `selectGroup(key)` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
