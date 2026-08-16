# Media (optional Qt Multimedia) — 1.21

`MediaPlayerElement` is a Fluent transport shell over **Qt Multimedia** (`MediaPlayer` + `VideoOutput`).

**Status:** **experimental** — codecs, GPU backends, and packaging differ by OS/kit. The API is the supported optional path for LoB apps that already ship Multimedia.

Gallery: **MediaPlayerElement**.

---

## Build

| CMake | Meaning |
|-------|---------|
| `QWINUI3_BUILD_MEDIA` | Default **ON** when `Qt6::Multimedia` is found; **OFF** otherwise |
| Result when Multimedia present | Real `MediaPlayerElement.qml` linked to `Qt6::Multimedia` (+ `MultimediaQuick` when available) |
| Result when Multimedia absent | Stub type still named `MediaPlayerElement` with `available === false` |

```powershell
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DQWINUI3_BUILD_MEDIA=ON
cmake --build build --config Release --target qwinui3_gallery
```

Deploy the Multimedia QML plugin / plugins with your app (`windeployqt`, or `qt.conf` `QmlImports` pointing at the kit `qml` folder).

---

## Integration recipe

```qml
import QWinUI3.Extras

MediaPlayerElement {
    id: media
    anchors.fill: parent
    source: "file:///C:/Videos/demo.mp4"
    autoPlay: true
    onVisibleChanged: if (!visible) media.pause()
}

// Soft-detect (Gallery pattern):
Component {
    id: probe
    MediaPlayerElement {}
}
// Or: Qt.createComponent("QWinUI3.Extras", "MediaPlayerElement")
if (media.available === false) {
    // Show EmptyState — stub build without Multimedia
}
```

| Member | Role |
|--------|------|
| `available` | `true` in Multimedia builds; `false` on stub |
| `source` / `play` / `pause` / `stop` / `togglePlayPause` | Transport |
| `volume` / `muted` | Audio |
| `autoPlay` / `showControls` | UX knobs |
| `playing` / `position` / `duration` / `errorString` | State |
| Space / Enter | Toggle play when the control is focused |

---

## Failure matrix

| Situation | Behavior |
|-----------|----------|
| No Qt Multimedia at configure | Stub `MediaPlayerElement`; Gallery EmptyState |
| Multimedia built but QML plugin missing at runtime | `createComponent` / load error — Gallery shows error string |
| Bad / unsupported file | `errorString` from `MediaPlayer`; chrome stays usable |
| Headless / offscreen CI | Prefer not relying on decode; smoke does not require this page |

---

## Stable-api decision (1.21)

Remain **experimental** on [stable-api.md](stable-api.md) — explicitly **deferred in 1.37** (won’t promote until Multimedia deploy story soaks).

Out of scope for 1.21: playlists, custom pipelines, non-Qt backends.

---

## Related

- [packaging-consumer.md](packaging-consumer.md) — deploying Qt modules  
- [ci-smoke.md](ci-smoke.md) — smoke does not require Multimedia  
- Generated API: [components/MediaPlayerElement.md](components/MediaPlayerElement.md)
