# WindowHelper

Platform chrome, backdrop, DPI, and geometry helpers (singleton).

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/WindowHelper.h`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/WindowHelper.h)

**Category:** Platform · **Library:** v3.10 · **C++ type** · **singleton**

[← Component index](../components.md)

**Gallery:** `Window shells` — [`src/gallery/pages/WindowParadigmPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/WindowParadigmPage.qml)

**Extends** `QObject`.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `platformName` | `QString` | — |
| `windows` | `bool` | — |
| `linux` | `bool` | — |
| `customFrame` | `bool` | — |
| `nativeChrome` | `bool` | — |
| `supportsBackdrop` | `bool` | — |
| `recommendedFlags` | `int` | — |
| `windowColor` | `QColor` | — |
| `contentTint` | `QColor` | — |
| `titleBarTint` | `QColor` | — |
| `backdrop` | `int` | — |
| `cornerPreference` | `int` | — |
| `borderVisible` | `bool` | — |
| `windowActive` | `bool` | — |
| `captionHover` | `int` | — |
| `captionPressed` | `int` | — |
| `frostEnabled` | `bool` | — |
| `frostBlur` | `qreal` | — |
| `frostSaturation` | `qreal` | — |
| `desktopWallpaperUrl` | `QUrl` | — |
| `virtualDesktopGeometry` | `QRect` | — |
| `systemReducedMotion` | `bool` | — |
| `systemHighContrast` | `bool` | — |
| `displayServer` | `QString` | — |
| `wayland` | `bool` | — |
| `x11` | `bool` | — |
| `serverSideDecorations` | `bool` | — |
| `clientShellDecoration` | `bool` | — |
| `shellQuickEffectsAvailable` | `bool` | — |
| `shellCompositorProfile` | `QString` | — |
| `desktopEnvironment` | `QString` | — |
| `waylandDisplay` | `QString` | — |
| `systemPrefersDark` | `bool` | — |
| `systemAccent` | `QColor` | — |
| `portalAvailable` | `bool` | — |
| `devicePixelRatio` | `qreal` | — |
| `snapLayoutsEnabled` | `bool` | — |
| `layoutDirection` | `int` | — |
| `idleInhibited` | `bool` | — |
| `batteryLevel` | `int` | — |
| `onBattery` | `bool` | — |
| `isOnline` | `bool` | — |
| `screenCount` | `int` | — |

### Signals

| Signature | Description |
| --- | --- |
| `windowColorChanged()` | — |
| `contentTintChanged()` | — |
| `backdropChanged()` | — |
| `cornerPreferenceChanged()` | — |
| `borderVisibleChanged()` | — |
| `windowActiveChanged()` | — |
| `captionHoverChanged()` | — |
| `captionPressedChanged()` | — |
| `wallpaperChanged()` | — |
| `accessibilityChanged()` | — |
| `colorSchemeChanged()` | — |
| `systemAccentChanged()` | — |
| `snapLayoutsEnabledChanged()` | — |
| `screensChanged()` | — |
| `idleInhibitedChanged()` | — |
| `layoutDirectionChanged()` | — |
| `powerChanged()` | — |
| `onlineChanged()` | — |
| `singleInstanceActivationRequested(const QStringList &args)` | — |

### Methods

| Signature | Description |
| --- | --- |
| `devicePixelRatioForWindow(QObject *windowObject) const)` | — |
| `highDpiScaleFactorRoundingPolicy() const)` | — |
| `notifyDisplayMetricsChanged()` | — |
| `setDesktopFileName(const QString &desktopFileName)` | — |
| `requestActivateWindow(QObject *windowObject)` | — |
| `setNoActivate(QObject *windowObject, bool on = true)` | — |
| `setTransientParent(QObject *windowObject, QObject *parentWindowObject)` | — |
| `ensureWindowCreated(QObject *windowObject)` | — |
| `portalParentWindow(QObject *windowObject) const)` | — |
| `openExternalUrl(const QString &url)` | — |
| `refreshColorScheme()` | — |
| `refreshSystemAccent()` | — |
| `install(QObject *windowObject, bool dark = false, int backdrop = BackdropSolid)` | — |
| `installParadigm(QObject *windowObject, int paradigm,
                                     bool dark = false, int backdrop = BackdropSolid)` | — |
