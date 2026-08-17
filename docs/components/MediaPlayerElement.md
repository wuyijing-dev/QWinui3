# MediaPlayerElement

Fluent shell around Qt Multimedia MediaPlayer / VideoOutput.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MediaPlayerElement.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/MediaPlayerElement.qml)

**Category:** Media & platform · **Library:** v1.80

[← Component index](../components.md)

**Gallery:** `MediaPlayerElement` — [`src/gallery/pages/MediaPlayerElementPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/MediaPlayerElementPage.qml)

**Extends** `Control`.

## Example

```qml
MediaPlayerElement {
    source: "file:///C:/video.mp4"
    Layout.fillWidth: true
    Layout.preferredHeight: 320
}
// --- API ---
// methods: play(), pause(), stop(), togglePlayPause()
// media.play() / media.pause() / media.stop()
```

## Notes

Optional Qt Multimedia — build with -DQWINUI3_BUILD_MEDIA=ON (default when Multimedia
is found). When Multimedia is absent, Extras ships a stub with available === false.
Recipe: docs/media.md (1.21). Deferred 1.67 — remains experimental (codecs / backends vary).
Keyboard: Space / Enter toggles play; focusable transport chrome.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `available` | `bool` | Always true in the Multimedia build (stub sets false). |
| `source` | `alias` | Media URL |
| `volume` | `alias` | Playback volume 0..1 |
| `muted` | `alias` | Mute flag |
| `autoPlay` | `bool` | Auto-play when source is set |
| `showControls` | `bool` | Show transport chrome |
| `accessibleName` | `string` | Screen-reader name override |
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
