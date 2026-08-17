#include "PinyinLexicon.h"

#include <QFile>
#include <algorithm>

PinyinLexicon &PinyinLexicon::instance()
{
    static PinyinLexicon lex;
    return lex;
}

PinyinLexicon::PinyinLexicon()
{
    loadFile(QStringLiteral(":/QWinUI3/keyboards/pinyin_lexicon.tsv"), false);
    loadFile(QStringLiteral(":/QWinUI3/keyboards/pinyin_words.tsv"), true);
}

void PinyinLexicon::loadFile(const QString &path, bool words)
{
    QFile f(path);
    if (!f.open(QIODevice::ReadOnly | QIODevice::Text))
        return;
    const QString text = QString::fromUtf8(f.readAll());
    const QStringList lines = text.split(QLatin1Char('\n'));
    for (QString line : lines) {
        line = line.trimmed();
        if (line.isEmpty() || line.startsWith(QLatin1Char('#')))
            continue;
        const int tab = line.indexOf(QLatin1Char('\t'));
        if (tab <= 0)
            continue;
        const QString py = line.left(tab);
        const QString rhs = line.mid(tab + 1);
        if (words) {
            const QStringList parts = rhs.split(QLatin1Char(','), Qt::SkipEmptyParts);
            if (parts.isEmpty())
                continue;
            m_words[py] += parts;
            for (int n = 1; n <= py.size(); ++n) {
                const QString pref = py.left(n);
                m_prefixes.insert(pref);
                QStringList &keys = m_wordPrefixKeys[pref];
                if (keys.size() < 48 && !keys.contains(py))
                    keys.append(py);
            }
        } else {
            m_chars.insert(py, rhs);
            for (int n = 1; n <= py.size(); ++n)
                m_prefixes.insert(py.left(n));
        }
    }
}

bool PinyinLexicon::valid(const QString &buf) const
{
    if (buf.isEmpty())
        return true;
    if (m_prefixes.contains(buf) || m_chars.contains(buf) || m_words.contains(buf))
        return true;
    const QString syl = firstSyllable(buf);
    if (syl.isEmpty() || syl.size() >= buf.size())
        return false;
    return valid(buf.mid(syl.size()));
}

QString PinyinLexicon::firstSyllable(const QString &buf) const
{
    const int maxn = qMin(buf.size(), 6);
    for (int n = maxn; n >= 1; --n) {
        if (m_chars.contains(buf.left(n)))
            return buf.left(n);
    }
    return {};
}

bool PinyinLexicon::canAppend(const QString &buf, QChar letter) const
{
    if (!letter.isLetter())
        return false;
    return valid(buf + letter.toLower());
}

QStringList PinyinLexicon::lookup(const QString &buf) const
{
    QStringList out;
    if (buf.isEmpty())
        return out;

    auto appendUnique = [&out](const QString &s) {
        if (!s.isEmpty() && !out.contains(s))
            out.append(s);
    };

    // Exact phrase hits first.
    const auto exact = m_words.constFind(buf);
    if (exact != m_words.cend()) {
        for (const QString &w : exact.value())
            appendUnique(w);
    }

    // Prefix phrase hits (typed "niha" → 你好 for nihao). Prefer shorter keys, then order in file.
    const auto pref = m_wordPrefixKeys.constFind(buf);
    if (pref != m_wordPrefixKeys.cend()) {
        QStringList keys = pref.value();
        std::sort(keys.begin(), keys.end(), [](const QString &a, const QString &b) {
            if (a.size() != b.size())
                return a.size() < b.size();
            return a < b;
        });
        for (const QString &key : keys) {
            if (out.size() >= 24)
                break;
            for (const QString &w : m_words.value(key)) {
                appendUnique(w);
                if (out.size() >= 24)
                    break;
            }
        }
    }

    // Also: buf longer than a word key (nihaoma → 你好 + …) — longest matching word key.
    for (int n = buf.size() - 1; n >= 2; --n) {
        const QString head = buf.left(n);
        const auto hit = m_words.constFind(head);
        if (hit == m_words.cend())
            continue;
        for (const QString &w : hit.value())
            appendUnique(w);
        break;
    }

    const QString syl = firstSyllable(buf);
    if (!syl.isEmpty()) {
        const QString chars = m_chars.value(syl);
        for (const QChar &c : chars)
            appendUnique(QString(c));
    }
    return out;
}

int PinyinLexicon::consumeLength(const QString &buf, const QString &picked) const
{
    if (buf.isEmpty() || picked.isEmpty())
        return 0;

    if (picked.size() == 1) {
        const QString syl = firstSyllable(buf);
        return qMax(1, int(syl.size()));
    }

    auto keyHas = [this, &picked](const QString &key) {
        return m_words.value(key).contains(picked);
    };

    if (keyHas(buf))
        return int(buf.size());

    // Prefix of a longer key (niha → nihao): consume what was typed.
    const auto pref = m_wordPrefixKeys.constFind(buf);
    if (pref != m_wordPrefixKeys.cend()) {
        for (const QString &key : pref.value()) {
            if (keyHas(key))
                return int(buf.size());
        }
    }

    // Longest word key that is a prefix of buf.
    for (int n = buf.size(); n >= 2; --n) {
        const QString head = buf.left(n);
        if (keyHas(head))
            return n;
    }

    return int(buf.size());
}
