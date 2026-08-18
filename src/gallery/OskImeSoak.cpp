#include "OskImeSoak.h"

#include "HangulComposer.h"
#include "KeyboardEngine.h"
#include "PinyinLexicon.h"
#include "RomajiKana.h"

#include <QDebug>

namespace {

void typeAscii(KeyboardEngine &engine, const char *ascii)
{
    for (const char *p = ascii; *p; ++p) {
        const char c = *p;
        const bool shift = c >= 'A' && c <= 'Z';
        const int vk = int(QChar::fromLatin1(c).toUpper().unicode());
        engine.processVk(vk, shift);
    }
}

void resetCompose(KeyboardEngine &engine)
{
    engine.processVk(27, false); // Esc
}

bool expectContains(const QStringList &hay, const QString &needle, const char *what)
{
    if (hay.contains(needle))
        return true;
    qWarning() << "osk-soak fail:" << what << "missing" << needle << "in" << hay.mid(0, 8);
    return false;
}

bool fail(const char *what)
{
    qWarning() << "osk-soak fail:" << what;
    return false;
}

} // namespace

bool runOskImeSoak()
{
    KeyboardEngine engine;

    const QStringList ids = engine.layoutIds();
    for (const char *need : {"en-US", "de-DE", "ar", "zh-Hans", "ja-JP", "ko-KR"}) {
        if (!ids.contains(QLatin1String(need)))
            return fail(need);
    }

    engine.setLayoutId(QStringLiteral("ar"));
    if (!engine.rtl())
        return fail("ar should be RTL");

    engine.setLayoutId(QStringLiteral("en-US"));
    const QString enBackend = engine.backend();
    if (enBackend != QLatin1String("keyman")
        && enBackend != QLatin1String("builtin"))
        return fail("en-US backend");

#ifdef Q_OS_WIN
    if (!engine.supportsSystemWide())
        return fail("Windows supportsSystemWide");
#else
    if (engine.supportsSystemWide())
        return fail("non-Windows supportsSystemWide should be false");
#endif

    engine.setLayoutId(QStringLiteral("zh-Hans"));
    if (engine.backend() != QLatin1String("pinyin"))
        return fail("zh backend");
    typeAscii(engine, "nihao");
    if (!expectContains(engine.candidates(), QStringLiteral("\u4f60\u597d"), "nihao"))
        return false;
    resetCompose(engine);
    typeAscii(engine, "nv");
    if (!expectContains(engine.candidates(), QStringLiteral("\u5973"), "nv"))
        return false;
    if (!PinyinLexicon::instance().lookup(QStringLiteral("niha")).contains(QStringLiteral("\u4f60\u597d")))
        return fail("prefix niha");

    engine.setLayoutId(QStringLiteral("ja-JP"));
    if (engine.backend() != QLatin1String("romaji"))
        return fail("ja backend");
    typeAscii(engine, "konnichiwa");
    if (!engine.candidates().contains(QStringLiteral("\u3053\u3093\u306b\u3061\u308f"))
        && !engine.candidates().contains(QStringLiteral("\u3053\u3093\u306b\u3061\u306f"))) {
        qWarning() << "osk-soak fail: konnichiwa kana; got" << engine.candidates()
                   << "preedit" << engine.preedit();
        return false;
    }
    const QStringList xtu = RomajiKana::candidates(QStringLiteral("xtu"));
    if (!xtu.contains(QStringLiteral("\u3063")))
        return fail("xtu small tsu");
    const QString nFinal = RomajiKana::toHiragana(QStringLiteral("n"), nullptr, true);
    if (nFinal != QStringLiteral("\u3093"))
        return fail("trailing n");

    HangulComposer hangul;
    QString hangulOut;
    for (const char *p = "dkssud"; *p; ++p)
        hangulOut += hangul.feedVk(int(QChar::fromLatin1(*p).toUpper().unicode()), false);
    hangulOut += hangul.flush();
    if (hangulOut != QStringLiteral("\uc548\ub155"))
        return fail("dkssud hangul");

    engine.setLayoutId(QStringLiteral("ko-KR"));
    if (engine.backend() != QLatin1String("hangul"))
        return fail("ko backend");
    typeAscii(engine, "dks");
    if (!engine.candidates().contains(QStringLiteral("\uc548"))
        && engine.preedit() != QStringLiteral("\uc548"))
        return fail("dks hangul");

    qInfo("QWinUI3 OSK/IME soak OK (layouts=%d, backend en-US=%s)",
          ids.size(),
          qPrintable(enBackend));
    return true;
}
