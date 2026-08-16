qt_add_executable(qwinui3_example_nav
    main.cpp
)

qt_add_qml_module(qwinui3_example_nav
    URI QWinUI3.Examples.NavSettings
    VERSION 1.0
    QML_FILES
        Main.qml
        HomePage.qml
        AboutPage.qml
        SettingsPage.qml
    IMPORTS
        TARGET qwinui3_theme
        TARGET qwinui3_extras
        TARGET qwinui3_platform
)

target_link_libraries(qwinui3_example_nav
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
        qwinui3_theme
        qwinui3_themeplugin
        qwinui3_style
        qwinui3_styleplugin
        qwinui3_extras
        qwinui3_extrasplugin
        qwinui3_platform
        qwinui3_platformplugin
)

include(${CMAKE_SOURCE_DIR}/cmake/StripRestrictedQtModules.cmake)
qwinui3_strip_restricted_qt_modules(qwinui3_example_nav)

set_target_properties(qwinui3_example_nav PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
)
