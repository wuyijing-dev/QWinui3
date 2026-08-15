set_source_files_properties(Theme.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

qt_add_library(qwinui3_theme STATIC)

qt_add_qml_module(qwinui3_theme
    URI QWinUI3.Theme
    VERSION 1.0
    QML_FILES
        Theme.qml
        ElevatedChrome.qml
)

target_link_libraries(qwinui3_theme
    PUBLIC
        Qt6::Quick
)
