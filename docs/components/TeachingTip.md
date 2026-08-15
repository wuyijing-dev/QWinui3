# TeachingTip

Anchored tip with title, subtitle, and actions.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TeachingTip.qml`](../../src/extras/QWinUI3/Extras/TeachingTip.qml)

[← Component index](../components.md)

**Extends** `Popup`.

## Example

```qml
TeachingTip {
    id: tip
    target: btn
    title: qsTr("Tip")
    subtitle: qsTr("Hint")
    actionText: qsTr("Got it")
    onActionClicked: tip.close()
}

// --- API ---
// tip.open() / tip.close() / tip.reanchor()
// signals: onActionClicked, onClosedByUser
// inherits Popup
```

## Notes

Anchored tip Popup; set target + title/subtitle (+ optional actionText).
Call open()/close(); reanchor() after the target moves.
isLightDismissEnabled controls outside-click dismiss.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `target` | `Item` | Anchor item for placement |
| `title` | `string` | Primary title text |
| `subtitle` | `string` | Secondary subtitle text |
| `actionText` | `string` | Optional action button label |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `isOpen` | `bool` | Open / visible state |
| `isLightDismissEnabled` | `bool` | Close on outside click / Esc |
| `isCloseButtonVisible` | `bool` | Alias of closable |
| `preferredPlacement` | `int` | Preferred flyout placement |
| `effectivePlacement` | `int` | Resolved flyout placement |
| `heroContent` | `alias` | Hero content slot |
| `effectiveIconGlyph` | `string` | Resolved glyph string |

### Signals

| Signature | Description |
| --- | --- |
| `actionClicked()` | Emitted when action is clicked |
| `closedByUser()` | True when the user dismissed the dialog |

### Methods

| Signature | Description |
| --- | --- |
| `reanchor()` | Recompute popup anchor |

### Inherited from `Popup`

Also available (base type / Qt Quick Controls):

- `open()` / `close()`
- `opened()` / `closed()`
- `modal` / `focus`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
