# OskSettingsFlyout

Win11-style keyboard settings (size, voice/handwriting, user lexicon).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/OskSettingsFlyout.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/OskSettingsFlyout.qml)

**Category:** Dialogs & flyouts · **Library:** v2.65

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
OskSettingsFlyout { engine: kbd; speech: speechSvc; handwriting: hwSvc }
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `engine` | `KeyboardEngine` | — |
| `speech` | `OskSpeechService` | — |
| `handwriting` | `OskHandwritingService` | — |
| `keyboardSize` | `string` | — |

### Signals

| Signature | Description |
| --- | --- |
| `sizePicked(string sizeId)` | — |
| `voiceRequested()` | — |
| `handwritingRequested()` | — |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
