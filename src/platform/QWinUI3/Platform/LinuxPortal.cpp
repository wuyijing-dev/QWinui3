#include "LinuxPortal.h"

#include <QCoreApplication>
#include <QEventLoop>
#include <QGuiApplication>
#include <QTimer>
#include <QUrl>
#include <QVariantList>
#include <QVariantMap>
#include <QWindow>

#if defined(QWINUI3_HAS_DBUS)
#  include <QDBusConnection>
#  include <QDBusInterface>
#  include <QDBusMessage>
#  include <QDBusObjectPath>
#  include <QDBusVariant>
#  include <QRandomGenerator>

class QWinUI3PortalWaiter : public QObject
{
    Q_OBJECT
public:
    int response = -1;
    QVariantMap results;

public slots:
    void onResponse(uint code, const QVariantMap &map)
    {
        response = int(code);
        results = map;
        emit finished();
    }

signals:
    void finished();
};

class QWinUI3ColorSchemeWatcher : public QObject
{
    Q_OBJECT
public:
    explicit QWinUI3ColorSchemeWatcher(QObject *target, QObject *parent = nullptr)
        : QObject(parent)
        , m_target(target)
    {
    }

public slots:
    void onSettingChanged(const QString &ns, const QString &key, const QDBusVariant &value)
    {
        Q_UNUSED(value);
        if (!m_target)
            return;
        if (ns == QLatin1String("org.freedesktop.appearance")
            && key == QLatin1String("color-scheme"))
            QMetaObject::invokeMethod(m_target, "refreshColorScheme");
    }

private:
    QObject *m_target = nullptr;
};
#endif

