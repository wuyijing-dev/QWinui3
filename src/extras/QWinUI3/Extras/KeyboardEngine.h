#pragma once

#include <QObject>
#include <QPointer>
#include <QString>
#include <QtQml/qqmlregistration.h>

class QQuickWindow;

// KeyboardEngine — inject text/keys into the last focused editor (1.70).
//
// Builtin en-US path for this minor. SIL Keyman Core (MIT) is the 1.71+
// layout/.kmx backend — same inject API. Not Qt Virtual Keyboard (GPL).
class KeyboardEngine : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString backend READ backend CONSTANT)
    Q_PROPERTY(QString layoutId READ layoutId CONSTANT)
    Q_PROPERTY(bool hasTarget READ hasTarget NOTIFY hasTargetChanged)

public:
    explicit KeyboardEngine(QObject *parent = nullptr);

    QString backend() const;
    QString layoutId() const { return QStringLiteral("en-US"); }
    bool hasTarget() const { return m_target != nullptr; }

    Q_INVOKABLE void watch(QObject *window);
    Q_INVOKABLE void commitText(const QString &text);
    Q_INVOKABLE void backspace();
    Q_INVOKABLE void enterKey();
    Q_INVOKABLE void tabKey();

signals:
    void hasTargetChanged();

private:
    void onFocusChanged();
    void rememberEditor(QObject *object);
    QObject *target() const;
    void sendKey(int key, const QString &text = QString()) const;
    static bool looksLikeEditor(const QObject *object);

    QPointer<QQuickWindow> m_window;
    QPointer<QObject> m_target;
};
