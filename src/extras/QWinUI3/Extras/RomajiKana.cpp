#include "RomajiKana.h"

#include <QList>
#include <QPair>
#include <algorithm>

namespace {

using Pair = QPair<QString, QString>;

const QList<Pair> &table()
{
    static const QList<Pair> t = [] {
        QList<Pair> rows = {
        {QStringLiteral("kya"), QStringLiteral("きゃ")},
        {QStringLiteral("kyu"), QStringLiteral("きゅ")},
        {QStringLiteral("kyo"), QStringLiteral("きょ")},
        {QStringLiteral("gya"), QStringLiteral("ぎゃ")},
        {QStringLiteral("gyu"), QStringLiteral("ぎゅ")},
        {QStringLiteral("gyo"), QStringLiteral("ぎょ")},
        {QStringLiteral("sha"), QStringLiteral("しゃ")},
        {QStringLiteral("shu"), QStringLiteral("しゅ")},
        {QStringLiteral("sho"), QStringLiteral("しょ")},
        {QStringLiteral("sya"), QStringLiteral("しゃ")},
        {QStringLiteral("syu"), QStringLiteral("しゅ")},
        {QStringLiteral("syo"), QStringLiteral("しょ")},
        {QStringLiteral("ja"), QStringLiteral("じゃ")},
        {QStringLiteral("ju"), QStringLiteral("じゅ")},
        {QStringLiteral("jo"), QStringLiteral("じょ")},
        {QStringLiteral("jya"), QStringLiteral("じゃ")},
        {QStringLiteral("jyu"), QStringLiteral("じゅ")},
        {QStringLiteral("jyo"), QStringLiteral("じょ")},
        {QStringLiteral("cha"), QStringLiteral("ちゃ")},
        {QStringLiteral("chu"), QStringLiteral("ちゅ")},
        {QStringLiteral("cho"), QStringLiteral("ちょ")},
        {QStringLiteral("tya"), QStringLiteral("ちゃ")},
        {QStringLiteral("tyu"), QStringLiteral("ちゅ")},
        {QStringLiteral("tyo"), QStringLiteral("ちょ")},
        {QStringLiteral("nya"), QStringLiteral("にゃ")},
        {QStringLiteral("nyu"), QStringLiteral("にゅ")},
        {QStringLiteral("nyo"), QStringLiteral("にょ")},
        {QStringLiteral("hya"), QStringLiteral("ひゃ")},
        {QStringLiteral("hyu"), QStringLiteral("ひゅ")},
        {QStringLiteral("hyo"), QStringLiteral("ひょ")},
        {QStringLiteral("bya"), QStringLiteral("びゃ")},
        {QStringLiteral("byu"), QStringLiteral("びゅ")},
        {QStringLiteral("byo"), QStringLiteral("びょ")},
        {QStringLiteral("pya"), QStringLiteral("ぴゃ")},
        {QStringLiteral("pyu"), QStringLiteral("ぴゅ")},
        {QStringLiteral("pyo"), QStringLiteral("ぴょ")},
        {QStringLiteral("mya"), QStringLiteral("みゃ")},
        {QStringLiteral("myu"), QStringLiteral("みゅ")},
        {QStringLiteral("myo"), QStringLiteral("みょ")},
        {QStringLiteral("rya"), QStringLiteral("りゃ")},
        {QStringLiteral("ryu"), QStringLiteral("りゅ")},
        {QStringLiteral("ryo"), QStringLiteral("りょ")},
        {QStringLiteral("ka"), QStringLiteral("か")},
        {QStringLiteral("ki"), QStringLiteral("き")},
        {QStringLiteral("ku"), QStringLiteral("く")},
        {QStringLiteral("ke"), QStringLiteral("け")},
        {QStringLiteral("ko"), QStringLiteral("こ")},
        {QStringLiteral("ga"), QStringLiteral("が")},
        {QStringLiteral("gi"), QStringLiteral("ぎ")},
        {QStringLiteral("gu"), QStringLiteral("ぐ")},
        {QStringLiteral("ge"), QStringLiteral("げ")},
        {QStringLiteral("go"), QStringLiteral("ご")},
        {QStringLiteral("sa"), QStringLiteral("さ")},
        {QStringLiteral("shi"), QStringLiteral("し")},
        {QStringLiteral("si"), QStringLiteral("し")},
        {QStringLiteral("su"), QStringLiteral("す")},
        {QStringLiteral("se"), QStringLiteral("せ")},
        {QStringLiteral("so"), QStringLiteral("そ")},
        {QStringLiteral("za"), QStringLiteral("ざ")},
        {QStringLiteral("ji"), QStringLiteral("じ")},
        {QStringLiteral("zi"), QStringLiteral("じ")},
        {QStringLiteral("zu"), QStringLiteral("ず")},
        {QStringLiteral("ze"), QStringLiteral("ぜ")},
        {QStringLiteral("zo"), QStringLiteral("ぞ")},
        {QStringLiteral("ta"), QStringLiteral("た")},
        {QStringLiteral("chi"), QStringLiteral("ち")},
        {QStringLiteral("ti"), QStringLiteral("ち")},
        {QStringLiteral("tsu"), QStringLiteral("つ")},
        {QStringLiteral("tu"), QStringLiteral("つ")},
        {QStringLiteral("te"), QStringLiteral("て")},
        {QStringLiteral("to"), QStringLiteral("と")},
        {QStringLiteral("da"), QStringLiteral("だ")},
        {QStringLiteral("di"), QStringLiteral("ぢ")},
        {QStringLiteral("du"), QStringLiteral("づ")},
        {QStringLiteral("de"), QStringLiteral("で")},
        {QStringLiteral("do"), QStringLiteral("ど")},
        {QStringLiteral("na"), QStringLiteral("な")},
        {QStringLiteral("ni"), QStringLiteral("に")},
        {QStringLiteral("nu"), QStringLiteral("ぬ")},
        {QStringLiteral("ne"), QStringLiteral("ね")},
        {QStringLiteral("no"), QStringLiteral("の")},
        {QStringLiteral("ha"), QStringLiteral("は")},
        {QStringLiteral("hi"), QStringLiteral("ひ")},
        {QStringLiteral("fu"), QStringLiteral("ふ")},
        {QStringLiteral("hu"), QStringLiteral("ふ")},
        {QStringLiteral("he"), QStringLiteral("へ")},
        {QStringLiteral("ho"), QStringLiteral("ほ")},
        {QStringLiteral("ba"), QStringLiteral("ば")},
        {QStringLiteral("bi"), QStringLiteral("び")},
        {QStringLiteral("bu"), QStringLiteral("ぶ")},
        {QStringLiteral("be"), QStringLiteral("べ")},
        {QStringLiteral("bo"), QStringLiteral("ぼ")},
        {QStringLiteral("pa"), QStringLiteral("ぱ")},
        {QStringLiteral("pi"), QStringLiteral("ぴ")},
        {QStringLiteral("pu"), QStringLiteral("ぷ")},
        {QStringLiteral("pe"), QStringLiteral("ぺ")},
        {QStringLiteral("po"), QStringLiteral("ぽ")},
        {QStringLiteral("ma"), QStringLiteral("ま")},
        {QStringLiteral("mi"), QStringLiteral("み")},
        {QStringLiteral("mu"), QStringLiteral("む")},
        {QStringLiteral("me"), QStringLiteral("め")},
        {QStringLiteral("mo"), QStringLiteral("も")},
        {QStringLiteral("ya"), QStringLiteral("や")},
        {QStringLiteral("yu"), QStringLiteral("ゆ")},
        {QStringLiteral("yo"), QStringLiteral("よ")},
        {QStringLiteral("ra"), QStringLiteral("ら")},
        {QStringLiteral("ri"), QStringLiteral("り")},
        {QStringLiteral("ru"), QStringLiteral("る")},
        {QStringLiteral("re"), QStringLiteral("れ")},
        {QStringLiteral("ro"), QStringLiteral("ろ")},
        {QStringLiteral("wa"), QStringLiteral("わ")},
        {QStringLiteral("wo"), QStringLiteral("を")},
        {QStringLiteral("nn"), QStringLiteral("ん")},
        {QStringLiteral("n'"), QStringLiteral("ん")},
        {QStringLiteral("a"), QStringLiteral("あ")},
        {QStringLiteral("i"), QStringLiteral("い")},
        {QStringLiteral("u"), QStringLiteral("う")},
        {QStringLiteral("e"), QStringLiteral("え")},
        {QStringLiteral("o"), QStringLiteral("お")},
        {QStringLiteral("-"), QStringLiteral("ー")},
        };
        std::sort(rows.begin(), rows.end(), [](const Pair &a, const Pair &b) {
            return a.first.size() > b.first.size();
        });
        return rows;
    }();
    return t;
}

bool isConsonant(QChar c)
{
    const QChar l = c.toLower();
    return l.isLetter() && !QStringLiteral("aiueo").contains(l);
}

} // namespace

