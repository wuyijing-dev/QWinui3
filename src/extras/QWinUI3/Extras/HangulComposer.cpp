#include "HangulComposer.h"

namespace {

constexpr int kSBase = 0xAC00;
constexpr int kVCount = 21;
constexpr int kTCount = 28;

struct KeyJamo {
    int l = -1;
    int v = -1;
    int t = 0;
};

KeyJamo keyJamo(int vk, bool shift)
{
    switch (vk) {
    case 81: return shift ? KeyJamo{8, -1, 0} : KeyJamo{7, -1, 17};   // ㅃ / ㅂ
    case 87: return shift ? KeyJamo{13, -1, 0} : KeyJamo{12, -1, 22};  // ㅉ / ㅈ
    case 69: return shift ? KeyJamo{4, -1, 0} : KeyJamo{3, -1, 7};     // ㄸ / ㄷ
    case 82: return shift ? KeyJamo{1, -1, 2} : KeyJamo{0, -1, 1};     // ㄲ / ㄱ
    case 84: return shift ? KeyJamo{10, -1, 20} : KeyJamo{9, -1, 19};  // ㅆ / ㅅ
    case 89: return {-1, 12, 0}; // ㅛ
    case 85: return {-1, 6, 0};  // ㅕ
    case 73: return {-1, 2, 0};  // ㅑ
    case 79: return shift ? KeyJamo{-1, 3, 0} : KeyJamo{-1, 1, 0}; // ㅒ / ㅐ
    case 80: return shift ? KeyJamo{-1, 7, 0} : KeyJamo{-1, 5, 0}; // ㅖ / ㅔ
    case 65: return {6, -1, 16}; // ㅁ
    case 83: return {2, -1, 4};  // ㄴ
    case 68: return {11, -1, 21}; // ㅇ
    case 70: return {5, -1, 8};  // ㄹ
    case 71: return {18, -1, 27}; // ㅎ
    case 72: return {-1, 8, 0};  // ㅗ
    case 74: return {-1, 4, 0};  // ㅓ
    case 75: return {-1, 0, 0};  // ㅏ
    case 76: return {-1, 20, 0}; // ㅣ
    case 90: return {15, -1, 24}; // ㅋ
    case 88: return {16, -1, 25}; // ㅌ
    case 67: return {14, -1, 23}; // ㅊ
    case 86: return {17, -1, 26}; // ㅍ
    case 66: return {-1, 16, 0}; // ㅠ
    case 78: return {-1, 13, 0}; // ㅜ
    case 77: return {-1, 18, 0}; // ㅡ
    default: return {};
    }
}

int combineV(int v, int add)
{
    if (v == 8 && add == 0)
        return 9;
    if (v == 8 && add == 1)
        return 10;
    if (v == 8 && add == 20)
        return 11;
    if (v == 13 && add == 4)
        return 14;
    if (v == 13 && add == 5)
        return 15;
    if (v == 13 && add == 20)
        return 16;
    if (v == 18 && add == 20)
        return 19;
    return -1;
}

int combineT(int t, int addT)
{
    if (t == 1 && addT == 19)
        return 3;
    if (t == 4 && addT == 22)
        return 5;
    if (t == 4 && addT == 27)
        return 6;
    if (t == 8 && addT == 1)
        return 9;
    if (t == 8 && addT == 16)
        return 10;
    if (t == 8 && addT == 17)
        return 11;
    if (t == 8 && addT == 19)
        return 12;
    if (t == 8 && addT == 25)
        return 13;
    if (t == 8 && addT == 26)
        return 14;
    if (t == 8 && addT == 27)
        return 15;
    if (t == 17 && addT == 19)
        return 18;
    return -1;
}

int tToL(int t)
{
    static const int map[28] = {
        -1, 0, 1, -1, 2, -1, -1, 3, 5, -1, -1, -1, -1, -1, -1, -1,
        6, 7, -1, 9, 10, 11, 12, 14, 15, 16, 17, 18
    };
    if (t <= 0 || t >= 28)
        return -1;
    return map[t];
}

int tTrailL(int t)
{
    switch (t) {
    case 3: return 9;
    case 5: return 12;
    case 6: return 18;
    case 9: return 0;
    case 10: return 6;
    case 11: return 7;
    case 12: return 9;
    case 13: return 16;
    case 14: return 17;
    case 15: return 18;
    case 18: return 9;
    default: return tToL(t);
    }
}

int tLead(int t)
{
    if (t == 3)
        return 1;
    if (t == 5 || t == 6)
        return 4;
    if (t >= 9 && t <= 15)
        return 8;
    if (t == 18)
        return 17;
    return 0;
}

QChar compatGlyph(int l, int v)
{
    if (v < 0 && l >= 0) {
        static const uint16_t Lcompat[] = {
            0x3131, 0x3132, 0x3134, 0x3137, 0x3138, 0x3139, 0x3141, 0x3142,
            0x3143, 0x3145, 0x3146, 0x3147, 0x3148, 0x3149, 0x314A, 0x314B,
            0x314C, 0x314D, 0x314E
        };
        return QChar(Lcompat[l]);
    }
    if (l < 0 && v >= 0) {
        static const uint16_t Vcompat[] = {
            0x314F, 0x3150, 0x3151, 0x3152, 0x3153, 0x3154, 0x3155, 0x3156,
            0x3157, 0x3158, 0x3159, 0x315A, 0x315B, 0x315C, 0x315D, 0x315E,
            0x315F, 0x3160, 0x3161, 0x3162, 0x3163
        };
        return QChar(Vcompat[v]);
    }
    return {};
}

int peelVowel(int v)
{
    // Compound medial → base (ㅘ/ㅙ/ㅚ → ㅗ, ㅝ/ㅞ/ㅟ → ㅜ, ㅢ → ㅡ).
    if (v == 9 || v == 10 || v == 11)
        return 8;
    if (v == 14 || v == 15 || v == 16)
        return 13;
    if (v == 19)
        return 18;
    return -1;
}

} // namespace

