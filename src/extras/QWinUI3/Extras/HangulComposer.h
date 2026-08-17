#pragma once

#include <QChar>
#include <QString>

// 2-beolsik hangul compositor (Unicode syllable algorithm, not a lexicon).
// Shift (not Caps) doubles ㅂㅈㄷㄱㅅ / ㅐㅔ. Backspace peels compound vowels/finals.
class HangulComposer
{
public:
    QString preedit() const;
    QString feedVk(int vk, bool shift);
    QString backspace();
    QString flush();
    void reset();
    static QChar jamoFromVk(int vk, bool shift);

private:
    QString syllable() const;
    void clear();

    int m_l = -1;
    int m_v = -1;
    int m_t = 0;
};
