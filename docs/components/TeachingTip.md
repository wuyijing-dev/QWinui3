# TeachingTip

Anchored tip with title, subtitle, content, and actions.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TeachingTip.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/TeachingTip.qml)

**Category:** Dialogs & flyouts · **Library:** v2.52

[← Component index](../components.md)

**Gallery:** `TeachingTip` — [`src/gallery/pages/TeachingTipPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/TeachingTipPage.qml)

**Extends** `Popup`.

## Example

```qml
TeachingTip {
    id: tip
    target: btn
    title: qsTr("Tip")
    subtitle: qsTr("Hint")
    actionText: qsTr("Got it")
    preferredPlacement: Qt.AlignTop
    tailVisibility: true
    onActionClicked: tip.close()
}

// --- API ---
// tip.open() / tip.close() / tip.reanchor()
// signals: onActionClicked, onClosedByUser, onCloseButtonClicked
// inherits Popup
```

## Notes

WinUI TeachingTip: target, title/subtitle, Content + HeroContent, ActionButton (actionText),
CloseButton, PreferredPlacement, TailVisibility, PlacementMargin, IsLightDismissEnabled.
Parents to Window Overlay on open so placement is relative to the window, not a layout cell.
Coach-mark / first-run tip — not for confirmations (use ContentDialog; docs/dialogs-flyouts.md).
On close, focus returns to target when focusable (docs/feedback.md, 1.34).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `target` | `Item` | Anchor item for placement |
| `title` | `string` | Primary title text |
| `subtitle` | `string` | Secondary subtitle text |
| `actionText` | `string` | Optional action button label (WinUI ActionButtonContent as text) |
| `actionButton` | `alias` | WinUI ActionButton — custom action control (replaces AccentButton when set) |
| `closeButtonContent` | `string` | WinUI CloseButtonContent — empty uses ChromeClose glyph |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `isOpen` | `bool` | Open / visible state |
| `isLightDismissEnabled` | `bool` | Close on outside click / Esc |
| `isCloseButtonVisible` | `bool` | Show the close affordance |
| `preferredPlacement` | `int` | Preferred flyout placement (Qt.AlignTop/Bottom/Left/Right) |
| `effectivePlacement` | `int` | Resolved flyout placement |
| `placementMargin` | `real` | Gap between target and tip (WinUI PlacementMargin) |
| `tailVisibility` | `bool` | Show the pointer tail (WinUI TailVisibility) |
| `shouldConstrainToRootBounds` | `bool` | WinUI ShouldConstrainToRootBounds — clamp tip inside parent when true |
| `heroContent` | `alias` | Hero content slot (above title) |
| `content` | `alias` | WinUI Content — body below subtitle |
| `effectiveIconGlyph` | `string` | Resolved glyph string |

### Signals

| Signature | Description |
| --- | --- |
| `actionClicked()` | Emitted when action is clicked |
| `closedByUser()` | True when the user dismissed the dialog |
| `closeButtonClicked()` | Close button clicked (before dismiss) |

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
