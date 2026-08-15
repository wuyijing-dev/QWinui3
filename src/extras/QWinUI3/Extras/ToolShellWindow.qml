import QtQuick
import QWinUI3.Theme
import QWinUI3.Platform

// Tool shell — floating tool window paradigm with ShellWindow chrome API.
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
