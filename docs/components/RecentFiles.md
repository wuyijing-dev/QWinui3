# RecentFiles

Persist recent paths in Settings + shell recent docs (2.77).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/RecentFiles.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/RecentFiles.qml)

**Category:** Other · **Library:** v2.80

[← Component index](../components.md)

**Gallery:** `RecentFiles` — [`src/gallery/pages/RecentFilesPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/RecentFilesPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `QtObject`.

## Example

```qml
RecentFiles {
    id: recent
    maxCount: 12
    category: "RecentFiles"
}
recent.add("/path/to/file")
recent.list()  // string array
recent.clear()
```

## Notes

Paths stored under Settings; add() also calls WindowHelper.addToRecentDocuments.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `category` | `string` | — |
| `maxCount` | `int` | — |
| `notifyShell` | `bool` | — |

### Signals

| Signature | Description |
| --- | --- |
| `changed()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `list()` | — |
| `add(path)` | — |
| `clear()` | — |
| `remove(path)` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
