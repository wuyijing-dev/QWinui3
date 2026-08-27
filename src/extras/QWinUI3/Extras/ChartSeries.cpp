#include "ChartSeries.h"

#include <QtMath>
#include <algorithm>
#include <limits>

ChartSeries::ChartSeries(QObject *parent)
    : QObject(parent)
{
}

void ChartSeries::setLabel(const QString &label)
{
    if (m_label == label)
        return;
    m_label = label;
    emit labelChanged();
}

void ChartSeries::setCapacity(int capacity)
{
    const int next = qMax(0, capacity);
    if (m_capacity == next)
        return;
    m_capacity = next;
    emit capacityChanged();
    if (m_capacity > 0 && m_y.size() > m_capacity) {
        trimToCapacity();
        emit dataChanged();
    }
}

void ChartSeries::trimToCapacity()
{
    if (m_capacity <= 0 || m_y.size() <= m_capacity)
        return;
    const int drop = m_y.size() - m_capacity;
    m_y.remove(0, drop);
    if (!m_x.isEmpty()) {
        if (m_x.size() > drop)
            m_x.remove(0, drop);
        else
            m_x.clear();
        if (m_x.size() != m_y.size())
            m_x.clear();
    }
}

void ChartSeries::clear()
{
    if (m_x.isEmpty() && m_y.isEmpty())
        return;
    m_x.clear();
    m_y.clear();
    m_x.squeeze();
    m_y.squeeze();
    emit dataChanged();
}

void ChartSeries::append(qreal y)
{
    if (!m_x.isEmpty())
        m_x.clear();
    m_y.append(y);
    trimToCapacity();
    emit dataChanged();
}

void ChartSeries::appendXY(qreal x, qreal y)
{
    if (m_x.isEmpty() && !m_y.isEmpty()) {
        // Promote index-based series to explicit X by filling 0..n-1.
        m_x.resize(m_y.size());
        for (int i = 0; i < m_y.size(); ++i)
            m_x[i] = i;
    }
    m_x.append(x);
    m_y.append(y);
    trimToCapacity();
    emit dataChanged();
}

void ChartSeries::generateWave(int count, qreal seed)
{
    const int n = qMax(0, count);
    m_x.clear();
    m_y.resize(n);
    const double s = seed;
    for (int i = 0; i < n; ++i) {
        const double t = i * 0.0008;
        m_y[i] = qSin(t * s) * 42.0
               + qSin(t * 2.3 + 0.4) * 18.0
               + qCos(t * 0.17) * 8.0
               + ((i * 17) % 23) * 0.15;
    }
    trimToCapacity();
    emit dataChanged();
}

void ChartSeries::generateCloud(int count, qreal seed)
{
    const int n = qMax(0, count);
    m_x.resize(n);
    m_y.resize(n);
    const double s = seed;
    const double xScale = 120.0 / qMax(1, n);
    for (int i = 0; i < n; ++i) {
        m_x[i] = qSin(i * s) * 40.0 + qCos(i * 0.11) * 20.0 + i * xScale;
        m_y[i] = qCos(i * 0.29) * 30.0 + qSin(i * 0.17) * 18.0 + 40.0
               + ((i * 13) % 11) * 0.4;
    }
    trimToCapacity();
    emit dataChanged();
}

qreal ChartSeries::valueAt(int index) const
{
    if (index < 0 || index >= m_y.size())
        return 0;
    return m_y[index];
}

qreal ChartSeries::xAt(int index) const
{
    if (hasXY()) {
        if (index < 0 || index >= m_x.size())
            return index;
        return m_x[index];
    }
    return index;
}

qreal ChartSeries::yAt(int index) const
{
    return valueAt(index);
}

