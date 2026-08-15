import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

// CompactOverlayWindow — StandardWindow compact overlay presenter.
//
//   CompactOverlayWindow { title: qsTr("Overlay") }

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
