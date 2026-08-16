#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QStringList>
#include <QVariantList>
#include <QtQml/qqmlregistration.h>

// Iconography catalog — separate QML singleton (not on QQmlPropertyMap).
class FluentIconsCatalog : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(FluentIconsCatalog)
    QML_SINGLETON
    Q_PROPERTY(QStringList names READ names CONSTANT)
    Q_PROPERTY(QVariantList entries READ entries CONSTANT)
    Q_PROPERTY(int namedCount READ namedCount CONSTANT)
    Q_PROPERTY(int entryCount READ entryCount CONSTANT)

public:
    explicit FluentIconsCatalog(QObject *parent = nullptr);

    static FluentIconsCatalog *create(QQmlEngine *engine, QJSEngine *scriptEngine);

    QStringList names() const;
    QVariantList entries() const;
    int namedCount() const;
    int entryCount() const;
};
