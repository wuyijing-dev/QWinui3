import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// Switch — Fluent styled Switch (WinUI ToggleSwitch OnContent / OffContent).
//
//   Switch {
//       id: sw
//       text: qsTr("Wi‑Fi")
//       onContent: qsTr("On")
//       offContent: qsTr("Off")
//       onToggled: Theme.dark = sw.checked
//   }
//
// @notes
//   Fluent Switch with WinUI OnContent/OffContent labels beside the track (plus Qt text as Header).
//   Base API is Qt Quick Controls Switch.

T.Switch {
    id: control


    Accessible.role: Accessible.CheckBox
    Accessible.name: control.text.length ? control.text : qsTr("Toggle")
    Accessible.checkable: true
    Accessible.checked: control.checked
    Accessible.onToggleAction: if (control.enabled) control.toggle()
    // WinUI OnContent — label shown when checked (beside indicator)
    property string onContent: ""
    // WinUI OffContent — label shown when unchecked
    property string offContent: ""
    // WinUI Header alias of text
    property alias header: control.text

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding,
                            implicitIndicatorWidth)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    spacing: Theme.spacing
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    hoverEnabled: true

    PointerCursor { shape: Qt.PointingHandCursor }

    readonly property string _stateLabel: checked
                                         ? (onContent.length ? onContent : "")
                                         : (offContent.length ? offContent : "")
    readonly property bool _hasStateLabel: _stateLabel.length > 0

    indicator: Item {
        implicitWidth: Theme.switchWidth
        implicitHeight: Theme.switchHeight
        x: control.text ? (control.mirrored ? control.width - width - control.rightPadding : control.leftPadding)
                        : control.leftPadding + (control.availableWidth - width) / 2
        y: control.topPadding + (control.availableHeight - height) / 2

        Rectangle {
            id: track
            anchors.fill: parent
            radius: height * 0.5
            border.width: control.checked ? 0 : 1
            border.color: control.enabled
                ? (Theme.dark ? "#9CFFFFFF" : "#9C000000")
                : (Theme.dark ? "#28FFFFFF" : "#37000000")
            color: {
                if (control.checked) {
                    if (!control.enabled)
                        return Theme.dark ? "#28FFFFFF" : "#37000000"
                    if (control.down)
                        return Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.8)
                    if (control.hovered)
                        return Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.902)
                    return Theme.accent
                }
                if (!control.enabled)
                    return "transparent"
                if (control.down)
                    return Theme.dark ? "#12FFFFFF" : "#18000000"
                if (control.hovered)
                    return Theme.dark ? "#0BFFFFFF" : "#0F000000"
                return Theme.dark ? "#19000000" : "#06000000"
            }

            Behavior on color {
                enabled: !Theme.reducedMotion
                         && (control.hovered || control.down || control.checked)
                ColorAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on border.width {
                enabled: !Theme.reducedMotion && (control.hovered || control.checked)
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }

            Rectangle {
                id: thumb
                x: Math.max(0, Math.min(parent.width - width,
                           control.visualPosition * parent.width - width / 2))
                y: (parent.height - height) / 2
                width: control.down ? Theme.switchThumb + 3 : Theme.switchThumb + 4
                height: Theme.switchThumb + 4
                radius: height / 2
                scale: control.hovered && control.enabled ? 0.82 : 0.72
                color: "transparent"

                Rectangle {
                    anchors.centerIn: parent
                    width: Theme.switchThumb
                    height: Theme.switchThumb
                    radius: height / 2
                    color: {
                        if (!control.checked)
                            return control.enabled
                                ? Theme.textSecondary
                                : Theme.textDisabled
                        return Theme.dark ? "#000000" : "#FFFFFF"
                    }

                    Behavior on color {
                        enabled: !Theme.reducedMotion
                                 && (control.hovered || control.checked || control.down)
                        ColorAnimation {
                            duration: Theme.motionMs("normal")
                            easing.type: Theme.motionEasing("standard")
                        }
                    }

                    // Optional check glyph on thumb when on (2.68 — I15)
                    Text {
                        anchors.centerIn: parent
                        text: FluentIcons.Accept
                        font.family: Theme.fontFamilyIcon
                        font.pixelSize: Math.max(8, Math.round(Theme.switchThumb * 0.55))
                        color: Theme.dark ? "#FFFFFF" : Theme.accent
                        opacity: control.checked ? 1 : 0
                        scale: control.checked ? 1 : 0.4
                        visible: opacity > 0.01

                        Behavior on opacity {
                            enabled: !Theme.reducedMotion
                                     && (control.hovered || control.down || control.checked)
                            NumberAnimation {
                                duration: Theme.motionMs("fast")
                                easing.type: Theme.motionEasing("standard")
                            }
                        }
                        Behavior on scale {
                            enabled: !Theme.reducedMotion
                                     && (control.hovered || control.down || control.checked)
                            NumberAnimation {
                                duration: Theme.motionMs("normal")
                                easing.type: Theme.motionEasing("enter")
                            }
                        }
                    }
                }

                Behavior on scale {
                    enabled: !Theme.reducedMotion && (control.hovered || control.down)
                    NumberAnimation {
                        duration: Theme.motionMs("normal")
                        easing.type: Theme.motionEasing("standard")
                    }
                }
                Behavior on x {
                    enabled: !control.down && !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.motionMs("normal")
                        easing.type: Theme.motionEasing("exit")
                    }
                }
                Behavior on width {
                    enabled: !Theme.reducedMotion && (control.down || control.hovered)
                    NumberAnimation {
                        duration: Theme.motionMs("fast")
                        easing.type: Theme.motionEasing("standard")
                    }
                }
            }
        }

        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
            frameRadius: height / 2
        }
    }

    contentItem: Item {
        implicitWidth: labelRow.implicitWidth
                       + (control.indicator ? control.indicator.width + control.spacing : 0)
        implicitHeight: Math.max(Theme.fontBody + 4, labelRow.implicitHeight)

        Row {
            id: labelRow
            spacing: Theme.spacing
            x: control.indicator && !control.mirrored ? control.indicator.width + control.spacing : 0
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - x
                   - (control.indicator && control.mirrored ? control.indicator.width + control.spacing : 0)

            Text {
                visible: control.text.length > 0
                text: control.text
                font: control.font
                color: control.enabled ? Theme.textPrimary : Theme.textDisabled
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
            Text {
                visible: control._hasStateLabel
                text: control._stateLabel
                font: control.font
                color: control.enabled ? Theme.textSecondary : Theme.textDisabled
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}