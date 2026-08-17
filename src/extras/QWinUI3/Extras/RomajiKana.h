#pragma once

#include <QString>
#include <QStringList>

// Longest-match Hepburn romaji → kana. Mapping table, not a word lexicon.
namespace RomajiKana {

QString toHiragana(const QString &romaji, QString *rest = nullptr, bool finalize = false);
QString toKatakana(const QString &hiragana);
QStringList candidates(const QString &romaji);

} // namespace RomajiKana
