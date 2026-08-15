import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// ApplicationWindow — Fluent ApplicationWindow chrome defaults.
//
//   ApplicationWindow { title: qsTr("App") }

T.ApplicationWindow {
    id: window
    color: Theme.bgLayer
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
}
