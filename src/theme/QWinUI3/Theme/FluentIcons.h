#pragma once

#include <QQmlEngine>
#include <QQmlPropertyMap>
#include <QStringList>
#include <QVariantList>
#include <QtQml/qqmlregistration.h>

// Segoe Fluent Icons character class — FluentIcons.Save, FluentIcons.Copy, …
// Full glyph lists: FluentIconsCatalog singleton (PropertyMap hides child props).
class FluentIcons : public QQmlPropertyMap
{
    Q_OBJECT
    QML_NAMED_ELEMENT(FluentIcons)
    QML_SINGLETON

public:
    explicit FluentIcons(QObject *parent = nullptr);

    static FluentIcons *create(QQmlEngine *engine, QJSEngine *scriptEngine);

    // Ensure named glyph map is ready. Full Iconography rows stay lazy (catalogEntries).
    static void ensureCatalogData();
    static QStringList catalogNames();
    static QVariantList catalogEntries();

    Q_INVOKABLE QString of(const QString &name) const;
    Q_INVOKABLE bool has(const QString &name) const;
    Q_INVOKABLE QString codeHex(const QString &name) const;

private:
    void populate();
};
