#include "OskSpeechService.h"

#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QIODevice>
#include <QJsonDocument>
#include <QJsonObject>
#include <QLibrary>
#include <QMetaObject>
#include <QThread>

#ifdef QWINUI3_OSK_MULTIMEDIA
#  include <QAudioFormat>
#  include <QAudioSource>
#  include <QMediaDevices>
#endif

#ifdef Q_OS_WIN
#  ifndef NOMINMAX
#    define NOMINMAX
#  endif
#  include <windows.h>
#  include <sapi.h>
#endif

namespace {

QString voskModelPath()
{
    const QString env = qEnvironmentVariable("QWINUI3_VOSK_MODEL");
    if (!env.isEmpty() && QFile::exists(env))
        return env;
    const QString bundled = QCoreApplication::applicationDirPath() + QStringLiteral("/vosk-model");
    if (QFile::exists(bundled))
        return bundled;
    return {};
}

QString voskLibraryPath()
{
    const QString env = qEnvironmentVariable("QWINUI3_VOSK_LIB");
    if (!env.isEmpty())
        return env;
#ifdef Q_OS_WIN
    return QStringLiteral("libvosk");
#else
    return QStringLiteral("vosk");
#endif
}

bool voskLoadable()
{
    if (voskModelPath().isEmpty())
        return false;
    QLibrary lib(voskLibraryPath());
    if (lib.load()) {
        lib.unload();
        return true;
    }
    return false;
}

QString parseVoskText(const QByteArray &json)
{
    const QJsonDocument doc = QJsonDocument::fromJson(json);
    if (!doc.isObject())
        return QString::fromUtf8(json).trimmed();
    return doc.object().value(QStringLiteral("text")).toString().trimmed();
}

struct VoskApi
{
    using ModelNew = void *(*)(const char *);
    using ModelFree = void (*)(void *);
    using RecNew = void *(*)(void *, float);
    using RecFree = void (*)(void *);
    using Accept = int (*)(void *, const char *, int);
    using Final = const char *(*)(void *);

    QLibrary lib;
    ModelNew modelNew = nullptr;
    ModelFree modelFree = nullptr;
    RecNew recNew = nullptr;
    RecFree recFree = nullptr;
    Accept accept = nullptr;
    Final finalResult = nullptr;

