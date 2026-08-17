# StepBar

Horizontal step / wizard progress.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/StepBar.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/StepBar.qml)

**Category:** Status & feedback · **Library:** v1.76

[← Component index](../components.md)

**Gallery:** `StepBar` — [`src/gallery/pages/StepBarPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/StepBarPage.qml)

**Extends** `Control`.

## Example

```qml
StepBar {
    id: stepBar
    model: ["Cart", "Ship", "Pay"]; currentIndex: 1
}

// --- API ---
// signals: onStepActivated
// methods: next(), previous(), goTo(index)
// stepBar.next()
// stepBar.previous()
// stepBar.goTo(index)
```

## Notes

Step indicator; model of steps, currentIndex; stepClicked when interactive.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `var` | Data model / item list for this control |
| `currentIndex` | `int` | Selected index |
| `selectedIndex` | `alias` | Selected index alias |
| `orientation` | `string` | horizontal \| vertical |
| `isInteractive` | `bool` | Alias of interactive |

### Signals

| Signature | Description |
| --- | --- |
| `stepActivated(int index)` | Emitted when a step is activated |

### Methods

| Signature | Description |
| --- | --- |
| `next()` | Advance to next |
| `previous()` | Go to previous |
| `goTo(index)` | Navigate to the given index |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
