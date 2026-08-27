import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// RadioButton — Fluent / WinUI 3 RadioButton (description caption).
//
//   RadioButton {
//       text: qsTr("Option A")
//       description: qsTr("Recommended for most users.")
//       checked: true
//   }
//
// @notes
//   Fluent chrome with optional description. Group with ButtonGroup or RadioButtons.

T.RadioButton {
    id: control

    // Supporting caption under the label (Fluent settings pattern)
    property string description: ""
    // WinUI Header alias of text
    property alias header: control.text

    Accessible.role: Accessible.RadioButton
    Accessible.name: control.text.length ? control.text : qsTr("Radio button")
    Accessible.description: control.description
    Accessible.checkable: true
    Accessible.checked: control.checked
    Accessible.onToggleAction: if (control.enabled) control.click()
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    spacing: Theme.spacing
    padding: 0
    font.pixelSize: Theme.fontBody
    hoverEnabled: true

    PointerCursor { shape: Qt.PointingHandCursor }

    indicator: Item {
        implicitWidth: Theme.radioSize
        implicitHeight: Theme.radioSize
        x: control.mirrored ? control.width - width - control.rightPadding
                            : control.leftPadding
        y: control.topPadding
           + Math.max(0, (Theme.fontBody + 4 - height) / 2)

        Rectangle {
            id: outer
            anchors.fill: parent
            radius: width / 2
            color: {
                if (control.checked) {
                    if (!control.enabled)
                        return Theme.dark ? "#28FFFFFF" : "#37000000"
                    if (control.down)
                        return Qt.tint(Theme.accent, Theme.dark ? Qt.rgba(0, 0, 0, 0.2) : Qt.rgba(1, 1, 1, 0.2))
                    if (control.hovered)
                        return Qt.tint(Theme.accent, Theme.dark ? Qt.rgba(0, 0, 0, 0.1) : Qt.rgba(1, 1, 1, 0.1))
                    return Theme.accent
                }
                if (!control.enabled)
                    return Theme.fillControlDisabled
                if (control.down)
                    return Theme.fillControlTertiary
                if (control.hovered)
                    return Theme.fillControlSecondary
                return Theme.bgControlRest
            }
            border.width: control.checked ? 0 : 1
            border.color: {
                if (control.checked)
                    return "transparent"
                if (!control.enabled)
                    return Theme.strokeControl
                if (control.hovered)
                    return Theme.accent
                return Theme.strokeControlStrong
            }
            scale: control.down ? 0.9 : 1

            Behavior on color {
                enabled: !Theme.reducedMotion
                         && (control.hovered || control.down || control.checked)
                ColorAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on scale {
                enabled: !Theme.reducedMotion && (control.hovered || control.down)
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on border.width {
                enabled: !Theme.reducedMotion
                         && (control.hovered || control.down || control.checked)
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: 10
            height: 10
            radius: 5
            scale: {
                if (!control.checked)
                    return 0
                if (control.down)
                    return 0.8
                if (control.hovered)
                    return 1.15
                return 1
            }
            opacity: control.checked ? 1 : 0
            visible: opacity > 0.01 || scale > 0.01

            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: Theme.dark ? "#12FFFFFF" : "#0F000000"
                }
                GradientStop {
                    position: 0.95
                    color: Theme.dark ? "#18FFFFFF" : "#29000000"
                }
            }

            Rectangle {
                anchors.centerIn: parent
                width: parent.width - 2
                height: parent.height - 2
                radius: height / 2
                color: Theme.dark ? "#000000" : "#FFFFFF"
            }

            Behavior on scale {
                enabled: !Theme.reducedMotion
                         && (control.hovered || control.down || control.checked)
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on opacity {
                enabled: !Theme.reducedMotion
                         && (control.hovered || control.down || control.checked)
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
        }

        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
            frameRadius: width / 2
        }
    }

    contentItem: Item {
        readonly property real _indGap: control.indicator
                                        ? control.indicator.width + control.spacing : 0
        implicitWidth: labelCol.implicitWidth + _indGap
        implicitHeight: Math.max(Theme.radioSize, labelCol.implicitHeight)

        Column {
            id: labelCol
            x: control.mirrored ? 0 : parent._indGap
            width: Math.max(0, parent.width - parent._indGap)
            spacing: 2

            Text {
                width: parent.width
                visible: control.text.length > 0
                text: control.text
                font: control.font
                color: control.enabled ? Theme.textPrimary : Theme.textDisabled
                wrapMode: Text.WordWrap
            }
            Text {
                width: parent.width
                visible: control.description.length > 0
                text: control.description
                font.pixelSize: Theme.fontCaption
                color: control.enabled ? Theme.textSecondary : Theme.textDisabled
                wrapMode: Text.WordWrap
            }
        }
    }
}
