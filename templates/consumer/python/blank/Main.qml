import QtQuick
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Platform

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: qsTr("QWinUI3 Python")
    color: Theme.bgLayer

    Label {
        anchors.centerIn: parent
        text: qsTr("Hello from qwinui3 init --python")
        color: Theme.textPrimary
        font.pixelSize: Theme.fontTitle
    }
}