QChar HangulComposer::jamoFromVk(int vk, bool shift)
{
    const KeyJamo j = keyJamo(vk, shift);
    if (j.v >= 0)
        return compatGlyph(-1, j.v);
    if (j.l >= 0)
        return compatGlyph(j.l, -1);
    return {};
}

QString HangulComposer::syllable() const
{
    if (m_l < 0) {
        if (m_v >= 0)
            return QString(compatGlyph(-1, m_v));
        return {};
    }
    if (m_v < 0)
        return QString(compatGlyph(m_l, -1));
    return QString(QChar(kSBase + (m_l * kVCount + m_v) * kTCount + m_t));
}

QString HangulComposer::preedit() const
{
    return syllable();
}

void HangulComposer::clear()
{
    m_l = -1;
    m_v = -1;
    m_t = 0;
}

void HangulComposer::reset()
{
    clear();
}

QString HangulComposer::flush()
{
    const QString out = syllable();
    clear();
    return out;
}

QString HangulComposer::backspace()
{
    if (m_t > 0) {
        const int lead = tLead(m_t);
        m_t = lead;
        return {};
    }
    if (m_v >= 0) {
        const int base = peelVowel(m_v);
        m_v = base;
        return {};
    }
    if (m_l >= 0) {
        m_l = -1;
        return {};
    }
    return QStringLiteral("\b");
}

QString HangulComposer::feedVk(int vk, bool shift)
{
    const KeyJamo in = keyJamo(vk, shift);
    if (in.l < 0 && in.v < 0)
        return flush();

    QString committed;

    if (in.v >= 0) {
        if (m_l >= 0 && m_v < 0) {
            m_v = in.v;
            return {};
        }
        if (m_l >= 0 && m_v >= 0 && m_t == 0) {
            const int cv = combineV(m_v, in.v);
            if (cv >= 0) {
                m_v = cv;
                return {};
            }
        }
        if (m_l >= 0 && m_v >= 0 && m_t > 0) {
            const int nl = tTrailL(m_t);
            const int lead = tLead(m_t);
            if (nl >= 0) {
                m_t = lead;
                committed = syllable();
                m_l = nl;
                m_v = in.v;
                m_t = 0;
                return committed;
            }
        }
        committed = flush();
        m_v = in.v;
        return committed;
    }

    if (m_l >= 0 && m_v >= 0 && m_t == 0 && in.t > 0) {
        m_t = in.t;
        return {};
    }
    if (m_l >= 0 && m_v >= 0 && m_t > 0 && in.t > 0) {
        const int ct = combineT(m_t, in.t);
        if (ct >= 0) {
            m_t = ct;
            return {};
        }
    }
    committed = flush();
    m_l = in.l;
    return committed;
}