| `installParadigmEx(QObject *windowObject, int paradigm,
                                       bool dark, int backdrop, int presenter, bool alwaysOnTop)` | — |
| `flagsForParadigm(int paradigm) const)` | — |
| `flagsForConfig(int paradigm, int presenter, bool alwaysOnTop) const)` | — |
| `paradigmName(int paradigm) const)` | — |
| `centerOnScreen(QObject *windowObject)` | — |
| `centerOnOwner(QObject *windowObject, QObject *ownerWindowObject)` | — |
| `setDarkMode(QObject *windowObject, bool dark)` | — |
| `setBackdrop(QObject *windowObject, int backdrop)` | — |
| `resolveBackdrop(int backdrop) const)` | — |
| `setCornerStyle(QObject *windowObject, int corner)` | — |
| `shellCornerRadius() const)` | — |
| `shellShadowMargin() const)` | — |
| `shellShadowOpacity() const)` | — |
| `shellShadowBlur() const)` | — |
| `shellShadowVerticalOffset() const)` | — |
| `shellContentInset(QObject *windowObject) const)` | — |
| `shellChromeExpanded(QObject *windowObject) const)` | — |
| `reapply(QObject *windowObject = nullptr)` | — |
| `backdropName(int backdrop) const)` | — |
| `refreshWallpaper()` | — |
| `refreshAccessibility()` | — |
| `setPresenter(QObject *windowObject, int kind)` | — |
| `presenterKind(QObject *windowObject) const)` | — |
| `presenterName(int kind) const)` | — |
| `setAlwaysOnTop(QObject *windowObject, bool on)` | — |
| `isAlwaysOnTop(QObject *windowObject) const)` | — |
| `titleBarHeightForOption(int option) const)` | — |
| `titleBarHeightName(int option) const)` | — |
| `setTaskbarProgress(QObject *windowObject, double value)` | — |
| `setTaskbarProgressState(QObject *windowObject, int state)` | — |
| `clearTaskbarProgress(QObject *windowObject)` | — |
| `setTaskbarOverlayText(QObject *windowObject, const QString &text)` | — |
| `clearTaskbarOverlay(QObject *windowObject)` | — |
| `requestUserAttention(QObject *windowObject, bool continuous = false)` | — |
| `revealFileInFolder(const QString &path, QObject *parentWindow = nullptr)` | — |
| `copyText(const QString &text)` | — |
| `clipboardText() const)` | — |
| `systemBeep()` | — |
| `setLayoutDirection(int direction)` | — |
| `inhibitIdle(const QString &reason = QString())` | — |
| `releaseIdleInhibit()` | — |
| `addToRecentDocuments(const QString &path)` | — |
| `clearRecentDocuments()` | — |
| `registerFileAssociation(const QString &extension,
                                             const QString &progId,
                                             const QString &friendlyName,
                                             const QString &openCommand = QString())` | — |
| `unregisterFileAssociation(const QString &extension,
                                               const QString &progId)` | — |
| `tryBecomeSingleInstancePrimary(const QString &serverName = QString())` | — |
| `singleInstanceEnvOptIn() const)` | — |
| `refreshPowerStatus()` | — |
| `refreshOnlineStatus()` | — |
| `screensInfo() const)` | — |
| `saveWindowGeometry(QObject *windowObject, const QString &key = QStringLiteral("MainWindow"))` | — |
| `restoreWindowGeometry(QObject *windowObject, const QString &key = QStringLiteral("MainWindow"))` | — |
| `clearWindowGeometry(const QString &key = QStringLiteral("MainWindow"))` | — |
| `updateHitTestLayout(QObject *windowObject,
                                         const QRect &titleBar,
                                         const QRect &minimizeButton,
                                         const QRect &maximizeButton,
                                         const QRect &closeButton,
                                         const QVariantList &clientRects =)` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
