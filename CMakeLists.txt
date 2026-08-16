cmake_minimum_required(VERSION 3.16)

# Single-config generators (Ninja/Makefiles): default to Release unless specified.
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS Debug Release RelWithDebInfo MinSizeRel)
endif()

# Help Qt Creator / clangd / VS Code resolve includes from the build tree.
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

project(QWinUI3
    VERSION 1.0.0
    DESCRIPTION "Fluent / WinUI 3 controls for Qt 6.8+ (LGPL-3.0)"
    HOMEPAGE_URL "https://github.com/wuyijing-dev/QWinui3"
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Put executables in the build root (examples + gallery). Qt qml finalizers may
# still write under src/<target>/; gallery also POST_BUILD-copies to here.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")

find_package(Qt6 6.8 REQUIRED COMPONENTS Quick QuickControls2 LabsQmlModels)
find_package(Qt6 COMPONENTS Multimedia QUIET)
# Must be at top-level so example/gallery finalizers see Qt6::QuickEffects
# (theme's ElevatedChrome imports QtQuick.Effects).
find_package(Qt6 COMPONENTS QuickEffects QUIET)

message(STATUS "QWinUI3: Qt ${Qt6_VERSION} (${Qt6_DIR})")

qt_standard_project_setup(REQUIRES 6.8)

option(QWINUI3_BUILD_EXAMPLES "Build copy-ready example apps" ON)
option(QWINUI3_BUILD_SHARED "Build QWinUI3 libraries as shared (DLL/.so) for redistribution" OFF)
if(QWINUI3_BUILD_SHARED)
    set(QWINUI3_LIB_TYPE SHARED)
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

add_subdirectory(src/theme/QWinUI3/Theme)
add_subdirectory(src/platform/QWinUI3/Platform)
add_subdirectory(src/style/QWinUI3)
add_subdirectory(src/extras/QWinUI3/Extras)
add_subdirectory(src/gallery)

if(QWINUI3_BUILD_EXAMPLES)
    add_subdirectory(examples)
endif()
