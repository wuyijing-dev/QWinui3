#include "SingleInstance.h"

#include <QCoreApplication>
#include <QDataStream>
#include <QDir>
#include <QIODevice>
#include <QLocalServer>
#include <QLocalSocket>
#include <QLockFile>
#include <QStandardPaths>
#include <QThread>
#include <QDebug>

namespace {

bool envTruthy(const QByteArray &raw)
{
    const QByteArray v = raw.trimmed().toLower();
    return v == "1" || v == "true" || v == "yes" || v == "on";
}

/// Forward argv to an already-running primary. Retries briefly so we do not
/// exit as "secondary" while the winner still holds the lock but has not listen()'d yet.
bool forwardArgsToPrimary(const QString &serverName)
{
    QLocalSocket socket;
    for (int attempt = 0; attempt < 10; ++attempt) {
        socket.abort();
        socket.connectToServer(serverName);
        if (socket.waitForConnected(200)) {
            QStringList args = QCoreApplication::arguments();
            QByteArray payload;
            {
                QDataStream out(&payload, QIODevice::WriteOnly);
                out.setVersion(QDataStream::Qt_6_5);
                out << args;
            }
            socket.write(payload);
            socket.flush();
            socket.waitForBytesWritten(1000);
            socket.waitForDisconnected(500);
            return true;
        }
        QThread::msleep(static_cast<unsigned long>(40 * (attempt + 1)));
    }
    return false;
}

} // namespace

SingleInstance::SingleInstance(QObject *parent)
    : QObject(parent)
{
}

SingleInstance::~SingleInstance()
{
    release();
}

bool SingleInstance::isEnvOptIn()
{
    return envTruthy(qgetenv("QWINUI3_SINGLE_INSTANCE"));
}

QString SingleInstance::sanitizeServerName(const QString &name)
{
    QString out;
    out.reserve(name.size());
    for (QChar c : name) {
        if (c.isLetterOrNumber() || c == QLatin1Char('.') || c == QLatin1Char('_')
            || c == QLatin1Char('-')) {
            out.append(c);
        } else {
            out.append(QLatin1Char('_'));
        }
    }
    if (out.isEmpty())
        out = QStringLiteral("qwinui3_app");
    return out;
}

QString SingleInstance::lockFilePath(const QString &serverName)
{
    const QString dir = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
    return QDir(dir).filePath(serverName + QStringLiteral(".qwinui3.lock"));
}

bool SingleInstance::tryBecomePrimary(const QString &serverName)
{
    const QString name = sanitizeServerName(serverName);
    if (m_primary && m_serverName == name)
        return true;

    release();

    if (m_serverName != name) {
        m_serverName = name;
        emit serverNameChanged();
    }

    auto *lock = new QLockFile(lockFilePath(name));
    // Allow recovery after crash/kill. 0 = never stale → permanent lockout.
    lock->setStaleLockTime(30'000);
    if (!lock->tryLock(100)) {
        if (lock->removeStaleLockFile())
            lock->tryLock(100);
    }
    if (!lock->isLocked()) {
        delete lock;
        // Secondary path: forward argv (best-effort retries).
        forwardArgsToPrimary(name);
        if (m_primary) {
            m_primary = false;
            emit primaryChanged();
        }
        return false;
    }

    m_lock = lock;
    auto *server = new QLocalServer(this);
    QLocalServer::removeServer(name);
    if (!server->listen(name)) {
        QLocalServer::removeServer(name);
        if (!server->listen(name)) {
            // Keep the process alive as primary via the lock; activations unavailable.
            qWarning("QWinUI3 SingleInstance: listen(%s) failed (%s); "
                     "running as primary without activation socket",
                     qPrintable(name), qPrintable(server->errorString()));
            delete server;
            m_server = nullptr;
            if (!m_primary) {
                m_primary = true;
                emit primaryChanged();
            }
            return true;
        }
    }

    m_server = server;
    connect(m_server, &QLocalServer::newConnection, this, &SingleInstance::onNewConnection);

    if (!m_primary) {
        m_primary = true;
        emit primaryChanged();
    }
    return true;
}

void SingleInstance::release()
{
    if (m_server) {
        m_server->close();
        m_server->deleteLater();
        m_server = nullptr;
    }
    if (m_lock) {
        m_lock->unlock();
        delete m_lock;
        m_lock = nullptr;
    }
    if (m_primary) {
        m_primary = false;
        emit primaryChanged();
    }
}

void SingleInstance::onNewConnection()
{
    if (!m_server)
        return;
    while (m_server->hasPendingConnections()) {
        QLocalSocket *socket = m_server->nextPendingConnection();
        if (socket)
            handleClient(socket);
    }
}

void SingleInstance::handleClient(QLocalSocket *socket)
{
    // Accumulate until a full QDataStream payload is available (avoid partial readAll).
    auto *buf = new QByteArray;
    connect(socket, &QLocalSocket::readyRead, this, [this, socket, buf]() {
        buf->append(socket->readAll());
        QDataStream in(*buf);
        in.setVersion(QDataStream::Qt_6_5);
        QStringList args;
        in.startTransaction();
        in >> args;
        if (!in.commitTransaction())
            return;
        emit activationRequested(args);
        socket->disconnectFromServer();
    });
    connect(socket, &QLocalSocket::disconnected, socket, [socket, buf]() {
        delete buf;
        socket->deleteLater();
    });
}
