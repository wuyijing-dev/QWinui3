#include "GalleryLanguage.h"

#include <QCoreApplication>
#include <QDir>
#include <QJSEngine>
#include <QQmlEngine>
#include <QSettings>
#include <QLocale>

QString GalleryLanguage::s_startupOverride;

GalleryLanguage::GalleryLanguage(QObject *parent)
    : QObject(parent)
{
}

GalleryLanguage *GalleryLanguage::create(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(scriptEngine)
    auto *self = instance();
    self->m_engine = engine;
    if (!s_startupOverride.isEmpty())
        self->applyLocale(s_startupOverride);
    else
        self->applyLocale(readPersistedLocale());
    return self;
}

GalleryLanguage *GalleryLanguage::instance()
{
    static GalleryLanguage s;
    return &s;
}

void GalleryLanguage::setStartupLocaleOverride(const QString &locale)
{
    s_startupOverride = normalizeLocale(locale);
}

QString GalleryLanguage::normalizeLocale(const QString &locale)
{
    const QString trimmed = locale.trimmed();
    if (trimmed.isEmpty() || trimmed == QLatin1String("en")
        || trimmed == QLatin1String("en_US"))
        return QString();
    return trimmed;
}

QStringList GalleryLanguage::searchDirectories()
{
    QStringList dirs;
    if (const QByteArray env = qgetenv("QWINUI3_GALLERY_TRANSLATIONS"); !env.isEmpty())
        dirs << QString::fromLocal8Bit(env);
    const QString appDir = QCoreApplication::applicationDirPath();
    dirs << QStringLiteral(":/i18n")
         << (appDir + QStringLiteral("/translations"))
         << appDir
         << (appDir + QStringLiteral("/../src/gallery/translations"))
         << (appDir + QStringLiteral("/../../src/gallery/translations"))
         << (appDir + QStringLiteral("/../../../src/gallery/translations"));
    return dirs;
}

bool GalleryLanguage::loadTranslator(const QString &locale)
{
    const QString norm = normalizeLocale(locale);
    if (norm.isEmpty())
        return false;

    const QString fileStem = QStringLiteral("qwinui3_gallery_%1").arg(norm);
    for (const QString &dir : searchDirectories()) {
        if (dir.isEmpty())
            continue;
        if (dir.startsWith(QStringLiteral(":/"))) {
            const QString resourceQm = dir + QLatin1Char('/') + fileStem + QStringLiteral(".qm");
            if (m_translator.load(resourceQm)) {
                qInfo("QWinUI3 Gallery translator: %s", qPrintable(resourceQm));
                return true;
            }
            continue;
        }
        if (!QDir(dir).exists())
            continue;
        const QString qm = QDir(dir).filePath(fileStem + QStringLiteral(".qm"));
        if (m_translator.load(qm)) {
            qInfo("QWinUI3 Gallery translator: %s", qPrintable(qm));
            return true;
        }
        if (m_translator.load(QLocale(norm),
                              QStringLiteral("qwinui3_gallery"),
                              QStringLiteral("_"),
                              dir)) {
            qInfo("QWinUI3 Gallery translator (locale): %s in %s",
                  qPrintable(norm), qPrintable(dir));
            return true;
        }
    }
    qWarning("QWinUI3 Gallery: locale %s — no .qm found (rebuild after lupdate/lrelease)",
             qPrintable(norm));
    return false;
}

void GalleryLanguage::unloadTranslator()
{
    if (m_installed) {
        QCoreApplication::removeTranslator(&m_translator);
        m_installed = false;
    }
}

QString GalleryLanguage::readPersistedLocale()
{
    QSettings settings;
    settings.beginGroup(QStringLiteral("Gallery"));
    return normalizeLocale(settings.value(QStringLiteral("uiLocale")).toString());
}

void GalleryLanguage::persistLocale(const QString &locale)
{
    QSettings settings;
    settings.beginGroup(QStringLiteral("Gallery"));
    const QString norm = normalizeLocale(locale);
    if (norm.isEmpty())
        settings.remove(QStringLiteral("uiLocale"));
    else
        settings.setValue(QStringLiteral("uiLocale"), norm);
}

QString GalleryLanguage::currentLocale() const
{
    return m_currentLocale;
}

void GalleryLanguage::setCurrentLocale(const QString &locale)
{
    applyLocale(locale);
}

QStringList GalleryLanguage::availableLocales() const
{
    return { QString(), QStringLiteral("zh_CN"), QStringLiteral("ja_JP"),
             QStringLiteral("ko_KR"), QStringLiteral("de_DE") };
}

QString GalleryLanguage::labelForLocale(const QString &locale) const
{
    const QString norm = normalizeLocale(locale);
    if (norm.isEmpty())
        return tr("English (default)");
    if (norm == QLatin1String("zh_CN"))
        return tr("简体中文 (zh_CN)");
    if (norm == QLatin1String("ja_JP"))
        return tr("日本語 (ja_JP)");
    if (norm == QLatin1String("ko_KR"))
        return tr("한국어 (ko_KR)");
    if (norm == QLatin1String("de_DE"))
        return tr("Deutsch (de_DE)");
    return norm;
}

QStringList GalleryLanguage::localeLabels() const
{
    QStringList labels;
    const auto locales = availableLocales();
    for (const QString &loc : locales)
        labels << labelForLocale(loc);
    return labels;
}

int GalleryLanguage::indexOfLocale(const QString &locale) const
{
    const QString norm = normalizeLocale(locale);
    const auto locales = availableLocales();
    for (int i = 0; i < locales.size(); ++i) {
        if (normalizeLocale(locales.at(i)) == norm)
            return i;
    }
    return 0;
}

bool GalleryLanguage::translatorActive() const
{
    return m_installed && !m_currentLocale.isEmpty();
}

void GalleryLanguage::applyLocale(const QString &locale)
{
    const QString norm = normalizeLocale(locale);
    if (norm == m_currentLocale && (norm.isEmpty() ? !m_installed : m_installed))
        return;

    unloadTranslator();

    const bool loaded = !norm.isEmpty() && loadTranslator(norm);
    if (loaded)
        QCoreApplication::installTranslator(&m_translator);

    m_installed = loaded;
    m_currentLocale = loaded ? norm : QString();

    if (m_engine)
        m_engine->retranslate();

    if (s_startupOverride.isEmpty())
        persistLocale(m_currentLocale);

    emit currentLocaleChanged();
}
