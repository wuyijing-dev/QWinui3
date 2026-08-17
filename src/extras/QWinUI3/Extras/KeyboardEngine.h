#pragma once

#include "HangulComposer.h"

#include <QByteArray>
#include <QObject>
#include <QPointer>
#include <QString>
#include <QStringList>
#include <QtQml/qqmlregistration.h>

class QKeyEvent;
class QQuickWindow;

#ifdef QWINUI3_HAVE_KEYMAN
struct km_core_keyboard;
struct km_core_state;
#endif

// KeyboardEngine — Keyman layouts + in-app IME + optional Windows system-wide inject (1.82).
// Not Qt Virtual Keyboard. CJK is not Keyman IMX.
// Japanese stays romaji→kana (no MIT kanji lexicon; JMDict is CC-BY-SA).
// systemWide (opt-in, Windows SendInput) injects into the focused desktop app.
class KeyboardEngine : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString backend READ backend NOTIFY layoutIdChanged)
    Q_PROPERTY(QString layoutId READ layoutId WRITE setLayoutId NOTIFY layoutIdChanged)
    Q_PROPERTY(QString layoutLabel READ layoutLabel NOTIFY layoutIdChanged)
    Q_PROPERTY(int layoutIndex READ layoutIndex WRITE setLayoutIndex NOTIFY layoutIdChanged)
    Q_PROPERTY(QStringList layoutIds READ layoutIds CONSTANT)
    Q_PROPERTY(QStringList layoutLabels READ layoutLabels CONSTANT)
    Q_PROPERTY(bool rtl READ rtl NOTIFY layoutIdChanged)
    Q_PROPERTY(bool pinyin READ pinyin NOTIFY layoutIdChanged)
    Q_PROPERTY(bool japanese READ japanese NOTIFY layoutIdChanged)
    Q_PROPERTY(bool korean READ korean NOTIFY layoutIdChanged)
    Q_PROPERTY(bool hasTarget READ hasTarget NOTIFY hasTargetChanged)
    Q_PROPERTY(bool composing READ composing NOTIFY composeChanged)
    Q_PROPERTY(QString preedit READ preedit NOTIFY composeChanged)
    Q_PROPERTY(QStringList candidates READ candidates NOTIFY composeChanged)
    Q_PROPERTY(QStringList pagedCandidates READ pagedCandidates NOTIFY composeChanged)
    Q_PROPERTY(int candidatePage READ candidatePage NOTIFY composeChanged)
    Q_PROPERTY(int candidatePageCount READ candidatePageCount NOTIFY composeChanged)
    // When true, physical keys in this app route through the engine (IME / Keyman).
    // Still in-process unless systemWide is also enabled.
    Q_PROPERTY(bool hardwareInput READ hardwareInput WRITE setHardwareInput NOTIFY hardwareInputChanged)
    // Opt-in: inject into the focused desktop app via SendInput (Windows). Default off.
    // Compose/preedit stay on the OSK candidate bar; commits/keys go system-wide.
    Q_PROPERTY(bool systemWide READ systemWide WRITE setSystemWide NOTIFY systemWideChanged)
    Q_PROPERTY(bool supportsSystemWide READ supportsSystemWide CONSTANT)

public:
    explicit KeyboardEngine(QObject *parent = nullptr);
    ~KeyboardEngine() override;

    QString backend() const;
    QString layoutId() const { return m_layoutId; }
    void setLayoutId(const QString &id);
    QString layoutLabel() const;
    int layoutIndex() const;
    void setLayoutIndex(int index);
    QStringList layoutIds() const;
    QStringList layoutLabels() const;
    bool rtl() const;
    bool pinyin() const;
    bool japanese() const;
    bool korean() const;
    bool ime() const;
    bool hasTarget() const { return m_target != nullptr; }
    bool composing() const;
    QString preedit() const;
    QStringList candidates() const { return m_candidates; }
    QStringList pagedCandidates() const;
    int candidatePage() const { return m_candidatePage; }
    int candidatePageCount() const;
    bool hardwareInput() const { return m_hardwareInput; }
    void setHardwareInput(bool on);
    bool systemWide() const { return m_systemWide; }
    void setSystemWide(bool on);
    bool supportsSystemWide() const;

    Q_INVOKABLE void watch(QObject *window);
    Q_INVOKABLE void rememberTarget();
    Q_INVOKABLE bool restoreFocus();
    Q_INVOKABLE void cycleLayout();
    Q_INVOKABLE void commitText(const QString &text);
    Q_INVOKABLE void processVk(int vk, bool shift);
    Q_INVOKABLE void processVk(int vk, bool shift, bool altGr);
    Q_INVOKABLE QString previewVk(int vk, bool shift) const;
    Q_INVOKABLE void backspace();
    Q_INVOKABLE void enterKey();
    Q_INVOKABLE void tabKey();
    Q_INVOKABLE void pickCandidate(int indexOnPage);
    Q_INVOKABLE void nextCandidatePage();
    Q_INVOKABLE void prevCandidatePage();
    Q_INVOKABLE void confirmCompose();
    Q_INVOKABLE void cancelCompose();
    Q_INVOKABLE void navigateKey(int qtKey);
    Q_INVOKABLE void pasteClipboard();
    Q_INVOKABLE QString clipboardText() const;

signals:
    void hasTargetChanged();
    void layoutIdChanged();
    void composeChanged();
    void hardwareInputChanged();
    void systemWideChanged();

protected:
    bool eventFilter(QObject *watched, QEvent *event) override;

private:
    void onFocusChanged();
    void rememberEditor(QObject *object);
    QObject *target() const;
    void sendKey(int key, const QString &text = QString()) const;
    bool trySystemWideText(const QString &text) const;
    bool trySystemWideKey(int qtKey) const;
    static bool looksLikeEditor(const QObject *object);
    static bool isKnownLayout(const QString &id);
    QString displayPreedit() const;
    void processPinyinVk(int vk, bool shift);
    void processJapaneseVk(int vk, bool shift);
    void processKoreanVk(int vk, bool shift);
    void refreshCompose();
    void sendPreedit();
    void commitReplace(const QString &text);
    bool editorFocused() const;
    bool canHandleHardware(const QKeyEvent *ke) const;
    bool handleHardwareKey(QKeyEvent *ke);
    static int qtKeyToVk(int key);
    bool capsLockOn() const;
#ifdef QWINUI3_HAVE_KEYMAN
    bool loadLayout(const QString &id);
    void disposeCore();
    void syncContext();
    void applyCoreActions();
    QString probeVk(int vk, bool shift) const;
    QByteArray loadKmx(const QString &id) const;
    void processKeymanVk(int vk, bool shift, bool altGr);
#endif

    QPointer<QQuickWindow> m_window;
    QPointer<QObject> m_target;
    QString m_layoutId = QStringLiteral("en-US");
    QString m_preedit;
    QStringList m_candidates;
    int m_candidatePage = 0;
    bool m_hardwareInput = true;
    bool m_systemWide = false;
    // Linux/Wayland: track CapsLock toggles (no portable GetKeyState). Windows uses VK_CAPITAL.
    bool m_capsLockOn = false;
    HangulComposer m_hangul;
    static constexpr int kPageSize = 9;
#ifdef QWINUI3_HAVE_KEYMAN
    km_core_keyboard *m_keyboard = nullptr;
    km_core_state *m_state = nullptr;
#endif
};
