#pragma once

#include <QHash>
#include <QSet>
#include <QString>
#include <QStringList>

// Compact MIT tables from mozillazg/pinyin-data + phrase-pinyin-data.
class PinyinLexicon
{
public:
    static PinyinLexicon &instance();

    QStringList lookup(const QString &buf) const;
    QString firstSyllable(const QString &buf) const;
    bool canAppend(const QString &buf, QChar letter) const;

private:
    PinyinLexicon();
    void loadFile(const QString &path, bool words);
    bool valid(const QString &buf) const;

    QHash<QString, QString> m_chars;
    QHash<QString, QStringList> m_words;
    QSet<QString> m_prefixes;
};
