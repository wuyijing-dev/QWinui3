import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// TextField — Fluent styled TextField.
//
//   TextField {
//       id: field
//       placeholderText: qsTr("Name")
//       onAccepted: submit(field.text)
//   }
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls TextField.
//   Public API is the Qt Quick Controls TextField type; this file supplies visuals/metrics only.

T.TextField {
    id: control

    // Form validation error (2.66 M3)
    property bool hasError: false
    // Visual variant: filled | outline | "" (filled default — 2.66 A2/M3)
    property string appearance: ""
    // Leading FluentIcons symbol (preferred) or raw glyph (2.67 — I11)
    property var leadingSymbol: ""
    property string leadingGlyph: ""
    // Show clear (×) when non-empty and editable
    property bool clearButtonVisible: true
    property int _errorShakeSeq: 0
    property real _shakeOffset: 0

    readonly property string _effectiveAppearance: appearance.length ? appearance : "filled"
    readonly property bool _outlineAppearance: _effectiveAppearance === "outline"
    readonly property string _leadingGlyph: {
        var fromSym = IconSource.resolve(leadingSymbol, "")
        if (fromSym.length)
            return fromSym
        return IconSource.resolve(leadingGlyph, "")
    }
    readonly property bool _showLeading: _leadingGlyph.length > 0
    readonly property bool _showClear: clearButtonVisible && !readOnly && enabled && text.length > 0

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
    Accessible.name: control.placeholderText.length ? control.placeholderText : qsTr("Text field")
    Accessible.readOnly: control.readOnly
    implicitWidth: Math.max(200, contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(Theme.controlHeight,
                             contentHeight + topPadding + bottomPadding)

    leftPadding: Theme.paddingControlH + (_showLeading ? 22 : 0)
    rightPadding: Theme.paddingControlH + (_showClear ? 28 : 0)
    topPadding: Theme.paddingControlV
    bottomPadding: Theme.paddingControlV
    color: control.enabled ? Theme.textPrimary : Theme.textDisabled
    placeholderTextColor: Theme.textSecondary
    selectionColor: Theme.accent
    selectedTextColor: Theme.textOnAccent
    font.pixelSize: Theme.fontBody
    verticalAlignment: TextInput.AlignVCenter
    hoverEnabled: true

    PointerCursor { shape: Qt.IBeamCursor }

    background: Item {
        x: control._shakeOffset
        implicitWidth: 200
        implicitHeight: Theme.searchBoxHeight
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
                color: control.activeFocus ? Theme.accent
                     : (control.enabled ? Theme.strokeControl : Theme.strokeControl)
                opacity: control.activeFocus ? 1 : 0.85

                Behavior on height {
                    enabled: !Theme.reducedMotion && (control.activeFocus || control.hovered)
                    NumberAnimation {
                        duration: Theme.motionMs("normal")
                        easing.type: Theme.motionEasing("standard")
                    }
                }
                Behavior on color {
                    enabled: !Theme.reducedMotion && (control.activeFocus || control.hovered)
                    ColorAnimation {
                        duration: Theme.motionMs("normal")
                        easing.type: Theme.motionEasing("standard")
                    }
                }

                transform: Scale {
                    origin.x: underline.width / 2
                    xScale: control.activeFocus ? 1 : (Theme.reducedMotion ? 1 : 0.28)
                    Behavior on xScale {
                        enabled: !Theme.reducedMotion
                        NumberAnimation {
                            duration: Theme.motionMs("normal")
                            easing.type: Theme.motionEasing("standard")
                        }
                    }
                }
            }
        }

        // Leading icon — optical align to cap height (2.67 — I11)
        Text {
            visible: control._showLeading
            anchors.left: parent.left
            anchors.leftMargin: Theme.paddingControlH - 2
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: Theme.iconOpticalOffset(14).y
            text: control._leadingGlyph
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 14
            color: control.enabled ? Theme.textSecondary : Theme.textDisabled
            Accessible.ignored: true
        }

        // Clear affordance — 32×32 hit pad (2.67 — I11)
        Item {
            id: clearHit
            visible: control._showClear
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 32
            height: 32
            z: 2

            Rectangle {
                anchors.centerIn: parent
                width: 20
                height: 20
                radius: 10
                color: clearHover.hovered ? Theme.fillSubtle : "transparent"
                Behavior on color {
                    enabled: !Theme.reducedMotion
                    ColorAnimation {
                        duration: Theme.motionMs("fast")
                        easing.type: Theme.motionEasing("standard")
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: FluentIcons.ChromeClose
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 10
                    color: control.enabled ? Theme.textSecondary : Theme.textDisabled
                }
            }

            HoverHandler { id: clearHover }
            TapHandler {
                onTapped: {
                    control.clear()
                    control.forceActiveFocus()
                }
            }
            PointerCursor { shape: Qt.PointingHandCursor }
            Accessible.role: Accessible.Button
            Accessible.name: qsTr("Clear")
            Accessible.onPressAction: {
                control.clear()
                control.forceActiveFocus()
            }
        }

        FocusStroke {
            anchors.fill: parent
            show: control.activeFocus && (control.focusReason === Qt.TabFocusReason
                                          || control.focusReason === Qt.BacktabFocusReason)
        }
    }
}