QVariantMap ChartSeries::lod(int maxPoints) const
{
    QVariantMap out;
    const int n = m_y.size();
    const int budget = qMax(2, maxPoints);
    out.insert(QStringLiteral("sourceCount"), n);

    if (n <= 0) {
        out.insert(QStringLiteral("values"), QVariantList());
        out.insert(QStringLiteral("min"), 0);
        out.insert(QStringLiteral("max"), 1);
        return out;
    }

    if (n <= budget) {
        QVariantList values;
        values.reserve(n);
        double lo = m_y[0];
        double hi = m_y[0];
        for (int i = 0; i < n; ++i) {
            const double v = m_y[i];
            values.append(v);
            lo = qMin(lo, v);
            hi = qMax(hi, v);
        }
        if (qFuzzyCompare(lo, hi)) {
            lo -= 1;
            hi += 1;
        }
        out.insert(QStringLiteral("values"), values);
        out.insert(QStringLiteral("min"), lo);
        out.insert(QStringLiteral("max"), hi);
        return out;
    }

    const int buckets = qMax(1, budget / 2);
    QVariantList values;
    values.reserve(budget);
    double glo = m_y[0];
    double ghi = m_y[0];

    for (int b = 0; b < buckets; ++b) {
        const int start = (int)((qint64)b * n / buckets);
        int end = (int)((qint64)(b + 1) * n / buckets);
        if (end <= start)
            end = start + 1;

        double lo = m_y[start];
        double hi = m_y[start];
        int loIdx = start;
        int hiIdx = start;
        for (int i = start + 1; i < end && i < n; ++i) {
            const double v = m_y[i];
            if (v < lo) {
                lo = v;
                loIdx = i;
            }
            if (v > hi) {
                hi = v;
                hiIdx = i;
            }
        }
        glo = qMin(glo, lo);
        ghi = qMax(ghi, hi);
        if (loIdx <= hiIdx) {
            values.append(lo);
            if (hiIdx != loIdx)
                values.append(hi);
        } else {
            values.append(hi);
            values.append(lo);
        }
    }

    while (values.size() > budget)
        values.removeLast();

    if (qFuzzyCompare(glo, ghi)) {
        glo -= 1;
        ghi += 1;
    }
    out.insert(QStringLiteral("values"), values);
    out.insert(QStringLiteral("min"), glo);
    out.insert(QStringLiteral("max"), ghi);
    return out;
}

QVariantMap ChartSeries::densityLod(int binsX, int binsY) const
{
    QVariantMap out;
    const int n = m_y.size();
    const int bx = qMax(2, binsX);
    const int by = qMax(2, binsY);
    out.insert(QStringLiteral("sourceCount"), n);

    if (n <= 0) {
        out.insert(QStringLiteral("points"), QVariantList());
        out.insert(QStringLiteral("minX"), 0);
        out.insert(QStringLiteral("maxX"), 1);
        out.insert(QStringLiteral("minY"), 0);
        out.insert(QStringLiteral("maxY"), 1);
        return out;
    }

    double loX = xAt(0);
    double hiX = loX;
    double loY = m_y[0];
    double hiY = loY;
    for (int i = 1; i < n; ++i) {
        const double x = xAt(i);
        const double y = m_y[i];
        loX = qMin(loX, x);
        hiX = qMax(hiX, x);
        loY = qMin(loY, y);
        hiY = qMax(hiY, y);
    }
    if (hiX <= loX) {
        loX -= 1;
        hiX += 1;
    }
    if (hiY <= loY) {
        loY -= 1;
        hiY += 1;
    }

    const double spanX = qMax(1e-9, hiX - loX);
    const double spanY = qMax(1e-9, hiY - loY);
    const int cellCount = bx * by;

    QVector<double> sx(cellCount, 0);
    QVector<double> sy(cellCount, 0);
    QVector<int> counts(cellCount, 0);
    QVector<int> firstIndex(cellCount, -1);

    for (int i = 0; i < n; ++i) {
        const double x = xAt(i);
        const double y = m_y[i];
        int cx = (int)qFloor(((x - loX) / spanX) * bx);
        int cy = (int)qFloor(((y - loY) / spanY) * by);
        cx = qBound(0, cx, bx - 1);
        cy = qBound(0, cy, by - 1);
        const int key = cy * bx + cx;
        sx[key] += x;
        sy[key] += y;
        if (counts[key] == 0)
            firstIndex[key] = i;
        counts[key] += 1;
    }

    QVariantList points;
    points.reserve(qMin(n, cellCount));
    for (int key = 0; key < cellCount; ++key) {
        const int c = counts[key];
        if (c <= 0)
            continue;
        QVariantMap p;
        p.insert(QStringLiteral("x"), sx[key] / c);
        p.insert(QStringLiteral("y"), sy[key] / c);
        p.insert(QStringLiteral("count"), c);
        p.insert(QStringLiteral("index"), firstIndex[key]);
        points.append(p);
    }

    out.insert(QStringLiteral("points"), points);
    out.insert(QStringLiteral("minX"), loX);
    out.insert(QStringLiteral("maxX"), hiX);
    out.insert(QStringLiteral("minY"), loY);
    out.insert(QStringLiteral("maxY"), hiY);
    return out;
}
