#pragma once

#include <QQmlEngine>
#include <QQmlPropertyMap>
#include <QtQml/qqmlregistration.h>

// Segoe Fluent Icons character class — FluentIcons.Save, FluentIcons.Copy, …
class FluentIcons : public QQmlPropertyMap
{
    Q_OBJECT
    QML_NAMED_ELEMENT(FluentIcons)
    QML_SINGLETON

public:
    explicit FluentIcons(QObject *parent = nullptr);

    static FluentIcons *create(QQmlEngine *engine, QJSEngine *scriptEngine);

    Q_INVOKABLE QString of(const QString &name) const;
    Q_INVOKABLE bool has(const QString &name) const;

private:
    void populate();
};
