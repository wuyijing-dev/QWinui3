# OnScreenKeyboardWindow

floating Win11-style OSK (1.83).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/OnScreenKeyboardWindow.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/OnScreenKeyboardWindow.qml)

**Category:** Shells & windows · **Library:** v2.55

[← Component index](../components.md)

**Extends** `Window`.

## Example

```qml
OnScreenKeyboardWindow { visible: true }
// Windows: systemWide defaults ON (SendInput into the focused desktop app).
// Docked OnScreenKeyboard stays in-app (systemWide default off).
```

## Notes

Always-on-top tool window with WS_EX_NOACTIVATE so taps do not steal focus.
systemWide is Windows-only; Linux floating is in-app only.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `systemWide` | `alias` | — |
| `keyboardSize` | `alias` | — |
| `layoutId` | `alias` | — |
| `engine` | `alias` | — |
| `supportsSystemWide` | `bool` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `applyNoActivate()` | — |
| `openFloating()` | — |
| `closeFloating()` | — |

### Inherited from `Window`

Also available (base type / Qt Quick Controls):

- `title`
- `visible`
- `width` / `height`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
