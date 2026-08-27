#include "ThemeFonts.h"

#include <QFont>
#include <QFontDatabase>
#include <QGuiApplication>
#include <QHash>
#include <QQmlEngine>
#include <QDebug>

ThemeFonts *ThemeFonts::s_instance = nullptr;
bool ThemeFonts::s_loaded = false;
QString ThemeFonts::s_iconFamily = QStringLiteral("Segoe Fluent Icons");
QString ThemeFonts::s_monoFamily;
QString ThemeFonts::s_uiLocale;
int ThemeFonts::s_revision = 0;
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
    // Only setFamilies — do not call setFamily afterward (can re-trigger GDI Fixedsys paths).
    QStringList families;
    if (!family.isEmpty() && !isBitmapMonoFamily(family))
        families << family;
    families << QStringLiteral("Cascadia Mono")
             << QStringLiteral("Cascadia Code")
             << QStringLiteral("Consolas")
             << QStringLiteral("Courier New");
    families.removeDuplicates();
    // Drop GDI bitmap monospace that DirectWrite rejects with noisy warnings.
    for (int i = families.size() - 1; i >= 0; --i) {
        if (isBitmapMonoFamily(families.at(i)))
            families.removeAt(i);
    }
    f.setFamilies(families);
    f.setStyleHint(QFont::TypeWriter);
    f.setStyleStrategy(static_cast<QFont::StyleStrategy>(
        static_cast<int>(QFont::PreferOutline)
        | static_cast<int>(QFont::PreferQuality)));
    f.setHintingPreference(QFont::PreferNoHinting);
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

// WinUI UI fonts — always list even if hasFamily is flaky on some TTC registrations.
static void appendUiPreferred(QStringList &out, const QString &family)
{
    if (family.isEmpty() || out.contains(family))
        return;
    out.append(family);
}

static QString normalizeUiLocale(const QString &locale)
{
    const QString t = locale.trimmed().toLower().replace(QLatin1Char('-'), QLatin1Char('_'));
    if (t.isEmpty() || t == QLatin1String("en") || t == QLatin1String("en_us")
        || t == QLatin1String("c"))
        return {};
    return t;
}

static bool s_textResolved = false;
static bool s_displayResolved = false;

