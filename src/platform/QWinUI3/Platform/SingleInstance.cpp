#include "SingleInstance.h"

#include <QCoreApplication>
#include <QDataStream>
#include <QDir>
#include <QIODevice>
#include <QLocalServer>
#include <QLocalSocket>
#include <QLockFile>
#include <QStandardPaths>

namespace {

bool envTruthy(const QByteArray &raw)
{
    const QByteArray v = raw.trimmed().toLower();
    return v == "1" || v == "true" || v == "yes" || v == "on";
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
    lock->setStaleLockTime(0);
    if (!lock->tryLock(100)) {
        delete lock;
        // Secondary: forward argv to primary, then let caller exit.
        QLocalSocket socket;
        socket.connectToServer(name);
        if (socket.waitForConnected(1500)) {
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
            socket.disconnectFromServer();
        }
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
        lock->unlock();
        delete lock;
        m_lock = nullptr;
        delete server;
        if (m_primary) {
            m_primary = false;
            emit primaryChanged();
        }
        return false;
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
    connect(socket, &QLocalSocket::readyRead, this, [this, socket]() {
        const QByteArray data = socket->readAll();
        if (data.isEmpty())
            return;
        QDataStream in(data);
        in.setVersion(QDataStream::Qt_6_5);
        QStringList args;
        in >> args;
        if (in.status() == QDataStream::Ok)
            emit activationRequested(args);
    });
    connect(socket, &QLocalSocket::disconnected, socket, &QObject::deleteLater);
}
