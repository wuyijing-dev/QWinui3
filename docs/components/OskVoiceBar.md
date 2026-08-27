# OskVoiceBar

cross-platform speech-to-text strip (Windows System.Speech / Linux whisper|vosk).

`import QWinUI3.Extras.Osk` · [`src/extras/QWinUI3/Extras/OskVoiceBar.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/OskVoiceBar.qml)

**Category:** Input & forms · **Library:** v3.56

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
OskVoiceBar { engine: kbd; speech: speechSvc }
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `engine` | `KeyboardEngine` | — |
| `speech` | `OskSpeechService` | — |

### Signals

| Signature | Description |
| --- | --- |
| `closeRequested()` | — |
| `flashRequested(string message)` | — |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
