#include "ThemeFonts.h"

#include <QFont>
#include <QFontDatabase>
#include <QGuiApplication>
#include <QQmlEngine>

bool ThemeFonts::s_loaded = false;
QString ThemeFonts::s_iconFamily = QStringLiteral("Segoe Fluent Icons");
QString ThemeFonts::s_monoFamily;
QStringList ThemeFonts::s_uiFamilies;
QStringList ThemeFonts::s_textFamilies;
QStringList ThemeFonts::s_displayFamilies;

static bool isBitmapMonoFamily(const QString &family)
{
    return family.compare(QLatin1String("Fixedsys"), Qt::CaseInsensitive) == 0
           || family.compare(QLatin1String("Terminal"), Qt::CaseInsensitive) == 0
           || family.compare(QLatin1String("Modern"), Qt::CaseInsensitive) == 0
           || family.compare(QLatin1String("MS Sans Serif"), Qt::CaseInsensitive) == 0;
}

static QString resolveMonoFamily()
{
    static const char *const kCandidates[] = {
        "Cascadia Mono",
        "Cascadia Code",
        "Consolas",
        "Courier New",
        nullptr,
    };
    for (const char *name : kCandidates) {
        const QString family = QString::fromUtf8(name);
        if (isBitmapMonoFamily(family))
            continue;
        if (QFontDatabase::hasFamily(family))
            return family;
    }
    return QStringLiteral("Courier New");
}

static QFont makeMonoFont(const QString &family, int pixelSize)
{
    QFont f;
    f.setFamilies({
        QStringLiteral("Cascadia Mono"),
        QStringLiteral("Cascadia Code"),
        QStringLiteral("Consolas"),
        QStringLiteral("Courier New"),
    });
    if (!family.isEmpty() && !isBitmapMonoFamily(family))
        f.setFamily(family);
    f.setStyleHint(QFont::AnyStyle);
    f.setStyleStrategy(static_cast<QFont::StyleStrategy>(
        static_cast<int>(QFont::PreferOutline)
        | static_cast<int>(QFont::NoFontMerging)
        | static_cast<int>(QFont::PreferMatch)));
    if (pixelSize > 0)
        f.setPixelSize(pixelSize);
    return f;
}

static void appendIfPresent(QStringList &out, const QString &family)
{
    if (family.isEmpty() || out.contains(family))
        return;
    if (QFontDatabase::hasFamily(family))
        out.append(family);
}

void ThemeFonts::resolveUiStacks()
{
    if (!s_uiFamilies.isEmpty())
        return;

    QStringList latin;
    QStringList cjk;

#if defined(Q_OS_WIN)
    // WinUI / Windows 11: Segoe UI Variable for Latin; UI CJK companions for Han/Kana/Hangul.
    // First family that has the glyph wins — keep Latin first so English stays Segoe.
    appendIfPresent(latin, QStringLiteral("Segoe UI Variable"));
    appendIfPresent(latin, QStringLiteral("Segoe UI"));
    appendIfPresent(cjk, QStringLiteral("Microsoft YaHei UI"));
    appendIfPresent(cjk, QStringLiteral("Microsoft JhengHei UI"));
    appendIfPresent(cjk, QStringLiteral("Yu Gothic UI"));
    appendIfPresent(cjk, QStringLiteral("Malgun Gothic"));
    appendIfPresent(cjk, QStringLiteral("Microsoft YaHei"));
    appendIfPresent(cjk, QStringLiteral("Microsoft JhengHei"));
#elif defined(Q_OS_MACOS)
    appendIfPresent(latin, QStringLiteral("SF Pro Text"));
    appendIfPresent(latin, QStringLiteral("Helvetica Neue"));
    appendIfPresent(cjk, QStringLiteral("PingFang SC"));
    appendIfPresent(cjk, QStringLiteral("PingFang TC"));
    appendIfPresent(cjk, QStringLiteral("Hiragino Sans GB"));
    appendIfPresent(cjk, QStringLiteral("Hiragino Sans"));
    appendIfPresent(cjk, QStringLiteral("Apple SD Gothic Neo"));
#else
    appendIfPresent(latin, QStringLiteral("Inter"));
    appendIfPresent(latin, QStringLiteral("Noto Sans"));
    appendIfPresent(latin, QStringLiteral("DejaVu Sans"));
    appendIfPresent(cjk, QStringLiteral("Noto Sans CJK SC"));
    appendIfPresent(cjk, QStringLiteral("Noto Sans CJK TC"));
    appendIfPresent(cjk, QStringLiteral("Noto Sans CJK JP"));
    appendIfPresent(cjk, QStringLiteral("Noto Sans CJK KR"));
    appendIfPresent(cjk, QStringLiteral("Source Han Sans SC"));
    appendIfPresent(cjk, QStringLiteral("WenQuanYi Micro Hei"));
    appendIfPresent(cjk, QStringLiteral("Droid Sans Fallback"));
#endif

    s_uiFamilies = latin + cjk;
    if (s_uiFamilies.isEmpty())
        s_uiFamilies << QStringLiteral("Sans Serif");

    QStringList textLatin;
#if defined(Q_OS_WIN)
    appendIfPresent(textLatin, QStringLiteral("Segoe UI Variable Text"));
    appendIfPresent(textLatin, QStringLiteral("Segoe UI Variable"));
    appendIfPresent(textLatin, QStringLiteral("Segoe UI"));
#else
    textLatin = latin;
#endif
    if (textLatin.isEmpty())
        textLatin = latin;
    s_textFamilies = textLatin + cjk;
    if (s_textFamilies.isEmpty())
        s_textFamilies = s_uiFamilies;

    QStringList displayLatin;
#if defined(Q_OS_WIN)
    appendIfPresent(displayLatin, QStringLiteral("Segoe UI Variable Display"));
    appendIfPresent(displayLatin, QStringLiteral("Segoe UI Variable"));
    appendIfPresent(displayLatin, QStringLiteral("Segoe UI"));
#else
    displayLatin = latin;
#endif
    if (displayLatin.isEmpty())
        displayLatin = latin;
    s_displayFamilies = displayLatin + cjk;
    if (s_displayFamilies.isEmpty())
        s_displayFamilies = s_uiFamilies;
}

