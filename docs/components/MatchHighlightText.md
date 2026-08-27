# MatchHighlightText

substring accent highlight for search/filter labels.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MatchHighlightText.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/MatchHighlightText.qml)

**Category:** Navigation · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `NavigationView` — [`src/gallery/pages/NavigationViewPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/NavigationViewPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Text`.

## Example

```qml
MatchHighlightText {
    sourceText: qsTr("NavigationView")
    query: searchField.text
    elide: Text.ElideRight
    Layout.fillWidth: true
}
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `sourceText` | `string` | — |
| `query` | `string` | — |
| `normalColor` | `color` | — |
| `highlightColor` | `color` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