    bool load()
    {
        lib.setFileName(voskLibraryPath());
        if (!lib.load())
            return false;
        modelNew = reinterpret_cast<ModelNew>(lib.resolve("vosk_model_new"));
        modelFree = reinterpret_cast<ModelFree>(lib.resolve("vosk_model_free"));
        recNew = reinterpret_cast<RecNew>(lib.resolve("vosk_recognizer_new"));
        recFree = reinterpret_cast<RecFree>(lib.resolve("vosk_recognizer_free"));
        accept = reinterpret_cast<Accept>(lib.resolve("vosk_recognizer_accept_waveform"));
        finalResult = reinterpret_cast<Final>(lib.resolve("vosk_recognizer_final_result"));
        return modelNew && modelFree && recNew && recFree && accept && finalResult;
    }
};

QString recognizeVoskPcm(const QByteArray &pcm)
{
    VoskApi api;
    if (!api.load())
        return {};
    void *model = api.modelNew(voskModelPath().toUtf8().constData());
    if (!model)
        return {};
    void *rec = api.recNew(model, 16000.0f);
    if (!rec) {
        api.modelFree(model);
        return {};
    }
    if (!pcm.isEmpty())
        api.accept(rec, pcm.constData(), pcm.size());
    const char *json = api.finalResult(rec);
    const QString text = json ? parseVoskText(QByteArray(json)) : QString();
    api.recFree(rec);
    api.modelFree(model);
    return text;
}

#ifdef Q_OS_WIN
QString recognizeSapi(std::atomic<bool> *cancel)
{
    const HRESULT initHr = CoInitializeEx(nullptr, COINIT_MULTITHREADED);
    const bool needUninit = SUCCEEDED(initHr) || initHr == S_FALSE;

    ISpRecognizer *reco = nullptr;
    ISpRecoContext *ctx = nullptr;
    ISpRecoGrammar *grammar = nullptr;
    QString text;

    auto cleanup = [&]() {
        if (grammar) {
            grammar->SetDictationState(SPRS_INACTIVE);
            grammar->Release();
        }
        if (ctx)
            ctx->Release();
        if (reco) {
            reco->SetRecoState(SPRST_INACTIVE);
            reco->Release();
        }
        if (needUninit)
            CoUninitialize();
    };

    if (FAILED(CoCreateInstance(CLSID_SpInprocRecognizer, nullptr, CLSCTX_ALL,
                                IID_ISpRecognizer, reinterpret_cast<void **>(&reco)))) {
        cleanup();
        return {};
    }
    if (FAILED(reco->CreateRecoContext(&ctx)) || !ctx) {
        cleanup();
        return {};
    }
    if (FAILED(ctx->SetNotifyWin32Event())) {
        cleanup();
        return {};
    }
    const ULONGLONG interest = SPFEI(SPEI_RECOGNITION) | SPFEI(SPEI_HYPOTHESIS);
    ctx->SetInterest(interest, interest);
    if (FAILED(ctx->CreateGrammar(0, &grammar)) || !grammar) {
        cleanup();
        return {};
    }
    if (FAILED(grammar->LoadDictation(nullptr, SPLO_STATIC))
        || FAILED(grammar->SetDictationState(SPRS_ACTIVE))
        || FAILED(reco->SetInput(nullptr, TRUE))) {
        cleanup();
        return {};
    }

    const HANDLE event = ctx->GetNotifyEventHandle();
    while (cancel && !cancel->load()) {
        const DWORD wait = WaitForSingleObject(event, 200);
        if (wait != WAIT_OBJECT_0)
            continue;
        SPEVENT ev{};
        ULONG fetched = 0;
        while (SUCCEEDED(ctx->GetEvents(1, &ev, &fetched)) && fetched == 1) {
            if ((ev.eEventId == SPEI_RECOGNITION || ev.eEventId == SPEI_HYPOTHESIS) && ev.lParam) {
                auto *result = reinterpret_cast<ISpRecoResult *>(ev.lParam);
                LPWSTR phrase = nullptr;
                if (SUCCEEDED(result->GetText(ULONG(-1), ULONG(-1), TRUE, &phrase, nullptr))
                    && phrase) {
                    const QString piece = QString::fromWCharArray(phrase).trimmed();
                    CoTaskMemFree(phrase);
                    if (!piece.isEmpty())
                        text = piece;
                }
            }
            if (ev.elParamType == SPET_LPARAM_IS_OBJECT && ev.lParam)
                reinterpret_cast<IUnknown *>(ev.lParam)->Release();
        }
    }

    cleanup();
    return text;
}
#endif

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
    switch (m_backend) {
    case Backend::Sapi:
        return QStringLiteral("sapi-inproc");
    case Backend::Vosk:
        return QStringLiteral("vosk-inproc");
    case Backend::None:
        break;
    }
    return QStringLiteral("none");
}

