#include "LinuxPortal.h"

#include <QCoreApplication>
#include <QEventLoop>
#include <QGuiApplication>
#include <QRegularExpression>
#include <QTimer>
#include <QUrl>
#include <QVariantList>
#include <QVariantMap>
#include <QWindow>
#if defined(Q_OS_LINUX)
#  include <QtGui/qpa/qplatformnativeinterface.h>
#  if defined(QWINUI3_HAS_GUI_PRIVATE)
#    include <qpa/qplatformintegration.h>
#    include <private/qguiapplication_p.h>
#    if QT_VERSION >= QT_VERSION_CHECK(6, 9, 0)
#      include <private/qdesktopunixservices_p.h>
using QWinUI3UnixServices = QDesktopUnixServices;
#    else
#      include <private/qgenericunixservices_p.h>
using QWinUI3UnixServices = QGenericUnixServices;
#    endif
#  endif
#endif

#if defined(QWINUI3_HAS_DBUS)
#  include <QDBusArgument>
#  include <QDBusConnection>
#  include <QDBusInterface>
#  include <QDBusMessage>
#  include <QDBusMetaType>
#  include <QDBusObjectPath>
#  include <QDBusVariant>
#  include <QRandomGenerator>

// Portal FileChooser filters: a(sa(us)) — type 0 = glob.
struct QWinUI3PortalGlob {
    uint type = 0;
    QString pattern;
};
struct QWinUI3PortalFilter {
    QString name;
    QList<QWinUI3PortalGlob> globs;
};
Q_DECLARE_METATYPE(QWinUI3PortalGlob)
Q_DECLARE_METATYPE(QList<QWinUI3PortalGlob>)
Q_DECLARE_METATYPE(QWinUI3PortalFilter)
Q_DECLARE_METATYPE(QList<QWinUI3PortalFilter>)

inline QDBusArgument &operator<<(QDBusArgument &arg, const QWinUI3PortalGlob &g)
{
    arg.beginStructure();
    arg << g.type << g.pattern;
    arg.endStructure();
    return arg;
}
inline const QDBusArgument &operator>>(const QDBusArgument &arg, QWinUI3PortalGlob &g)
{
    arg.beginStructure();
    arg >> g.type >> g.pattern;
    arg.endStructure();
    return arg;
}
inline QDBusArgument &operator<<(QDBusArgument &arg, const QWinUI3PortalFilter &f)
{
    arg.beginStructure();
    arg << f.name << f.globs;
    arg.endStructure();
    return arg;
}
inline const QDBusArgument &operator>>(const QDBusArgument &arg, QWinUI3PortalFilter &f)
{
    arg.beginStructure();
    arg >> f.name >> f.globs;
    arg.endStructure();
    return arg;
}

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

enum class PortalWait { Failed, TimedOut, Done };

// Portal Inhibit session — cookie 1 marker; Close() on release.
QString g_portalIdleInhibitPath;

PortalWait waitForRequest(const QDBusObjectPath &requestPath, QVariantMap *resultsOut, int *responseOut)
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
        return PortalWait::Failed;

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
        return PortalWait::TimedOut;
    if (responseOut)
        *responseOut = waiter.response;
    if (resultsOut)
        *resultsOut = waiter.results;
    return PortalWait::Done;
}

void registerChooserTypes()
{
    static bool done = false;
    if (done)
        return;
    done = true;
    qDBusRegisterMetaType<QWinUI3PortalGlob>();
    qDBusRegisterMetaType<QList<QWinUI3PortalGlob>>();
    qDBusRegisterMetaType<QWinUI3PortalFilter>();
    qDBusRegisterMetaType<QList<QWinUI3PortalFilter>>();
}

