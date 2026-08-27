# LayoutPreset

Named SplitWorkspace layouts persisted in QSettings (3.03 W6).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/LayoutPreset.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/LayoutPreset.qml)

**Category:** Layout · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `SplitWorkspace` — [`src/gallery/pages/SplitWorkspacePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SplitWorkspacePage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `QtObject`.

## Example

```qml
LayoutPreset {
    id: layouts
    category: "MyApp/Layouts"
    workspace: split
    Component.onCompleted: {
        save("Editor", { paneCount: 2, orientation: "horizontal", ratios: [0.3, 0.7] })
        apply("Editor")
    }
}

// --- API ---
// methods: save(name, snapshot?), apply(name), remove(name), rename(from, to),
//          listNames(), clear(), has(name)
// properties: category, workspace, names, currentName
```

## Notes

snapshot defaults to workspace.snapshot() when workspace is set.
Host inside a zero-size Item when used under StandardWindow (QtObject child rule).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `category` | `string` | — |
| `workspace` | `var` | — |
| `currentName` | `string` | — |
| `revision` | `int` | — |
| `names` | `var` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `listNames()` | — |
| `has(name)` | — |
| `save(name, snapshot)` | — |
| `apply(name)` | — |
| `remove(name)` | — |
| `rename(from, to)` | — |
| `clear()` | — |
| `restoreLast()` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
