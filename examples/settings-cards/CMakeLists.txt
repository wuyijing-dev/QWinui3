qt_add_executable(qwinui3_example_settings
    main.cpp
)

qt_add_qml_module(qwinui3_example_settings
    URI QWinUI3.Examples.SettingsCards
    VERSION 1.0
    QML_FILES
        Main.qml
    IMPORTS
        TARGET qwinui3_theme
        TARGET qwinui3_extras
        TARGET qwinui3_platform
)

target_link_libraries(qwinui3_example_settings
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
)
qwinui3_link_qml_import_set(qwinui3_example_settings shell)

include(${CMAKE_SOURCE_DIR}/cmake/StripRestrictedQtModules.cmake)
qwinui3_strip_restricted_qt_modules(qwinui3_example_settings)

set_target_properties(qwinui3_example_settings PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
)
