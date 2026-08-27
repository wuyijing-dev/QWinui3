# SplitWorkspace

2–3 resizable panes for IDE/ops layouts (3.03 W5).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SplitWorkspace.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SplitWorkspace.qml)

**Category:** Layout · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `SplitWorkspace` — [`src/gallery/pages/SplitWorkspacePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SplitWorkspacePage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Item`.

## Example

```qml
SplitWorkspace {
    paneCount: 3
    orientation: Qt.Horizontal
    minPaneWidth: 120
    ratios: [0.25, 0.5, 0.25]
    pane1: Rectangle { }
    pane2: Rectangle { }
    pane3: Rectangle { }
}

// --- API ---
// methods: focusNextPane(), focusPreviousPane(), focusPane(index),
//          setRatios(list), applyPreset(obj), snapshot()
```

## Notes

Pair with LayoutPreset for named QSettings restore (3.03 W6).
Focus chords: Ctrl+Alt+Left/Right (or Up/Down when vertical).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `paneCount` | `int` | — |
| `orientation` | `int` | — |
| `minPaneWidth` | `real` | — |
| `minPaneHeight` | `real` | — |
| `ratios` | `var` | — |
| `pane1` | `Item` | — |
| `pane2` | `Item` | — |
| `pane3` | `Item` | — |
| `focusedPane` | `int` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `snapshot()` | — |
| `applyPreset(obj)` | — |
| `setRatios(list)` | — |
| `focusPane(index)` | — |
| `focusNextPane()` | — |
| `focusPreviousPane()` | — |

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