namespace LinuxPortal {

#if defined(QWINUI3_HAS_DBUS)

namespace {

QString makeToken(const char *prefix)
{
    return QStringLiteral("%1_%2")
            .arg(QLatin1String(prefix))
            .arg(QRandomGenerator::global()->generate(), 0, 16);
}

bool waitForRequest(const QDBusObjectPath &requestPath, QVariantMap *resultsOut, int *responseOut)
{
    QWinUI3PortalWaiter waiter;
    const bool ok = QDBusConnection::sessionBus().connect(
            QString(),
            requestPath.path(),
            QStringLiteral("org.freedesktop.portal.Request"),
            QStringLiteral("Response"),
            &waiter,
            SLOT(onResponse(uint,QVariantMap)));
    if (!ok)
        return false;

    QEventLoop loop;
    QObject::connect(&waiter, &QWinUI3PortalWaiter::finished, &loop, &QEventLoop::quit);
    QTimer::singleShot(120000, &loop, &QEventLoop::quit);
    loop.exec();

    QDBusConnection::sessionBus().disconnect(
            QString(),
            requestPath.path(),
            QStringLiteral("org.freedesktop.portal.Request"),
            QStringLiteral("Response"),
            &waiter,
            SLOT(onResponse(uint,QVariantMap)));

    if (waiter.response < 0)
        return false;
    if (responseOut)
        *responseOut = waiter.response;
    if (resultsOut)
        *resultsOut = waiter.results;
    return true;
}

QDBusInterface fileChooser()
{
    return QDBusInterface(QStringLiteral("org.freedesktop.portal.Desktop"),
                          QStringLiteral("/org/freedesktop/portal/desktop"),
                          QStringLiteral("org.freedesktop.portal.FileChooser"),
                          QDBusConnection::sessionBus());
}

QString uriToLocal(const QString &uri)
{
    const QUrl url(uri);
    if (url.isLocalFile())
        return url.toLocalFile();
    if (uri.startsWith(QLatin1String("file:")))
        return QUrl(uri).toLocalFile();
    return uri;
}

QString firstUri(const QVariantMap &results)
{
    const QVariantList uris = results.value(QStringLiteral("uris")).toList();
    if (uris.isEmpty())
        return {};
    return uriToLocal(uris.first().toString());
}

QStringList allUris(const QVariantMap &results)
{
    QStringList out;
    const QVariantList uris = results.value(QStringLiteral("uris")).toList();
    for (const QVariant &v : uris) {
        const QString local = uriToLocal(v.toString());
        if (!local.isEmpty())
            out.push_back(local);
    }
    return out;
}

uint unpackColorScheme(const QVariant &v)
{
    // Portal wraps values in QDBusVariant (sometimes nested).
    QVariant cur = v;
    if (cur.userType() == qMetaTypeId<QDBusVariant>())
        cur = cur.value<QDBusVariant>().variant();
    if (cur.userType() == qMetaTypeId<QDBusVariant>())
        cur = cur.value<QDBusVariant>().variant();
    return cur.toUInt();
}

} // namespace

bool available()
{
    return QDBusConnection::sessionBus().isConnected();
}

QString parentWindowFrom(QObject *windowObject)
{
    if (!windowObject)
        return {};
    QWindow *window = qobject_cast<QWindow *>(windowObject);
    if (!window)
        window = windowObject->property("window").value<QWindow *>();
    if (!window || !window->handle())
        return {};

    const QString platform = QGuiApplication::platformName();
    if (platform == QLatin1String("xcb") || platform.startsWith(QLatin1String("x11")))
        return QStringLiteral("x11:0x%1").arg(quint64(window->winId()), 0, 16);
    // Pure Wayland needs an exported wl_surface handle; Qt public API does not expose it.
    return {};
}

bool notify(const QString &appName, const QString &title, const QString &message, int timeoutMs)
{
    QDBusInterface iface(QStringLiteral("org.freedesktop.Notifications"),
                         QStringLiteral("/org/freedesktop/Notifications"),
                         QStringLiteral("org.freedesktop.Notifications"),
                         QDBusConnection::sessionBus());
    if (!iface.isValid())
        return false;

    const QDBusMessage reply = iface.call(
            QStringLiteral("Notify"),
            appName.isEmpty() ? QCoreApplication::applicationName() : appName,
            uint(0),
            QString(),
            title,
            message,
            QStringList(),
            QVariantMap(),
            timeoutMs);
    return reply.type() != QDBusMessage::ErrorMessage;
}

bool tryReadColorScheme(uint *schemeOut)
{
    if (schemeOut)
        *schemeOut = 0;
    QDBusInterface settings(QStringLiteral("org.freedesktop.portal.Desktop"),
                            QStringLiteral("/org/freedesktop/portal/desktop"),
                            QStringLiteral("org.freedesktop.portal.Settings"),
                            QDBusConnection::sessionBus());
    if (!settings.isValid())
        return false;

    const QDBusMessage reply = settings.call(QStringLiteral("Read"),
                                             QStringLiteral("org.freedesktop.appearance"),
                                             QStringLiteral("color-scheme"));
    if (reply.type() == QDBusMessage::ErrorMessage || reply.arguments().isEmpty())
        return false;

    const uint scheme = unpackColorScheme(reply.arguments().constFirst());
    if (schemeOut)
        *schemeOut = scheme;
    return true;
}

bool watchColorSchemeChanges(QObject *receiver, const char *slot)
{
    Q_UNUSED(slot);
    if (!receiver || !QDBusConnection::sessionBus().isConnected())
        return false;

    auto *watcher = new QWinUI3ColorSchemeWatcher(receiver, receiver);
    return QDBusConnection::sessionBus().connect(
            QStringLiteral("org.freedesktop.portal.Desktop"),
            QStringLiteral("/org/freedesktop/portal/desktop"),
            QStringLiteral("org.freedesktop.portal.Settings"),
            QStringLiteral("SettingChanged"),
            watcher,
            SLOT(onSettingChanged(QString,QString,QDBusVariant)));
}

bool tryOpenUri(const QString &uri, const QString &parentWindow)
{
    if (uri.isEmpty())
        return false;
    QDBusInterface portal(QStringLiteral("org.freedesktop.portal.Desktop"),
                          QStringLiteral("/org/freedesktop/portal/desktop"),
                          QStringLiteral("org.freedesktop.portal.OpenURI"),
                          QDBusConnection::sessionBus());
    if (!portal.isValid())
        return false;

    QVariantMap options;
    options.insert(QStringLiteral("handle_token"), makeToken("uri"));
    const QDBusMessage reply = portal.call(QStringLiteral("OpenURI"),
                                           parentWindow,
                                           uri,
                                           options);
    if (reply.type() == QDBusMessage::ErrorMessage || reply.arguments().isEmpty())
        return false;

    const auto path = reply.arguments().constFirst().value<QDBusObjectPath>();
    int response = -1;
    if (!waitForRequest(path, nullptr, &response))
        return false;
    return response == 0;
}

bool tryOpenFile(const QString &title, QString *pathOut, const QString &parentWindow)
{
    if (pathOut)
        pathOut->clear();
    QDBusInterface portal = fileChooser();
    if (!portal.isValid())
        return false;

    QVariantMap options;
    options.insert(QStringLiteral("handle_token"), makeToken("open"));
    options.insert(QStringLiteral("modal"), true);

    const QDBusMessage reply = portal.call(QStringLiteral("OpenFile"), parentWindow, title, options);
    if (reply.type() == QDBusMessage::ErrorMessage || reply.arguments().isEmpty())
        return false;

    const auto path = reply.arguments().constFirst().value<QDBusObjectPath>();
    QVariantMap results;
    int response = -1;
    if (!waitForRequest(path, &results, &response))
        return false;
    if (response == 0 && pathOut)
        *pathOut = firstUri(results);
    return true;
}

bool tryOpenFiles(const QString &title, QStringList *pathsOut, const QString &parentWindow)
{
    if (pathsOut)
        pathsOut->clear();
    QDBusInterface portal = fileChooser();
    if (!portal.isValid())
        return false;

    QVariantMap options;
    options.insert(QStringLiteral("handle_token"), makeToken("openm"));
    options.insert(QStringLiteral("modal"), true);
    options.insert(QStringLiteral("multiple"), true);

    const QDBusMessage reply = portal.call(QStringLiteral("OpenFile"), parentWindow, title, options);
    if (reply.type() == QDBusMessage::ErrorMessage || reply.arguments().isEmpty())
        return false;

    const auto path = reply.arguments().constFirst().value<QDBusObjectPath>();
    QVariantMap results;
    int response = -1;
    if (!waitForRequest(path, &results, &response))
        return false;
    if (response == 0 && pathsOut)
        *pathsOut = allUris(results);
    return true;
}

bool trySaveFile(const QString &title, QString *pathOut, const QString &parentWindow)
{
    if (pathOut)
        pathOut->clear();
    QDBusInterface portal = fileChooser();
    if (!portal.isValid())
        return false;

    QVariantMap options;
    options.insert(QStringLiteral("handle_token"), makeToken("save"));
    options.insert(QStringLiteral("modal"), true);

    const QDBusMessage reply = portal.call(QStringLiteral("SaveFile"), parentWindow, title, options);
    if (reply.type() == QDBusMessage::ErrorMessage || reply.arguments().isEmpty())
        return false;

    const auto path = reply.arguments().constFirst().value<QDBusObjectPath>();
    QVariantMap results;
    int response = -1;
    if (!waitForRequest(path, &results, &response))
        return false;
    if (response == 0 && pathOut)
        *pathOut = firstUri(results);
    return true;
}

bool tryOpenFolder(const QString &title, QString *pathOut, const QString &parentWindow)
{
    if (pathOut)
        pathOut->clear();
    QDBusInterface portal = fileChooser();
    if (!portal.isValid())
        return false;

    QVariantMap options;
    options.insert(QStringLiteral("handle_token"), makeToken("dir"));
    options.insert(QStringLiteral("modal"), true);
    options.insert(QStringLiteral("directory"), true);

    const QDBusMessage reply = portal.call(QStringLiteral("OpenFile"), parentWindow, title, options);
    if (reply.type() == QDBusMessage::ErrorMessage || reply.arguments().isEmpty())
        return false;

    const auto path = reply.arguments().constFirst().value<QDBusObjectPath>();
    QVariantMap results;
    int response = -1;
    if (!waitForRequest(path, &results, &response))
        return false;
    if (response == 0 && pathOut)
        *pathOut = firstUri(results);
    return true;
}

bool tryShowItems(const QStringList &uris)
{
    if (uris.isEmpty())
        return false;
    QDBusInterface fm(QStringLiteral("org.freedesktop.FileManager1"),
                      QStringLiteral("/org/freedesktop/FileManager1"),
                      QStringLiteral("org.freedesktop.FileManager1"),
                      QDBusConnection::sessionBus());
    if (!fm.isValid())
        return false;
    const QDBusMessage reply = fm.call(QStringLiteral("ShowItems"), uris, QString());
    return reply.type() != QDBusMessage::ErrorMessage;
}

bool tryInhibitIdle(const QString &appName, const QString &reason, quint32 *cookieOut)
{
    if (cookieOut)
        *cookieOut = 0;

    // Prefer classic ScreenSaver inhibit (widely available, sync cookie).
    QDBusInterface ss(QStringLiteral("org.freedesktop.ScreenSaver"),
                      QStringLiteral("/org/freedesktop/ScreenSaver"),
                      QStringLiteral("org.freedesktop.ScreenSaver"),
                      QDBusConnection::sessionBus());
    if (ss.isValid()) {
        const QDBusMessage reply = ss.call(
                QStringLiteral("Inhibit"),
                appName.isEmpty() ? QCoreApplication::applicationName() : appName,
                reason.isEmpty() ? QStringLiteral("Idle inhibit") : reason);
        if (reply.type() != QDBusMessage::ErrorMessage && !reply.arguments().isEmpty()) {
            if (cookieOut)
                *cookieOut = reply.arguments().constFirst().toUInt();
            return true;
        }
    }

    // Fallback: portal Inhibit (flags: 8 = idle).
    QDBusInterface portal(QStringLiteral("org.freedesktop.portal.Desktop"),
                          QStringLiteral("/org/freedesktop/portal/desktop"),
                          QStringLiteral("org.freedesktop.portal.Inhibit"),
                          QDBusConnection::sessionBus());
    if (!portal.isValid())
        return false;

    QVariantMap options;
    options.insert(QStringLiteral("handle_token"), makeToken("inhib"));
    options.insert(QStringLiteral("reason"),
                   reason.isEmpty() ? QStringLiteral("Idle inhibit") : reason);
    const QDBusMessage reply = portal.call(QStringLiteral("Inhibit"),
                                           QString(),
                                           uint(8),
                                           options);
    if (reply.type() == QDBusMessage::ErrorMessage || reply.arguments().isEmpty())
        return false;

    const auto path = reply.arguments().constFirst().value<QDBusObjectPath>();
    int response = -1;
    if (!waitForRequest(path, nullptr, &response) || response != 0)
        return false;
    // Portal inhibit does not return a simple cookie; store 1 as a marker.
    if (cookieOut)
        *cookieOut = 1;
    return true;
}

bool tryUninhibitIdle(quint32 cookie)
{
    if (cookie == 0)
        return false;
    if (cookie == 1)
        return true; // portal Inhibit marker (no ScreenSaver cookie)
    QDBusInterface ss(QStringLiteral("org.freedesktop.ScreenSaver"),
                      QStringLiteral("/org/freedesktop/ScreenSaver"),
                      QStringLiteral("org.freedesktop.ScreenSaver"),
                      QDBusConnection::sessionBus());
    if (!ss.isValid())
        return false;
    const QDBusMessage reply = ss.call(QStringLiteral("UnInhibit"), cookie);
    return reply.type() != QDBusMessage::ErrorMessage;
}

#else // !QWINUI3_HAS_DBUS

bool available()
{
    return false;
}

QString parentWindowFrom(QObject *)
{
    return {};
}

bool notify(const QString &, const QString &, const QString &, int)
{
    return false;
}

bool tryReadColorScheme(uint *)
{
    return false;
}

bool watchColorSchemeChanges(QObject *, const char *)
{
    return false;
}

bool tryOpenUri(const QString &, const QString &)
{
    return false;
}

bool tryShowItems(const QStringList &)
{
    return false;
}

bool tryInhibitIdle(const QString &, const QString &, quint32 *)
{
    return false;
}

bool tryUninhibitIdle(quint32)
{
    return false;
}

bool tryOpenFile(const QString &, QString *, const QString &)
{
    return false;
}

bool tryOpenFiles(const QString &, QStringList *, const QString &)
{
    return false;
}

bool trySaveFile(const QString &, QString *, const QString &)
{
    return false;
}

bool tryOpenFolder(const QString &, QString *, const QString &)
{
    return false;
}

#endif

} // namespace LinuxPortal

#if defined(QWINUI3_HAS_DBUS)
#  include "LinuxPortal.moc"
#endif
