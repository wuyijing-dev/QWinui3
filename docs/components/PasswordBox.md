# PasswordBox

Password field with reveal toggle.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/PasswordBox.qml`](../../src/extras/QWinUI3/Extras/PasswordBox.qml)

[← Component index](../components.md)

## Usage

```qml
PasswordBox { placeholderText: qsTr("Password") }
```

## Properties

- `text: alias` — Display / input text
- `placeholderText: alias` — Placeholder when empty
- `maximumLength: alias` — Hard maximum text length
- `header: string` — Header label above the control
- `description: string` — Supporting description text
- `errorMessage: string` — Validation error text
- `clearButtonVisible: bool` — Show clear affordance
- `passwordRevealMode: string` — WinUI PasswordRevealMode: peek | hidden | visible
- `revealPassword: bool` — Reveal Password
- `revealButtonVisible: bool` — Reveal Button Visible
- `echoMode: alias` — TextField echo mode
- `field: alias` — Inner text field
- `hasError: bool` — True when validation failed

## Signals

- `accepted()` — Emitted on accept / submit
- `cleared()` — Emitted when content is cleared

## Methods

- `clear()` — Clear
- `focusField()` — Focus Field

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
