# Future: WebView2 embedding

Qt WebEngine is intentionally stripped from Gallery deploy (`cmake/StripRestrictedQtModules.cmake`).

## Status

**Implemented (optional):** `QWinUI3.Platform.WebView2Host` — HWND child under a
`QQuickItem`, Edge **WebView2 Runtime**, NuGet SDK via `scripts/fetch_webview2.ps1`.

```powershell
powershell -ExecutionPolicy Bypass -File scripts/fetch_webview2.ps1
cmake -S . -B build -DQWINUI3_BUILD_WEBVIEW2=ON
cmake --build build --target qwinui3_gallery
```

Gallery page: **WebView2**. When the SDK is missing or the platform is not Windows,
the page shows `EmptyState` and can open the URL externally.

CMake: `QWINUI3_BUILD_WEBVIEW2` (default ON on Windows). `QWINUI3_HAS_WEBVIEW2` is
set when `third_party/webview2/pkg/build/native` (or `WEBVIEW2_SDK_PATH`) is found.

## Notes

- Prefer native QML for settings and dashboards (see `examples/`).
- Do not ship Qt WebEngine with the Gallery binary.
- `WebView2Host` syncs the child HWND from `mapToScene` on each window frame and
  clips to `clip: true` ancestors so CatalogPage `ScrollView` scrolling stays aligned.
