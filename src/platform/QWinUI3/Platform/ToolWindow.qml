import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

// ToolWindow — StandardWindow tool paradigm.
//
//   ToolWindow { title: qsTr("Tool") }

StandardWindow {
    id: root

    paradigm: WindowHelper.ParadigmTool
    showMaximize: false
    width: 360
    height: 280
    minimumWidth: 240
    minimumHeight: 160
    title: qsTr("Tool")
}
