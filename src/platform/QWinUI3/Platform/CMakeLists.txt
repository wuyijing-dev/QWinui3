qt_add_library(qwinui3_platform STATIC)

find_package(Qt6 COMPONENTS DBus QUIET)

set(QWINUI3_PLATFORM_SOURCES
    WindowHelper.cpp
    FilePicker.cpp
    TrayIcon.cpp
    LinuxPortal.cpp
)

if(WIN32)
    list(APPEND QWINUI3_PLATFORM_SOURCES WindowHelper_win.cpp)
    set(QWINUI3_PLATFORM_LIBS dwmapi user32 ole32 shell32 wininet)
elseif(UNIX AND NOT APPLE)
    list(APPEND QWINUI3_PLATFORM_SOURCES WindowHelper_linux.cpp)
else()
    list(APPEND QWINUI3_PLATFORM_SOURCES WindowHelper_other.cpp)
endif()

qt_add_qml_module(qwinui3_platform
    URI QWinUI3.Platform
    VERSION 1.0
    SOURCES
        WindowHelper.h
        FilePicker.h
        TrayIcon.h
        ${QWINUI3_PLATFORM_SOURCES}
    QML_FILES
        PlatformTitleBar.qml
        CaptionButton.qml
        WindowResizeBorder.qml
        StandardWindow.qml
        DialogWindow.qml
        ToolWindow.qml
        CompactOverlayWindow.qml
    IMPORTS
        TARGET qwinui3_theme
)

target_link_libraries(qwinui3_platform
    PUBLIC
        Qt6::Quick
        Qt6::QuickControls2
        qwinui3_theme
    PRIVATE
        ${QWINUI3_PLATFORM_LIBS}
)

if(TARGET Qt6::DBus AND UNIX AND NOT APPLE)
    target_link_libraries(qwinui3_platform PRIVATE Qt6::DBus)
    target_compile_definitions(qwinui3_platform PRIVATE QWINUI3_HAS_DBUS=1)
endif()

target_include_directories(qwinui3_platform
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
)