QList<QWinUI3PortalFilter> filtersFromNames(const QStringList &nameFilters)
{
    QList<QWinUI3PortalFilter> out;
    for (const QString &f : nameFilters) {
        QWinUI3PortalFilter pf;
        const int lp = f.lastIndexOf(QLatin1Char('('));
        const int rp = f.lastIndexOf(QLatin1Char(')'));
        if (lp >= 0 && rp > lp) {
            pf.name = f.left(lp).trimmed();
            const QString inner = f.mid(lp + 1, rp - lp - 1);
            const QStringList parts = inner.split(QRegularExpression(QStringLiteral("[ ;]+")),
                                                  Qt::SkipEmptyParts);
            for (QString g : parts) {
                g.remove(QLatin1Char(','));
                if (!g.isEmpty())
                    pf.globs.push_back({0, g});
            }
        } else {
            pf.name = f;
            pf.globs.push_back({0, QStringLiteral("*")});
        }
        if (pf.name.isEmpty())
            pf.name = f;
        if (pf.globs.isEmpty())
            pf.globs.push_back({0, QStringLiteral("*")});
        out.push_back(pf);
    }
    return out;
}

void applyChooserOptions(QVariantMap *options, const QStringList &nameFilters,
                         const QString &currentName = QString())
{
    registerChooserTypes();
    options->insert(QStringLiteral("modal"), true);
    const auto filters = filtersFromNames(nameFilters);
    if (!filters.isEmpty())
        options->insert(QStringLiteral("filters"), QVariant::fromValue(filters));
    if (!currentName.isEmpty())
        options->insert(QStringLiteral("current_name"), currentName);
}

bool finishChooser(const QDBusMessage &reply, QVariantMap *resultsOut, int *responseOut)
{
    if (reply.type() == QDBusMessage::ErrorMessage || reply.arguments().isEmpty())
        return false;
    const auto path = reply.arguments().constFirst().value<QDBusObjectPath>();
    const PortalWait wait = waitForRequest(path, resultsOut, responseOut);
    // TimedOut: dialog was shown — treat as handled so callers do not open zenity too.
    return wait != PortalWait::Failed;
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

static QString normalizePortalParent(const QString &raw)
{
    const QString id = raw.trimmed();
    if (id.isEmpty())
        return {};
    if (id.startsWith(QLatin1String("wayland:")) || id.startsWith(QLatin1String("x11:")))
        return id;
    return QStringLiteral("wayland:%1").arg(id);
}

QString parentWindowFrom(QObject *windowObject)
{
    if (!windowObject)
        return {};
    QWindow *window = qobject_cast<QWindow *>(windowObject);
    if (!window)
        window = windowObject->property("window").value<QWindow *>();
    if (!window)
        return {};
    // Portal export needs a realized surface; QML Window may not have a handle yet.
    if (!window->handle())
        window->create();
    if (!window->handle())
        return {};

    const QString platform = QGuiApplication::platformName();
    if (platform == QLatin1String("xcb") || platform.startsWith(QLatin1String("x11")))
        return QStringLiteral("x11:0x%1").arg(quint64(window->winId()), 0, 16);

    if (platform.contains(QLatin1String("wayland"))) {
#if defined(Q_OS_LINUX)
#  if defined(QWINUI3_HAS_GUI_PRIVATE)
        // Same path Qt uses for portal FileDialog / color picker (xdg-foreign export).
        if (QPlatformIntegration *pi = QGuiApplicationPrivate::platformIntegration()) {
            if (auto *services = dynamic_cast<QWinUI3UnixServices *>(pi->services())) {
                const QString fromQt = normalizePortalParent(services->portalWindowIdentifier(window));
                if (!fromQt.isEmpty())
                    return fromQt;
            }
        }
#  endif
        if (QPlatformNativeInterface *native = QGuiApplication::platformNativeInterface()) {
            static const char *const kKeys[] = {
                "xdgforeignexportv2",
                "xdgexportv2",
                "xdg_foreign_exported_v2",
                "xdg_exporter_v2",
                "export",
                nullptr
            };
            for (int i = 0; kKeys[i]; ++i) {
                if (void *res = native->nativeResourceForWindow(kKeys[i], window)) {
                    const char *s = static_cast<const char *>(res);
                    if (s && s[0] >= 32 && s[0] < 127) {
                        const QString fromNative = normalizePortalParent(QString::fromUtf8(s));
                        if (!fromNative.isEmpty())
                            return fromNative;
                    }
                }
            }
        }
#endif
        return {};
    }
    return {};
}

QObject *resolveParentObject(QObject *parentWindow)
{
    if (parentWindow)
        return parentWindow;
    if (!qGuiApp)
        return nullptr;
    if (QWindow *focus = qGuiApp->focusWindow())
        return focus;
    const auto windows = qGuiApp->allWindows();
    for (QWindow *w : windows) {
        if (w && w->isVisible())
            return w;
    }
    return windows.isEmpty() ? nullptr : windows.constFirst();
}

bool notify(const QString &appName, const QString &title, const QString &message, int timeoutMs,
            const QStringList &actions)
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
            actions,
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
    if (waitForRequest(path, nullptr, &response) != PortalWait::Done)
        return false;
    return response == 0;
}

