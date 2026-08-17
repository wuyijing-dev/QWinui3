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

Remaining limitations (documented, not blockers for promote): Windows-only; single user-data folder under `AppLocalDataLocation/WebView2Host`; no multi-profile / custom Environment options API yet.

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

1. Attached to a `QQuickWindow` → create child HWND + `CreateCoreWebView2Environment` (user data under `AppLocalDataLocation/WebView2Host`).
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

**Trust boundaries (1.64):** the host does **not** cancel navigations or offer an allowlist API — gate `source` / `navigate` in the app; user data under `AppLocalDataLocation/WebView2Host` — [security-trust.md](security-trust.md).
