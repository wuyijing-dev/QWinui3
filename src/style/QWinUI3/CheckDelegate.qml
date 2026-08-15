import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.impl
import QtQuick.Shapes
import QWinUI3.Theme

// CheckDelegate — Fluent styled CheckDelegate.
//
//   CheckDelegate { text: qsTr("Option") }

T.CheckDelegate {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(Theme.navItemHeight,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 10
    leftPadding: 12
    rightPadding: 12
    spacing: 12
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    hoverEnabled: true
    icon.width: 16
    icon.height: 16
    icon.color: Theme.textPrimary

    indicator: Item {
        implicitWidth: Theme.checkSize
        implicitHeight: Theme.checkSize
        x: control.mirrored ? control.width - width - control.rightPadding
                            : control.leftPadding
        y: control.topPadding + (control.availableHeight - height) / 2

        Rectangle {
            anchors.fill: parent
            radius: 4
            color: {
                if (control.checkState !== Qt.Unchecked) {
                    if (!control.enabled)
                        return Theme.dark ? "#28FFFFFF" : "#37000000"
                    if (control.down)
                        return Qt.tint(Theme.accent, Theme.dark ? Qt.rgba(0, 0, 0, 0.2) : Qt.rgba(1, 1, 1, 0.2))
                    return Theme.accent
                }
                if (control.hovered)
                    return Theme.fillControlSecondary
                return Theme.dark ? "#0FFFFFFF" : "#FFFFFF"
            }
            border.width: control.checkState === Qt.Unchecked ? 1 : 0
            border.color: Theme.strokeControlStrong
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }

        Shape {
            anchors.centerIn: parent
            width: 12
            height: 12
            opacity: control.checkState === Qt.Checked ? 1 : 0
            scale: control.checkState === Qt.Checked ? 1 : 0.6
            antialiasing: true
            preferredRendererType: Shape.CurveRenderer
            Behavior on opacity {
                enabled: !Theme.reducedMotion
                NumberAnimation { duration: Theme.duration(Theme.motionFast) }
            }
            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingEnter
                }
            }
            ShapePath {
                strokeWidth: 1.5
                strokeColor: Theme.dark ? "#000000" : "#FFFFFF"
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: 1; startY: 6
                PathLine { x: 5; y: 10 }
                PathLine { x: 11; y: 3 }
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: 8
            height: 1.5
            radius: 1
            visible: control.checkState === Qt.PartiallyChecked
            color: Theme.dark ? "#000000" : "#FFFFFF"
        }
    }

    contentItem: IconLabel {
        leftPadding: control.mirrored ? 0 : (control.indicator ? control.indicator.width + control.spacing : 0)
        rightPadding: control.mirrored ? (control.indicator ? control.indicator.width + control.spacing : 0) : 0
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        alignment: Qt.AlignLeft | Qt.AlignVCenter
        icon: control.icon
        text: control.text
        font: control.font
        color: control.enabled ? Theme.textPrimary : Theme.textDisabled
    }

    background: Item {
        implicitHeight: Theme.navItemHeight
        Rectangle {
            anchors.fill: parent
            anchors.leftMargin: 4
            anchors.rightMargin: 4
            anchors.topMargin: 2
            anchors.bottomMargin: 2
            radius: Theme.cornerControl
            color: control.down ? Theme.fillSubtleTertiary
                 : (control.hovered ? Theme.fillSubtleSecondary : "transparent")
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }
        FocusStroke {
            anchors.fill: parent
            anchors.margins: 2
            show: control.visualFocus
        }
    }
}
