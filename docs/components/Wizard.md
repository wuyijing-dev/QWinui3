# Wizard

Multi-step flow host (StepBar + content + Back/Next).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/Wizard.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/Wizard.qml)

**Category:** Other · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `Wizard` — [`src/gallery/pages/WizardPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/WizardPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
Wizard {
    id: wizard
    model: [
        { title: qsTr("Account"), content: accountStep },
        { title: qsTr("Review"), content: reviewStep }
    ]
    stepValidators: [function () { return emailField.acceptableInput }, null]
    onFinished: { /* … */ }
}

// --- API ---
// currentIndex / stepCount / canGoBack / canGoNext / isLastStep
// methods: next(), previous(), goTo(index), finish(), cancel(), reset(), stepTitle(i)
// signals: finished(), cancelled(), stepChanged(int)
```

## Notes

Per-step validation via stepValidators[i]() → bool (2.68 D3).
model entries: string title, or { title, description?, content|sourceComponent }.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `var` | — |
| `currentIndex` | `int` | — |
| `selectedIndex` | `alias` | — |
| `stepValidators` | `var` | Array of functions returning bool; missing/null = always valid |
| `showStepBar` | `bool` | — |
| `cancelVisible` | `bool` | — |
| `nextText` | `string` | — |
| `backText` | `string` | — |
| `finishText` | `string` | — |
| `cancelText` | `string` | — |
| `defaultStepContent` | `Component` | Default content when a step has no content / sourceComponent |
| `stepCount` | `int` | — |
| `canGoBack` | `bool` | — |
| `isLastStep` | `bool` | — |
| `canGoNext` | `bool` | — |

### Signals

| Signature | Description |
| --- | --- |
| `finished()` | — |
| `cancelled()` | — |
| `stepChanged(int index)` | — |

### Methods

| Signature | Description |
| --- | --- |
| `goTo(index)` | — |
| `next()` | — |
| `previous()` | — |
| `finish()` | — |
| `cancel()` | — |
| `stepTitle(index)` | — |
| `reset()` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
