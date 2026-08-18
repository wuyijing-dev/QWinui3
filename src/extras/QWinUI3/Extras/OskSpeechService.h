#pragma once

#include <QObject>
#include <QString>
#include <QtQml/qqmlregistration.h>

class QProcess;

// Cross-platform speech-to-text for OSK (Windows + Linux). No custom neural nets.
// Windows: System.Speech via helper process. Linux: whisper-cli or vosk CLI when configured.
class OskSpeechService : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(bool available READ available NOTIFY availabilityChanged)
    Q_PROPERTY(bool listening READ listening NOTIFY listeningChanged)
    Q_PROPERTY(QString statusText READ statusText NOTIFY statusTextChanged)
    Q_PROPERTY(QString platformBackend READ platformBackend CONSTANT)

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
    void setListening(bool on);
    void setStatus(const QString &text);
    void probeAvailability();
    void beginCapture();
    void finishCapture();
    void runRecognizer(const QString &wavPath);

    bool m_available = false;
    bool m_listening = false;
    QString m_statusText;
    QString m_capturePath;
    QProcess *m_recognizer = nullptr;
};
