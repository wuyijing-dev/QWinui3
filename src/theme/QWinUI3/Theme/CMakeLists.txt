set_source_files_properties(Theme.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)
set_source_files_properties(IconSource.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

qt_add_library(qwinui3_theme STATIC)

qt_add_qml_module(qwinui3_theme
    URI QWinUI3.Theme
    VERSION 1.0
    SOURCES
        FluentIcons.h
        FluentIcons.cpp
        FluentIconsCatalog.h
        FluentIconsCatalog.cpp
        ThemeFonts.h
        ThemeFonts.cpp
    QML_FILES
        Theme.qml
        ElevatedChrome.qml
        IconSource.qml
    RESOURCES
        fonts/WinSymbols3.ttf
)

target_link_libraries(qwinui3_theme
    PUBLIC
        Qt6::Quick
        Qt6::Qml
)

target_include_directories(qwinui3_theme
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
)

# ElevatedChrome uses QtQuick.Effects (MultiEffect). find_package is in root
# CMakeLists.txt so dependent executables can see Qt6::QuickEffects.
if(TARGET Qt6::QuickEffects)
    target_link_libraries(qwinui3_theme PUBLIC Qt6::QuickEffects)
endif()
