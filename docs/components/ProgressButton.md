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
- `showPercentage: bool` — Show percentage readout
- `progressState: string` — idle | progressing | completed | error
- `progressingText: string` — Text while progress is running
- `completedText: string` — Text shown when complete
- `errorText: string` — Error message text
- `percentage: real` — Value as 0..100 percentage
- `displayText: string` — Text shown to the user
- `innerRadius: real` — Inner radius
- `innerWidth: real` — Inner width

## Signals

- `progressCompleted()` — Emitted when progress reaches completion
- `progressFailed()` — Emitted when progress fails

## Methods

- `setProgress(value)` — Set progress 0..1
- `reset()` — Reset to defaults
- `start(indeterminateMode)` — Start animation / operation
- `complete()` — Mark the step / task complete
- `fail()` — Mark the operation failed

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