bool tryOpenFile(const QString &title, QString *pathOut, const QString &parentWindow,
                 const QStringList &nameFilters)
{
    if (pathOut)
        pathOut->clear();
    QDBusInterface portal = fileChooser();
    if (!portal.isValid())
        return false;

    QVariantMap options;
    options.insert(QStringLiteral("handle_token"), makeToken("open"));
    applyChooserOptions(&options, nameFilters);

    const QDBusMessage reply = portal.call(QStringLiteral("OpenFile"), parentWindow, title, options);
    QVariantMap results;
    int response = -1;
    if (!finishChooser(reply, &results, &response))
        return false;
    if (response == 0 && pathOut)
        *pathOut = firstUri(results);
    return true;
}

bool tryOpenFiles(const QString &title, QStringList *pathsOut, const QString &parentWindow,
                  const QStringList &nameFilters)
{
    if (pathsOut)
        pathsOut->clear();
    QDBusInterface portal = fileChooser();
    if (!portal.isValid())
        return false;

    QVariantMap options;
    options.insert(QStringLiteral("handle_token"), makeToken("openm"));
    applyChooserOptions(&options, nameFilters);
    options.insert(QStringLiteral("multiple"), true);

    const QDBusMessage reply = portal.call(QStringLiteral("OpenFile"), parentWindow, title, options);
    QVariantMap results;
    int response = -1;
    if (!finishChooser(reply, &results, &response))
        return false;
    if (response == 0 && pathsOut)
        *pathsOut = allUris(results);
    return true;
}

bool trySaveFile(const QString &title, QString *pathOut, const QString &parentWindow,
                 const QStringList &nameFilters, const QString &currentName)
{
    if (pathOut)
        pathOut->clear();
    QDBusInterface portal = fileChooser();
    if (!portal.isValid())
        return false;

    QVariantMap options;
    options.insert(QStringLiteral("handle_token"), makeToken("save"));
    applyChooserOptions(&options, nameFilters, currentName);

    const QDBusMessage reply = portal.call(QStringLiteral("SaveFile"), parentWindow, title, options);
    QVariantMap results;
    int response = -1;
    if (!finishChooser(reply, &results, &response))
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
    QVariantMap results;
    int response = -1;
    if (!finishChooser(reply, &results, &response))
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
    if (waitForRequest(path, nullptr, &response) != PortalWait::Done || response != 0)
        return false;
    // Portal inhibit: keep Request path for Close() on release (cookie 1 marker).
    g_portalIdleInhibitPath = path.path();
    if (cookieOut)
        *cookieOut = 1;
    return true;
}

bool tryUninhibitIdle(quint32 cookie)
{
    if (cookie == 0)
        return false;
    if (cookie == 1) {
        if (g_portalIdleInhibitPath.isEmpty())
            return false;
        QDBusInterface req(QStringLiteral("org.freedesktop.portal.Desktop"),
                           g_portalIdleInhibitPath,
                           QStringLiteral("org.freedesktop.portal.Request"),
                           QDBusConnection::sessionBus());
        const QDBusMessage reply = req.call(QStringLiteral("Close"));
        const bool ok = reply.type() != QDBusMessage::ErrorMessage;
        if (ok)
            g_portalIdleInhibitPath.clear();
        return ok;
    }
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

QObject *resolveParentObject(QObject *parentWindow)
{
    return parentWindow;
}

bool notify(const QString &, const QString &, const QString &, int, const QStringList &)
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

bool tryOpenFile(const QString &, QString *, const QString &, const QStringList &)
{
    return false;
}

bool tryOpenFiles(const QString &, QStringList *, const QString &, const QStringList &)
{
    return false;
}

bool trySaveFile(const QString &, QString *, const QString &, const QStringList &, const QString &)
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
