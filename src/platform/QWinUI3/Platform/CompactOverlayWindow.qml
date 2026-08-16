import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

// CompactOverlayWindow — StandardWindow compact overlay presenter.
//
//   CompactOverlayWindow {
//       id: pip
//       title: qsTr("PiP")
//       width: 320; height: 180
//   }
//
// @notes
//   StandardWindow compact-overlay presenter (always-on-top PiP).

StandardWindow {
    id: root
    paradigm: WindowHelper.ParadigmTool
    presenter: WindowHelper.PresenterCompactOverlay
    isAlwaysOnTop: true
    showMaximize: false
    showMinimize: true
    preferredHeightOption: WindowHelper.TitleBarHeightStandard
    width: 360
    height: 240
    minimumWidth: 240
    minimumHeight: 160
    title: qsTr("Compact overlay")
}
