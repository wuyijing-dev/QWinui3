// No-op km_regex for native KMN_NO_ICU (LDML regex needs ICU / WASM JS).
// Basic .kmx layouts do not use this path.

#define KMN_NO_ICU 1
#include "util_regex.hpp"

namespace km {
namespace core {
namespace util {

km_regex::km_regex() = default;
km_regex::km_regex(const km_regex &other) = default;
km_regex::km_regex(const std::u32string &pattern)
    : fPattern(pattern)
{
}
km_regex::~km_regex() = default;

bool km_regex::init(const std::u32string &pattern)
{
    fPattern = pattern;
    return !pattern.empty();
}

bool km_regex::valid() const
{
    return !fPattern.empty();
}

size_t km_regex::apply(const std::u32string &, std::u32string &,
                       const std::u32string &,
                       const std::deque<std::u32string> &,
                       const std::deque<std::u32string> &) const
{
    return 0;
}

int32_t km_regex::findIndex(const std::u32string &match, const std::deque<std::u32string> &list)
{
    int32_t index = 0;
    for (const auto &e : list) {
        if (match == e)
            return index;
        ++index;
    }
    return -1;
}

} // namespace util
} // namespace core
} // namespace km
