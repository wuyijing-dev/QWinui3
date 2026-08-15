# StatusBar

Window status strip with progress and slots.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/StatusBar.qml`](../../src/extras/QWinUI3/Extras/StatusBar.qml)

[← Component index](../components.md)

## Usage

```qml
StatusBar {
    text: qsTr("Ready")
    progress: 0.4
}
```

## Properties

- `text: string` — Display / input text
- `leftContent: alias` — Leading content slot
- `centerContent: alias` — Center content slot
- `content: alias` — Content slot / children host
- `rightContent: alias` — Trailing content slot
- `progress: real` — 0..1 shows determinate bar; <0 hides; NaN-safe. Set indeterminate for busy.
- `progressIndeterminate: bool` — Show indeterminate progress

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
