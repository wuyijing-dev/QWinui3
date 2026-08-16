import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// SpinBox — Fluent styled SpinBox.
//
//   SpinBox {
//       id: spin
//       from: 0; to: 10; value: 3
//   }
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls SpinBox.
//   Public API is the Qt Quick Controls SpinBox type; this file supplies visuals/metrics only.

T.SpinBox {
    id: control


    Accessible.role: Accessible.SpinBox
    Accessible.name: qsTr("Spin box")
    Accessible.description: qsTr("%1 of %2").arg(control.value).arg(control.to)
    implicitWidth: Math.max(96, contentItem.implicitWidth + leftPadding + rightPadding
                            + up.implicitIndicatorWidth + down.implicitIndicatorWidth)
    implicitHeight: Theme.controlHeight

    leftPadding: Theme.paddingControlH
    rightPadding: up.indicator.width + 4
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    editable: true
    hoverEnabled: true

    validator: IntValidator {
        bottom: Math.min(control.from, control.to)
        top: Math.max(control.from, control.to)
    }

    contentItem: TextInput {
        text: control.displayText
        font: control.font
        color: control.enabled ? Theme.textPrimary : Theme.textDisabled
        selectionColor: Theme.accent
        selectedTextColor: Theme.textOnAccent
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        readOnly: !control.editable
        validator: control.validator
        inputMethodHints: Qt.ImhFormattedNumbersOnly
    }

    up.indicator: Item {
        x: control.mirrored ? 0 : parent.width - width
        height: parent.height / 2
        implicitWidth: 28
        implicitHeight: 16

        Rectangle {
            anchors.fill: parent
            anchors.margins: 2
            anchors.bottomMargin: 1
            radius: Theme.cornerControl - 1
            color: control.up.pressed ? Theme.fillSubtleTertiary
                 : (control.up.hovered ? Theme.fillSubtle : "transparent")
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation { duration: Theme.duration(Theme.motionFast) }
            }
        }
        Text {
            anchors.centerIn: parent
            text: FluentIcons.ChevronUp
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 8
            color: control.up.pressed ? Theme.accent
                 : (control.enabled ? Theme.textSecondary : Theme.textDisabled)
        }
    }

    down.indicator: Item {
        x: control.mirrored ? 0 : parent.width - width
        y: parent.height / 2
        height: parent.height / 2
        implicitWidth: 28
        implicitHeight: 16

        Rectangle {
            anchors.fill: parent
            anchors.margins: 2
            anchors.topMargin: 1
            radius: Theme.cornerControl - 1
            color: control.down.pressed ? Theme.fillSubtleTertiary
                 : (control.down.hovered ? Theme.fillSubtle : "transparent")
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation { duration: Theme.duration(Theme.motionFast) }
            }
        }
        Text {
            anchors.centerIn: parent
            text: FluentIcons.ChevronDown
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 8
            color: control.down.pressed ? Theme.accent
                 : (control.enabled ? Theme.textSecondary : Theme.textDisabled)
        }
    }

    background: Rectangle {
        radius: Theme.cornerControl
        color: {
            if (!control.enabled)
                return Theme.fillControlDisabled
            if (control.activeFocus)
                return Theme.dark ? "#0FFFFFFF" : "#FFFFFF"
            if (control.hovered)
                return Theme.fillControlSecondary
            return Theme.dark ? "#0FFFFFFF" : "#FFFFFF"
        }
        border.width: 1
        border.color: Theme.strokeControl

        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingStandard
            }
        }

        Rectangle {
            anchors.right: parent.right
            anchors.rightMargin: 28
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 6
            anchors.bottomMargin: 6
            width: 1
            color: Theme.strokeDivider
        }

        Rectangle {
            id: underline
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: control.activeFocus ? 2 : 1
            color: control.activeFocus ? Theme.accent : Theme.strokeControl
            opacity: control.activeFocus ? 1 : 0.85

            Behavior on height {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }

            transform: Scale {
                origin.x: underline.width / 2
                xScale: control.activeFocus ? 1 : (Theme.reducedMotion ? 1 : 0.28)
                Behavior on xScale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingStandard
                    }
                }
            }
        }

        FocusStroke {
            anchors.fill: parent
            show: control.activeFocus && (control.focusReason === Qt.TabFocusReason
                                          || control.focusReason === Qt.BacktabFocusReason)
        }
    }
}
