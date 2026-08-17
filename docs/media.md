# Media (optional Qt Multimedia) — 1.21 / 1.67

`MediaPlayerElement` is a Fluent transport shell over **Qt Multimedia** (`MediaPlayer` + `VideoOutput`).

**Status (1.67):** **experimental — deferred for remaining 1.xx.** Not freeze-covered. Apps that already ship Qt Multimedia may still use it; do not treat the type as a stable-api promise.

Gallery: **MediaPlayerElement**. Related: [stable-api.md](stable-api.md) · [packaging-consumer.md](packaging-consumer.md) · [ci-smoke.md](ci-smoke.md).

**Out of scope (1.67):** new codecs, streaming / CDN, playlists, custom pipelines, non-Qt backends.

---

## Decision (1.67) — defer, do not promote

| Question | Answer |
|----------|--------|
| Promote a thin stable subset? | **No** |
| Keep shipping? | **Yes** — real type when Multimedia is found; stub otherwise |
| Freeze-covered? | **No** — API / deploy story may still change |

**Why not promote**

| Gap | Detail |
|-----|--------|
| Optional kit | Consumer Qt installs often omit Multimedia; stub vs real is a configure-time fork |
| Backends | Windows Media Foundation vs Linux GStreamer vs FFmpeg — decode quality is not a kit contract |
| Deploy | Multimedia QML plugin / codecs are **app** `windeployqt` / installer work, not in the QWinUI3 zip |
| CI | Gallery `--smoke` does **not** decode media; no codec matrix gate |
| Surface | Transport chrome only — no playlist, captions, hardware-decode flags, or network streaming recipe |

Prefer **not** depending on this type for LoB shells that must stay on [stable-api.md](stable-api.md). Open local files with [FilePicker](system-integration.md) and host video only when you already own Multimedia deploy.

---

## Soak checklist (1.67)

What **is** soaked enough to keep shipping as experimental:

- [x] CMake `QWINUI3_BUILD_MEDIA` ON when `Qt6::Multimedia` is found; stub type still named `MediaPlayerElement` with `available === false`
- [x] Gallery page always present; `Qt.createComponent` + `Loader` so missing Multimedia never crashes the page
- [x] Keyboard Space / Enter toggles play; mute / seek / volume chrome named for a11y
- [x] Pause when the host is not visible (app recipe — see below)
- [x] Bad file → `errorString`; chrome stays usable

What **fails** promote (still open):

- [ ] Codec matrix (H.264 / WebM / audio-only) across Win + Linux kits
- [ ] Hardware decode / RHI + `VideoOutput` field bugs as a kit promise
- [ ] Shared zip / `find_package` consumer ships Multimedia plugins by default
- [ ] Headless CI decode (explicitly out of smoke)

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

Deploy the Multimedia QML plugin / plugins with your app (`windeployqt`, or `qt.conf` `QmlImports` pointing at the kit `qml` folder). QWinUI3 shared zips **do not** include the Qt runtime.

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

if (media.available === false) {
    // Show EmptyState — stub build without Multimedia
}
```

Soft-detect (Gallery pattern): `Qt.createComponent("QWinUI3.Extras", "MediaPlayerElement")` then `Loader`.

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

## Related

- [packaging-consumer.md](packaging-consumer.md) — deploying Qt modules  
- [ci-smoke.md](ci-smoke.md) — smoke does not require Multimedia  
- [accessibility.md](accessibility.md) — Space/Enter + named transport  
- Generated API: [components/MediaPlayerElement.md](components/MediaPlayerElement.md)
