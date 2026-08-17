#pragma once

#include <QObject>
#include <QColor>
#include <QRect>
#include <QUrl>
#include <QVariantList>
#include <QtQml/qqmlregistration.h>

class QWindow;
class QQmlEngine;
class QJSEngine;

class WindowHelper : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    // --- platform / chrome capabilities ---
    Q_PROPERTY(QString platformName READ platformName CONSTANT)
    Q_PROPERTY(bool windows READ isWindows CONSTANT)
    Q_PROPERTY(bool linux READ isLinux CONSTANT)
    Q_PROPERTY(bool customFrame READ customFrame CONSTANT)
    Q_PROPERTY(bool nativeChrome READ nativeChrome CONSTANT)
    Q_PROPERTY(bool supportsBackdrop READ supportsBackdrop CONSTANT)
    Q_PROPERTY(int recommendedFlags READ recommendedFlags CONSTANT)
    // --- tints / backdrop ---
    Q_PROPERTY(QColor windowColor READ windowColor NOTIFY windowColorChanged)
    Q_PROPERTY(QColor contentTint READ contentTint NOTIFY contentTintChanged)
    Q_PROPERTY(QColor titleBarTint READ titleBarTint NOTIFY contentTintChanged)
    Q_PROPERTY(int backdrop READ backdrop WRITE setBackdropMode NOTIFY backdropChanged)
    Q_PROPERTY(int cornerPreference READ cornerPreference WRITE setCornerPreference NOTIFY cornerPreferenceChanged)
    Q_PROPERTY(bool borderVisible READ borderVisible WRITE setBorderVisible NOTIFY borderVisibleChanged)
    Q_PROPERTY(bool windowActive READ windowActive NOTIFY windowActiveChanged)
    // Caption button hover/press driven by native NC hit-test (or QML)
    Q_PROPERTY(int captionHover READ captionHover NOTIFY captionHoverChanged)
    Q_PROPERTY(int captionPressed READ captionPressed NOTIFY captionPressedChanged)
    // Qt-side frosted glass (works even when DWM materials don't composite through RHI)
    Q_PROPERTY(bool frostEnabled READ frostEnabled NOTIFY backdropChanged)
    Q_PROPERTY(qreal frostBlur READ frostBlur NOTIFY backdropChanged)
    Q_PROPERTY(qreal frostSaturation READ frostSaturation NOTIFY backdropChanged)
    Q_PROPERTY(QUrl desktopWallpaperUrl READ desktopWallpaperUrl NOTIFY wallpaperChanged)
    Q_PROPERTY(QRect virtualDesktopGeometry READ virtualDesktopGeometry NOTIFY wallpaperChanged)
    // OS accessibility (Windows SPI); Theme.followSystemAccessibility can mirror these
    Q_PROPERTY(bool systemReducedMotion READ systemReducedMotion NOTIFY accessibilityChanged)
    Q_PROPERTY(bool systemHighContrast READ systemHighContrast NOTIFY accessibilityChanged)
    // Display server / compositor (windows | wayland | xcb | …)
    Q_PROPERTY(QString displayServer READ displayServer CONSTANT)
    Q_PROPERTY(bool wayland READ isWayland CONSTANT)
    Q_PROPERTY(bool x11 READ isX11 CONSTANT)
    // Linux / Wayland: false when using client-side Fluent chrome (customFrame).
    Q_PROPERTY(bool serverSideDecorations READ serverSideDecorations CONSTANT)
    Q_PROPERTY(QString desktopEnvironment READ desktopEnvironment CONSTANT)
    Q_PROPERTY(QString waylandDisplay READ waylandDisplay CONSTANT)
    Q_PROPERTY(bool systemPrefersDark READ systemPrefersDark NOTIFY colorSchemeChanged)
    Q_PROPERTY(bool portalAvailable READ portalAvailable CONSTANT)
    Q_PROPERTY(qreal devicePixelRatio READ devicePixelRatio NOTIFY screensChanged)
    // Win11 Snap Layouts: report HTMAXBUTTON for the maximize caption rect
    Q_PROPERTY(bool snapLayoutsEnabled READ snapLayoutsEnabled WRITE setSnapLayoutsEnabled NOTIFY snapLayoutsEnabledChanged)

