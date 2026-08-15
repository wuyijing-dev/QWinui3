import QtQuick
import QWinUI3.Theme
import QWinUI3.Platform

// Dialog shell — same ShellWindow API, dialog paradigm (no maximize, centered host).
ShellWindow {
    id: root
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
