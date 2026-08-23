#pragma once

#include <QObject>
#include <QString>
#include <QStringList>
#include <QtQml/qqmlregistration.h>

class QLockFile;
class QLocalServer;
class QLocalSocket;

// SingleInstance — Opt-in primary/secondary guard (2.74).
//
// Default is multi-instance. Enable with env QWINUI3_SINGLE_INSTANCE=1 or an
// explicit tryBecomePrimary() call. Secondary processes forward argv to the
// primary over QLocalSocket; the caller must exit when tryBecomePrimary returns false.
//
//   #include "SingleInstance.h"
//   QWinUI3::SingleInstance guard;
//   if (!guard.tryBecomePrimary(QStringLiteral("org.example.myapp")))
//       return 0;
//   QObject::connect(&guard, &QWinUI3::SingleInstance::activationRequested,
//                    [](const QStringList &args) { /* raise window */ });
//
class SingleInstance : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(bool primary READ isPrimary NOTIFY primaryChanged)
    Q_PROPERTY(QString serverName READ serverName NOTIFY serverNameChanged)

public:
    explicit SingleInstance(QObject *parent = nullptr);
    ~SingleInstance() override;

    /// True when QWINUI3_SINGLE_INSTANCE is set to a truthy value (1/true/yes/on).
    Q_INVOKABLE static bool isEnvOptIn();

    /// Attempt to become the primary instance for \a serverName.
    /// Returns true on primary; false if another primary exists (argv already sent).
    Q_INVOKABLE bool tryBecomePrimary(const QString &serverName);

    /// Release lock + stop listening (rarely needed; destructor cleans up).
    Q_INVOKABLE void release();

    bool isPrimary() const { return m_primary; }
    QString serverName() const { return m_serverName; }

signals:
    /// Emitted on the primary when a secondary forwards its argv (and on local reconnect).
    void activationRequested(const QStringList &args);
    void primaryChanged();
    void serverNameChanged();

private:
    void onNewConnection();
    void handleClient(QLocalSocket *socket);
    static QString sanitizeServerName(const QString &name);
    static QString lockFilePath(const QString &serverName);

    QString m_serverName;
    bool m_primary = false;
    QLockFile *m_lock = nullptr;
    QLocalServer *m_server = nullptr;
};
