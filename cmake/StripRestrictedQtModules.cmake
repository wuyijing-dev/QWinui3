# Removes Qt add-on modules that are GPL/Commercial (or otherwise restricted)
# and must not ship with LGPL-oriented QWinUI3 deployments.
# Virtual Keyboard is the primary example; extend the lists as needed.
#
# Usage:
#   include(${CMAKE_SOURCE_DIR}/cmake/StripRestrictedQtModules.cmake)
#   qwinui3_strip_restricted_qt_modules(qwinui3_gallery)

function(qwinui3_strip_restricted_qt_modules _target)
    set(_dir "$<TARGET_FILE_DIR:${_target}>")

    # Relative paths under the deploy/runtime directory.
    set(_dirs
        "qml/QtQuick/VirtualKeyboard"
        "qml/QtQuick/Scene2D"
        "qml/QtQuick/Scene3D"
        "qml/QtCharts"
        "qml/QtDataVisualization"
        "qml/QtWebEngine"
        "qml/QtWebView"
        "qml/QtQuick3D"
        "qml/QtGraphs"
    )
    set(_files
        "Qt6VirtualKeyboard.dll"
        "Qt6VirtualKeyboardQml.dll"
        "Qt6Charts.dll"
        "Qt6ChartsQml.dll"
        "Qt6DataVisualization.dll"
        "Qt6DataVisualizationQml.dll"
        "Qt6WebEngineCore.dll"
        "Qt6WebEngineQuick.dll"
        "Qt6WebEngineWidgets.dll"
        "Qt6WebView.dll"
        "Qt6Quick3D.dll"
        "Qt6Quick3DRuntimeRender.dll"
        "Qt6Quick3DUtils.dll"
        "Qt6Graphs.dll"
        "platforminputcontexts/qtvirtualkeyboardplugin.dll"
    )

    set(_rm_cmds)
    foreach(_rel IN LISTS _dirs)
        list(APPEND _rm_cmds
            COMMAND ${CMAKE_COMMAND} -E rm -rf "${_dir}/${_rel}"
        )
    endforeach()
    foreach(_rel IN LISTS _files)
        list(APPEND _rm_cmds
            COMMAND ${CMAKE_COMMAND} -E rm -f "${_dir}/${_rel}"
        )
    endforeach()

    add_custom_command(TARGET ${_target} POST_BUILD
        ${_rm_cmds}
        COMMENT "Stripping restricted Qt modules (VirtualKeyboard, etc.) from $<TARGET_FILE_DIR:${_target}>"
        VERBATIM
    )
endfunction()
