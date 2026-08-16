#pragma once

#include <QObject>
#include <QStringList>
#include <QVariantList>

// Catalog lists for Iconography — kept separate from QQmlPropertyMap so QML
// can read them (PropertyMap intercepts unknown keys and hides invokables).
class FluentIconsCatalog : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList names READ names CONSTANT)
    Q_PROPERTY(QVariantList entries READ entries CONSTANT)
    Q_PROPERTY(int namedCount READ namedCount CONSTANT)
    Q_PROPERTY(int entryCount READ entryCount CONSTANT)

public:
    explicit FluentIconsCatalog(QObject *parent = nullptr)
        : QObject(parent)
    {
    }

    void setData(const QStringList &names, const QVariantList &entries)
    {
        m_names = names;
        m_entries = entries;
    }

    QStringList names() const { return m_names; }
    QVariantList entries() const { return m_entries; }
    int namedCount() const { return m_names.size(); }
    int entryCount() const { return m_entries.size(); }

private:
    QStringList m_names;
    QVariantList m_entries;
};
