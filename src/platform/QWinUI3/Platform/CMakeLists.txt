qt_add_library(qwinui3_platform STATIC)

set(QWINUI3_PLATFORM_SOURCES
    WindowHelper.cpp
)

if(WIN32)
    list(APPEND QWINUI3_PLATFORM_SOURCES WindowHelper_win.cpp)
    set(QWINUI3_PLATFORM_LIBS dwmapi user32)
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

target_include_directories(qwinui3_platform
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
)
