# FlyoutKeyboardFocusTrap

restore keyboard focus after MenuFlyout closes.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/FlyoutKeyboardFocusTrap.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/FlyoutKeyboardFocusTrap.qml)

**Category:** Input & forms · **Library:** v2.81

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `QtObject`.

## Notes

MenuFlyout is a Popup-like component; keyboard users may expect focus to
return to the control that triggered the flyout.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `flyout` | `var` | MenuFlyout or MenuFlyoutPresenter instance. |
| `focusTarget` | `Item` | Focus target to restore after flyout closes. |
| `enabled` | `bool` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `arm(flyoutItem, target)` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
