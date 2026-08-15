import QtQuick
import QWinUI3.Theme
import QWinUI3.Platform

// ToolShellWindow — ShellWindow with tool paradigm.
//
//   ToolShellWindow {
//       id: tool
//       title: qsTr("Inspector")
//       width: 360; height: 480
//   }
//   // --- API ---
//   // WindowHelper.ParadigmTool flags

ShellWindow {
    id: root
    paradigm: WindowHelper.ParadigmTool
    showMaximize: false
    width: 360
    height: 280
    title: qsTr("Tool")
    subtitle: qsTr("Tool shell")
    symbol: FluentIcons.OpenInNewWindow
}
