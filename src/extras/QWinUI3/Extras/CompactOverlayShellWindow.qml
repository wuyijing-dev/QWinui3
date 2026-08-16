import QtQuick
import QWinUI3.Theme
import QWinUI3.Platform

// CompactOverlayShellWindow — Always-on-top compact overlay shell.
//
//   CompactOverlayShellWindow {
//       id: pip
//       title: qsTr("Now playing")
//       width: 320; height: 180
//   }
//   // --- API ---
//   // always-on-top compact overlay presenter
//
// @notes
//   Always-on-top compact overlay shell (PiP-style presenter).

ShellWindow {
    id: root

    Accessible.role: Accessible.Window
    Accessible.name: root.title

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
