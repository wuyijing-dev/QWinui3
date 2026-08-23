# Wizard

Multi-step flow host with StepBar, content stack, and Back/Next/Finish.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/Wizard.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/Wizard.qml)

**Category:** Navigation · **Library:** v2.68

[← Component index](../components.md)

**Gallery:** `Wizard` — [`src/gallery/pages/WizardPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/WizardPage.qml)

**Extends** `Control`.

## Example

```qml
Wizard {
    id: wizard
    model: [
        { title: qsTr("Account"), content: accountStep },
        { title: qsTr("Review"), content: reviewStep }
    ]
    stepValidators: [
        function () { return emailField.acceptableInput },
        null
    ]
    onFinished: { /* … */ }
}
```

## Notes

Per-step validation via `stepValidators[i]()` → bool (2.68 D3). Model entries may be a title string or `{ title, content|sourceComponent }`.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `var` | Step titles or `{ title, content }` objects |
| `currentIndex` | `int` | Active step |
| `stepValidators` | `var` | Per-step functions returning bool |
| `showStepBar` | `bool` | Show StepBar chrome |
| `cancelVisible` | `bool` | Show Cancel |
| `canGoNext` | `bool` (readonly) | Current step passes validation |
| `isLastStep` | `bool` (readonly) | On final step |

### Signals

| Signature | Description |
| --- | --- |
| `finished()` | Finish pressed on a valid last step |
| `cancelled()` | Cancel pressed |
| `stepChanged(int index)` | Active step changed |

### Methods

| Signature | Description |
| --- | --- |
| `next()` | Advance or finish |
| `previous()` | Go back |
| `goTo(index)` | Jump when intermediate validators pass |
| `finish()` | Emit finished when valid |
| `cancel()` | Emit cancelled |
