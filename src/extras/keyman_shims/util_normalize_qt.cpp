// Qt NFC/NFD stand-in for Keyman Core util_normalize.cpp (native KMN_NO_ICU).
// SIL Keyman Core is MIT; this shim is Apache-2.0 (this repo).

#include "util_normalize.hpp"

#include <QList>
#include <QString>

namespace km {
namespace core {
namespace util {

namespace {

QString from32(const std::u32string &str)
{
    if (str.empty())
        return {};
    return QString::fromUcs4(reinterpret_cast<const char32_t *>(str.data()), qsizetype(str.size()));
}

std::u32string to32(const QString &str)
{
    const QList<uint> ucs = str.toUcs4();
    std::u32string out;
    out.reserve(size_t(ucs.size()));
    for (uint u : ucs)
        out.push_back(char32_t(u));
    return out;
}

QString from16(const std::u16string &str)
{
    return QString::fromUtf16(reinterpret_cast<const char16_t *>(str.data()), qsizetype(str.size()));
}

std::u16string to16(const QString &str)
{
    const char16_t *p = reinterpret_cast<const char16_t *>(str.utf16());
    return std::u16string(p, size_t(str.size()));
}

} // namespace

bool normalize_nfc(std::u32string &str)
{
    str = to32(from32(str).normalized(QString::NormalizationForm_C));
    return true;
}

bool normalize_nfc(std::u16string &str)
{
    str = to16(from16(str).normalized(QString::NormalizationForm_C));
    return true;
}

bool normalize_nfd(std::u32string &str)
{
    str = to32(from32(str).normalized(QString::NormalizationForm_D));
    return true;
}

bool normalize_nfd(std::u16string &str)
{
    str = to16(from16(str).normalized(QString::NormalizationForm_D));
    return true;
}

bool normalize_nfd(km_core_cu const *src, std::u16string &dst)
{
    if (!src)
        return false;
    dst = to16(QString::fromUtf16(src).normalized(QString::NormalizationForm_D));
    return true;
}

bool normalize_nfd(km_core_usv cp, std::u32string &dst)
{
    const QString s = QString::fromUcs4(&cp, 1);
    const QString n = s.normalized(QString::NormalizationForm_D);
    if (n == s)
        return false;
    dst = to32(n);
    return true;
}

bool is_nfd(const std::u16string &str)
{
    return from16(str).normalized(QString::NormalizationForm_D) == from16(str);
}

bool is_nfd(const std::u32string &str)
{
    return from32(str).normalized(QString::NormalizationForm_D) == from32(str);
}

bool has_nfc_boundary_before(km_core_usv cp)
{
    if (cp > 0x10FFFFu)
        return true;
    return QChar::combiningClass(char32_t(cp)) == 0;
}

km_core_usv *string_to_usv(const std::u32string &src)
{
    auto *buf = new km_core_usv[src.size() + 1];
    for (size_t i = 0; i < src.size(); ++i)
        buf[i] = src[i];
    buf[src.size()] = 0;
    return buf;
}

} // namespace util
} // namespace core
} // namespace km
