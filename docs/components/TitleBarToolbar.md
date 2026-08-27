# TitleBarToolbar

horizontal action row for titleBarContent / leftHeader slots.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TitleBarToolbar.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/TitleBarToolbar.qml)

**Category:** Shells & windows · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `TitleBar` — [`src/gallery/pages/TitleBarPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/TitleBarPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `RowLayout`.

## Example

```qml
NavigationWindow {
    titleBarContent: TitleBarToolbar {
        Button { text: qsTr("Undo"); flat: true }
        Button { text: qsTr("Redo"); flat: true }
    }
}
```

## Notes

Sized for the title band; refreshes NC hit-test when children resize.

## API

### Properties

_No additional properties beyond the base type._

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
