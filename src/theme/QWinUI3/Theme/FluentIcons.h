#pragma once

#include <QQmlEngine>
#include <QQmlPropertyMap>
#include <QStringList>
#include <QVariantList>
#include <QtQml/qqmlregistration.h>

#include "FluentIconsCatalog.h"

// Segoe Fluent Icons character class — FluentIcons.Save, FluentIcons.Copy, …
// Catalog (names/entries) lives on FluentIcons.catalog — QQmlPropertyMap
// shadows invokable/property names that are not inserted keys.
class FluentIcons : public QQmlPropertyMap
{
    Q_OBJECT
    QML_NAMED_ELEMENT(FluentIcons)
    QML_SINGLETON
    Q_PROPERTY(FluentIconsCatalog *catalog READ catalog CONSTANT)

public:
    explicit FluentIcons(QObject *parent = nullptr);

    static FluentIcons *create(QQmlEngine *engine, QJSEngine *scriptEngine);

    Q_INVOKABLE QString of(const QString &name) const;
    Q_INVOKABLE bool has(const QString &name) const;
    Q_INVOKABLE QString codeHex(const QString &name) const;

    FluentIconsCatalog *catalog() const { return m_catalog; }

private:
    void populate();
    void buildCatalog();

    FluentIconsCatalog *m_catalog = nullptr;
    QStringList m_names;
    QHash<ushort, QString> m_primaryNameByCode;
};
