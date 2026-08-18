#pragma once

#include <QByteArray>
#include <QObject>
#include <QString>
#include <QtQml/qqmlregistration.h>
#include <atomic>

class QThread;

// In-process speech-to-text for OSK (Windows + Linux). No helper processes.
// Windows: SAPI in-proc recognizer. Optional Vosk shared library on both OSes.
class OskSpeechService : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(bool available READ available NOTIFY availabilityChanged)
    Q_PROPERTY(bool listening READ listening NOTIFY listeningChanged)
    Q_PROPERTY(QString statusText READ statusText NOTIFY statusTextChanged)
    Q_PROPERTY(QString platformBackend READ platformBackend NOTIFY availabilityChanged)

public:
    explicit OskSpeechService(QObject *parent = nullptr);
    ~OskSpeechService() override;

    bool available() const { return m_available; }
    bool listening() const { return m_listening; }
    QString statusText() const { return m_statusText; }
    QString platformBackend() const;

    Q_INVOKABLE void startListening();
    Q_INVOKABLE void stopListening();
    Q_INVOKABLE void cancel();

signals:
    void availabilityChanged();
    void listeningChanged();
    void statusTextChanged();
    void recognized(const QString &text);
    void errorOccurred(const QString &message);

private:
    enum class Backend { None, Sapi, Vosk };

    void setListening(bool on);
    void setStatus(const QString &text);
    void probeAvailability();
    void finishWithText(const QString &text);
    void finishWithError(const QString &message);
    void startSapiWorker();
    void startVoskWorker();

    bool m_available = false;
    bool m_listening = false;
    Backend m_backend = Backend::None;
    QString m_statusText;
    QByteArray m_pcm;
    QThread *m_worker = nullptr;
    QObject *m_capture = nullptr;
    std::atomic<bool> m_cancel{false};
};
