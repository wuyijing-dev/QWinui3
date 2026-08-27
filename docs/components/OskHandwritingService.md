# OskHandwritingService

process handwriting for OSK (Windows + Linux). No helper processes. Windows: Ink recognizer COM. Both: Zinnia shared library when a model is present.

`import QWinUI3.Extras.Osk` · [`src/extras/QWinUI3/Extras/OskHandwritingService.h`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/OskHandwritingService.h)

**Category:** Input & forms · **Library:** v3.56 · **C++ type**

[← Component index](../components.md)

> Internal / support type — not part of the public Gallery surface.

**Extends** `QObject`.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `available` | `bool` | — |
| `candidates` | `QStringList` | — |
| `statusText` | `QString` | — |
| `platformBackend` | `QString` | — |

### Signals

| Signature | Description |
| --- | --- |
| `availabilityChanged()` | — |
| `candidatesChanged()` | — |
| `statusTextChanged()` | — |
| `candidatePicked(const QString &text)` | — |
| `errorOccurred(const QString &message)` | — |

### Methods

| Signature | Description |
| --- | --- |
| `clearStrokes()` | — |
| `addStroke(const QVariantList &points)` | — |
| `recognize()` | — |
| `pickCandidate(int index)` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
