#include "ThemeFonts.h"

#include <QFontDatabase>
#include <QQmlEngine>

bool ThemeFonts::s_loaded = false;
QString ThemeFonts::s_iconFamily = QStringLiteral("Segoe Fluent Icons");
QString ThemeFonts::s_monoFamily;

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
        if (QFontDatabase::hasFamily(family))
            return family;
    }
    return QStringLiteral("Courier New");
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

#if defined(Q_OS_WIN)
    // Prefer the system font when present (native Win11 look).
    if (QFontDatabase::hasFamily(QStringLiteral("Segoe Fluent Icons"))) {
        s_iconFamily = QStringLiteral("Segoe Fluent Icons");
        return;
    }
#endif

    // WinSymbols3.ttf (MIT, SymbolIconManager) — Segoe Fluent Icons codepoints.
    // Packaged via qt_add_qml_module RESOURCES.
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
        // Last resort: keep Segoe name (may tofu on Linux) or generic Symbols.
        s_iconFamily = QStringLiteral("Symbols");
        return;
    }

    const QStringList families = QFontDatabase::applicationFontFamilies(fontId);
    if (!families.isEmpty())
        s_iconFamily = families.first();
    else
        s_iconFamily = QStringLiteral("Symbols");
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

bool ThemeFonts::iconFontLoaded() const
{
    ensureLoaded();
    return !s_iconFamily.isEmpty();
}
