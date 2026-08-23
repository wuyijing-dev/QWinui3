#include "WelcomeBanner.h"

#include <QByteArray>
#include <QDateTime>
#include <QString>
#include <cstdio>

#if defined(Q_OS_WIN)
#  ifndef NOMINMAX
#    define NOMINMAX
#  endif
#  include <windows.h>
#endif

#include <QWinUI3/Compat/QtCompatQml.h>
#include <QWinUI3/Compat/QtCompatVersion.h>

#ifndef QWINUI3_VERSION_STRING
#  define QWINUI3_VERSION_STRING "dev"
#endif

namespace QWinUI3 {

namespace {

constexpr int kInner = 58;

bool envTruthy(const char *name)
{
    const QByteArray v = qgetenv(name).trimmed().toLower();
    return v == "1" || v == "true" || v == "yes" || v == "on";
}

void enableAnsiConsole()
{
#if defined(Q_OS_WIN)
    SetConsoleOutputCP(CP_UTF8);
    SetConsoleCP(CP_UTF8);
    HANDLE h = GetStdHandle(STD_ERROR_HANDLE);
    if (!h || h == INVALID_HANDLE_VALUE)
        return;
    DWORD mode = 0;
    if (!GetConsoleMode(h, &mode))
        return;
    SetConsoleMode(h, mode | ENABLE_VIRTUAL_TERMINAL_PROCESSING);
#endif
}

QString padInner(QString s)
{
    if (s.size() > kInner)
        s = s.left(kInner - 1) + QChar(0x2026);
    return s.leftJustified(kInner, QLatin1Char(' '));
}

struct Palette {
    const char *accent;
    const char *dim;
    const char *bright;
    const char *warn;
};

const Palette kPalettes[] = {
    { "\033[38;5;39m", "\033[38;5;67m", "\033[38;5;159m", "\033[38;5;214m" },
    { "\033[38;5;141m", "\033[38;5;98m", "\033[38;5;183m", "\033[38;5;218m" },
    { "\033[38;5;43m", "\033[38;5;29m", "\033[38;5;120m", "\033[38;5;185m" },
    { "\033[38;5;208m", "\033[38;5;166m", "\033[38;5;223m", "\033[38;5;229m" },
    { "\033[38;5;205m", "\033[38;5;162m", "\033[38;5;218m", "\033[38;5;117m" },
};

const char *kTips[] = {
    "Tip: NavigationWindow + Theme.dark — shell in under a minute",
    "Tip: Prefer docs/stable-api.md types in shipping apps",
    "Tip: FormLayout.beginValidate / endValidate for async rules",
    "Tip: PlatformCapability.mica before assuming Win11 materials",
    "Tip: DataTable reuseItems + maxFilterResults at 10k+ rows",
    "Tip: Theme.motion.ms(\"fast\") — honor Theme.reducedMotion",
    "Tip: examples/first-app before copying Gallery sources",
    "Tip: QWINUI3_NO_BANNER=1 quiets this splash",
};

constexpr const char *kReset = "\033[0m";
constexpr const char *kBold = "\033[1m";

QString row(const Palette &c, const QString &bodyColored)
{
    return QString::fromLatin1(c.dim) + QStringLiteral("  │ ") + kReset + bodyColored
            + QString::fromLatin1(c.dim) + QStringLiteral(" │") + kReset + QLatin1Char('\n');
}

} // namespace

void printWelcomeBanner()
{
    static bool printed = false;
    if (printed)
        return;
    if (envTruthy("QWINUI3_NO_BANNER") || envTruthy("QWINUI3_QUIET"))
        return;
    printed = true;

    enableAnsiConsole();

    const qint64 now = QDateTime::currentMSecsSinceEpoch();
    const Palette &c = kPalettes[int(now / 1000) % 5];
    const int tipCount = int(sizeof(kTips) / sizeof(kTips[0]));
    const char *tip = kTips[int(now / 17) % tipCount];

    const QString qt = QStringLiteral("%1.%2.%3")
                           .arg(Compat::qtVersionMajor())
                           .arg(Compat::qtVersionMinor())
                           .arg(Compat::qtVersionPatch());
    const QString support = Compat::Qml::supportRangeString();

    static const char *const wordmark[] = {
        "  ██████╗ ██╗    ██╗██╗███╗   ██╗██╗   ██╗██╗██████╗",
        " ██╔═══██╗██║    ██║██║████╗  ██║██║   ██║██║╚════██╗",
        " ██║   ██║██║ █╗ ██║██║██╔██╗ ██║██║   ██║██║ █████╔╝",
        " ██║▄▄ ██║██║███╗██║██║██║╚██╗██║╚██╗ ██╔╝██║ ╚═══██╗",
        " ╚██████╔╝╚███╔███╔╝██║██║ ╚████║ ╚████╔╝ ██║██████╔╝",
        "  ╚══▀▀═╝  ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═════╝",
    };

    QString out;
    out += QLatin1Char('\n');
    out += QString::fromLatin1(c.dim) + kBold
            + QStringLiteral("  ╭──────────────────────────────────────────────────────────╮")
            + kReset + QLatin1Char('\n');

    out += QString::fromLatin1(c.dim) + QStringLiteral("  │ ") + kReset
            + QStringLiteral("\033[38;5;203m●\033[0m \033[38;5;221m●\033[0m \033[38;5;114m●\033[0m  ")
            + QString::fromLatin1(c.bright) + kBold + QStringLiteral("QWinUI3") + kReset
            + QString::fromLatin1(c.dim)
            + QStringLiteral("                                       │") + kReset + QLatin1Char('\n');

    out += QString::fromLatin1(c.dim)
            + QStringLiteral("  │ ──────────────────────────────────────────────────────── │")
            + kReset + QLatin1Char('\n');

    out += row(c, QString::fromLatin1(c.bright) + padInner(QString()) + kReset);

    for (const char *wm : wordmark) {
        out += row(c, QString::fromLatin1(c.accent) + kBold
                          + padInner(QString::fromUtf8(wm)) + kReset);
    }

    out += row(c, QString::fromLatin1(c.bright) + padInner(QString()) + kReset);
    out += row(c, QString::fromLatin1(c.bright)
                          + padInner(QStringLiteral("Fluent · WinUI-style controls for Qt Quick"))
                          + kReset);
    out += row(c, QString::fromLatin1(c.warn) + kBold
                          + padInner(QStringLiteral("v%1  ·  Qt %2  ·  %3")
                                            .arg(QLatin1String(QWINUI3_VERSION_STRING), qt, support))
                          + kReset);
    out += row(c, QString::fromLatin1(c.bright) + padInner(QString()) + kReset);

    {
        QString tipBody = QString::fromUtf8(tip);
        if (tipBody.size() > kInner - 2)
            tipBody = tipBody.left(kInner - 3) + QChar(0x2026);
        tipBody = tipBody.leftJustified(kInner - 2, QLatin1Char(' '));
        out += QString::fromLatin1(c.dim) + QStringLiteral("  │ ") + kReset
                + QString::fromLatin1(c.warn) + QStringLiteral("▸ ") + kReset
                + QString::fromLatin1(c.bright) + tipBody + kReset
                + QString::fromLatin1(c.dim) + QStringLiteral(" │") + kReset + QLatin1Char('\n');
    }

    out += QString::fromLatin1(c.dim) + kBold
            + QStringLiteral("  ╰──────────────────────────────────────────────────────────╯")
            + kReset + QLatin1Char('\n');
    out += QLatin1Char('\n');

    fprintf(stderr, "%s", qUtf8Printable(out));
    fflush(stderr);
}

} // namespace QWinUI3
