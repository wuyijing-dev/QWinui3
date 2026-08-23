# MenuFlyoutPresenter

product-friendly wrapper for MenuFlyout.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MenuFlyoutPresenter.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/MenuFlyoutPresenter.qml)

**Category:** Dialogs & flyouts · **Library:** v2.81

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `MenuFlyout`.

## Notes

- Ensures contentMaxHeight is set (default 480) so long menus scroll.
- Provides snapshotModel.freeze() hook on open.
- Exposes convenience popupAtGlobal(overlay, globalX, globalY).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `overlay` | `Item` | Optional overlay host for popupAtGlobal. |
| `presenterContentMaxHeight` | `real` | (MenuFlyout height binding uses this property when > 0.) |
| `autoMaxHeight` | `bool` | When true, apply presenterContentMaxHeight during open. |
| `snapshotModel` | `var` | Optional snapshot model: calls snapshotModel.freeze() when menu opens. |

### Signals

| Signature | Description |
| --- | --- |
| `snapshotFrozen(var frozenRows)` | Frozen snapshot rows for apps that care (emitted from snapshotModel.freeze()). |

### Methods

| Signature | Description |
| --- | --- |
| `popupAtGlobal(xGlobal, yGlobal)` | Convenience: popup using overlay resolved from root.overlay or parent window overlay. |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
