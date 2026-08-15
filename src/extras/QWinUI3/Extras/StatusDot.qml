import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// StatusDot — Colored status indicator dot.
//
//   StatusDot { severity: success }

T.Control {
    id: root

    // Offline status constant
    readonly property int offline: 0
    // Available status constant
    readonly property int available: 1
    // Away status constant
    readonly property int away: 2
    // Busy status constant
    readonly property int busy: 3
    // Unknown status constant
    readonly property int unknown: 4

    // Current status enum
    property int status: available
    // Animate a pulse when true
    property bool pulse: status === available
    // Diameter or box size in px
    property real size: 10
    // Field label
    property string label: ""
    // Show text label beside the dot
    property bool showLabel: label.length > 0

    implicitWidth: showLabel ? row.implicitWidth : size
    implicitHeight: showLabel ? Math.max(size, row.implicitHeight) : size

    // Status name string
    readonly property string statusName: {
        switch (status) {
        case available: return qsTr("Available")
        case away: return qsTr("Away")
        case busy: return qsTr("Busy")
        case offline: return qsTr("Offline")
        default: return qsTr("Unknown")
        }
    }

    // Status indicator color
    readonly property color statusColor: {
        switch (status) {
        case available: return Theme.systemSuccess
        case away: return Theme.systemCaution
        case busy: return Theme.systemCritical
        case offline: return Theme.textDisabled
        default: return Theme.textSecondary
        }
    }

    ToolTip.visible: hovered && label.length === 0
    ToolTip.text: statusName
    hoverEnabled: true
    Accessible.role: Accessible.StatusBar
    Accessible.name: label.length ? label : statusName

    contentItem: Row {
        id: row
        spacing: 8

        Item {
            width: root.size * 2.2
            height: root.size * 2.2
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                id: pulseRing
                anchors.centerIn: parent
                width: root.size
                height: root.size
                radius: width / 2
                color: "transparent"
                border.width: 1.5
                border.color: root.statusColor
                opacity: 0
                scale: 1
                visible: root.pulse && !Theme.reducedMotion

                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    running: pulseRing.visible
                    NumberAnimation { from: 0.5; to: 0; duration: 1400; easing.type: Easing.OutCubic }
                }
                SequentialAnimation on scale {
                    loops: Animation.Infinite
                    running: pulseRing.visible
                    NumberAnimation { from: 1; to: 2.1; duration: 1400; easing.type: Easing.OutCubic }
                }
            }

            Rectangle {
                anchors.centerIn: parent
                width: root.size
                height: root.size
                radius: width / 2
                color: root.statusColor
                border.width: 2
                border.color: Theme.bgLayer

                Behavior on color {
                    enabled: !Theme.reducedMotion
                    ColorAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                    }
                }
            }
        }

        Text {
            visible: root.showLabel
            anchors.verticalCenter: parent.verticalCenter
            text: root.label
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }
    }

    background: Item {}
}