QString RomajiKana::toHiragana(const QString &romaji, QString *rest)
{
    QString in = romaji.toLower();
    QString out;
    int i = 0;
    while (i < in.size()) {
        if (in.at(i) == QLatin1Char('n') && i + 1 == in.size())
            break;
        if (in.at(i) == QLatin1Char('n') && i + 1 < in.size()) {
            const QChar nxt = in.at(i + 1);
            if (nxt != QLatin1Char('a') && nxt != QLatin1Char('i') && nxt != QLatin1Char('u')
                && nxt != QLatin1Char('e') && nxt != QLatin1Char('o') && nxt != QLatin1Char('y')
                && nxt != QLatin1Char('n') && nxt != QLatin1Char('\'')) {
                out += QStringLiteral("ん");
                ++i;
                continue;
            }
        }
        if (i + 1 < in.size() && in.at(i) == in.at(i + 1) && isConsonant(in.at(i))
            && in.at(i) != QLatin1Char('n')) {
            out += QStringLiteral("っ");
            ++i;
            continue;
        }
        bool hit = false;
        for (const Pair &p : table()) {
            if (in.mid(i).startsWith(p.first)) {
                out += p.second;
                i += p.first.size();
                hit = true;
                break;
            }
        }
        if (hit)
            continue;
        break;
    }
    if (rest)
        *rest = in.mid(i);
    return out;
}

QString RomajiKana::toKatakana(const QString &hiragana)
{
    QString out;
    out.reserve(hiragana.size());
    for (QChar c : hiragana) {
        const uint u = c.unicode();
        if (u >= 0x3041 && u <= 0x3096)
            out += QChar(u + 0x60);
        else
            out += c;
    }
    return out;
}

QStringList RomajiKana::candidates(const QString &romaji)
{
    QString rest;
    const QString hira = toHiragana(romaji, &rest);
    if (hira.isEmpty())
        return {};
    QStringList out;
    out << hira;
    const QString kata = toKatakana(hira);
    if (kata != hira)
        out << kata;
    return out;
}
