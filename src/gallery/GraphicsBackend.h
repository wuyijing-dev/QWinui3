#pragma once

#include <QObject>
#include <QString>
#include <QStringList>
#include <QtQml/qqmlregistration.h>

class QQmlEngine;
class QJSEngine;

class GraphicsBackend : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(QString active READ active NOTIFY changed)
    Q_PROPERTY(QString preferred READ preferred WRITE setPreferred NOTIFY changed)
    Q_PROPERTY(QStringList available READ available CONSTANT)
    Q_PROPERTY(bool restartRequired READ restartRequired NOTIFY changed)
    Q_PROPERTY(QString hint READ hint NOTIFY changed)

public:
    explicit GraphicsBackend(QObject *parent = nullptr);

    static GraphicsBackend *create(QQmlEngine *engine, QJSEngine *scriptEngine);
    static GraphicsBackend *instance();

    // Must run before QGuiApplication / any QQuickWindow.
    static QString applyEarly(int &argc, char **argv);

    QString active() const;
    QString preferred() const;
    void setPreferred(const QString &backend);
    QStringList available() const;
    bool restartRequired() const;
    QString hint() const;

    Q_INVOKABLE void restartApplication();

signals:
    void changed();

private:
    static QString normalize(const QString &name);
    static QString defaultBackend();
    static QStringList platformBackends();
    static void apply(const QString &backend);
    static QString readStoredPreferred();
    static void writeStoredPreferred(const QString &backend);
    static QString parseCli(int &argc, char **argv);

    QString m_active;
    QString m_preferred;
};
