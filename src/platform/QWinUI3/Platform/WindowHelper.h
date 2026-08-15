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

    void setBackdropMode(int backdrop);
    void setCornerPreference(int corner);
    void setBorderVisible(bool visible);

    Q_INVOKABLE void install(QObject *windowObject, bool dark = false, int backdrop = BackdropSolid);
    Q_INVOKABLE void installParadigm(QObject *windowObject, int paradigm,
                                     bool dark = false, int backdrop = BackdropSolid);
    Q_INVOKABLE void installParadigmEx(QObject *windowObject, int paradigm,
                                       bool dark, int backdrop, int presenter, bool alwaysOnTop);
    Q_INVOKABLE int flagsForParadigm(int paradigm) const;
    Q_INVOKABLE int flagsForConfig(int paradigm, int presenter, bool alwaysOnTop) const;
    Q_INVOKABLE QString paradigmName(int paradigm) const;
    Q_INVOKABLE void centerOnScreen(QObject *windowObject);
    Q_INVOKABLE void setDarkMode(QObject *windowObject, bool dark);
    Q_INVOKABLE void setBackdrop(QObject *windowObject, int backdrop);
    Q_INVOKABLE void setCornerStyle(QObject *windowObject, int corner);
    Q_INVOKABLE void reapply(QObject *windowObject = nullptr);
    Q_INVOKABLE QString backdropName(int backdrop) const;
    Q_INVOKABLE void refreshWallpaper();
    Q_INVOKABLE void refreshAccessibility();

    // WinUI AppWindowPresenterKind
    Q_INVOKABLE void setPresenter(QObject *windowObject, int kind);
    Q_INVOKABLE int presenterKind(QObject *windowObject) const;
    Q_INVOKABLE QString presenterName(int kind) const;
    Q_INVOKABLE void setAlwaysOnTop(QObject *windowObject, bool on);
    Q_INVOKABLE bool isAlwaysOnTop(QObject *windowObject) const;
    Q_INVOKABLE int titleBarHeightForOption(int option) const;
    Q_INVOKABLE QString titleBarHeightName(int option) const;

    // NC hit-test: titleBar + caption buttons are screen-logical rects (mapToGlobal);
    // clientRects are non-draggable client areas inside the title bar.
    Q_INVOKABLE void updateHitTestLayout(QObject *windowObject,
                                         const QRect &titleBar,
                                         const QRect &minimizeButton,
                                         const QRect &maximizeButton,
                                         const QRect &closeButton,
                                         const QVariantList &clientRects = {});

    static WindowHelper *create(QQmlEngine *, QJSEngine *);

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

private:
    void applyNative(QWindow *window, bool dark, int backdrop);
    void refreshTint();
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
};
