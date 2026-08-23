# Pane

Fluent styled Pane.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Pane.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/Pane.qml)

**Category:** Styled controls · **Library:** v2.81

[← Component index](../components.md)

**Gallery:** `Pane` — [`src/gallery/pages/PanePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/PanePage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

## Example

```qml
Pane {
    id: pane
    padding: Theme.paddingControlH
    TextBlock {
        width: pane.availableWidth   // required for Wrap / Elide
        text: qsTr("Pane body")
        textWrapping: "wrap"
    }
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls Pane.
Long text (WinUI): size the Pane (Layout.fillWidth / width), then bind
child text width to availableWidth — TextWrapping / TextTrimming via TextBlock.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `Pane` API (this file only supplies Fluent visuals / metrics).

### Inherited from `Pane`

- `padding`
- `background`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
