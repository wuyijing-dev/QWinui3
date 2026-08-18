#include "OskSpeechService.h"

#include <QDateTime>
#include <QDir>
#include <QProcess>

namespace {

QString whisperCliPath()
{
    const QString env = qEnvironmentVariable("QWINUI3_WHISPER_CLI");
    if (!env.isEmpty())
        return env;
    return QStringLiteral("whisper-cli");
}

QString whisperModelPath()
{
    return qEnvironmentVariable("QWINUI3_WHISPER_MODEL");
}

QString voskModelPath()
{
    return qEnvironmentVariable("QWINUI3_VOSK_MODEL");
}

QString voskTranscriberPath()
{
    const QString env = qEnvironmentVariable("QWINUI3_VOSK_BIN");
    if (!env.isEmpty())
        return env;
    return QStringLiteral("vosk-transcriber");
}

QString winSpeechHelperScript()
{
    return QStringLiteral(
        "$r=New-Object System.Speech.Recognition.SpeechRecognitionEngine;"
        "Add-Type -AssemblyName System.Speech;"
        "$r.SetInputToDefaultAudioDevice();"
        "$r.LoadGrammar([System.Speech.Recognition.DictationGrammar]::new());"
        "$res=$r.Recognize();"
        "if($res){$res.Text}");
}

} // namespace

OskSpeechService::OskSpeechService(QObject *parent)
    : QObject(parent)
{
    probeAvailability();
}

OskSpeechService::~OskSpeechService()
{
    cancel();
}

QString OskSpeechService::platformBackend() const
{
#if defined(Q_OS_WIN)
    return QStringLiteral("system.speech");
#elif defined(Q_OS_LINUX)
    if (!whisperModelPath().isEmpty())
        return QStringLiteral("whisper-cli");
    if (!voskModelPath().isEmpty())
        return QStringLiteral("vosk");
    return QStringLiteral("none");
#else
    return QStringLiteral("none");
#endif
}

void OskSpeechService::probeAvailability()
{
    bool ok = false;
#if defined(Q_OS_WIN)
    ok = true;
#elif defined(Q_OS_LINUX)
    ok = !whisperModelPath().isEmpty() || !voskModelPath().isEmpty();
#endif
    if (m_available == ok)
        return;
    m_available = ok;
    emit availabilityChanged();
    if (!ok)
        setStatus(tr("Linux: set QWINUI3_WHISPER_MODEL + whisper-cli, or QWINUI3_VOSK_MODEL."));
    else
        setStatus(QString());
}

void OskSpeechService::setListening(bool on)
{
    if (m_listening == on)
        return;
    m_listening = on;
    emit listeningChanged();
}

void OskSpeechService::setStatus(const QString &text)
{
    if (m_statusText == text)
        return;
    m_statusText = text;
    emit statusTextChanged();
}

void OskSpeechService::startListening()
{
    if (!m_available) {
        emit errorOccurred(m_statusText.isEmpty() ? tr("Speech input is not configured.") : m_statusText);
        return;
    }
    if (m_listening)
        return;
    setListening(true);
    setStatus(tr("Listening…"));
    beginCapture();
}

void OskSpeechService::stopListening()
{
    if (!m_listening)
        return;
    setListening(false);
    setStatus(tr("Processing…"));
    finishCapture();
}

void OskSpeechService::cancel()
{
    if (m_recognizer) {
        m_recognizer->kill();
        m_recognizer->deleteLater();
        m_recognizer = nullptr;
    }
    setListening(false);
    setStatus(QString());
}

void OskSpeechService::beginCapture()
{
    m_capturePath = QDir::tempPath() + QStringLiteral("/qwinui3_osk_speech_")
                    + QString::number(QDateTime::currentMSecsSinceEpoch()) + QStringLiteral(".wav");
}

void OskSpeechService::finishCapture()
{
#if defined(Q_OS_WIN)
    if (m_recognizer) {
        m_recognizer->kill();
        m_recognizer->deleteLater();
    }
    m_recognizer = new QProcess(this);
    connect(m_recognizer, &QProcess::finished, this, [this](int code, QProcess::ExitStatus st) {
        QProcess *proc = qobject_cast<QProcess *>(sender());
        if (!proc)
            return;
        const QString out = QString::fromLocal8Bit(proc->readAllStandardOutput()).trimmed();
        const QString err = QString::fromLocal8Bit(proc->readAllStandardError()).trimmed();
        proc->deleteLater();
        if (m_recognizer == proc)
            m_recognizer = nullptr;
        setStatus(QString());
        if (st != QProcess::NormalExit || code != 0) {
            emit errorOccurred(err.isEmpty() ? tr("Windows speech failed. Install a speech language pack.") : err);
            return;
        }
        if (out.isEmpty()) {
            emit errorOccurred(tr("No speech detected."));
            return;
        }
        emit recognized(out);
    });
    m_recognizer->start(QStringLiteral("powershell"),
                        {QStringLiteral("-NoProfile"), QStringLiteral("-Command"), winSpeechHelperScript()});
#elif defined(Q_OS_LINUX)
    if (m_recognizer) {
        m_recognizer->kill();
        m_recognizer->deleteLater();
    }
    m_recognizer = new QProcess(this);
    connect(m_recognizer, &QProcess::finished, this, [this](int code, QProcess::ExitStatus st) {
        QProcess *proc = qobject_cast<QProcess *>(sender());
        if (!proc)
            return;
        const QString out = QString::fromUtf8(proc->readAllStandardOutput()).trimmed();
        const QString err = QString::fromUtf8(proc->readAllStandardError()).trimmed();
        proc->deleteLater();
        if (m_recognizer == proc)
            m_recognizer = nullptr;
        setStatus(QString());
        if (st != QProcess::NormalExit || code != 0) {
            emit errorOccurred(err.isEmpty() ? tr("Speech recognizer failed.") : err);
            return;
        }
        if (out.isEmpty()) {
            emit errorOccurred(tr("No speech detected."));
            return;
        }
        emit recognized(out);
    });

    const QString wav = QDir::tempPath() + QStringLiteral("/qwinui3_osk.wav");
    QProcess record;
    record.start(QStringLiteral("arecord"),
                 {QStringLiteral("-q"), QStringLiteral("-d"), QStringLiteral("4"), QStringLiteral("-f"),
                  QStringLiteral("S16_LE"), QStringLiteral("-r"), QStringLiteral("16000"),
                  QStringLiteral("-c"), QStringLiteral("1"), wav});
    if (!record.waitForFinished(6000) || record.exitCode() != 0) {
        setStatus(QString());
        emit errorOccurred(tr("Install alsa-utils (arecord) for microphone capture."));
        return;
    }

    if (!whisperModelPath().isEmpty()) {
        m_recognizer->start(whisperCliPath(),
                            {QStringLiteral("-m"), whisperModelPath(), QStringLiteral("-f"), wav,
                             QStringLiteral("-l"), QStringLiteral("zh"), QStringLiteral("--no-timestamps")});
        return;
    }
    if (!voskModelPath().isEmpty()) {
        m_recognizer->start(voskTranscriberPath(),
                            {QStringLiteral("--model"), voskModelPath(), QStringLiteral("--filename"), wav});
        return;
    }
    setStatus(QString());
    emit errorOccurred(tr("Configure QWINUI3_WHISPER_MODEL or QWINUI3_VOSK_MODEL."));
#else
    Q_UNUSED(m_capturePath);
    setStatus(QString());
    emit errorOccurred(tr("Speech input is not supported on this platform."));
#endif
}

void OskSpeechService::runRecognizer(const QString &wavPath)
{
    Q_UNUSED(wavPath);
}
