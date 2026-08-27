# QWinUI3 QML import sets (3.36 S13)
#
#   shell     Theme + Style + Extras (nav/shell) + Platform — default apps
#   charts    shell + QWinUI3.Extras.Charts
#   osk       shell + QWinUI3.Extras.Osk
#   gallery   shell + Charts + Osk + Platform.WebView2 (control catalog)
#
# Call after the qwinui3_* targets exist. Still list matching TARGET entries on
# qt_add_qml_module(IMPORTS …) so qmlimportscanner sees the extra modules.
#
#   target_link_libraries(myapp PRIVATE Qt6::Quick Qt6::QuickControls2)
#   qwinui3_link_qml_import_set(myapp shell)

function(qwinui3_link_qml_import_set target import_set)
    if(NOT TARGET "${target}")
        message(FATAL_ERROR "qwinui3_link_qml_import_set: unknown target '${target}'")
    endif()
    string(TOLOWER "${import_set}" _set)

    set(_libs
        qwinui3_theme
        qwinui3_style
        qwinui3_extras
        qwinui3_platform
    )
    set(_plugins
        qwinui3_themeplugin
        qwinui3_styleplugin
        qwinui3_extrasplugin
        qwinui3_platformplugin
    )

    if(_set STREQUAL "charts" OR _set STREQUAL "gallery")
        list(APPEND _libs qwinui3_extras_charts)
        list(APPEND _plugins qwinui3_extras_chartsplugin)
    endif()
    if(_set STREQUAL "osk" OR _set STREQUAL "gallery")
        list(APPEND _libs qwinui3_extras_osk)
        list(APPEND _plugins qwinui3_extras_oskplugin)
    endif()
    if(_set STREQUAL "gallery")
        list(APPEND _libs qwinui3_platform_webview2)
        list(APPEND _plugins qwinui3_platform_webview2plugin)
    elseif(_set STREQUAL "webview2")
        list(APPEND _libs qwinui3_platform_webview2)
        list(APPEND _plugins qwinui3_platform_webview2plugin)
    elseif(NOT _set STREQUAL "shell" AND NOT _set STREQUAL "charts" AND NOT _set STREQUAL "osk")
        message(FATAL_ERROR
            "qwinui3_link_qml_import_set: unknown set '${import_set}' "
            "(shell|charts|osk|webview2|gallery)")
    endif()

    target_link_libraries("${target}" PRIVATE ${_libs})
    if(NOT QWINUI3_BUILD_SHARED)
        target_link_libraries("${target}" PRIVATE ${_plugins})
    endif()
endfunction()
