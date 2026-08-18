#include "OskUserLexicon.h"

#include <QCollator>
#include <QSettings>
#include <algorithm>

OskUserLexicon &OskUserLexicon::instance()
{
    static OskUserLexicon lex;
    return lex;
}

OskUserLexicon::OskUserLexicon()
{
    QSettings s(QStringLiteral("QWinUI3"), QStringLiteral("OskUserLexicon"));
    const int n = s.beginReadArray(QStringLiteral("entries"));
    for (int i = 0; i < n; ++i) {
        s.setArrayIndex(i);
        const QString k = s.value(QStringLiteral("key")).toString();
        const int score = s.value(QStringLiteral("score")).toInt();
        if (!k.isEmpty() && score > 0)
            m_scores.insert(k, score);
    }
    s.endArray();
}

QString OskUserLexicon::keyFor(const QString &pinyinBuf, const QString &word) const
{
    return pinyinBuf.toLower() + QLatin1Char('\t') + word;
}

void OskUserLexicon::recordPick(const QString &pinyinBuf, const QString &word)
{
    if (pinyinBuf.isEmpty() || word.isEmpty())
        return;
    const QString k = keyFor(pinyinBuf, word);
    m_scores[k] = m_scores.value(k, 0) + 1;

    QSettings s(QStringLiteral("QWinUI3"), QStringLiteral("OskUserLexicon"));
    s.beginWriteArray(QStringLiteral("entries"));
    int i = 0;
    for (auto it = m_scores.cbegin(); it != m_scores.cend(); ++it, ++i) {
        s.setArrayIndex(i);
        s.setValue(QStringLiteral("key"), it.key());
        s.setValue(QStringLiteral("score"), it.value());
    }
    s.endArray();
}

void OskUserLexicon::boost(QStringList *candidates, const QString &pinyinBuf) const
{
    if (!candidates || candidates->isEmpty() || pinyinBuf.isEmpty())
        return;
    QStringList ordered = *candidates;
    std::stable_sort(ordered.begin(), ordered.end(), [&](const QString &a, const QString &b) {
        const int sa = m_scores.value(keyFor(pinyinBuf, a), 0);
        const int sb = m_scores.value(keyFor(pinyinBuf, b), 0);
        if (sa != sb)
            return sa > sb;
        return candidates->indexOf(a) < candidates->indexOf(b);
    });
    *candidates = ordered;
}

void OskUserLexicon::clear()
{
    m_scores.clear();
    QSettings s(QStringLiteral("QWinUI3"), QStringLiteral("OskUserLexicon"));
    s.remove(QStringLiteral("entries"));
}
