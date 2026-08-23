# ImeCandidateBar

Win11-style in-app IME candidate strip (1.74).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ImeCandidateBar.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ImeCandidateBar.qml)

**Category:** Date & time · **Library:** v2.65

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
ImeCandidateBar { engine: osk.engine }
ImeCandidateBar { engine: osk.engine; placement: "floating"; dockInset: osk.implicitHeight }
```

## Notes

Host above OnScreenKeyboard (inline) or window overlay (floating). Theme acrylic
matches OSK dock in light and dark. No focus steal.
Shared by pinyin / romaji-kana / hangul. Digits 1–9 / Space via engine.
Not Microsoft IME.
Live-region: announce paged candidates / preedit on composeChanged (1.85).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `engine` | `KeyboardEngine` | — |
| `placement` | `string` | — |
| `dockInset` | `real` | — |
| `activeGroupIndex` | `int` | — |
| `groupPage` | `int` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
