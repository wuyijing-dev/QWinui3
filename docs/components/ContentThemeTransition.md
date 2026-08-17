# ContentThemeTransition

Cross-fade + slight horizontal shift when swapping content.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ContentThemeTransition.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ContentThemeTransition.qml)

**Category:** Media & platform · **Library:** v2.63

[← Component index](../components.md)

**Extends** `Item`.

## Example

```qml
ContentThemeTransition {
    id: transition
    anchors.fill: parent
    contentKey: currentPageId
    Label { text: "…" }
}

// --- API ---
// properties: contentKey, offsetX, autoPlay
// methods: play(), reset()
```

## Notes

Change contentKey (or call play) after replacing children to animate in.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `content` | `alias` | — |
| `contentKey` | `var` | Change this when content identity changes to re-run the transition |
| `offsetX` | `real` | Horizontal offset at start (px); positive enters from the right |
| `autoPlay` | `bool` | Play automatically when contentKey changes / completed |
| `running` | `bool` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `play()` | — |
| `reset()` | — |

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
