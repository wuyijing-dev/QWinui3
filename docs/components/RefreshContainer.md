# RefreshContainer

Pull-to-refresh host for flickable content.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/RefreshContainer.qml`](../../src/extras/QWinUI3/Extras/RefreshContainer.qml)

[← Component index](../components.md)

## Usage

```qml
RefreshContainer {
    onRefreshRequested: reload()
    ListView { /* … */ }
}
```

## Properties

- `contentData: alias` — Default children / content slot
- `contentWidth: alias` — Flickable content width
- `contentHeight: alias` — Flickable content height
- `contentX: alias` — Flickable content X
- `contentY: alias` — Flickable content Y
- `flickable: alias` — Inner Flickable
- `refreshing: bool` — True while a refresh is in progress
- `isRefreshing: alias` — True while refreshing
- `pullToRefreshEnabled: bool` — Enable pull-to-refresh gesture
- `isEnabled: alias` — Is Enabled
- `pullThreshold: real` — Pull distance before refresh fires
- `refreshText: string` — Text shown while pulling
- `refreshingText: string` — Text shown while refreshing
- `pullText: string` — Pull Text
- `spinAngle: real` — Indeterminate spin angle

## Signals

- `refreshRequested()` — Pull-to-refresh requested

## Methods

- `endRefresh()` — End Refresh
- `beginRefresh()` — Begin Refresh

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
