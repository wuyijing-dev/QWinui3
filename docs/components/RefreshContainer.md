# RefreshContainer

Pull-to-refresh host for flickable content.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/RefreshContainer.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/RefreshContainer.qml)

**Category:** Other · **Library:** v1.14

[← Component index](../components.md)

**Gallery:** `RefreshContainer` — [`src/gallery/pages/RefreshContainerPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/RefreshContainerPage.qml)

**Extends** `Control`.

## Example

```qml
RefreshContainer {
    id: refresh
    onRefreshRequested: {
        load()
        refresh.endRefresh()
    }
    ListView { model: items; /* … */ }
}
// --- API ---
// refresh.beginRefresh() / endRefresh()
// signals: onRefreshRequested
```

## Notes

Pull-to-refresh wrapper; onRefreshRequested then endRefresh() when done.
pullDirection: "top" | "bottom" (WinUI PullDirection).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `contentData` | `alias` | Default children / content slot |
| `contentWidth` | `alias` | Flickable content width |
| `contentHeight` | `alias` | Flickable content height |
| `contentX` | `alias` | Flickable content X |
| `contentY` | `alias` | Flickable content Y |
| `flickable` | `alias` | Inner Flickable |
| `refreshing` | `bool` | True while a refresh is in progress |
| `isRefreshing` | `alias` | True while refreshing |
| `pullToRefreshEnabled` | `bool` | Enable pull-to-refresh gesture |
| `isEnabled` | `alias` | Enabled state alias |
| `pullThreshold` | `real` | Pull distance before refresh fires |
| `pullDirection` | `string` | WinUI PullDirection — "top" (default) or "bottom" |
| `refreshText` | `string` | Text shown while pulling |
| `refreshingText` | `string` | Text shown while refreshing |
| `pullText` | `string` | Pull-to-refresh prompt text |

### Signals

| Signature | Description |
| --- | --- |
| `refreshRequested()` | Pull-to-refresh requested |

### Methods

| Signature | Description |
| --- | --- |
| `endRefresh()` | End a pull-to-refresh cycle |
| `beginRefresh()` | Start a pull-to-refresh cycle |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