static void collectLanguageStacks(const QString &loc,
                                  QStringList *primary,
                                  QStringList *latin,
                                  QStringList *cjk)
{
    primary->clear();
    latin->clear();
    cjk->clear();

#if defined(Q_OS_WIN)
    appendIfPresent(*latin, QStringLiteral("Segoe UI Variable"));
    appendIfPresent(*latin, QStringLiteral("Segoe UI Variable Text"));
    appendIfPresent(*latin, QStringLiteral("Segoe UI"));

    const bool hans = loc.startsWith(QLatin1String("zh_cn"))
                      || loc.startsWith(QLatin1String("zh_sg"))
                      || loc == QLatin1String("zh")
                      || loc.startsWith(QLatin1String("zh_hans"));
    const bool hant = loc.startsWith(QLatin1String("zh_tw"))
                      || loc.startsWith(QLatin1String("zh_hk"))
                      || loc.startsWith(QLatin1String("zh_mo"))
                      || loc.startsWith(QLatin1String("zh_hant"));
    const bool ja = loc.startsWith(QLatin1String("ja"));
    const bool ko = loc.startsWith(QLatin1String("ko"));

    if (hans) {
        appendUiPreferred(*primary, QStringLiteral("Microsoft YaHei UI"));
        appendUiPreferred(*primary, QStringLiteral("Microsoft YaHei"));
    } else if (hant) {
        appendUiPreferred(*primary, QStringLiteral("Microsoft JhengHei UI"));
        appendUiPreferred(*primary, QStringLiteral("Microsoft JhengHei"));
    } else if (ja) {
        appendUiPreferred(*primary, QStringLiteral("Yu Gothic UI"));
        appendUiPreferred(*primary, QStringLiteral("Yu Gothic"));
    } else if (ko) {
        appendUiPreferred(*primary, QStringLiteral("Malgun Gothic"));
    }

    appendIfPresent(*cjk, QStringLiteral("Microsoft YaHei UI"));
    appendIfPresent(*cjk, QStringLiteral("Microsoft JhengHei UI"));
    appendIfPresent(*cjk, QStringLiteral("Yu Gothic UI"));
    appendIfPresent(*cjk, QStringLiteral("Malgun Gothic"));
    appendIfPresent(*cjk, QStringLiteral("Microsoft YaHei"));
    appendIfPresent(*cjk, QStringLiteral("Microsoft JhengHei"));
#elif defined(Q_OS_MACOS)
    appendIfPresent(*latin, QStringLiteral("SF Pro Text"));
    appendIfPresent(*latin, QStringLiteral("Helvetica Neue"));
    if (loc.startsWith(QLatin1String("zh"))) {
        appendUiPreferred(*primary, QStringLiteral("PingFang SC"));
        appendUiPreferred(*primary, QStringLiteral("Hiragino Sans GB"));
    } else if (loc.startsWith(QLatin1String("ja"))) {
        appendUiPreferred(*primary, QStringLiteral("Hiragino Sans"));
    } else if (loc.startsWith(QLatin1String("ko"))) {
        appendUiPreferred(*primary, QStringLiteral("Apple SD Gothic Neo"));
    }
    appendIfPresent(*cjk, QStringLiteral("PingFang SC"));
    appendIfPresent(*cjk, QStringLiteral("PingFang TC"));
    appendIfPresent(*cjk, QStringLiteral("Hiragino Sans GB"));
    appendIfPresent(*cjk, QStringLiteral("Hiragino Sans"));
    appendIfPresent(*cjk, QStringLiteral("Apple SD Gothic Neo"));
#else
    appendIfPresent(*latin, QStringLiteral("Inter"));
    appendIfPresent(*latin, QStringLiteral("Noto Sans"));
    appendIfPresent(*latin, QStringLiteral("DejaVu Sans"));
    if (loc.startsWith(QLatin1String("zh"))) {
        appendUiPreferred(*primary, QStringLiteral("Noto Sans CJK SC"));
        appendUiPreferred(*primary, QStringLiteral("Source Han Sans SC"));
    } else if (loc.startsWith(QLatin1String("ja"))) {
        appendUiPreferred(*primary, QStringLiteral("Noto Sans CJK JP"));
    } else if (loc.startsWith(QLatin1String("ko"))) {
        appendUiPreferred(*primary, QStringLiteral("Noto Sans CJK KR"));
    }
    appendIfPresent(*cjk, QStringLiteral("Noto Sans CJK SC"));
    appendIfPresent(*cjk, QStringLiteral("Noto Sans CJK TC"));
    appendIfPresent(*cjk, QStringLiteral("Noto Sans CJK JP"));
    appendIfPresent(*cjk, QStringLiteral("Noto Sans CJK KR"));
    appendIfPresent(*cjk, QStringLiteral("Source Han Sans SC"));
    appendIfPresent(*cjk, QStringLiteral("WenQuanYi Micro Hei"));
    appendIfPresent(*cjk, QStringLiteral("Droid Sans Fallback"));
#endif
}

static void fillTextFamilies(const QString &loc, QStringList *out, const QStringList &uiFallback)
{
    QStringList primary;
    QStringList latin;
    QStringList cjk;
    collectLanguageStacks(loc, &primary, &latin, &cjk);

    QStringList textLatin;
#if defined(Q_OS_WIN)
    if (primary.isEmpty()) {
        appendIfPresent(textLatin, QStringLiteral("Segoe UI Variable Text"));
        appendIfPresent(textLatin, QStringLiteral("Segoe UI Variable"));
        appendIfPresent(textLatin, QStringLiteral("Segoe UI"));
    } else {
        textLatin = primary;
        appendIfPresent(textLatin, QStringLiteral("Segoe UI Variable Text"));
        appendIfPresent(textLatin, QStringLiteral("Segoe UI Variable"));
    }
#else
    textLatin = primary.isEmpty() ? latin : primary;
#endif
    out->clear();
    for (const QString &f : textLatin + latin + cjk) {
        if (!out->contains(f))
            out->append(f);
    }
    if (out->isEmpty())
        *out = uiFallback;
}

