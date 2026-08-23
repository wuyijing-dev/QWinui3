import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// TextArea — Fluent styled TextArea.
//
//   TextArea {
//       id: area
//       placeholderText: qsTr("Notes")
//       wrapMode: TextEdit.Wrap
//   }
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls TextArea.
//   Public API is the Qt Quick Controls TextArea type; this file supplies visuals/metrics only.

T.TextArea {
    id: control

    // Form validation error (2.66 M3)
    property bool hasError: false
    // Visual variant: filled | outline | "" (filled default — 2.66 A2/M3)
    property string appearance: ""
    property int _errorShakeSeq: 0
    property real _shakeOffset: 0

    readonly property string _effectiveAppearance: appearance.length ? appearance : "filled"
    readonly property bool _outlineAppearance: _effectiveAppearance === "outline"

    onHasErrorChanged: {
        if (hasError)
            _errorShakeSeq += 1
    }

    on_ErrorShakeSeqChanged: {
        if (_errorShakeSeq <= 0)
            return
        if (Theme.reducedMotion) {
            _shakeOffset = 0
            return
        }
        errorShakeAnim.restart()
    }

    SequentialAnimation {
        id: errorShakeAnim
        NumberAnimation { target: control; property: "_shakeOffset"; to: -4; duration: Theme.duration(40); easing.type: Theme.easingStandard }
        NumberAnimation { target: control; property: "_shakeOffset"; to: 4; duration: Theme.duration(40); easing.type: Theme.easingStandard }
        NumberAnimation { target: control; property: "_shakeOffset"; to: -2; duration: Theme.duration(40); easing.type: Theme.easingStandard }
        NumberAnimation { target: control; property: "_shakeOffset"; to: 0; duration: Theme.duration(40); easing.type: Theme.easingStandard }
    }

    Accessible.role: Accessible.EditableText
    Accessible.multiLine: true
    Accessible.name: control.placeholderText.length ? control.placeholderText : qsTr("Text area")
    Accessible.readOnly: control.readOnly
    implicitWidth: Math.max(200, contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(80, contentHeight + topPadding + bottomPadding)

    leftPadding: Theme.paddingControlH
    rightPadding: Theme.paddingControlH
    topPadding: Theme.paddingControlV
    bottomPadding: Theme.paddingControlV
    color: control.enabled ? Theme.textPrimary : Theme.textDisabled
    placeholderTextColor: Theme.textSecondary
    selectionColor: Theme.accent
    selectedTextColor: Theme.textOnAccent
    font.pixelSize: Theme.fontBody
    wrapMode: TextEdit.Wrap
    hoverEnabled: true

    PointerCursor { shape: Qt.IBeamCursor }

    background: Item {
        x: control._shakeOffset
        implicitWidth: 200
        implicitHeight: 80

        Rectangle {
            id: fieldChrome
            anchors.fill: parent
            radius: Theme.cornerControl
            color: {
                if (!control.enabled)
                    return Theme.fillControlDisabled
                if (control.hovered)
                    return Theme.fillControlSecondary
                if (control._outlineAppearance)
                    return "transparent"
                return Theme.bgControlRest
            }
            border.width: control.hasError ? 2
                        : (control._outlineAppearance && control.activeFocus ? 2 : 1)
            border.color: control.hasError ? Theme.systemCritical
                          : (control.activeFocus && control._outlineAppearance
                             ? Theme.accent : Theme.strokeControl)

            Behavior on color {
                enabled: !Theme.reducedMotion && (control.hovered || control.activeFocus)
                ColorAnimation {
                    duration: Theme.motionMs("normal")
                    easing.type: Theme.motionEasing("standard")
                }
            }
            Behavior on border.color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.motionMs("fast")
                    easing.type: Theme.motionEasing("standard")
                }
            }

            Rectangle {
                id: underline
                visible: !control._outlineAppearance
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: control.activeFocus ? 2 : 1
                color: control.activeFocus ? Theme.accent : Theme.strokeControl
                opacity: control.activeFocus ? 1 : 0.85

                Behavior on height {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingStandard
                    }
                }
                Behavior on color {
                    enabled: !Theme.reducedMotion
                    ColorAnimation {
                        duration: Theme.duration(Theme.motionFast)
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
        }

        FocusStroke {
            anchors.fill: parent
            show: control.activeFocus && (control.focusReason === Qt.TabFocusReason
                                          || control.focusReason === Qt.BacktabFocusReason)
        }
    }
}
