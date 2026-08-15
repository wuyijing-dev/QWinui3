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
- `isEnabled: alias` — Enabled state alias
- `pullThreshold: real` — Pull distance before refresh fires
- `refreshText: string` — Text shown while pulling
- `refreshingText: string` — Text shown while refreshing
- `pullText: string` — Pull-to-refresh prompt text

## Signals

- `refreshRequested()` — Pull-to-refresh requested

## Methods

- `endRefresh()` — End a pull-to-refresh cycle
- `beginRefresh()` — Start a pull-to-refresh cycle

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
