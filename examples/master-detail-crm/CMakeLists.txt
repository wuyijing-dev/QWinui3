qt_add_executable(qwinui3_example_master_detail_crm
    main.cpp
)

qt_add_qml_module(qwinui3_example_master_detail_crm
    URI QWinUI3.Examples.MasterDetailCrm
    VERSION 1.0
    QML_FILES
        Main.qml
    IMPORTS
        TARGET qwinui3_theme
        TARGET qwinui3_extras
        TARGET qwinui3_platform
)

target_link_libraries(qwinui3_example_master_detail_crm
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
)
qwinui3_link_qml_import_set(qwinui3_example_master_detail_crm shell)

include(${CMAKE_SOURCE_DIR}/cmake/StripRestrictedQtModules.cmake)
qwinui3_strip_restricted_qt_modules(qwinui3_example_master_detail_crm)

set_target_properties(qwinui3_example_master_detail_crm PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
)
