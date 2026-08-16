#pragma once

#include "QtCompatVersion.h"

// Effects capability for C++ / docs. QML falls back via CMake-selected
// ElevatedChrome implementation (see Theme/CMakeLists.txt).

namespace QWinUI3::Compat::Effects {

inline constexpr bool available() noexcept
{
    return QWINUI3_HAVE_QUICK_EFFECTS != 0;
}

} // namespace QWinUI3::Compat::Effects
