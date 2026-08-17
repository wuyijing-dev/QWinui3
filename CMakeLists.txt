cmake_minimum_required(VERSION 3.16)

# Default to Release when the user/tool does not pick a build type.
# Single-config (Ninja/Makefiles): CMAKE_BUILD_TYPE
# Multi-config (Visual Studio/Xcode): CMAKE_DEFAULT_BUILD_TYPE after project()
if(NOT CMAKE_CONFIGURATION_TYPES)
    if(NOT CMAKE_BUILD_TYPE OR CMAKE_BUILD_TYPE STREQUAL "")
        message(STATUS "QWinUI3: CMAKE_BUILD_TYPE not set — defaulting to Release")
        set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the type of build." FORCE)
    endif()
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
        "Debug" "Release" "RelWithDebInfo" "MinSizeRel")
endif()

# Help Qt Creator / clangd / VS Code resolve includes from the build tree.
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Product version is X.YY (two-digit minor), e.g. 1.00, 1.01, 1.10.
# Git tags / packages use v${QWINUI3_VERSION}. CMake needs major.minor.patch.
set(QWINUI3_VERSION "1.59")
if(NOT QWINUI3_VERSION MATCHES "^[0-9]+\\.[0-9][0-9]$")
    message(FATAL_ERROR "QWINUI3_VERSION must be X.YY (two-digit minor), got '${QWINUI3_VERSION}'")
endif()
string(REGEX REPLACE "^([0-9]+)\\.([0-9]+)$" "\\1;\\2" _qwinui3_ver_parts "${QWINUI3_VERSION}")
list(GET _qwinui3_ver_parts 0 _qwinui3_ver_major)
list(GET _qwinui3_ver_parts 1 _qwinui3_ver_yy)
math(EXPR _qwinui3_ver_minor "${_qwinui3_ver_yy}")
set(_qwinui3_cmake_version "${_qwinui3_ver_major}.${_qwinui3_ver_minor}.0")

project(QWinUI3
    VERSION ${_qwinui3_cmake_version}
    DESCRIPTION "Fluent / WinUI 3 controls for Qt 6.5+ (LGPL-3.0); recommended 6.8+"
    HOMEPAGE_URL "https://github.com/wuyijing-dev/QWinui3"
    LANGUAGES CXX
)
message(STATUS "QWinUI3: product version ${QWINUI3_VERSION} (CMake ${PROJECT_VERSION})")
unset(_qwinui3_ver_parts)
unset(_qwinui3_ver_major)
unset(_qwinui3_ver_yy)
unset(_qwinui3_ver_minor)
unset(_qwinui3_cmake_version)

# Multi-config generators ignore CMAKE_BUILD_TYPE; pin the default config to Release
# so `cmake --build` / Qt Creator / VS without an explicit --config use Release.
get_property(_qwinui3_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(_qwinui3_multi_config)
    set(CMAKE_CONFIGURATION_TYPES "Release;RelWithDebInfo;Debug;MinSizeRel"
        CACHE STRING "Available build configurations" FORCE)
    if(NOT CMAKE_DEFAULT_BUILD_TYPE)
        set(CMAKE_DEFAULT_BUILD_TYPE "Release"
            CACHE STRING "Default multi-config build type" FORCE)
    endif()
    set_property(CACHE CMAKE_DEFAULT_BUILD_TYPE PROPERTY STRINGS
        "Release" "RelWithDebInfo" "Debug" "MinSizeRel")
    message(STATUS "QWinUI3: multi-config default = ${CMAKE_DEFAULT_BUILD_TYPE} "
                   "(configs: ${CMAKE_CONFIGURATION_TYPES})")
else()
    message(STATUS "QWinUI3: CMAKE_BUILD_TYPE = ${CMAKE_BUILD_TYPE}")
endif()
unset(_qwinui3_multi_config)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Put executables in the build root (examples + gallery). Qt qml finalizers may
# still write under src/<target>/; gallery also POST_BUILD-copies to here.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")

# Floor: 6.5. Recommended: 6.8 LTS. Forward: 6.10+.
find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2 LabsQmlModels Gui)
find_package(Qt6 COMPONENTS Multimedia QUIET)
# Public target is rare; many kits only ship Qt6QuickEffectsPrivate + QML plugin.
find_package(Qt6 COMPONENTS QuickEffects QUIET)
find_package(Qt6 COMPONENTS QuickEffectsPrivate QUIET)

