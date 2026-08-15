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
- `leftContent: alias` — Left Content
- `centerContent: alias` — Center Content
- `content: alias` — Content slot / children host
- `rightContent: alias` — Right Content
- `progress: real` — 0..1 shows determinate bar; <0 hides; NaN-safe. Set indeterminate for busy.
- `progressIndeterminate: bool` — Progress Indeterminate

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
