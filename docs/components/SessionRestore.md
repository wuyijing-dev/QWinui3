# SessionRestore

Persist window geometry plus navigation page and DataTable scroll/selection.

`import QWinUI3.Extras` · [`SessionRestore.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SessionRestore.qml)

**Library:** v2.70

[← Component index](../components.md)

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
```

## Notes

Geometry uses `geometryPersistenceKey` / WindowHelper when present; nav `currentKey` and table selection/scroll use QtCore Settings under `category` (2.70 D8).
