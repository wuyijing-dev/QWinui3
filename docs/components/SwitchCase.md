# SwitchCase

Case child for SwitchPresenter.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SwitchCase.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SwitchCase.qml)

**Category:** Input & forms · **Library:** v2.53

[← Component index](../components.md)

**Extends** `Item`.

## Example

```qml
SwitchPresenter {
    currentCase: "a"
    SwitchCase { value: "a"; Label { text: "A" } }
    SwitchCase { value: "b"; Label { text: "B" } }
}
```

## Notes

Named case content for SwitchPresenter (value matches currentCase).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `var` | Current value |
| `active` | `bool` | Active state |
| `contentData` | `alias` | Default children / content slot |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
