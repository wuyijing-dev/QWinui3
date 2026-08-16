# SwipeAction

Action revealed by SwipeControl.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SwipeAction.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SwipeAction.qml)

**Category:** Other · **Library:** v1.08

[← Component index](../components.md)

**Extends** `Item`.

## Example

```qml
SwipeControl {
    SwipeAction {
        text: qsTr("Delete")
        symbol: FluentIcons.Delete
        behaviorOnInvoked: "close"
        onTriggered: remove()
    }
    Label { text: qsTr("Row") }
}
```

## Notes

Action revealed by SwipeControl; text/symbol + onTriggered.
behaviorOnInvoked: auto | close | remainOpen (WinUI SwipeBehaviorOnInvoked).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `text` | `string` | Display / input text |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `color` | `color` | Primary color |
| `textColor` | `color` | Badge / content text color |
| `leading` | `bool` | Leading content slot |
| `behaviorOnInvoked` | `string` | WinUI BehaviorOnInvoked: auto \| close \| remainOpen |
| `effectiveGlyph` | `string` | Resolved glyph string |
| `swipeControl` | `var` | Host SwipeControl (wired by SwipeControl — no parent walk) |

### Signals

| Signature | Description |
| --- | --- |
| `triggered()` | Emitted when the action is invoked (preferred) |
| `clicked()` | Emitted when clicked (alias of triggered for older demos) |

### Methods

| Signature | Description |
| --- | --- |
| `invoke()` | Invoke this action (also used by SwipeControl execute mode) |

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
