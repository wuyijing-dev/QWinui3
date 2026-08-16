#include "FluentIconsCatalog.h"
#include "FluentIcons.h"

FluentIconsCatalog::FluentIconsCatalog(QObject *parent)
    : QObject(parent)
{
    FluentIcons::ensureCatalogData();
}

FluentIconsCatalog *FluentIconsCatalog::create(QQmlEngine *, QJSEngine *)
{
    return new FluentIconsCatalog;
}

QStringList FluentIconsCatalog::names() const
{
    return FluentIcons::catalogNames();
}

QVariantList FluentIconsCatalog::entries() const
{
    return FluentIcons::catalogEntries();
}

int FluentIconsCatalog::namedCount() const
{
    return names().size();
}

int FluentIconsCatalog::entryCount() const
{
    return entries().size();
}
