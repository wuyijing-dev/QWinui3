# ItemsViewEmptyStateHelper

unify emptyTitle/emptyMessage for filtered lists.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ItemsViewEmptyStateHelper.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ItemsViewEmptyStateHelper.qml)

**Category:** Collections & data · **Library:** v2.67

[← Component index](../components.md)

**Extends** `QtObject`.

## Notes

ItemsView already has EmptyState integration via emptyTitle/emptyMessage,
but apps often want different copy:
  - no items at all
  - no matches while filter is active

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `itemsView` | `var` | Attach to a specific ItemsView instance. |
| `filteredEmptyTitle` | `string` | Default copy (only used when you have not overridden those on ItemsView). |
| `filteredEmptyMessage` | `string` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `attach(view)` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
