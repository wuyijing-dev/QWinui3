# InfoBar

Inline severity banner with optional action.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/InfoBar.qml`](../../src/extras/QWinUI3/Extras/InfoBar.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
InfoBar {
    id: infoBar
    title: qsTr("Saved")
    message: qsTr("All changes stored.")
    severity: InfoBar.Success
}

// --- API ---
// signals: onCloseClicked, onActionClicked, onClosed, onOpened
// methods: open(), close(), setSeverityName(name)
// infoBar.open()
// infoBar.close()
// infoBar.setSeverityName(name)
```

## Notes

Inline severity banner: informational | success | warning | error.
open()/close() or bind isOpen; optional actionText -> actionClicked.
Prefer InfoBarHost.info/success/warning/error for stacked toasts-like banners.

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
| `isOpen` | `bool` | Open / visible state |
| `closable` | `bool` | Shows a close affordance when true |
| `isClosable` | `alias` | Alias of closable |
| `showIcon` | `bool` | Show leading status icon |
| `isIconVisible` | `alias` | Show leading status icon |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `actionText` | `string` | Optional action button label |
| `action` | `alias` | Custom action slot |
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
| `open()` | Open / show |
| `close()` | Close / dismiss |
| `setSeverityName(name)` | Set severity from a string name |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