public:
    enum Backdrop {
        BackdropAuto = 0,
        BackdropNone = 1,
        BackdropMica = 2,
        BackdropAcrylic = 3,
        BackdropMicaAlt = 4,
        BackdropTransparent = 5,
        BackdropSolid = 6
    };
    Q_ENUM(Backdrop)

    enum CornerPreference {
        CornerDefault = 0,
        CornerDoNotRound = 1,
        CornerRound = 2,
        CornerRoundSmall = 3
    };
    Q_ENUM(CornerPreference)

    enum CaptionButton {
        CaptionNone = 0,
        CaptionMinimize = 1,
        CaptionMaximize = 2,
        CaptionClose = 3
    };
    Q_ENUM(CaptionButton)

    // Fluent / WinUI-style top-level window paradigms.
    enum WindowParadigm {
        ParadigmStandard = 0, // primary application window
        ParadigmDialog = 1,   // secondary dialog / prompt window
        ParadigmTool = 2      // tool / palette / inspector window
    };
    Q_ENUM(WindowParadigm)

    // WinUI AppWindowPresenterKind
    enum PresenterKind {
        PresenterOverlapped = 0,
        PresenterFullScreen = 1,
        PresenterCompactOverlay = 2
    };
    Q_ENUM(PresenterKind)

    // WinUI TitleBar.PreferredHeightOption / AppWindowTitleBar height
    enum TitleBarHeightOption {
        TitleBarHeightStandard = 0, // 32px
        TitleBarHeightTall = 1      // 48px
    };
    Q_ENUM(TitleBarHeightOption)

    // Taskbar progress (ITaskbarList3 on Windows)
    enum TaskbarProgressState {
        TaskbarNoProgress = 0,
        TaskbarIndeterminate = 1,
        TaskbarNormal = 2,
        TaskbarError = 3,
        TaskbarPaused = 4
    };
    Q_ENUM(TaskbarProgressState)

    explicit WindowHelper(QObject *parent = nullptr);

    QString platformName() const;
    bool isWindows() const;
    bool isLinux() const;
    bool customFrame() const;
    bool nativeChrome() const;
    bool supportsBackdrop() const;
    int recommendedFlags() const;
    QColor windowColor() const;
    QColor contentTint() const;
    QColor titleBarTint() const;
    int backdrop() const { return m_backdrop; }
    int cornerPreference() const { return m_corner; }
    bool borderVisible() const { return m_borderVisible; }
    bool windowActive() const { return m_windowActive; }
    int captionHover() const { return m_captionHover; }
    int captionPressed() const { return m_captionPressed; }
    bool frostEnabled() const;
    qreal frostBlur() const;
    qreal frostSaturation() const;
    QUrl desktopWallpaperUrl() const;
    QRect virtualDesktopGeometry() const;
    bool systemReducedMotion() const { return m_systemReducedMotion; }
    bool systemHighContrast() const { return m_systemHighContrast; }
    QString displayServer() const;
    bool isWayland() const;
    bool isX11() const;
    bool serverSideDecorations() const;
    QString desktopEnvironment() const;
    QString waylandDisplay() const;
    bool systemPrefersDark() const { return m_systemPrefersDark; }
    bool portalAvailable() const;
    qreal devicePixelRatio() const;
    // Per-window / per-monitor DPR (falls back to primary screen).
    Q_INVOKABLE qreal devicePixelRatioForWindow(QObject *windowObject) const;
    // Native DPI / scale changes (e.g. WM_DPICHANGED) — refreshes devicePixelRatio bindings.
    Q_INVOKABLE void notifyDisplayMetricsChanged();
    bool snapLayoutsEnabled() const { return m_snapLayoutsEnabled; }
    void setSnapLayoutsEnabled(bool enabled);

    // Call before QGuiApplication on Linux: Wayland-first QPA + SSD.
    // High-DPI PassThrough is applied by QWinUI3::configureEnvironment (API).
    // Call before QGuiApplication. Pass argv[0] on Linux so a broken
    // build/qt.conf (Plugins=plugins) can be removed before Qt reads it.
    static void configurePlatformEnvironment(const char *argv0 = nullptr);
    // Windows AppUserModelID (taskbar grouping); also sets desktop file name on Linux.
    static void setAppUserModelId(const QString &appId);
    // Wayland app_id / X11 WM_CLASS — pass desktop id without ".desktop"
    Q_INVOKABLE void setDesktopFileName(const QString &desktopFileName);
    // Raise / activate (Wayland may need xdg-activation token from the compositor)
    Q_INVOKABLE void requestActivateWindow(QObject *windowObject);
    // Floating OSK: Win32 WS_EX_NOACTIVATE + WM_MOUSEACTIVATE → MA_NOACTIVATE (1.83).
    Q_INVOKABLE void setNoActivate(QObject *windowObject, bool on = true);
    // Dialog parenting (important on Wayland for correct stacking / modality)
    Q_INVOKABLE void setTransientParent(QObject *windowObject, QObject *parentWindowObject);
    // Portal FileChooser parent_window string (Linux); empty on Win / pure Wayland without export.
    // 1.79: prefers Qt portalWindowIdentifier (xdg-foreign) when GuiPrivate is linked.
    Q_INVOKABLE QString portalParentWindow(QObject *windowObject) const;
    // Open http(s)/file URLs via xdg-desktop-portal OpenURI when available
    Q_INVOKABLE bool openExternalUrl(const QString &url);
    Q_INVOKABLE void refreshColorScheme(); // poll OS light/dark preference

    void setBackdropMode(int backdrop);
    void setCornerPreference(int corner);
    void setBorderVisible(bool visible);

    Q_INVOKABLE void install(QObject *windowObject, bool dark = false, int backdrop = BackdropSolid); // attach chrome
    Q_INVOKABLE void installParadigm(QObject *windowObject, int paradigm,
                                     bool dark = false, int backdrop = BackdropSolid); // Standard/Dialog/Tool
    Q_INVOKABLE void installParadigmEx(QObject *windowObject, int paradigm,
                                       bool dark, int backdrop, int presenter, bool alwaysOnTop);
    Q_INVOKABLE int flagsForParadigm(int paradigm) const; // recommended Qt::WindowFlags
    Q_INVOKABLE int flagsForConfig(int paradigm, int presenter, bool alwaysOnTop) const;
    Q_INVOKABLE QString paradigmName(int paradigm) const;
    Q_INVOKABLE void centerOnScreen(QObject *windowObject);
    Q_INVOKABLE void setDarkMode(QObject *windowObject, bool dark);
    Q_INVOKABLE void setBackdrop(QObject *windowObject, int backdrop);
    // Map requested backdrop to what this platform can actually composite (Linux → Solid).
    Q_INVOKABLE int resolveBackdrop(int backdrop) const;
    Q_INVOKABLE void setCornerStyle(QObject *windowObject, int corner);
    Q_INVOKABLE void reapply(QObject *windowObject = nullptr); // re-apply tracked/given window
    Q_INVOKABLE QString backdropName(int backdrop) const;
    Q_INVOKABLE void refreshWallpaper(); // reload desktop wallpaper URL
    Q_INVOKABLE void refreshAccessibility(); // poll SPI reduced-motion / high-contrast

    // WinUI AppWindowPresenterKind
    Q_INVOKABLE void setPresenter(QObject *windowObject, int kind);
    Q_INVOKABLE int presenterKind(QObject *windowObject) const;
    Q_INVOKABLE QString presenterName(int kind) const;
    Q_INVOKABLE void setAlwaysOnTop(QObject *windowObject, bool on);
    Q_INVOKABLE bool isAlwaysOnTop(QObject *windowObject) const;
    Q_INVOKABLE int titleBarHeightForOption(int option) const;
    Q_INVOKABLE QString titleBarHeightName(int option) const;

    // --- shell extras (stable 1.17; docs/shell-extras.md) ---
    // Taskbar overlay progress (Windows ITaskbarList3; no-op elsewhere)
    Q_INVOKABLE void setTaskbarProgress(QObject *windowObject, double value);
    Q_INVOKABLE void setTaskbarProgressState(QObject *windowObject, int state);
    Q_INVOKABLE void clearTaskbarProgress(QObject *windowObject);
    // Taskbar overlay badge text (Windows SetOverlayIcon; empty clears)
    Q_INVOKABLE void setTaskbarOverlayText(QObject *windowObject, const QString &text);
    Q_INVOKABLE void clearTaskbarOverlay(QObject *windowObject);

    // Flash / urgency attention (FlashWindowEx on Windows; raise elsewhere)
    Q_INVOKABLE void requestUserAttention(QObject *windowObject, bool continuous = false);
    // Reveal path in system file manager (Explorer select / FileManager1 → OpenURI)
    Q_INVOKABLE bool revealFileInFolder(const QString &path);
    // Clipboard helpers
    Q_INVOKABLE void copyText(const QString &text);
    Q_INVOKABLE QString clipboardText() const;
    Q_INVOKABLE void systemBeep();
    // Idle inhibit (Windows SetThreadExecutionState / Linux ScreenSaver+portal)
    Q_INVOKABLE bool inhibitIdle(const QString &reason = QString());
    Q_INVOKABLE void releaseIdleInhibit();
    Q_PROPERTY(bool idleInhibited READ idleInhibited NOTIFY idleInhibitedChanged)

    // Windows AppUserModelID (taskbar grouping / toast identity) — use static setAppUserModelId
    // Shell recent documents (Windows SHAddToRecentDocs; Linux best-effort)
    Q_INVOKABLE void addToRecentDocuments(const QString &path);
    Q_INVOKABLE void clearRecentDocuments();

    // Power / network / screens
    Q_PROPERTY(int batteryLevel READ batteryLevel NOTIFY powerChanged) // 0–100, or -1 unknown
    Q_PROPERTY(bool onBattery READ onBattery NOTIFY powerChanged)
    Q_PROPERTY(bool isOnline READ isOnline NOTIFY onlineChanged)
    Q_PROPERTY(int screenCount READ screenCount NOTIFY screensChanged)
    Q_INVOKABLE void refreshPowerStatus();
    Q_INVOKABLE void refreshOnlineStatus();
    Q_INVOKABLE QVariantList screensInfo() const; // [{name,geometry,availableGeometry,dpr,primary}]

    // Window geometry persistence (QSettings under org/app → WindowGeometry/<key>)
    Q_INVOKABLE void saveWindowGeometry(QObject *windowObject, const QString &key = QStringLiteral("MainWindow"));
    Q_INVOKABLE bool restoreWindowGeometry(QObject *windowObject, const QString &key = QStringLiteral("MainWindow"));
    Q_INVOKABLE void clearWindowGeometry(const QString &key = QStringLiteral("MainWindow"));

    // NC hit-test: titleBar + caption buttons are screen-logical rects (mapToGlobal);
    // clientRects are non-draggable client areas inside the title bar.
    Q_INVOKABLE void updateHitTestLayout(QObject *windowObject,
                                         const QRect &titleBar,
                                         const QRect &minimizeButton,
                                         const QRect &maximizeButton,
                                         const QRect &closeButton,
                                         const QVariantList &clientRects = {});

    bool idleInhibited() const { return m_idleInhibited; }
    int batteryLevel() const { return m_batteryLevel; }
    bool onBattery() const { return m_onBattery; }
    bool isOnline() const { return m_isOnline; }
    int screenCount() const;

    static WindowHelper *create(QQmlEngine *, QJSEngine *);

    // Solid host fill + frosted detection (Platform perf 1.86; used from win chrome).
    static bool isFrostedBackdrop(int backdrop);
    static QColor solidHostFill(bool dark, const QColor &windowColor);

    void setCaptionHover(int button);
    void setCaptionPressed(int button);
    void setWindowActive(bool active);

