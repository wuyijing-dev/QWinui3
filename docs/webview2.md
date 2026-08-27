# WebView2 embedding (Windows)

`QWinUI3.Platform.WebView2Host` embeds **Edge WebView2** as an HWND child under a `QQuickItem`.

**Stable in 1.18** for Windows apps that follow this recipe (Evergreen Runtime + `clip: true` host). Qt WebEngine remains out of scope.

Gallery page **WebView2** matches this guide.

---

## Soak checklist (1.18 — green)

| Area | Result | Notes |
|------|--------|-------|
| **Lifecycle** | Pass | Attach → env + controller; detach / destroy → `Close()` + destroy HWND; hide/opacity → `IsVisible(FALSE)` without destroy |
| **Scroll / clip** | Pass | `frameSwapped` + `mapToScene` × DPR; `SetWindowRgn` vs `clip: true` ancestors / Catalog `ScrollView` |
| **DPI / screen** | Pass | Repositions on size + `screenChanged`; uses window `devicePixelRatio` |
| **Focus** | Pass | `activeFocusOnTab`; Tab / `focusBrowser()` → `MoveFocus(PROGRAMMATIC)`; GotFocus syncs QML |
| **Missing Runtime** | Pass | `runtimeInstalled` / EmptyState / `runtimeDownloadUrl`; **Retry** (`refreshRuntimeProbe`) force-recreates after install |
| **Async teardown** | Pass (1.18) | Generation token abandons in-flight CreateEnvironment / CreateController callbacks |

Remaining limitations (documented, not blockers for promote): Windows-only; no full multi-profile Environment options API yet. **Multi-instance:** default user-data is `AppLocalDataLocation/WebView2Host/p<pid>` so Gallery and consumer exes can run side-by-side; set `userDataFolder` only when you intentionally share one profile (single-instance apps).

---

## Build

```powershell
powershell -ExecutionPolicy Bypass -File scripts/fetch_webview2.ps1
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DQWINUI3_BUILD_WEBVIEW2=ON
cmake --build build --config Release --target qwinui3_gallery
```

| CMake | Meaning |
|-------|---------|
| `QWINUI3_BUILD_WEBVIEW2` | Default **ON** on Windows |
| `QWINUI3_HAS_WEBVIEW2` | Set when NuGet SDK is found (`third_party/webview2/pkg/build/native` or `WEBVIEW2_SDK_PATH`) |

Non-Windows builds always expose a stub `WebView2Host` with `available === false`.

---

## Integration recipe

```qml
import QWinUI3.Platform
import QWinUI3.Platform.WebView2

Item {
    clip: true   // required so ScrollView / overlapping panes don't leak HWND pixels

    WebView2Host {
        id: web
        anchors.fill: parent
        source: "https://example.com"
        onNavigationCompleted: (ok) => { /* … */ }
    }
}

// Missing Runtime (mirror Gallery EmptyState):
if (!web.available) { /* not built */ }
else if (!web.runtimeInstalled) {
    // EmptyState → Qt.openUrlExternally(web.runtimeDownloadUrl)
    // Retry → web.refreshRuntimeProbe()
}
```

```cpp
// main.cpp — same as Gallery
WindowHelper::configurePlatformEnvironment(argv[0]);
```

### Lifecycle

1. Attached to a `QQuickWindow` → create child HWND + `CreateCoreWebView2Environment` (user data under `AppLocalDataLocation/WebView2Host/p<pid>` by default; override with `userDataFolder`).
2. `ready` becomes true when the controller exists; then `source` navigates.
3. Scene detach / destruction → `Close()` controller and destroy HWND (in-flight create callbacks are ignored).
4. Hide / opacity / empty clip → `put_IsVisible(FALSE)` and hide HWND (no destroy).

### Scroll / clip / DPI

- Each `frameSwapped` (and size/screen changes) repositions via `mapToScene` × DPR.
- Intersects `clip: true` ancestors and the window content item; applies `SetWindowRgn` so CatalogPage `ScrollView` does not leave ghost pixels.
- Put the host inside a clipped card/pane (Gallery does).

### Focus

- `activeFocusOnTab: true` — Tab into the item calls `MoveFocus(PROGRAMMATIC)`.
- `focusBrowser()` / browser GotFocus syncs QML active focus.
- Prefer clicking the surface or an explicit Focus button for keyboard users.

### Missing Runtime

| Property | Meaning |
|----------|---------|
| `available` | Built with WebView2 SDK (`QWINUI3_HAS_WEBVIEW2`) |
| `runtimeInstalled` | Evergreen Runtime detected (`GetAvailableCoreWebView2BrowserVersionString`) |
| `runtimeMissing` | `!runtimeInstalled` when SDK built |
| `runtimeDownloadUrl` | Microsoft Evergreen installer link |
| `refreshRuntimeProbe()` | Re-check Runtime and **force-recreate** host if it appeared |

Do **not** treat `available` alone as “can navigate” — check `runtimeInstalled` and `ready`.

---

## API (QML)

