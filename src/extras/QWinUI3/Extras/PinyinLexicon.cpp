#include "PinyinLexicon.h"

#include <QFile>

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
            if (!parts.isEmpty())
                m_words[py] += parts;
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
    const auto words = m_words.constFind(buf);
    if (words != m_words.cend()) {
        for (const QString &w : words.value()) {
            if (!out.contains(w))
                out.append(w);
        }
    }
    const QString syl = firstSyllable(buf);
    if (!syl.isEmpty()) {
        const QString chars = m_chars.value(syl);
        for (const QChar &c : chars) {
            const QString s(c);
            if (!out.contains(s))
                out.append(s);
        }
    }
    return out;
}
