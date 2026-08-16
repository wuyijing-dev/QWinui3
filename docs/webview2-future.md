# Future: WebView2 embedding

Qt WebEngine is intentionally stripped from Gallery deploy (`cmake/StripRestrictedQtModules.cmake`).

A Win32 **WebView2** host (Edge WebView2 Runtime + HWND child under a `QQuickItem`) is the preferred path for in-app web content on Windows. It is **not** implemented in this tree yet.

Until then:

- Use an external browser / `Qt.openUrlExternally` for links.
- Prefer native QML for settings and dashboards (see `examples/`).