void OskSpeechService::probeAvailability()
{
    Backend backend = Backend::None;
    QString status;
#ifdef QWINUI3_OSK_MULTIMEDIA
    if (voskLoadable())
        backend = Backend::Vosk;
#endif
#ifdef Q_OS_WIN
    if (backend == Backend::None)
        backend = Backend::Sapi;
#endif
    if (backend == Backend::None) {
        if (voskLoadable())
            status = tr("Vosk model found; rebuild with Qt Multimedia for in-process microphone capture.");
        else
            status = tr("Place libvosk + a model next to the app, or set QWINUI3_VOSK_LIB / QWINUI3_VOSK_MODEL. No command-line tools.");
    }

    const bool ok = backend != Backend::None;
    const bool changed = (m_available != ok) || (m_backend != backend);
    m_backend = backend;
    m_available = ok;
    if (changed)
        emit availabilityChanged();
    setStatus(status);
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

void OskSpeechService::finishWithText(const QString &text)
{
    setListening(false);
    setStatus(QString());
    if (text.trimmed().isEmpty()) {
        emit errorOccurred(tr("No speech detected."));
        return;
    }
    emit recognized(text.trimmed());
}

void OskSpeechService::finishWithError(const QString &message)
{
    setListening(false);
    setStatus(QString());
    emit errorOccurred(message);
}

void OskSpeechService::startListening()
{
    if (!m_available) {
        emit errorOccurred(m_statusText.isEmpty() ? tr("Speech input is not configured.") : m_statusText);
        return;
    }
    if (m_listening)
        return;
    m_cancel.store(false);
    m_pcm.clear();
    setListening(true);
    setStatus(tr("Listening…"));
    if (m_backend == Backend::Vosk)
        startVoskWorker();
    else
        startSapiWorker();
}

void OskSpeechService::stopListening()
{
    if (!m_listening)
        return;
    setStatus(tr("Processing…"));
    m_cancel.store(true);
#ifdef QWINUI3_OSK_MULTIMEDIA
    if (auto *source = qobject_cast<QAudioSource *>(m_capture)) {
        source->stop();
        const QByteArray pcm = m_pcm;
        source->deleteLater();
        m_capture = nullptr;
        QThread *thread = QThread::create([this, pcm]() {
            const QString text = recognizeVoskPcm(pcm);
            QMetaObject::invokeMethod(this, [this, text]() { finishWithText(text); }, Qt::QueuedConnection);
        });
        m_worker = thread;
        connect(thread, &QThread::finished, thread, &QObject::deleteLater);
        connect(thread, &QThread::finished, this, [this, thread]() {
            if (m_worker == thread)
                m_worker = nullptr;
        });
        thread->start();
        return;
    }
#endif
}

void OskSpeechService::cancel()
{
    m_cancel.store(true);
#ifdef QWINUI3_OSK_MULTIMEDIA
    if (auto *source = qobject_cast<QAudioSource *>(m_capture)) {
        source->stop();
        source->deleteLater();
    }
    m_capture = nullptr;
#endif
    if (m_worker) {
        m_worker->wait(4000);
        m_worker->deleteLater();
        m_worker = nullptr;
    }
    setListening(false);
    setStatus(QString());
}

void OskSpeechService::startSapiWorker()
{
#ifdef Q_OS_WIN
    if (m_worker) {
        m_worker->wait(1000);
        m_worker->deleteLater();
    }
    QThread *thread = QThread::create([this]() {
        const QString text = recognizeSapi(&m_cancel);
        QMetaObject::invokeMethod(this, [this, text]() { finishWithText(text); }, Qt::QueuedConnection);
    });
    m_worker = thread;
    connect(thread, &QThread::finished, thread, &QObject::deleteLater);
    connect(thread, &QThread::finished, this, [this, thread]() {
        if (m_worker == thread)
            m_worker = nullptr;
    });
    thread->start();
#else
    finishWithError(tr("Windows SAPI is not available on this platform."));
#endif
}

void OskSpeechService::startVoskWorker()
{
#ifdef QWINUI3_OSK_MULTIMEDIA
    QAudioFormat fmt;
    fmt.setSampleRate(16000);
    fmt.setChannelCount(1);
    fmt.setSampleFormat(QAudioFormat::Int16);
    auto *source = new QAudioSource(QMediaDevices::defaultAudioInput(), fmt, this);
    QIODevice *dev = source->start();
    if (!dev) {
        source->deleteLater();
        finishWithError(tr("Could not open the microphone."));
        return;
    }
    m_capture = source;
    connect(dev, &QIODevice::readyRead, this, [this, dev]() {
        m_pcm.append(dev->readAll());
    });
#else
    finishWithError(tr("In-process Vosk capture needs Qt Multimedia."));
#endif
}
