# FeedbackSeverity

Shared severity palette + glyphs for InfoBar / Toast / TeachingTip (2.70 A7).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/FeedbackSeverity.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/FeedbackSeverity.qml)

**Category:** Other · **Library:** v2.81 · **singleton**

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `QtObject`.

## Example

```qml
color: FeedbackSeverity.colorFor(FeedbackSeverity.error)
glyph: FeedbackSeverity.glyphFor(FeedbackSeverity.warning)
```

## Notes

Aligns systemSuccess / Caution / Critical / Attention tokens and FluentIcons.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `informational` | `int` | — |
| `success` | `int` | — |
| `warning` | `int` | — |
| `error` | `int` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `colorFor(severity)` | — |
| `backgroundFor(severity)` | — |
| `glyphFor(severity)` | — |
| `nameFor(severity)` | — |
| `fromString(name)` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