signals:
    void windowColorChanged();
    void contentTintChanged();
    void backdropChanged();
    void cornerPreferenceChanged();
    void borderVisibleChanged();
    void windowActiveChanged();
    void captionHoverChanged();
    void captionPressedChanged();
    void wallpaperChanged();
    void accessibilityChanged();
    void colorSchemeChanged();
    void snapLayoutsEnabledChanged();
    void screensChanged();
    void idleInhibitedChanged();
    void powerChanged();
    void onlineChanged();

private:
    void applyNative(QWindow *window, bool dark, int backdrop);
    void refreshTint();
    void syncQuickHostColor(QWindow *window);
    QWindow *resolveWindow(QObject *windowObject) const;
    QWindow *currentWindow() const;

    QColor m_windowColor;
    QColor m_contentTint;
    QColor m_titleBarTint;
    int m_backdrop = BackdropSolid;
    int m_corner = CornerRound;
    bool m_borderVisible = false;
    bool m_windowActive = true;
    bool m_dark = false;
    int m_captionHover = CaptionNone;
    int m_captionPressed = CaptionNone;
    QWindow *m_window = nullptr;
    QUrl m_wallpaperUrl;
    bool m_systemReducedMotion = false;
    bool m_systemHighContrast = false;
    bool m_systemPrefersDark = false;
    bool m_snapLayoutsEnabled = true;
    bool m_idleInhibited = false;
    quint32 m_idleCookie = 0;
    int m_batteryLevel = -1;
    bool m_onBattery = false;
    bool m_isOnline = true;
};
