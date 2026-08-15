# Button

Fluent styled Button.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Button.qml`](../../src/style/QWinUI3/Button.qml)

[← Component index](../components.md)

## Usage

```qml
Button { text: qsTr("OK"); onClicked: accept() }
```

## Properties

- `accented: bool` — Use accent chrome
- `lightScheme: bool` — True in light theme
- `hasSolidStroke: bool` — Draw solid stroke chrome
- `hasGradientStroke: bool` — Draw gradient stroke chrome
- `topStroke: color` — WinUI ControlStrokeDefault / Secondary — keep soft, not StrongStroke
- `bottomStroke: color` — Bottom edge stroke width
- `inset: bool` — Content inset

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
