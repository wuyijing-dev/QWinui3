# MenuFlyoutAutoMaxHeight

menu max-height computed from host overlay size.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MenuFlyoutAutoMaxHeight.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/MenuFlyoutAutoMaxHeight.qml)

**Category:** Dialogs & flyouts · **Library:** v2.80

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `MenuFlyoutPresenter`.

## Notes

Use this when you want the menu to clamp to “a sensible portion” of the screen,
instead of a fixed 480px.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `maxHeightRatio` | `real` | Clamp menu height to a portion of host overlay height. |
| `minPresenterContentMaxHeight` | `real` | — |
| `maxPresenterContentMaxHeight` | `real` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