static void fillDisplayFamilies(const QString &loc, QStringList *out, const QStringList &uiFallback)
{
    QStringList primary;
    QStringList latin;
    QStringList cjk;
    collectLanguageStacks(loc, &primary, &latin, &cjk);

    QStringList displayLatin;
#if defined(Q_OS_WIN)
    if (primary.isEmpty()) {
        appendIfPresent(displayLatin, QStringLiteral("Segoe UI Variable Display"));
        appendIfPresent(displayLatin, QStringLiteral("Segoe UI Variable"));
        appendIfPresent(displayLatin, QStringLiteral("Segoe UI"));
    } else {
        displayLatin = primary;
        appendIfPresent(displayLatin, QStringLiteral("Segoe UI Variable Display"));
        appendIfPresent(displayLatin, QStringLiteral("Segoe UI Variable"));
    }
#else
    displayLatin = primary.isEmpty() ? latin : primary;
#endif
    out->clear();
    for (const QString &f : displayLatin + latin + cjk) {
        if (!out->contains(f))
            out->append(f);
    }
    if (out->isEmpty())
        *out = uiFallback;
}

void ThemeFonts::resolveUiStacks()
{
    QStringList primary;
    QStringList latin;
    QStringList cjk;
    collectLanguageStacks(s_uiLocale, &primary, &latin, &cjk);

    // Primary language font first (YaHei UI for zh_CN), then Segoe, then other CJK.
    QStringList stack;
    for (const QString &f : primary + latin + cjk) {
        if (!stack.contains(f))
            stack.append(f);
    }
    if (stack.isEmpty())
        stack << QStringLiteral("Sans Serif");
    s_uiFamilies = stack;
    // 3.42 H11 — Text / Display stacks resolve on first textFamilies()/displayFamilies().
    s_textFamilies.clear();
    s_displayFamilies.clear();
    s_textResolved = false;
    s_displayResolved = false;
}

static QFont makeUiFont(const QStringList &families, int pixelSize)
{
    QFont f;
    QStringList stack = families;
    // Last-resort outline faces so an empty stack never falls through to GDI Fixedsys.
    static const char *const kSafe[] = {
        "Segoe UI Variable",
        "Segoe UI",
        "Microsoft YaHei UI",
        "Arial",
        nullptr,
    };
    for (const char *name : kSafe) {
        const QString family = QString::fromUtf8(name);
        if (isBitmapMonoFamily(family))
            continue;
        if (!stack.contains(family))
            stack.append(family);
    }
    for (int i = stack.size() - 1; i >= 0; --i) {
        if (isBitmapMonoFamily(stack.at(i)))
            stack.removeAt(i);
    }
    if (!stack.isEmpty())
        f.setFamilies(stack);
    f.setStyleHint(QFont::SansSerif);
    f.setStyleStrategy(static_cast<QFont::StyleStrategy>(
        static_cast<int>(QFont::PreferOutline)
        | static_cast<int>(QFont::PreferQuality)));
    // Fractional DPR (125%/150% Wayland): PreferVerticalHinting keeps glyphs crisp (2.70 F6)
    qreal dpr = 1.0;
    if (qGuiApp && qGuiApp->devicePixelRatio() > 0)
        dpr = qGuiApp->devicePixelRatio();
    const bool fractional = qAbs(dpr - qRound(dpr)) > 0.02;
    f.setHintingPreference(fractional ? QFont::PreferVerticalHinting
                                      : QFont::PreferDefaultHinting);
    if (pixelSize > 0)
        f.setPixelSize(pixelSize);
    return f;
}

ThemeFonts::ThemeFonts(QObject *parent)
    : QObject(parent)
{
    ensureLoaded();
}

ThemeFonts *ThemeFonts::instance()
{
    if (!s_instance)
        s_instance = new ThemeFonts;
    return s_instance;
}

ThemeFonts *ThemeFonts::create(QQmlEngine *, QJSEngine *)
{
    auto *self = instance();
    QQmlEngine::setObjectOwnership(self, QQmlEngine::CppOwnership);
    return self;
}