| Member | Role |
|--------|------|
| `source` / `navigate(url)` | Current URL |
| `reload` / `stop` / `goBack` / `goForward` | Navigation |
| `documentTitle` / `canGoBack` / `canGoForward` / `loading` | State |
| `statusMessage` | Human status (init / Ready / HRESULT errors) |
| `ready` | Controller ready |
| `navigationCompleted(success)` | Signal |
| `focusBrowser()` / `blurBrowser()` | Focus hand-off |
| `refreshRuntimeProbe()` | Retry after Runtime install |

---

## Ship notes

- Copy `WebView2Loader.dll` next to the app (Gallery packaging already does when enabled).
- End users need the **Evergreen WebView2 Runtime** (usually already on Win10/11 with Edge).
- Not supported: Qt WebEngine; Linux/macOS embedding.

Stable-api: **`WebView2Host` promoted in 1.18** — see [stable-api.md](stable-api.md).

**Trust boundaries (1.64):** the host does **not** cancel navigations or offer an allowlist API — gate `source` / `navigate` in the app; user data under `AppLocalDataLocation/WebView2Host/p<pid>` by default — [security-trust.md](security-trust.md).

---

## Field matrix (2.32 — 2.x floor)

Windows-only embedding. Qt **6.5+** (recommended **6.8**). Gallery `--smoke` includes **WebView2Page** (compile only — no HWND pixels in CI).

| Scenario | Expected UX | App action |
|----------|-------------|------------|
| SDK built + Runtime installed | `available && runtimeInstalled && ready` | `clip: true` host; set `source` after allowlist check |
| SDK built, Runtime missing | EmptyState + `runtimeDownloadUrl` + **Retry** (`refreshRuntimeProbe`) | Mirror Gallery; do not navigate until `runtimeInstalled` |
| `QWINUI3_BUILD_WEBVIEW2=OFF` or SDK absent | `available === false` | EmptyState “not built”; open externally |
| Non-Windows configure | Stub `available === false` | Same as not built |
| Host inside `ScrollView` / overlapping panes | `SetWindowRgn` + `mapToScene` × DPR | Parent **`clip: true`** — ghost pixels if skipped |
| High-DPI / monitor move | Repositions on `frameSwapped` + `screenChanged` | Avoid fixed pixel offsets |
| Keyboard | Tab → `MoveFocus(PROGRAMMATIC)`; `focusBrowser()` | Name host `Accessible.name` |
| In-document navigation | Edge allows — host does **not** cancel | App Pattern A/B/C below |


---

## Navigation policy recipes (2.32)

`WebView2Host` does **not** enforce policy — copy one pattern into your shell ([security-trust.md](security-trust.md) Pattern A–C).

| Pattern | When | Sketch |
|---------|------|--------|
| **A — Fixed URL** | Help / status page only | `source: "https://docs.example.com/help"` — no URL bar |
| **B — HTTPS only** | Known hosts, block `file:` / `http:` | Validate scheme before `navigate(url)` |
| **C — Host allowlist** | LoB with curated domains | Gallery **WebView2** `navigateSafe()` — suffix match on host |

```qml
function hostAllowed(urlString) {
    var m = String(urlString).match(/^https?:\/\/([^/?#]+)/i)
    if (!m) return false
    var host = m[1].toLowerCase().replace(/^www\./, "")
    for (var i = 0; i < allowedHosts.length; ++i) {
        var h = allowedHosts[i].toLowerCase()
        if (host === h || host.endsWith("." + h))
            return true
    }
    return false
}

WebView2Host {
    id: web
    // Set source only after hostAllowed(url)
}
```

**Downloads / new windows:** not intercepted by the kit — treat as app security review (block raw URL bars in production). **2.36** download policy patterns: [security-trust.md](security-trust.md) **Download policy** · Gallery **WebView2** callout.

---

## Download policy (2.36)

`WebView2Host` does **not** wire CoreWebView2 `DownloadStarting`. Edge may still prompt save/open for content on allowlisted pages.

| Pattern | When | Sketch |
|---------|------|--------|
| **D — Tight navigation** | Default LoB | Pattern A/C — users cannot reach arbitrary download hosts in-embed |
| **E — External fetch** | Known release artifact | `Qt.openUrlExternally(url)` only after `hostAllowed(url)` + explicit button |
| **F — Sandboxed save (app C++)** | Must save in-app | Your native handler: destination under `AppDataLocation`, confirm filename, block `.exe` |

```qml
// Policy E — never auto-download from page JS; user clicks a vetted control
Button {
    text: qsTr("Get update (browser)")
    onClicked: {
        if (!hostAllowed(updateUrl))
            return
        Qt.openUrlExternally(updateUrl)
    }
}
```

**Checklist:** no silent writes to `%USERPROFILE%\\Downloads`; log blocked attempts; same host rules as navigation. Full cookbook: [security-trust.md](security-trust.md) wave 3 (**2.36**).

Gallery: **WebView2** trust + field matrix callouts (**2.32** / **2.36**).
