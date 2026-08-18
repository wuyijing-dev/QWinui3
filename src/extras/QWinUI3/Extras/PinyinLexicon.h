#pragma once

#include <QHash>
#include <QSet>
#include <QString>
#include <QStringList>

// Compact MIT tables from mozillazg/pinyin-data + phrase-pinyin-data.
struct OskPinyinGroupedLookup
{
    QStringList single;
    QStringList doubleChar;
    QStringList phrase;
    QStringList all() const;
};

class PinyinLexicon
{
public:
    static PinyinLexicon &instance();

    QStringList lookup(const QString &buf) const;
    OskPinyinGroupedLookup lookupGrouped(const QString &buf) const;
    QString firstSyllable(const QString &buf) const;
    bool canAppend(const QString &buf, QChar letter) const;
    // How many romanization chars to consume when `picked` is chosen for `buf`.
    int consumeLength(const QString &buf, const QString &picked) const;

private:
    PinyinLexicon();
    void loadFile(const QString &path, bool words);
    bool valid(const QString &buf) const;

    QHash<QString, QString> m_chars;
    QHash<QString, QStringList> m_words;
    QHash<QString, QStringList> m_wordPrefixKeys; // buf prefix → full pinyin keys
    QSet<QString> m_prefixes;
};
