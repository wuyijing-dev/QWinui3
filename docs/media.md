# Media (optional Qt Multimedia) — 1.21 / 1.67 / 2.09

`MediaPlayerElement` is a Fluent transport shell over **Qt Multimedia** (`MediaPlayer` + `VideoOutput`).

**Status (2.09):** **experimental — permanently deferred.** Not freeze-covered. The type still ships (real player when Multimedia is linked; `available === false` stub otherwise). Product shells on [stable-api.md](stable-api.md) should **not** depend on it.

Gallery: **MediaPlayerElement**. Related: [stable-api.md](stable-api.md) · [packaging-consumer.md](packaging-consumer.md) · `python scripts/smoke_gallery.py`.

**Out of scope:** bundling FFmpeg, cloud streaming SDKs, playlists, captions, hardware-decode promises.

---

## Verdict (2.09) — permanent defer, do not promote

Closes the **1.67** promote/defer loop. Soak is green enough to **keep shipping** as experimental; promote blockers remain open.

| Question | Answer |
|----------|--------|
| Promote to stable-api? | **No — permanent defer (2.09)** |
| Keep shipping? | **Yes** — real type when Multimedia is found; stub otherwise |
| Freeze-covered? | **No** |
| Product LoB on stable-api? | **Do not require** this type |

**Why permanent defer (not a kit contract)**

| Gap | Detail |
|-----|--------|
| Optional kit | Consumer Qt installs often omit Multimedia; stub vs real is a configure-time fork |
| Backends | Windows Media Foundation vs Linux GStreamer vs FFmpeg — decode quality varies by OS/kit |
| Deploy | Multimedia QML plugin / codecs are **app** `windeployqt` / installer work, not in QWinUI3 zips |
| CI | Gallery `--smoke` does **not** decode media; no codec matrix gate |
| Surface | Transport chrome only — no playlist, captions, streaming recipe, or hardware-decode flags |

**App-owned path when you need video:** install/link Qt Multimedia yourself, deploy plugins with your installer, gate UI on `available === false`, pause when hidden. Use [FilePicker](system-integration.md) for local files.

---

## Soak checklist (shipped — experimental)

What **is** soaked enough to keep shipping:

- [x] CMake `QWINUI3_BUILD_MEDIA` ON when `Qt6::Multimedia` is found; stub type still named `MediaPlayerElement` with `available === false`
- [x] Gallery page always present; `Qt.createComponent` + `Loader` so missing Multimedia never crashes the page
- [x] Keyboard Space / Enter toggles play; mute / seek / volume chrome named for a11y
- [x] Pause when the host is not visible (Gallery recipe)
- [x] Bad file → `errorString`; chrome stays usable

What **blocks promote** (unchanged — why defer is permanent):

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
| Product on stable-api only | Do not ship MediaPlayerElement — use app-owned Multimedia or external player |

---

## Field matrix (2.32 — 2.x floor)

Qt **6.5+** (recommended **6.8**). Gallery `--smoke` compiles **MediaPlayerElementPage** but does **not** decode video.

| Scenario | Windows Release | Linux Release | App action |
|----------|-----------------|---------------|------------|
| `QWINUI3_BUILD_MEDIA=ON` + kit has Multimedia | Real player (`available === true`) | Real (GStreamer backend) | Deploy Multimedia QML plugin via `windeployqt` / package |
| Multimedia absent at configure | Stub (`available === false`) | Same | EmptyState; optional `-DQWINUI3_BUILD_MEDIA=ON` after installing Multimedia |
| QML plugin missing at runtime | `createComponent` error / load fail | Same | Ship `QtMultimedia` / `QtMultimediaQuick` imports with installer |
| Unsupported codec / bad file | `errorString`; chrome usable | Same | App-owned codec matrix — not a kit promise |
| Hidden / off-screen host | Gallery pauses on `visible === false` | Same | `onVisibleChanged: if (!visible) pause()` |
| CI / headless smoke | Page instantiates; no decode gate | Same | Do not gate CI on playback |

**Deploy checklist (app-owned — not in QWinUI3 zips):**

1. Configure with `-DQWINUI3_BUILD_MEDIA=ON` when `Qt6::Multimedia` is present.
2. Run `windeployqt` (or Linux equivalent) including **Multimedia** QML plugins.
3. Gate product UI on `MediaPlayerElement.available === false` → EmptyState + docs link.
4. Soft-load with `Qt.createComponent("QWinUI3.Extras", "MediaPlayerElement")` + `Loader` (Gallery pattern).

See [packaging-consumer.md](packaging-consumer.md) · Gallery **MediaPlayerElement** field matrix callout (**2.32**).

---

## Related

- [packaging-consumer.md](packaging-consumer.md) — deploying Qt modules  
- `python scripts/smoke_gallery.py` — smoke does not require Multimedia  
- [accessibility.md](accessibility.md) — Space/Enter + named transport  
- Generated API: [components/MediaPlayerElement.md](components/MediaPlayerElement.md)
