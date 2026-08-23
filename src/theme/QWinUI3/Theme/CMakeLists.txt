set_source_files_properties(Theme.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)
set_source_files_properties(IconSource.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

# ElevatedChrome: MultiEffect when QtQuick.Effects is linked; otherwise Simple.
if(QWINUI3_HAVE_QUICK_EFFECTS)
    set(QWINUI3_ELEVATED_CHROME_QML ElevatedChrome.qml)
else()
    set(QWINUI3_ELEVATED_CHROME_QML ${CMAKE_CURRENT_BINARY_DIR}/ElevatedChrome.qml)
    configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/ElevatedChrome_Simple.qml
        ${QWINUI3_ELEVATED_CHROME_QML}
        COPYONLY
    )
    set_source_files_properties(${QWINUI3_ELEVATED_CHROME_QML} PROPERTIES
        QT_RESOURCE_ALIAS "ElevatedChrome.qml"
    )
    message(STATUS "QWinUI3.Theme: ElevatedChrome without QtQuick.Effects (simple fallback)")
endif()

qt_add_library(qwinui3_theme ${QWINUI3_LIB_TYPE})

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
        ${QWINUI3_ELEVATED_CHROME_QML}
        FocusStroke.qml
        PointerCursor.qml
        IconSource.qml
    RESOURCES
        fonts/WinSymbols3.ttf
)

target_link_libraries(qwinui3_theme
    PUBLIC
        qwinui3_qtcompat
        Qt6::Quick
        Qt6::Qml
)

target_include_directories(qwinui3_theme
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
)

# ElevatedChrome uses QtQuick.Effects (MultiEffect) at QML import time.
# Link public C++ target only when available (Private is runtime-loaded via QML).
if(QWINUI3_HAVE_QUICK_EFFECTS AND TARGET Qt6::QuickEffects)
    target_link_libraries(qwinui3_theme PUBLIC Qt6::QuickEffects)
endif()
