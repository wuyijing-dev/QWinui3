import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// ApplicationWindow — Fluent ApplicationWindow chrome defaults.
//
//   ApplicationWindow {
//       id: win
//       width: 1024; height: 720
//       title: qsTr("App")
//       visible: true
//   }
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls ApplicationWindow.
//   Public API is the Qt Quick Controls ApplicationWindow type; this file supplies visuals/metrics only.

T.ApplicationWindow {
    id: window

    Accessible.role: Accessible.Window
    Accessible.name: window.title.length ? window.title : qsTr("Application")

    color: Theme.bgLayer
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
}
