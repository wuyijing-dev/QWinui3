#pragma once

#include <QByteArray>
#include <QObject>
#include <QPointer>
#include <QString>
#include <QStringList>
#include <QtQml/qqmlregistration.h>

class QQuickWindow;

#ifdef QWINUI3_HAVE_KEYMAN
struct km_core_keyboard;
struct km_core_state;
#endif

// KeyboardEngine — Keyman layouts (1.71) + in-app pinyin IME (1.72).
// Not Qt Virtual Keyboard.
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
    Q_PROPERTY(bool hasTarget READ hasTarget NOTIFY hasTargetChanged)
    Q_PROPERTY(bool composing READ composing NOTIFY composeChanged)
    Q_PROPERTY(QString preedit READ preedit NOTIFY composeChanged)
    Q_PROPERTY(QStringList candidates READ candidates NOTIFY composeChanged)
    Q_PROPERTY(QStringList pagedCandidates READ pagedCandidates NOTIFY composeChanged)
    Q_PROPERTY(int candidatePage READ candidatePage NOTIFY composeChanged)
    Q_PROPERTY(int candidatePageCount READ candidatePageCount NOTIFY composeChanged)

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
    bool hasTarget() const { return m_target != nullptr; }
    bool composing() const { return !m_preedit.isEmpty(); }
    QString preedit() const { return m_preedit; }
    QStringList candidates() const { return m_candidates; }
    QStringList pagedCandidates() const;
    int candidatePage() const { return m_candidatePage; }
    int candidatePageCount() const;

    Q_INVOKABLE void watch(QObject *window);
    Q_INVOKABLE void cycleLayout();
    Q_INVOKABLE void commitText(const QString &text);
    Q_INVOKABLE void processVk(int vk, bool shift);
    Q_INVOKABLE QString previewVk(int vk, bool shift) const;
    Q_INVOKABLE void backspace();
    Q_INVOKABLE void enterKey();
    Q_INVOKABLE void tabKey();
    Q_INVOKABLE void pickCandidate(int indexOnPage);
    Q_INVOKABLE void nextCandidatePage();
    Q_INVOKABLE void prevCandidatePage();
    Q_INVOKABLE void confirmCompose();
    Q_INVOKABLE void cancelCompose();

signals:
    void hasTargetChanged();
    void layoutIdChanged();
    void composeChanged();

private:
    void onFocusChanged();
    void rememberEditor(QObject *object);
    QObject *target() const;
    void sendKey(int key, const QString &text = QString()) const;
    static bool looksLikeEditor(const QObject *object);
    static bool isKnownLayout(const QString &id);
    void processPinyinVk(int vk, bool shift);
    void refreshCompose();
    void sendPreedit();
    void commitReplace(const QString &text);
#ifdef QWINUI3_HAVE_KEYMAN
    bool loadLayout(const QString &id);
    void disposeCore();
    void syncContext();
    void applyCoreActions();
    QString probeVk(int vk, bool shift) const;
    QByteArray loadKmx(const QString &id) const;
#endif

    QPointer<QQuickWindow> m_window;
    QPointer<QObject> m_target;
    QString m_layoutId = QStringLiteral("en-US");
    QString m_preedit;
    QStringList m_candidates;
    int m_candidatePage = 0;
    static constexpr int kPageSize = 9;
#ifdef QWINUI3_HAVE_KEYMAN
    km_core_keyboard *m_keyboard = nullptr;
    km_core_state *m_state = nullptr;
#endif
};
