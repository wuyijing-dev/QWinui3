# DataTableFilterOverlay

lightweight filter UI for DataTable.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/DataTableFilterOverlay.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/DataTableFilterOverlay.qml)

**Category:** Collections & data · **Library:** v3.56

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `ColumnLayout`.

## Notes

DataTable already provides filterText/filterPlaceholder/filterDebounceMs.
This component gives a ready-to-use filter bar that binds those properties.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `dataTable` | `var` | Target DataTable instance. |
| `filterPlaceholder` | `string` | Placeholder for the filter input. |
| `showMatchCount` | `bool` | — |
| `contentData` | `alias` | Content slot (usually a DataTable). |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
