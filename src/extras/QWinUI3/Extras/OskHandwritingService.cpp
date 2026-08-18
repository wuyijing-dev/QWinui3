#include "OskHandwritingService.h"

#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QLibrary>

#ifdef Q_OS_WIN
#  ifndef NOMINMAX
#    define NOMINMAX
#  endif
#  include <windows.h>
#  include <oleauto.h>
#  include <msinkaut.h>
#  include <msinkaut_i.c>
#endif

namespace {

QString zinniaModelPath()
{
    const QString fromEnv = qEnvironmentVariable("QWINUI3_ZINNIA_MODEL");
    if (!fromEnv.isEmpty() && QFile::exists(fromEnv))
        return fromEnv;
    const QString bundled = QCoreApplication::applicationDirPath()
                            + QStringLiteral("/handwriting-zh_CN.model");
    if (QFile::exists(bundled))
        return bundled;
    return {};
}

QString zinniaLibraryPath()
{
    const QString env = qEnvironmentVariable("QWINUI3_ZINNIA_LIB");
    if (!env.isEmpty())
        return env;
#ifdef Q_OS_WIN
    return QStringLiteral("zinnia");
#else
    return QStringLiteral("zinnia");
#endif
}

bool zinniaLoadable()
{
    if (zinniaModelPath().isEmpty())
        return false;
    QLibrary lib(zinniaLibraryPath());
    if (lib.load()) {
        lib.unload();
        return true;
    }
    return false;
}

struct ZinniaApi
{
    using RecognizerNew = void *(*)();
    using RecognizerDestroy = void (*)(void *);
    using RecognizerOpen = int (*)(void *, const char *);
    using CharacterNew = void *(*)();
    using CharacterDestroy = void (*)(void *);
    using CharacterSetWidth = void (*)(void *, size_t);
    using CharacterSetHeight = void (*)(void *, size_t);
    using CharacterAdd = int (*)(void *, size_t, int, int);
    using Classify = void *(*)(void *, void *, size_t);
    using ResultValue = const char *(*)(void *, size_t);
    using ResultSize = size_t (*)(void *);
    using ResultDestroy = void (*)(void *);

    QLibrary lib;
    RecognizerNew recognizerNew = nullptr;
    RecognizerDestroy recognizerDestroy = nullptr;
    RecognizerOpen recognizerOpen = nullptr;
    CharacterNew characterNew = nullptr;
    CharacterDestroy characterDestroy = nullptr;
    CharacterSetWidth characterSetWidth = nullptr;
    CharacterSetHeight characterSetHeight = nullptr;
    CharacterAdd characterAdd = nullptr;
    Classify classify = nullptr;
    ResultValue resultValue = nullptr;
    ResultSize resultSize = nullptr;
    ResultDestroy resultDestroy = nullptr;

    bool load()
    {
        lib.setFileName(zinniaLibraryPath());
        if (!lib.load())
            return false;
        recognizerNew = reinterpret_cast<RecognizerNew>(lib.resolve("zinnia_recognizer_new"));
        recognizerDestroy = reinterpret_cast<RecognizerDestroy>(lib.resolve("zinnia_recognizer_destroy"));
        recognizerOpen = reinterpret_cast<RecognizerOpen>(lib.resolve("zinnia_recognizer_open"));
        characterNew = reinterpret_cast<CharacterNew>(lib.resolve("zinnia_character_new"));
        characterDestroy = reinterpret_cast<CharacterDestroy>(lib.resolve("zinnia_character_destroy"));
        characterSetWidth = reinterpret_cast<CharacterSetWidth>(lib.resolve("zinnia_character_set_width"));
        characterSetHeight = reinterpret_cast<CharacterSetHeight>(lib.resolve("zinnia_character_set_height"));
        characterAdd = reinterpret_cast<CharacterAdd>(lib.resolve("zinnia_character_add"));
        classify = reinterpret_cast<Classify>(lib.resolve("zinnia_recognizer_classify"));
        resultValue = reinterpret_cast<ResultValue>(lib.resolve("zinnia_result_value"));
        resultSize = reinterpret_cast<ResultSize>(lib.resolve("zinnia_result_size"));
        resultDestroy = reinterpret_cast<ResultDestroy>(lib.resolve("zinnia_result_destroy"));
        return recognizerNew && recognizerDestroy && recognizerOpen && characterNew && characterDestroy
               && characterSetWidth && characterSetHeight && characterAdd && classify && resultValue
               && resultSize && resultDestroy;
    }
};

#ifdef Q_OS_WIN
bool inkAvailable()
{
    IInkRecognizerContext *ctx = nullptr;
    const HRESULT hr = CoCreateInstance(CLSID_InkRecognizerContext, nullptr, CLSCTX_INPROC_SERVER,
                                        IID_IInkRecognizerContext, reinterpret_cast<void **>(&ctx));
    if (FAILED(hr) || !ctx)
        return false;
    ctx->Release();
    return true;
}
#endif

} // namespace

