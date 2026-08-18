#pragma once

#include <QHash>
#include <QString>
#include <QStringList>

// Local user word-frequency for pinyin OSK (no cloud). Stored in QSettings.
class OskUserLexicon
{
public:
    static OskUserLexicon &instance();

    void recordPick(const QString &pinyinBuf, const QString &word);
    void boost(QStringList *candidates, const QString &pinyinBuf) const;
    void clear();

private:
    OskUserLexicon();
    QString keyFor(const QString &pinyinBuf, const QString &word) const;

    QHash<QString, int> m_scores;
};
