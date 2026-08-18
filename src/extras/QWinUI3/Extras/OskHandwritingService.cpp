#include "OskHandwritingService.h"

#include "PinyinLexicon.h"

#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QProcess>
#include <QProcessEnvironment>
#include <QTemporaryFile>
#include <QTextStream>

namespace {

QString zinniaModelPath()
{
    const QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
    const QString fromEnv = env.value(QStringLiteral("QWINUI3_ZINNIA_MODEL"));
    if (!fromEnv.isEmpty() && QFile::exists(fromEnv))
        return fromEnv;
    const QString appDir = QCoreApplication::applicationDirPath();
    const QString bundled = appDir + QStringLiteral("/handwriting-zh_CN.model");
    if (QFile::exists(bundled))
        return bundled;
    return {};
}

QString zinniaExecutable()
{
    const QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
    const QString fromEnv = env.value(QStringLiteral("QWINUI3_ZINNIA_BIN"));
    if (!fromEnv.isEmpty())
        return fromEnv;
    return QStringLiteral("zinnia_character");
}

QString strokesToZinniaSexp(const QVector<OskStroke> &strokes)
{
    QString out;
    QTextStream ts(&out);
    for (const OskStroke &stroke : strokes) {
        if (stroke.points.size() < 2)
            continue;
        ts << QLatin1Char('(');
        for (const QPointF &pt : stroke.points)
            ts << QLatin1Char('(') << int(pt.x()) << QLatin1Char(' ') << int(pt.y()) << QLatin1String(") ");
        ts << QLatin1String(")\n");
    }
    return out;
}

} // namespace

OskHandwritingService::OskHandwritingService(QObject *parent)
    : QObject(parent)
{
    probeAvailability();
}

QString OskHandwritingService::platformBackend() const
{
#if defined(Q_OS_WIN)
    return QStringLiteral("zinnia-cli");
#elif defined(Q_OS_LINUX)
    return QStringLiteral("zinnia-cli");
#else
    return QStringLiteral("none");
#endif
}

void OskHandwritingService::probeAvailability()
{
    const bool ok = !zinniaModelPath().isEmpty();
    if (m_available == ok)
        return;
    m_available = ok;
    emit availabilityChanged();
    if (!ok)
        setStatus(tr("Set QWINUI3_ZINNIA_MODEL to a Zinnia .model file (see docs/on-screen-keyboard-voice-handwriting.md)."));
    else
        setStatus(QString());
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
        emit errorOccurred(m_statusText.isEmpty() ? tr("Handwriting model not configured.") : m_statusText);
        return;
    }

    QTemporaryFile strokeFile(QDir::tempPath() + QStringLiteral("/qwinui3_strokes_XXXXXX.txt"));
    strokeFile.setAutoRemove(true);
    if (!strokeFile.open()) {
        emit errorOccurred(tr("Could not write stroke data."));
        return;
    }
    strokeFile.write(strokesToZinniaSexp(m_strokes).toUtf8());
    strokeFile.close();

    QProcess proc;
    proc.setProgram(zinniaExecutable());
    proc.setArguments({QStringLiteral("-m"), zinniaModelPath(), QStringLiteral("-r"), strokeFile.fileName()});
    proc.start();
    if (!proc.waitForFinished(8000)) {
        proc.kill();
        emit errorOccurred(tr("Zinnia timed out. Install zinnia_character and set QWINUI3_ZINNIA_MODEL."));
        return;
    }
    if (proc.exitStatus() != QProcess::NormalExit || proc.exitCode() != 0) {
        emit errorOccurred(proc.readAllStandardError().trimmed().isEmpty()
                               ? tr("Zinnia failed. Check QWINUI3_ZINNIA_BIN / model path.")
                               : QString::fromUtf8(proc.readAllStandardError()).trimmed());
        return;
    }

    const QStringList lines = QString::fromUtf8(proc.readAllStandardOutput())
                                      .split(QLatin1Char('\n'), Qt::SkipEmptyParts);
    for (const QString &line : lines) {
        const QString w = line.section(QLatin1Char('\t'), 0, 0).trimmed();
        if (!w.isEmpty() && !m_candidates.contains(w))
            m_candidates.append(w);
        if (m_candidates.size() >= 12)
            break;
    }

    if (m_candidates.isEmpty()) {
        setStatus(tr("No match — try clearer strokes."));
        emit errorOccurred(tr("No handwriting match."));
        return;
    }

    setStatus(tr("%1 candidates").arg(m_candidates.size()));
    emit candidatesChanged();
}

void OskHandwritingService::pickCandidate(int index)
{
    if (index < 0 || index >= m_candidates.size())
        return;
    emit candidatePicked(m_candidates.at(index));
    clearStrokes();
    m_candidates.clear();
    emit candidatesChanged();
}
