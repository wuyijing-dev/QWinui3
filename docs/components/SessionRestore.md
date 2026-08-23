# SessionRestore

Persist window geometry + nav page + table scroll/selection (2.70 D8).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SessionRestore.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SessionRestore.qml)

**Category:** Other · **Library:** v2.81

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `QtObject`.

## Example

```qml
SessionRestore {
    id: session
    category: "MyAppSession"
    window: mainWindow
    navigationView: nav
    dataTable: table
}
Component.onCompleted: session.restore()
Component.onDestruction: session.save()

// --- API ---
// methods: save(), restore(), clear()
// properties: category, window, navigationView, dataTable, enabled
```

## Notes

Geometry still uses WindowHelper when window.geometryPersistenceKey is set;
this type stores nav currentKey + DataTable selectedIndex / contentY.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `category` | `string` | — |
| `window` | `var` | — |
| `navigationView` | `var` | — |
| `dataTable` | `var` | — |
| `enabled` | `bool` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `save()` | — |
| `restore()` | — |
| `clear()` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
