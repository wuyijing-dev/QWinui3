qt_add_executable(qwinui3_example_multi_window
    main.cpp
)

qt_add_qml_module(qwinui3_example_multi_window
    URI QWinUI3.Examples.MultiWindow
    VERSION 1.0
    QML_FILES
        Main.qml
    IMPORTS
        TARGET qwinui3_theme
        TARGET qwinui3_extras
        TARGET qwinui3_platform
)

target_link_libraries(qwinui3_example_multi_window
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
        qwinui3_theme
        qwinui3_style
        qwinui3_extras
        qwinui3_platform
)

if(NOT QWINUI3_BUILD_SHARED)
    target_link_libraries(qwinui3_example_multi_window
        PRIVATE
            qwinui3_themeplugin
            qwinui3_styleplugin
            qwinui3_extrasplugin
            qwinui3_platformplugin
    )
endif()

include(${CMAKE_SOURCE_DIR}/cmake/StripRestrictedQtModules.cmake)
qwinui3_strip_restricted_qt_modules(qwinui3_example_multi_window)

set_target_properties(qwinui3_example_multi_window PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
)
