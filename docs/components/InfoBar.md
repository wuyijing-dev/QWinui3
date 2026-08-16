# InfoBar

Inline severity banner with optional action and Content slot.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/InfoBar.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/InfoBar.qml)

**Category:** Dialogs & flyouts · **Library:** v1.16

[← Component index](../components.md)

**Gallery:** `InfoBar` — [`src/gallery/pages/InfoBarPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/InfoBarPage.qml)

**Extends** `Control`.

## Example

```qml
InfoBar {
    id: infoBar
    title: qsTr("Saved")
    message: qsTr("All changes stored.")
    severity: InfoBar.Success
    Button { flat: true; text: qsTr("Details") }
}

// --- API ---
// signals: onCloseClicked, onActionClicked, onClosed, onOpened
// methods: open(), close(), setSeverityName(name)
// infoBar.open() / infoBar.close()
```

## Notes

Inline severity banner: informational | success | warning | error.
WinUI Content slot via default children (below message); actionText or action slot; isClosable.
Content-only (no title/message) promotes Content to the primary row — no empty title gap.
collapseWhenClosed (default) drops layout space immediately when closed (no Stack spacing).
Prefer InfoBarHost.info/success/warning/error for stacked banners.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `informational` | `int` | Informational severity constant |
| `success` | `int` | Success severity constant |
| `warning` | `int` | Warning severity constant |
| `error` | `int` | Error severity constant |
| `severity` | `int` | Status severity enum |
| `title` | `string` | Primary title text |
| `message` | `string` | Body / message text |
| `description` | `alias` | WinUI / docs alias of message |
| `isOpen` | `bool` | Open / visible state |
| `collapseWhenClosed` | `bool` | When true, closed bars leave no Column/Stack spacing (unlike WinUI IsOpen=false) |
| `closable` | `bool` | Shows a close affordance when true |
| `isClosable` | `alias` | Alias of closable |
| `showIcon` | `bool` | Show leading status icon |
| `isIconVisible` | `alias` | Show leading status icon |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `actionText` | `string` | Optional action button label |
| `action` | `alias` | Custom action slot (WinUI ActionButton) |
| `content` | `alias` | WinUI Content — rich body below the message (or primary row when content-only) |
| `durationMs` | `int` | Auto-dismiss duration; 0 keeps open |
| `severityName` | `string` | Convenience string: "informational" \| "success" \| "warning" \| "error" |

### Signals

| Signature | Description |
| --- | --- |
| `closeClicked()` | Close button clicked |
| `actionClicked()` | Emitted when action is clicked |
| `closed()` | Swipe content closed |
| `opened()` | Emitted when opened |

### Methods

| Signature | Description |
| --- | --- |
| `open()` | — |
| `close()` | — |
| `setSeverityName(name)` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
