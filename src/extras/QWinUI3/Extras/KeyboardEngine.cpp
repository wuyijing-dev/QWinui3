#include "KeyboardEngine.h"

#include <QCoreApplication>
#include <QGuiApplication>
#include <QInputMethodEvent>
#include <QKeyEvent>
#include <QQuickItem>
#include <QQuickWindow>

KeyboardEngine::KeyboardEngine(QObject *parent)
    : QObject(parent)
{
}

QString KeyboardEngine::backend() const
{
#ifdef QWINUI3_HAVE_KEYMAN
    return QStringLiteral("keyman");
#else
    return QStringLiteral("builtin");
#endif
}

void KeyboardEngine::watch(QObject *window)
{
    auto *quick = qobject_cast<QQuickWindow *>(window);
    if (m_window == quick)
        return;
    if (m_window)
        disconnect(m_window, nullptr, this, nullptr);
    m_window = quick;
    if (!m_window)
        return;
    connect(m_window, &QQuickWindow::activeFocusItemChanged,
            this, &KeyboardEngine::onFocusChanged);
    onFocusChanged();
}

void KeyboardEngine::onFocusChanged()
{
    if (!m_window)
        return;
    rememberEditor(m_window->activeFocusItem());
}

void KeyboardEngine::rememberEditor(QObject *object)
{
    QObject *walk = object;
    while (walk && !looksLikeEditor(walk))
        walk = walk->parent();
    if (!walk || walk == m_target)
        return;
    m_target = walk;
    emit hasTargetChanged();
}

QObject *KeyboardEngine::target() const
{
    if (m_target)
        return m_target;
    QObject *focus = QGuiApplication::focusObject();
    QObject *walk = focus;
    while (walk && !looksLikeEditor(walk))
        walk = walk->parent();
    return walk;
}

bool KeyboardEngine::looksLikeEditor(const QObject *object)
{
    if (!object)
        return false;
    const QMetaObject *mo = object->metaObject();
    while (mo) {
        const QByteArray cn(mo->className());
        if (cn.contains("TextInput") || cn.contains("TextEdit"))
            return true;
        mo = mo->superClass();
    }
    return false;
}

void KeyboardEngine::commitText(const QString &text)
{
    if (text.isEmpty())
        return;
    rememberEditor(QGuiApplication::focusObject());
    QObject *item = target();
    if (!item)
        return;
    QInputMethodEvent event;
    event.setCommitString(text);
    QCoreApplication::sendEvent(item, &event);
}

void KeyboardEngine::backspace()
{
    rememberEditor(QGuiApplication::focusObject());
    sendKey(Qt::Key_Backspace);
}

void KeyboardEngine::enterKey()
{
    rememberEditor(QGuiApplication::focusObject());
    sendKey(Qt::Key_Return, QStringLiteral("\n"));
}

void KeyboardEngine::tabKey()
{
    rememberEditor(QGuiApplication::focusObject());
    sendKey(Qt::Key_Tab, QStringLiteral("\t"));
}

void KeyboardEngine::sendKey(int key, const QString &text) const
{
    QObject *item = target();
    if (!item)
        return;
    QKeyEvent press(QEvent::KeyPress, key, Qt::NoModifier, text);
    QKeyEvent release(QEvent::KeyRelease, key, Qt::NoModifier, text);
    QCoreApplication::sendEvent(item, &press);
    QCoreApplication::sendEvent(item, &release);
}
