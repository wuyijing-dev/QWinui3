import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

T.TextField {
    id: control

    implicitWidth: Math.max(200, contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(Theme.controlHeight,
                             contentHeight + topPadding + bottomPadding)

    leftPadding: Theme.paddingControlH
    rightPadding: Theme.paddingControlH
    topPadding: Theme.paddingControlV
    bottomPadding: Theme.paddingControlV
    color: control.enabled ? Theme.textPrimary : Theme.textDisabled
    placeholderTextColor: Theme.textSecondary
    selectionColor: Theme.accent
    selectedTextColor: Theme.textOnAccent
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    verticalAlignment: TextInput.AlignVCenter
    hoverEnabled: true

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: Theme.searchBoxHeight
        radius: Theme.cornerControl
        color: {
            if (!control.enabled)
                return Theme.dark ? "#0BFFFFFF" : "#4DF9F9F9"
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
            id: underline
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: control.activeFocus ? 2 : 1
            color: control.activeFocus ? Theme.accent
                 : (control.enabled ? Theme.strokeControl : Theme.strokeControl)
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