OskHandwritingService::OskHandwritingService(QObject *parent)
    : QObject(parent)
{
    probeAvailability();
}

QString OskHandwritingService::platformBackend() const
{
    switch (m_backend) {
    case Backend::Zinnia:
        return QStringLiteral("zinnia-inproc");
    case Backend::Ink:
        return QStringLiteral("windows-ink");
    case Backend::None:
        break;
    }
    return QStringLiteral("none");
}

void OskHandwritingService::probeAvailability()
{
    Backend backend = Backend::None;
    QString status;
    if (zinniaLoadable()) {
        backend = Backend::Zinnia;
    }
#ifdef Q_OS_WIN
    else if (inkAvailable()) {
        backend = Backend::Ink;
    }
#endif
    if (backend == Backend::None) {
        status = tr("Place libzinnia + a .model file (QWINUI3_ZINNIA_LIB / QWINUI3_ZINNIA_MODEL). No command-line tools.");
    }

    const bool ok = backend != Backend::None;
    const bool changed = (m_available != ok) || (m_backend != backend);
    m_backend = backend;
    m_available = ok;
    if (changed)
        emit availabilityChanged();
    setStatus(status);
}

void OskHandwritingService::setStatus(const QString &text)
{
    if (m_statusText == text)
        return;
    m_statusText = text;
    emit statusTextChanged();
}

void OskHandwritingService::clearStrokes()
{
    m_strokes.clear();
}

void OskHandwritingService::addStroke(const QVariantList &points)
{
    OskStroke stroke;
    for (const QVariant &v : points) {
        const QPointF pt = v.toPointF();
        stroke.points.append(pt);
    }
    if (stroke.points.size() >= 2)
        m_strokes.append(stroke);
}

void OskHandwritingService::recognize()
{
    m_candidates.clear();
    emit candidatesChanged();

    if (m_strokes.isEmpty()) {
        setStatus(tr("Draw a character first."));
        return;
    }
    if (!m_available) {
        emit errorOccurred(m_statusText.isEmpty() ? tr("Handwriting is not configured.") : m_statusText);
        return;
    }

    bool ok = false;
    if (m_backend == Backend::Zinnia)
        ok = recognizeZinnia();
#ifdef Q_OS_WIN
    else if (m_backend == Backend::Ink)
        ok = recognizeInk();
    if (!ok && m_backend == Backend::Ink && zinniaLoadable())
        ok = recognizeZinnia();
#endif
    if (!ok)
        return;

    if (m_candidates.isEmpty()) {
        setStatus(tr("No match — try clearer strokes."));
        emit errorOccurred(tr("No handwriting match."));
        return;
    }
    setStatus(tr("%1 candidates").arg(m_candidates.size()));
    emit candidatesChanged();
}

bool OskHandwritingService::recognizeZinnia()
{
    ZinniaApi api;
    if (!api.load()) {
        emit errorOccurred(tr("Could not load the Zinnia library (set QWINUI3_ZINNIA_LIB)."));
        return false;
    }
    void *recognizer = api.recognizerNew();
    if (!recognizer) {
        emit errorOccurred(tr("Zinnia recognizer failed to start."));
        return false;
    }
    const QByteArray model = zinniaModelPath().toUtf8();
    if (!api.recognizerOpen(recognizer, model.constData())) {
        api.recognizerDestroy(recognizer);
        emit errorOccurred(tr("Could not open the Zinnia model file."));
        return false;
    }

    qreal minX = 0, minY = 0, maxX = 1, maxY = 1;
    bool first = true;
    for (const OskStroke &stroke : m_strokes) {
        for (const QPointF &pt : stroke.points) {
            if (first) {
                minX = maxX = pt.x();
                minY = maxY = pt.y();
                first = false;
            } else {
                minX = qMin(minX, pt.x());
                maxX = qMax(maxX, pt.x());
                minY = qMin(minY, pt.y());
                maxY = qMax(maxY, pt.y());
            }
        }
    }
    const int width = qMax(1, int(maxX - minX + 1));
    const int height = qMax(1, int(maxY - minY + 1));

    void *character = api.characterNew();
    api.characterSetWidth(character, size_t(width));
    api.characterSetHeight(character, size_t(height));
    for (int s = 0; s < m_strokes.size(); ++s) {
        for (const QPointF &pt : m_strokes.at(s).points) {
            api.characterAdd(character, size_t(s), int(pt.x() - minX), int(pt.y() - minY));
        }
    }

    void *result = api.classify(recognizer, character, 12);
    if (result) {
        const size_t n = api.resultSize(result);
        for (size_t i = 0; i < n; ++i) {
            const char *value = api.resultValue(result, i);
            if (!value)
                continue;
            const QString w = QString::fromUtf8(value);
            if (!w.isEmpty() && !m_candidates.contains(w))
                m_candidates.append(w);
        }
        api.resultDestroy(result);
    }
    api.characterDestroy(character);
    api.recognizerDestroy(recognizer);
    return true;
}

