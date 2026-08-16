# Qt multi-version compatibility helpers (header + thin RHI shim).
# Linked by theme / platform / style / extras / gallery.

add_library(qwinui3_qtcompat STATIC
    QtCompatRhi.cpp
)

add_library(QWinUI3::Compat ALIAS qwinui3_qtcompat)

target_include_directories(qwinui3_qtcompat
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/../..
)

target_link_libraries(qwinui3_qtcompat
    PUBLIC
        Qt6::Quick
        Qt6::Gui
)

if(QWINUI3_HAVE_QUICK_EFFECTS)
    target_compile_definitions(qwinui3_qtcompat PUBLIC QWINUI3_HAVE_QUICK_EFFECTS=1)
else()
    target_compile_definitions(qwinui3_qtcompat PUBLIC QWINUI3_HAVE_QUICK_EFFECTS=0)
endif()
if(QWINUI3_HAVE_RHI_D3D12)
    target_compile_definitions(qwinui3_qtcompat PUBLIC QWINUI3_HAVE_RHI_D3D12=1)
else()
    target_compile_definitions(qwinui3_qtcompat PUBLIC QWINUI3_HAVE_RHI_D3D12=0)
endif()

set_target_properties(qwinui3_qtcompat PROPERTIES
    AUTOMOC OFF
    AUTORCC OFF
    AUTOUIC OFF
)
