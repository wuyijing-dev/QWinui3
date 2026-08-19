# OskVoiceBar

cross-platform speech-to-text strip (Windows System.Speech / Linux whisper|vosk).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/OskVoiceBar.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/OskVoiceBar.qml)

**Category:** Other · **Library:** v2.64

[← Component index](../components.md)

## Example

```qml
OskVoiceBar { engine: kbd; speech: speechSvc }
T.Control {
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

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