#ifdef Q_OS_WIN
bool OskHandwritingService::recognizeInk()
{
    IInkDisp *ink = nullptr;
    IInkRecognizerContext *ctx = nullptr;
    if (FAILED(CoCreateInstance(CLSID_InkDisp, nullptr, CLSCTX_INPROC_SERVER, IID_IInkDisp,
                                reinterpret_cast<void **>(&ink)))
        || FAILED(CoCreateInstance(CLSID_InkRecognizerContext, nullptr, CLSCTX_INPROC_SERVER,
                                   IID_IInkRecognizerContext, reinterpret_cast<void **>(&ctx)))) {
        if (ink)
            ink->Release();
        if (ctx)
            ctx->Release();
        emit errorOccurred(tr("Windows Ink recognizer is not installed."));
        return false;
    }

    for (const OskStroke &stroke : m_strokes) {
        if (stroke.points.size() < 2)
            continue;
        SAFEARRAY *sa = SafeArrayCreateVector(VT_I4, 0, LONG(stroke.points.size() * 2));
        if (!sa)
            continue;
        LONG *data = nullptr;
        if (SUCCEEDED(SafeArrayAccessData(sa, reinterpret_cast<void **>(&data)))) {
            LONG i = 0;
            for (const QPointF &pt : stroke.points) {
                data[i++] = LONG(pt.x());
                data[i++] = LONG(pt.y());
            }
            SafeArrayUnaccessData(sa);
        }
        VARIANT points;
        VariantInit(&points);
        points.vt = VT_ARRAY | VT_I4;
        points.parray = sa;
        VARIANT desc;
        VariantInit(&desc);
        IInkStrokeDisp *inkStroke = nullptr;
        ink->CreateStroke(points, desc, &inkStroke);
        if (inkStroke)
            inkStroke->Release();
        VariantClear(&points);
        VariantClear(&desc);
    }

    IInkStrokes *strokes = nullptr;
    ink->get_Strokes(&strokes);
    if (!strokes) {
        ctx->Release();
        ink->Release();
        emit errorOccurred(tr("Could not build Ink strokes."));
        return false;
    }
    ctx->putref_Strokes(strokes);

    InkRecognitionStatus recoStatus = IRS_NoError;
    IInkRecognitionResult *result = nullptr;
    const HRESULT hr = ctx->Recognize(&recoStatus, &result);
    if (FAILED(hr) || !result) {
        strokes->Release();
        ctx->Release();
        ink->Release();
        emit errorOccurred(tr("Ink recognition failed. Install a handwriting language pack."));
        return false;
    }

    IInkRecognitionAlternates *alts = nullptr;
    result->AlternatesFromSelection(0, -1, 12, &alts);
    if (alts) {
        long count = 0;
        alts->get_Count(&count);
        for (long i = 0; i < count; ++i) {
            IInkRecognitionAlternate *alt = nullptr;
            alts->Item(i, &alt);
            if (!alt)
                continue;
            BSTR text = nullptr;
            alt->get_String(&text);
            if (text) {
                const QString w = QString::fromWCharArray(text).trimmed();
                SysFreeString(text);
                if (!w.isEmpty() && !m_candidates.contains(w))
                    m_candidates.append(w);
            }
            alt->Release();
        }
        alts->Release();
    }
    if (m_candidates.isEmpty()) {
        BSTR top = nullptr;
        result->get_TopString(&top);
        if (top) {
            const QString w = QString::fromWCharArray(top).trimmed();
            SysFreeString(top);
            if (!w.isEmpty())
                m_candidates.append(w);
        }
    }

    result->Release();
    strokes->Release();
    ctx->Release();
    ink->Release();
    return true;
}
#else
bool OskHandwritingService::recognizeInk()
{
    return false;
}
#endif

void OskHandwritingService::pickCandidate(int index)
{
    if (index < 0 || index >= m_candidates.size())
        return;
    emit candidatePicked(m_candidates.at(index));
    clearStrokes();
    m_candidates.clear();
    emit candidatesChanged();
}
