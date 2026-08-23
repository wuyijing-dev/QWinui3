# OskSpeechService

process speech-to-text for OSK (Windows + Linux). No helper processes. Windows: SAPI in-proc recognizer. Optional Vosk shared library on both OSes.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/OskSpeechService.h`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/OskSpeechService.h)

**Category:** Other · **Library:** v2.67 · **C++ type**

[← Component index](../components.md)

> Internal / support type — not part of the public Gallery surface.

**Extends** `QObject`.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `available` | `bool` | — |
| `listening` | `bool` | — |
| `statusText` | `QString` | — |
| `platformBackend` | `QString` | — |

### Signals

| Signature | Description |
| --- | --- |
| `availabilityChanged()` | — |
| `listeningChanged()` | — |
| `statusTextChanged()` | — |
| `recognized(const QString &text)` | — |
| `errorOccurred(const QString &message)` | — |

### Methods

| Signature | Description |
| --- | --- |
| `startListening()` | — |
| `stopListening()` | — |
| `cancel()` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
