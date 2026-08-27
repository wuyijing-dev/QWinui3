#pragma once

#include <QObject>
#include <QVariant>
#include <QVariantList>
#include <QVariantMap>
#include <QVector>
#include <QtQml/qqmlregistration.h>

// Dense numeric series owned in C++ for million-point charts.
class ChartSeries : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int count READ count NOTIFY dataChanged)
    Q_PROPERTY(int length READ count NOTIFY dataChanged)
    Q_PROPERTY(bool empty READ isEmpty NOTIFY dataChanged)
    Q_PROPERTY(int capacity READ capacity WRITE setCapacity NOTIFY capacityChanged)
    Q_PROPERTY(QString label READ label WRITE setLabel NOTIFY labelChanged)

public:
    explicit ChartSeries(QObject *parent = nullptr);

    int count() const { return m_y.size(); }
    bool isEmpty() const { return m_y.isEmpty(); }
    int capacity() const { return m_capacity; }
    void setCapacity(int capacity);
    QString label() const { return m_label; }
    void setLabel(const QString &label);

    Q_INVOKABLE void clear();
    Q_INVOKABLE void generateWave(int count, qreal seed = 1.7);
    Q_INVOKABLE void generateCloud(int count, qreal seed = 0.37);

    // Opt-in ring buffer (3.45 H14): capacity 0 = unlimited (default).
    Q_INVOKABLE void append(qreal y);
    Q_INVOKABLE void appendXY(qreal x, qreal y);

    // Min/max bucket LOD — O(n) in C++, returns a small values[] for Canvas.
    Q_INVOKABLE QVariantMap lod(int maxPoints) const;
    // Spatial density bins for scatter (uses x/y when present, else index/y).
    Q_INVOKABLE QVariantMap densityLod(int binsX, int binsY) const;

    Q_INVOKABLE qreal valueAt(int index) const;
    Q_INVOKABLE qreal xAt(int index) const;
    Q_INVOKABLE qreal yAt(int index) const;

signals:
    void dataChanged();
    void capacityChanged();
    void labelChanged();

private:
    bool hasXY() const { return m_x.size() == m_y.size() && !m_x.isEmpty(); }
    void trimToCapacity();

    QVector<double> m_x;
    QVector<double> m_y;
    int m_capacity = 0;
    QString m_label;
};
