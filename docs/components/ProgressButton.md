# ProgressButton

Button with inline determinate/indeterminate fill.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ProgressButton.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ProgressButton.qml)

**Category:** Buttons & commands · **Library:** v1.53

[← Component index](../components.md)

**Gallery:** `ProgressButton` — [`src/gallery/pages/ProgressButtonPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ProgressButtonPage.qml)

**Extends** `AbstractButton`.

## Example

```qml
ProgressButton {
    id: progressButton
    text: qsTr("Upload"); progress: 0.4
}

// --- API ---
// signals: onProgressCompleted, onProgressFailed
// methods: setProgress(value), reset(), start(indeterminateMode), complete(), fail()
// progressButton.setProgress(value)
// progressButton.reset()
// progressButton.start(indeterminateMode)
// progressButton.complete()
// inherits AbstractButton (+ Qt Quick Controls base API)
```

## Notes

Button that shows determinate/indeterminate progress while busy.
setProgress / progressCompleted / progressFailed.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `progress` | `real` | 0..1 progress (determinate) |
| `indeterminate` | `bool` | Show indeterminate animation when true |
| `isIndeterminate` | `alias` | Alias of indeterminate |
| `showProgress` | `bool` | Show progress indicator |
| `showPercentage` | `bool` | Show percentage readout |
| `progressState` | `string` | idle \| progressing \| completed \| error |
| `progressingText` | `string` | Text while progress is running |
| `completedText` | `string` | Text shown when complete |
| `errorText` | `string` | Error message text |
| `percentage` | `real` | Value as 0..100 percentage |
| `displayText` | `string` | Text shown to the user |

### Signals

| Signature | Description |
| --- | --- |
| `progressCompleted()` | Emitted when progress reaches completion |
| `progressFailed()` | Emitted when progress fails |

### Methods

| Signature | Description |
| --- | --- |
| `setProgress(value)` | Set progress 0..1 |
| `reset()` | Reset to defaults |
| `start(indeterminateMode)` | Start animation / operation |
| `complete()` | Mark the step / task complete |
| `fail()` | Mark the operation failed |

### Inherited from `AbstractButton`

Also available (base type / Qt Quick Controls):

- `text`
- `enabled`
- `down` / `pressed` / `hovered`
- `clicked()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
