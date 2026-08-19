import QtQuick
import QWinUI3.Theme

// OskPanelButton — compact action chip for OSK auxiliary panels.
//
//   OskPanelButton { label: qsTr("123"); onTapped: showSymbols() }
//
Item {
    id: cap
    property string label: ""
    property bool accent: false
    property bool enabled: true
    signal tapped

    implicitWidth: capLabel.implicitWidth + Theme.dp(16)
    implicitHeight: Theme.dp(32)
    opacity: enabled ? 1 : 0.45

    Rectangle {
        anchors.fill: parent
        radius: Theme.cornerControl
        color: cap.accent ? Theme.fillAccent
             : (ma.containsPress ? Theme.fillControlTertiary
                : ma.containsMouse ? Theme.fillControlSecondary
                : Theme.fillControl)
        border.width: Theme.strokeHairline
        border.color: Theme.strokeControl
    }
    Text {
        id: capLabel
        anchors.centerIn: parent
        text: cap.label
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontCaption
        color: cap.accent ? Theme.textOnAccent : Theme.textPrimary
    }
    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        enabled: cap.enabled
        preventStealing: true
        onClicked: cap.tapped()
    }
    Accessible.role: Accessible.Button
    Accessible.name: cap.label.length ? cap.label : qsTr("Button")
    Accessible.onPressAction: cap.tapped()
}
