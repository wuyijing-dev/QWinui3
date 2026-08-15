import QtQuick
import QWinUI3.Theme
import QWinUI3.Platform

// CompactOverlayShellWindow — Always-on-top compact overlay shell.
//
//   CompactOverlayShellWindow { title: qsTr("Now playing") }

ShellWindow {
    id: root
    paradigm: WindowHelper.ParadigmTool
    presenter: WindowHelper.PresenterCompactOverlay
    isAlwaysOnTop: true
    preferredHeightOption: WindowHelper.TitleBarHeightStandard
    showMaximize: false
    showMinimize: true
    width: 360
    height: 240
    title: qsTr("Compact overlay")
    subtitle: qsTr("Picture-in-picture shell")
    symbol: FluentIcons.FullScreen
}