static QFont makeUiFont(const QStringList &families, int pixelSize)
{
    QFont f;
    if (!families.isEmpty()) {
        f.setFamilies(families);
        f.setFamily(families.first());
    }
    f.setStyleHint(QFont::SansSerif);
    f.setStyleStrategy(QFont::PreferOutline);
    if (pixelSize > 0)
        f.setPixelSize(pixelSize);
    return f;
}

ThemeFonts::ThemeFonts(QObject *parent)
    : QObject(parent)
{
    ensureLoaded();
}

ThemeFonts *ThemeFonts::create(QQmlEngine *, QJSEngine *)
{
    return new ThemeFonts;
}

void ThemeFonts::ensureLoaded()
{
    if (s_loaded)
        return;
    s_loaded = true;
    s_monoFamily = resolveMonoFamily();
    resolveUiStacks();

#if defined(Q_OS_WIN)
    if (QFontDatabase::hasFamily(QStringLiteral("Segoe Fluent Icons"))) {
        s_iconFamily = QStringLiteral("Segoe Fluent Icons");
        return;
    }
#endif

    static const char *const kCandidates[] = {
        ":/qt/qml/QWinUI3/Theme/fonts/WinSymbols3.ttf",
        ":/QWinUI3/Theme/fonts/WinSymbols3.ttf",
        ":/fonts/WinSymbols3.ttf",
    };

    int fontId = -1;
    for (const char *path : kCandidates) {
        fontId = QFontDatabase::addApplicationFont(QString::fromUtf8(path));
        if (fontId >= 0)
            break;
    }

    if (fontId < 0) {
        s_iconFamily = QStringLiteral("Symbols");
        return;
    }

    const QStringList families = QFontDatabase::applicationFontFamilies(fontId);
    if (!families.isEmpty())
        s_iconFamily = families.first();
    else
        s_iconFamily = QStringLiteral("Symbols");
}

void ThemeFonts::applyApplicationFont()
{
    ensureLoaded();
    if (!QGuiApplication::instance())
        return;
    QGuiApplication::setFont(makeUiFont(s_uiFamilies, 14));
}

QString ThemeFonts::iconFamily() const
{
    ensureLoaded();
    return s_iconFamily;
}

QString ThemeFonts::monoFamily() const
{
    ensureLoaded();
    return s_monoFamily;
}

QFont ThemeFonts::monoFont() const
{
    return monoFontFor(12);
}

QFont ThemeFonts::monoFontFor(int pixelSize) const
{
    ensureLoaded();
    return makeMonoFont(s_monoFamily, pixelSize);
}

bool ThemeFonts::iconFontLoaded() const
{
    ensureLoaded();
    return !s_iconFamily.isEmpty();
}

QString ThemeFonts::uiFamily() const
{
    ensureLoaded();
    return s_uiFamilies.isEmpty() ? QStringLiteral("Sans Serif") : s_uiFamilies.first();
}

QStringList ThemeFonts::uiFamilies() const
{
    ensureLoaded();
    return s_uiFamilies;
}

QStringList ThemeFonts::textFamilies() const
{
    ensureLoaded();
    return s_textFamilies;
}

QStringList ThemeFonts::displayFamilies() const
{
    ensureLoaded();
    return s_displayFamilies;
}

QFont ThemeFonts::uiFont() const
{
    return uiFontFor(14);
}

QFont ThemeFonts::uiFontFor(int pixelSize) const
{
    ensureLoaded();
    return makeUiFont(s_uiFamilies, pixelSize);
}
