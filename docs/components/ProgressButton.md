# ProgressButton

Button with inline determinate/indeterminate fill.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ProgressButton.qml`](../../src/extras/QWinUI3/Extras/ProgressButton.qml)

[← Component index](../components.md)

## Usage

```qml
ProgressButton { text: qsTr("Upload"); progress: 0.4 }
```

## Properties

- `progress: real` — 0..1 progress (determinate)
- `indeterminate: bool` — Show indeterminate animation when true
- `isIndeterminate: alias` — Alias of indeterminate
- `showProgress: bool` — Show progress indicator
- `showPercentage: bool` — Show Percentage
- `progressState: string` — idle | progressing | completed | error
- `progressingText: string` — Progressing Text
- `completedText: string` — Completed Text
- `errorText: string` — Error Text
- `percentage: real` — Value as 0..100 percentage
- `displayText: string` — Text shown to the user
- `innerRadius: real` — Inner Radius
- `innerWidth: real` — Inner Width

## Signals

- `progressCompleted()` — Progress Completed
- `progressFailed()` — Progress Failed

## Methods

- `setProgress(value)` — Set Progress
- `reset()` — Reset
- `start(indeterminateMode)` — Start
- `complete()` — Complete
- `fail()` — Fail

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
