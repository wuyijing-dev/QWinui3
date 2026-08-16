import QtQuick
import QWinUI3.Theme
import QWinUI3.Platform

// DialogShellWindow — ShellWindow with dialog paradigm flags.
//
//   DialogShellWindow {
//       title: qsTr("Confirm")
//       width: 440; height: 280
//   }
//
// @notes
//   ShellWindow with WindowHelper.ParadigmDialog flags.

ShellWindow {
    id: root

    Accessible.role: Accessible.Window
    Accessible.name: root.title

    paradigm: WindowHelper.ParadigmDialog
    showMaximize: false
    width: 480
    height: 360
    minimumWidth: 320
    minimumHeight: 200
    title: qsTr("Dialog")
    subtitle: qsTr("Dialog shell")
    symbol: FluentIcons.OpenInNewWindow
}
