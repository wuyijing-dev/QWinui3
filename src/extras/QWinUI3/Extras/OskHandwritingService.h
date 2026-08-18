#pragma once

#include <QObject>
#include <QPointF>
#include <QStringList>
#include <QVariantList>
#include <QVector>
#include <QtQml/qqmlregistration.h>

struct OskStroke
{
    QVector<QPointF> points;
};

// In-process handwriting for OSK (Windows + Linux). No helper processes.
// Windows: Ink recognizer COM. Both: Zinnia shared library when a model is present.
class OskHandwritingService : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(bool available READ available NOTIFY availabilityChanged)
    Q_PROPERTY(QStringList candidates READ candidates NOTIFY candidatesChanged)
    Q_PROPERTY(QString statusText READ statusText NOTIFY statusTextChanged)
    Q_PROPERTY(QString platformBackend READ platformBackend NOTIFY availabilityChanged)

public:
    explicit OskHandwritingService(QObject *parent = nullptr);

    bool available() const { return m_available; }
    QStringList candidates() const { return m_candidates; }
    QString statusText() const { return m_statusText; }
    QString platformBackend() const;

    Q_INVOKABLE void clearStrokes();
    Q_INVOKABLE void addStroke(const QVariantList &points);
    Q_INVOKABLE void recognize();
    Q_INVOKABLE void pickCandidate(int index);

signals:
    void availabilityChanged();
    void candidatesChanged();
    void statusTextChanged();
    void candidatePicked(const QString &text);
    void errorOccurred(const QString &message);

private:
    enum class Backend { None, Ink, Zinnia };

    void probeAvailability();
    void setStatus(const QString &text);
    bool recognizeInk();
    bool recognizeZinnia();

    bool m_available = false;
    Backend m_backend = Backend::None;
    QString m_statusText;
    QStringList m_candidates;
    QVector<OskStroke> m_strokes;
};
