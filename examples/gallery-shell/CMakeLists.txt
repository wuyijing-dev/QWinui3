qt_add_executable(qwinui3_example_gallery_shell
    main.cpp
)

find_package(Qt6 REQUIRED COMPONENTS LinguistTools)

qt_add_translations(qwinui3_example_gallery_shell
    TS_FILES
        translations/qwinui3_gallery_shell_en.ts
        translations/qwinui3_gallery_shell_ko_KR.ts
    RESOURCE_PREFIX "/i18n"
)

qt_add_qml_module(qwinui3_example_gallery_shell
    URI QWinUI3.Examples.GalleryShell
    VERSION 1.0
    QML_FILES
        Main.qml
        HomePage.qml
        SettingsPage.qml
    IMPORTS
        TARGET qwinui3_theme
        TARGET qwinui3_extras
        TARGET qwinui3_platform
)

target_link_libraries(qwinui3_example_gallery_shell
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
)
qwinui3_link_qml_import_set(qwinui3_example_gallery_shell shell)

include(${CMAKE_SOURCE_DIR}/cmake/StripRestrictedQtModules.cmake)
qwinui3_strip_restricted_qt_modules(qwinui3_example_gallery_shell)

set_target_properties(qwinui3_example_gallery_shell PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
)
