# 窗口材质说明（当前 Gallery 策略）

Gallery **默认不透明 Solid**，不再启用 Mica / Acrylic / 窗口透明宿主。

此前白边来自：

1. 默认 `BackdropMica` 强制 `window.color = transparent`
2. Gallery 自绘的 1px 描边框（`borderVisible`）在浅色主题下看起来像白边

这些路径已从 Gallery 去掉。平台层仍保留 `WindowHelper` 的 backdrop API（供其它应用选用），但 Gallery 安装时固定 `BackdropSolid`。

若要重新做原生毛玻璃，需单独恢复透明宿主 + DWM `SYSTEMBACKDROP`，且不要叠加 QML 描边框。

RHI / `--rhi` / Fixedsys 警告见 [`graphics-backend.md`](graphics-backend.md)。
Tray、壳窗口总览见 [`window-shells.md`](window-shells.md) 与 Platform `TrayIcon`（C++，见源码 `src/platform/QWinUI3/Platform/TrayIcon.h`）。