message(STATUS "QWinUI3: Qt ${Qt6_VERSION} (${Qt6_DIR})")
message(STATUS "QWinUI3: support range = Qt 6.5+ (recommended 6.8 LTS; forward 6.10+)")

# Capability probes (consumed by qwinui3_qtcompat + theme QML selection).
get_filename_component(_qwinui3_qt_prefix "${Qt6_DIR}/../../.." ABSOLUTE)
set(QWINUI3_HAVE_QUICK_EFFECTS OFF)
if(TARGET Qt6::QuickEffects OR TARGET Qt6::QuickEffectsPrivate)
    set(QWINUI3_HAVE_QUICK_EFFECTS ON)
elseif(EXISTS "${_qwinui3_qt_prefix}/qml/QtQuick/Effects/qmldir")
    set(QWINUI3_HAVE_QUICK_EFFECTS ON)
endif()
unset(_qwinui3_qt_prefix)

# Direct3D 12 RHI since Qt 6.6.
if(Qt6_VERSION VERSION_GREATER_EQUAL "6.6.0")
    set(QWINUI3_HAVE_RHI_D3D12 ON)
else()
    set(QWINUI3_HAVE_RHI_D3D12 OFF)
endif()

message(STATUS "QWinUI3: HAVE_QUICK_EFFECTS=${QWINUI3_HAVE_QUICK_EFFECTS} "
               "HAVE_RHI_D3D12=${QWINUI3_HAVE_RHI_D3D12}")

qt_standard_project_setup(REQUIRES 6.5)

# IMPORTS TARGET <cmake-target> must resolve to that target's QML URI (not the
# literal string "TARGET"). OLD broke Gallery qmldir → "No module named QWinUI3.Gallery".
qt_policy(SET QTP0005 NEW)
# gallery/pages/*.qml need subdirectory qmldir with prefer → module root so
# CatalogPage / ControlExample resolve without an explicit (circular) module import.
qt_policy(SET QTP0004 NEW)

option(QWINUI3_BUILD_EXAMPLES "Build copy-ready example apps" ON)
option(QWINUI3_BUILD_SHARED "Build QWinUI3 libraries as shared (DLL/.so) for redistribution" OFF)
if(QWINUI3_BUILD_SHARED)
    set(QWINUI3_LIB_TYPE SHARED)
    # MSVC: export C++ symbols used across qwinui3_* DLLs (e.g. ThemeFonts from platform).
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
else()
    set(QWINUI3_LIB_TYPE STATIC)
endif()
# Ensure subdirs always see a type even if included oddly
if(NOT DEFINED QWINUI3_LIB_TYPE)
    set(QWINUI3_LIB_TYPE STATIC)
endif()
if(TARGET Qt6::Multimedia)
    option(QWINUI3_BUILD_MEDIA "Build MediaPlayerElement (requires Qt Multimedia)" ON)
else()
    option(QWINUI3_BUILD_MEDIA "Build MediaPlayerElement (requires Qt Multimedia)" OFF)
endif()
if(WIN32)
    option(QWINUI3_BUILD_WEBVIEW2 "Build WebView2Host (requires Edge WebView2 Runtime + SDK)" ON)
else()
    option(QWINUI3_BUILD_WEBVIEW2 "Build WebView2Host (requires Edge WebView2 Runtime + SDK)" OFF)
endif()

add_subdirectory(src/compat/QWinUI3/Compat)
add_subdirectory(src/theme/QWinUI3/Theme)
add_subdirectory(src/platform/QWinUI3/Platform)
add_subdirectory(src/style/QWinUI3)
add_subdirectory(src/extras/QWinUI3/Extras)
add_subdirectory(src/gallery)

if(QWINUI3_BUILD_EXAMPLES)
    add_subdirectory(examples)
endif()