void ThemeFonts::ensureLoaded()
{
    if (s_loaded)
        return;
    s_loaded = true;
    // Mono family resolved lazily in monoFontFor — not needed for first chrome paint (3.34 S11).
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

void ThemeFonts::applyForUiLocale(const QString &locale)
{
    ensureLoaded();
    const QString norm = normalizeUiLocale(locale);
    if (norm == s_uiLocale && !s_uiFamilies.isEmpty()) {
        applyApplicationFont();
        return;
    }
    s_uiLocale = norm;
    s_uiFamilies.clear();
    s_textFamilies.clear();
    s_displayFamilies.clear();
    s_textResolved = false;
    s_displayResolved = false;
    resolveUiStacks();
    ++s_revision;
    applyApplicationFont();
    if (!s_uiFamilies.isEmpty()) {
        qInfo("QWinUI3 UI font: %s (locale=%s)",
              qPrintable(s_uiFamilies.first()),
              qPrintable(s_uiLocale.isEmpty() ? QStringLiteral("en") : s_uiLocale));
    }
    emitUiFontsChanged();
}

void ThemeFonts::emitUiFontsChanged()
{
    if (s_instance)
        emit s_instance->uiFontsChanged();
}

QString ThemeFonts::iconFamily() const
{
    ensureLoaded();
    return s_iconFamily;
}

QString ThemeFonts::monoFamily() const
{
    ensureLoaded();
    if (s_monoFamily.isEmpty())
        s_monoFamily = resolveMonoFamily();
    return s_monoFamily;
}

QFont ThemeFonts::monoFont() const
{
    return monoFontFor(12);
}

QFont ThemeFonts::monoFontFor(int pixelSize) const
{
    ensureLoaded();
    if (s_monoFamily.isEmpty())
        s_monoFamily = resolveMonoFamily();
    return makeMonoFont(s_monoFamily, pixelSize);
}

QFont ThemeFonts::iconFont() const
{
    return iconFontFor(16);
}

QFont ThemeFonts::iconFontFor(int pixelSize) const
{
    return iconFontFor(pixelSize, int(QFont::Normal));
}

QFont ThemeFonts::iconFontFor(int pixelSize, int weight) const
{
    ensureLoaded();
    const int px = pixelSize > 0 ? pixelSize : 0;
    const int w = weight > 0 ? weight : int(QFont::Normal);
    // 3.41 H10 — one QFont per (size, weight); PreferNoHinting already on this path.
    const qint64 key = (qint64(px) << 32) | quint32(w);
    static QHash<qint64, QFont> cache;
    const auto it = cache.constFind(key);
    if (it != cache.cend())
        return it.value();

    QFont f;
    QStringList families;
    if (!s_iconFamily.isEmpty() && !isBitmapMonoFamily(s_iconFamily))
        families << s_iconFamily;
    families << QStringLiteral("Segoe Fluent Icons")
             << QStringLiteral("Segoe MDL2 Assets")
             << QStringLiteral("Segoe UI Symbol");
    families.removeDuplicates();
    for (int i = families.size() - 1; i >= 0; --i) {
        if (isBitmapMonoFamily(families.at(i)))
            families.removeAt(i);
    }
    f.setFamilies(families);
    // Icon PUA glyphs must stay on outline DirectWrite paths — PreferVerticalHinting
    // inherited from the app UI font previously fell through to GDI Fixedsys (smoke noise).
    // NoFontMerging: do not merge missing PUA codepoints into GDI Fixedsys.
    f.setStyleHint(QFont::SansSerif);
    f.setStyleStrategy(static_cast<QFont::StyleStrategy>(
        static_cast<int>(QFont::PreferOutline)
        | static_cast<int>(QFont::PreferQuality)
        | static_cast<int>(QFont::NoFontMerging)));
    f.setHintingPreference(QFont::PreferNoHinting);
    f.setWeight(QFont::Weight(w));
    if (px > 0)
        f.setPixelSize(px);
    cache.insert(key, f);
    return f;
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
    if (!s_textResolved)
        fillTextFamilies(s_uiLocale, &s_textFamilies, s_uiFamilies);
    s_textResolved = true;
    return s_textFamilies;
}

QStringList ThemeFonts::displayFamilies() const
{
    ensureLoaded();
    if (!s_displayResolved)
        fillDisplayFamilies(s_uiLocale, &s_displayFamilies, s_uiFamilies);
    s_displayResolved = true;
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

QString ThemeFonts::uiLocale() const
{
    return s_uiLocale;
}

int ThemeFonts::revision() const
{
    return s_revision;
}
