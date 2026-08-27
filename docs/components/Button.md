# Button

Fluent / WinUI 3 Button with appearances, optional leading icon, accent chrome, and loading state.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Button.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/Button.qml)

**Category:** Styled controls · **Library:** v3.19

[← Component index](../components.md)

**Gallery:** `Button` — [`src/gallery/pages/ButtonPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ButtonPage.qml)

## Example

```qml
Button {
    text: qsTr("Share")
    leadingSymbol: FluentIcons.Share
    appearance: "outline"
    onClicked: share()
}

Button {
    text: qsTr("Submit")
    highlighted: true
    loading: submitting
    onClicked: submit()
}
```

## QWinUI3 properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `appearance` | `string` | `""` → `filled` | `filled` · `subtle` · `outline` · `ghost` |
| `leadingSymbol` / `leadingGlyph` | `var` / `string` | | Leading Fluent icon (hidden while `loading`) |
| `loading` | `bool` | `false` | Inline BusyIndicator; blocks click |
| `preserveWidthWhileLoading` | `bool` | `true` | Cache width to avoid toolbar reflow |
| `accented` | `bool` | | Readonly — `highlighted \|\| checked` |
| `lightScheme` | `bool` | | Readonly — `!Theme.dark` |

## Inherited from Qt `Button`

- `text` · `enabled` · `highlighted` · `flat` · `checked`
- `clicked()` · `pressed` / `released`

## Notes

Primary CTA: `highlighted: true`, or use **AccentButton** (`symbol` API). Icon-only buttons should keep a ≥ `Theme.controlHeight` hit target. Honors `Theme.reducedMotion` on press scale and color.

---
*Updated for 3.19 leading icon + Gallery demos.*
