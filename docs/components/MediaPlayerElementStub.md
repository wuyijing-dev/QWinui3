# MediaPlayerElementStub

Stub when Qt Multimedia is not linked (1.21).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MediaPlayerElementStub.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/MediaPlayerElementStub.qml)

**Category:** Media & platform · **Library:** v2.56

[← Component index](../components.md)

> Internal / support type — not part of the public Gallery surface.

**Extends** `Control`.

## Example

```qml
MediaPlayerElement {
    // available === false — show EmptyState in apps
}
```

## Notes

CMake registers this file as type MediaPlayerElement when Multimedia is
missing. Real player: MediaPlayerElement.qml. Recipe: docs/media.md.
@internal

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `available` | `bool` | — |
| `source` | `url` | — |
| `volume` | `real` | — |
| `muted` | `bool` | — |
| `autoPlay` | `bool` | — |
| `showControls` | `bool` | — |
| `accessibleName` | `string` | — |
| `playing` | `bool` | — |
| `duration` | `real` | — |
| `position` | `real` | — |
| `mediaStatus` | `int` | — |
| `errorString` | `string` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `play()` | — |
| `pause()` | — |
| `stop()` | — |
| `togglePlayPause()` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
