#include "StatusNotifierItem.h"

#if defined(Q_OS_LINUX) && defined(QWINUI3_HAS_DBUS)

#include <QDBusConnection>
#include <QDBusInterface>
#include <QDBusReply>
#include <QCoreApplication>

#include <unistd.h>

namespace {

constexpr auto kWatcherService = "org.kde.StatusNotifierWatcher";
constexpr auto kWatcherPath = "/StatusNotifierWatcher";
constexpr auto kWatcherIface = "org.kde.StatusNotifierWatcher";
constexpr auto kItemPath = "/StatusNotifierItem";

} // namespace

StatusNotifierItem::StatusNotifierItem(QObject *parent)
    : QObject(parent)
{
    m_title = QCoreApplication::applicationName();
    if (m_title.isEmpty())
        m_title = QStringLiteral("QWinUI3");
}

StatusNotifierItem::~StatusNotifierItem()
{
    unregisterItem();
}

QString StatusNotifierItem::id() const
{
    const QString app = QCoreApplication::applicationName();
    return QStringLiteral("qwinui3-%1").arg(app.isEmpty() ? QStringLiteral("app") : app);
}

bool StatusNotifierItem::registerItem()
{
    if (m_registered)
        return true;

    QDBusConnection bus = QDBusConnection::sessionBus();
    if (!bus.isConnected())
        return false;

    m_serviceName = QStringLiteral("org.kde.StatusNotifierItem-%1-1").arg(getpid());
    if (!bus.registerService(m_serviceName)) {
        m_serviceName = QStringLiteral("org.kde.StatusNotifierItem-%1-%2")
                            .arg(getpid())
                            .arg(reinterpret_cast<quintptr>(this) & 0xffff);
        if (!bus.registerService(m_serviceName))
            return false;
    }

    if (!bus.registerObject(QString::fromLatin1(kItemPath), this,
                            QDBusConnection::ExportAllSlots | QDBusConnection::ExportAllProperties
                                | QDBusConnection::ExportAllSignals)) {
        bus.unregisterService(m_serviceName);
        m_serviceName.clear();
        return false;
    }

    QDBusInterface watcher(QString::fromLatin1(kWatcherService), QString::fromLatin1(kWatcherPath),
                           QString::fromLatin1(kWatcherIface), bus);
    if (!watcher.isValid()) {
        bus.unregisterObject(QString::fromLatin1(kItemPath));
        bus.unregisterService(m_serviceName);
        m_serviceName.clear();
        return false;
    }

    QDBusReply<void> reply = watcher.call(QStringLiteral("RegisterStatusNotifierItem"), m_serviceName);
    if (!reply.isValid()) {
        reply = watcher.call(QStringLiteral("RegisterStatusNotifierItem"),
                             QString::fromLatin1(kItemPath));
        if (!reply.isValid()) {
            bus.unregisterObject(QString::fromLatin1(kItemPath));
            bus.unregisterService(m_serviceName);
            m_serviceName.clear();
            return false;
        }
    }

    m_registered = true;
    return true;
}

void StatusNotifierItem::unregisterItem()
{
    if (!m_registered && m_serviceName.isEmpty())
        return;

    QDBusConnection bus = QDBusConnection::sessionBus();
    bus.unregisterObject(QString::fromLatin1(kItemPath));
    if (!m_serviceName.isEmpty())
        bus.unregisterService(m_serviceName);
    m_serviceName.clear();
    m_registered = false;
}

void StatusNotifierItem::setTitle(const QString &title)
{
    if (m_title == title)
        return;
    m_title = title;
    if (m_registered)
        emit NewTitle();
}

void StatusNotifierItem::setIconName(const QString &name)
{
    const QString resolved = name.isEmpty() ? QStringLiteral("application-x-executable") : name;
    if (m_iconName == resolved)
        return;
    m_iconName = resolved;
    if (m_registered)
        emit NewIcon();
}

void StatusNotifierItem::setTooltip(const QString &tooltip)
{
    if (m_tooltip == tooltip)
        return;
    m_tooltip = tooltip;
    if (m_registered)
        emit NewToolTip();
}

void StatusNotifierItem::Activate(int /*x*/, int /*y*/)
{
    emit activated(1);
}

void StatusNotifierItem::SecondaryActivate(int /*x*/, int /*y*/)
{
    emit activated(3);
}

void StatusNotifierItem::ContextMenu(int /*x*/, int /*y*/)
{
    emit activated(2);
}

void StatusNotifierItem::Scroll(int /*delta*/, const QString & /*orientation*/)
{
}

#endif // Q_OS_LINUX && QWINUI3_HAS_DBUS
