# ImeCandidateBar

Win11-style in-app pinyin candidate strip (1.72).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ImeCandidateBar.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ImeCandidateBar.qml)

**Category:** Date & time · **Library:** v1.72

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
ImeCandidateBar { engine: osk.engine }
```

## Notes

Host above OnScreenKeyboard. Theme tokens only. No focus steal.
Lexicon is MIT pinyin-data / phrase-pinyin-data, not Microsoft Pinyin.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `engine` | `KeyboardEngine` | — |

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
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
