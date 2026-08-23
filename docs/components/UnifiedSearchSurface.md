# UnifiedSearchSurface

unify TitleBar search + Navigation pane search + custom middle search

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/UnifiedSearchSurface.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/UnifiedSearchSurface.qml)

**Category:** Input & forms · **Library:** v2.67

[← Component index](../components.md)

**Extends** `Item`.

## Example

```qml
Usage (NavigationWindow):

NavigationWindow {
  id: win
  isPaneSearchEnabled: true
  paneSearchModel: [{ title: "Home", component: "HomePage" }]

  UnifiedSearchSurface {
      id: s
      anchors.fill: parent
      hostWindow: win
      mode: UnifiedSearchSurface.Pane
      searchModel: win.paneSearchModel
      placeholderText: qsTr("Search photos")
      panePlaceholderText: qsTr("Filter library")
      onSearchTextEdited: (t) => model.filter(t)
      onSearchActivated: (item) => open(item)
  }
}
```

## Notes

This component is an adapter: it routes host search signals into a single unified event stream.
Middle mode disables host built-in search and places a SearchBox into titleBarContent.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `hostWindow` | `var` | Shell host: pass ShellWindow or NavigationWindow instance. |
| `mode` | `SearchSurfaceMode` | Unified behavior mode. |
| `searchModel` | `var` | Suggestions / suggestions model (rows). |
| `placeholderText` | `string` | Placeholder for Global/TitleBar channel. |
| `panePlaceholderText` | `string` | Placeholder for Pane channel. |
| `middlePlaceholderText` | `string` | Placeholder for Middle channel SearchBox. |
| `enabled` | `bool` | Search UI enabled. |
| `searchText` | `string` | Current query text (adapter-level). |

### Signals

| Signature | Description |
| --- | --- |
| `searchTextEdited(string text)` | Unified event stream: |
| `searchActivated(var item)` | — |
| `searchSubmitted(string query)` | — |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
