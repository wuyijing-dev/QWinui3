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

// KeyboardEngine — inject via SIL Keyman Core (.kmx) when linked (1.71).
// Builtin commitText remains for space / fallback. Not Qt Virtual Keyboard.
class KeyboardEngine : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString backend READ backend CONSTANT)
    Q_PROPERTY(QString layoutId READ layoutId WRITE setLayoutId NOTIFY layoutIdChanged)
    Q_PROPERTY(QString layoutLabel READ layoutLabel NOTIFY layoutIdChanged)
    Q_PROPERTY(int layoutIndex READ layoutIndex WRITE setLayoutIndex NOTIFY layoutIdChanged)
    Q_PROPERTY(QStringList layoutIds READ layoutIds CONSTANT)
    Q_PROPERTY(QStringList layoutLabels READ layoutLabels CONSTANT)
    Q_PROPERTY(bool rtl READ rtl NOTIFY layoutIdChanged)
    Q_PROPERTY(bool hasTarget READ hasTarget NOTIFY hasTargetChanged)

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
    bool hasTarget() const { return m_target != nullptr; }

    Q_INVOKABLE void watch(QObject *window);
    Q_INVOKABLE void cycleLayout();
    Q_INVOKABLE void commitText(const QString &text);
    Q_INVOKABLE void processVk(int vk, bool shift);
    Q_INVOKABLE QString previewVk(int vk, bool shift) const;
    Q_INVOKABLE void backspace();
    Q_INVOKABLE void enterKey();
    Q_INVOKABLE void tabKey();

signals:
    void hasTargetChanged();
    void layoutIdChanged();

private:
    void onFocusChanged();
    void rememberEditor(QObject *object);
    QObject *target() const;
    void sendKey(int key, const QString &text = QString()) const;
    static bool looksLikeEditor(const QObject *object);
    static bool isKnownLayout(const QString &id);
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
#ifdef QWINUI3_HAVE_KEYMAN
    km_core_keyboard *m_keyboard = nullptr;
    km_core_state *m_state = nullptr;
#endif
};
