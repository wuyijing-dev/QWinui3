qt_add_library(qwinui3_platform ${QWINUI3_LIB_TYPE})

# WindowShellDecoration: MultiEffect when QtQuick.Effects is linked; otherwise Simple.
if(QWINUI3_HAVE_QUICK_EFFECTS)
    set(QWINUI3_SHELL_DECORATION_QML WindowShellDecoration.qml)
else()
    set(QWINUI3_SHELL_DECORATION_QML ${CMAKE_CURRENT_BINARY_DIR}/WindowShellDecoration.qml)
    configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/WindowShellDecoration_Simple.qml
        ${QWINUI3_SHELL_DECORATION_QML}
        COPYONLY
    )
    set_source_files_properties(${QWINUI3_SHELL_DECORATION_QML} PROPERTIES
        QT_RESOURCE_ALIAS "WindowShellDecoration.qml"
    )
    message(STATUS "QWinUI3.Platform: WindowShellDecoration without QtQuick.Effects (simple fallback)")
endif()

find_package(Qt6 REQUIRED COMPONENTS Network)
find_package(Qt6 COMPONENTS DBus QUIET)

include(${CMAKE_SOURCE_DIR}/cmake/FindWebView2.cmake)
set(QWINUI3_HAS_WEBVIEW2 OFF)
set(QWINUI3_WEBVIEW2_SOURCES WebView2Host.cpp)
if(WIN32 AND QWINUI3_BUILD_WEBVIEW2)
    qwinui3_find_webview2()
    if(QWINUI3_WEBVIEW2_FOUND)
        set(QWINUI3_HAS_WEBVIEW2 ON)
        set(QWINUI3_WEBVIEW2_DLL "${QWINUI3_WEBVIEW2_DLL}" PARENT_SCOPE)
        message(STATUS "QWinUI3: WebView2Host enabled")
    else()
        message(WARNING "QWINUI3_BUILD_WEBVIEW2=ON but SDK not found. Run scripts/fetch_webview2.ps1")
    endif()
endif()
set(QWINUI3_HAS_WEBVIEW2 ${QWINUI3_HAS_WEBVIEW2} PARENT_SCOPE)

set(QWINUI3_PLATFORM_SOURCES
    WindowHelper.cpp
    FilePicker.cpp
    TrayIcon.cpp
    LinuxPortal.cpp
    Bootstrap.cpp
    WelcomeBanner.cpp
    SingleInstance.cpp
    ${QWINUI3_WEBVIEW2_SOURCES}
)

if(WIN32)
    list(APPEND QWINUI3_PLATFORM_SOURCES WindowHelper_win.cpp)
    set(QWINUI3_PLATFORM_LIBS dwmapi user32 ole32 shell32 wininet)
elseif(UNIX AND NOT APPLE)
    list(APPEND QWINUI3_PLATFORM_SOURCES WindowHelper_linux.cpp)
    if(TARGET Qt6::DBus)
        list(APPEND QWINUI3_PLATFORM_SOURCES StatusNotifierItem.cpp)
    endif()
else()
    list(APPEND QWINUI3_PLATFORM_SOURCES WindowHelper_other.cpp)
endif()

set_source_files_properties(PlatformCapability.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(qwinui3_platform
    URI QWinUI3.Platform
    VERSION 1.0
    SOURCES
        WindowHelper.h
        FilePicker.h
        TrayIcon.h
        Bootstrap.h
        SingleInstance.h
        FrameStatsMonitor.h
        ${QWINUI3_PLATFORM_SOURCES}
        FrameStatsMonitor.cpp
    QML_FILES
        PlatformCapability.qml
        PlatformTitleBar.qml
        CaptionButton.qml
        WindowResizeBorder.qml
        ThemeSync.qml
        StandardWindow.qml
        DialogWindow.qml
        ToolWindow.qml
        CompactOverlayWindow.qml
        FrameStatsBadge.qml
        FrameStatsOverlay.qml
        ${QWINUI3_SHELL_DECORATION_QML}
        WindowShellContentClip.qml
    IMPORTS
        TARGET qwinui3_theme
)

target_link_libraries(qwinui3_platform
    PUBLIC
        Qt6::Quick
        Qt6::QuickControls2
        Qt6::Network
        qwinui3_theme
        qwinui3_qtcompat
    PRIVATE
        ${QWINUI3_PLATFORM_LIBS}
)

if(QWINUI3_HAVE_QUICK_EFFECTS AND TARGET Qt6::QuickEffects)
    target_link_libraries(qwinui3_platform PUBLIC Qt6::QuickEffects)
endif()

if(QWINUI3_HAS_WEBVIEW2)
    target_compile_definitions(qwinui3_platform PUBLIC QWINUI3_HAS_WEBVIEW2=1)
    target_link_libraries(qwinui3_platform PRIVATE qwinui3_webview2_loader)
endif()

if(TARGET Qt6::DBus AND UNIX AND NOT APPLE)
    target_link_libraries(qwinui3_platform PRIVATE Qt6::DBus)
    target_compile_definitions(qwinui3_platform PRIVATE QWINUI3_HAS_DBUS=1)
endif()

# Optional: Qt Gui private headers expose portalWindowIdentifier (xdg-foreign) on Wayland.
# Distros without qt*-private-dev keep the native-resource fallback in LinuxPortal.cpp.
if(UNIX AND NOT APPLE)
    find_package(Qt6 COMPONENTS GuiPrivate QUIET)
    if(TARGET Qt6::GuiPrivate)
        target_link_libraries(qwinui3_platform PRIVATE Qt6::GuiPrivate)
        target_compile_definitions(qwinui3_platform PRIVATE QWINUI3_HAS_GUI_PRIVATE=1)
        message(STATUS "QWinUI3: GuiPrivate enabled for Wayland portal parent_window")
    endif()
endif()

target_include_directories(qwinui3_platform
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
)

target_compile_definitions(qwinui3_platform
    PRIVATE
        "QWINUI3_VERSION_STRING=\"${QWINUI3_VERSION}\""
)

# --- QWinUI3.Platform.WebView2 (3.35 S12) — not imported by StandardWindow ---
qt_add_library(qwinui3_platform_webview2 ${QWINUI3_LIB_TYPE})
get_target_property(_qwinui3_platform_qml_out qwinui3_platform QT_QML_MODULE_OUTPUT_DIRECTORY)
if(NOT _qwinui3_platform_qml_out)
    set(_qwinui3_platform_qml_out "${CMAKE_CURRENT_BINARY_DIR}")
endif()

qt_add_qml_module(qwinui3_platform_webview2
    URI QWinUI3.Platform.WebView2
    VERSION 1.0
    OUTPUT_DIRECTORY "${_qwinui3_platform_qml_out}/WebView2"
    SOURCES
        WebView2Host_qml.h
    IMPORTS
        TARGET qwinui3_platform
)

target_link_libraries(qwinui3_platform_webview2
    PUBLIC
        Qt6::Quick
        qwinui3_platform
)
