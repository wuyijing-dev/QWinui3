import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// AccentButton — Accent-colored CTA with optional Fluent symbol (2.66 A1 appearances).
//
//   AccentButton {
//       id: saveBtn
//       text: qsTr("Save")
//       symbol: FluentIcons.Save
//       appearance: "filled"   // filled | subtle | outline | ghost
//       onClicked: save()
//   }
//
// @notes
//   Prefer symbol: FluentIcons.* over iconGlyph. Default appearance is filled (solid accent).
//   Inherits Button appearance API (2.66 A1).

Button {
    id: control

    Accessible.role: Accessible.Button
    Accessible.name: control.text.length ? control.text : qsTr("Accent button")
    Accessible.onPressAction: if (control.enabled) control.clicked()

    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""
    // Icon size in px
    property real iconSize: 14

    // Resolved glyph string
    readonly property string effectiveIconGlyph: IconSource.resolve(symbol, iconGlyph)
    // True in light theme
    readonly property bool lightScheme: !Theme.dark
    readonly property string _mode: {
        var a = String(appearance || "").toLowerCase()
        if (a === "subtle" || a === "outline" || a === "ghost")
            return a
        return "filled"
    }
    readonly property bool _onAccent: _mode === "filled"
    readonly property color _labelColor: {
        if (!control.enabled)
            return Theme.textDisabled
        if (control._onAccent)
            return Theme.textOnAccent
        return Theme.accent
    }

    highlighted: true
    appearance: "filled"
    implicitHeight: Theme.controlHeight
    leftPadding: Theme.paddingControlH
    rightPadding: Theme.paddingControlH
    font.pixelSize: Theme.fontBody
    hoverEnabled: true

    background: Item {
        implicitWidth: Math.max(Theme.controlMinWidth, control.contentItem.implicitWidth + 24)
        implicitHeight: Theme.controlHeight
        scale: control.down && !Theme.reducedMotion ? 0.98 : 1

        Behavior on scale {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: Theme.cornerControl
            border.width: control._mode === "outline" ? 1 : 0
            border.color: control.enabled ? Theme.accent : Theme.strokeControl
            color: {
                if (!control.enabled) {
                    if (control._mode === "filled")
                        return Theme.dark ? "#28FFFFFF" : "#37000000"
                    return "transparent"
                }
                var mode = control._mode
                if (mode === "ghost") {
                    if (control.down || control.hovered)
                        return Theme.fillSubtleSecondary
                    return "transparent"
                }
                if (mode === "outline") {
                    if (control.down)
                        return Theme.fillSubtleTertiary
                    if (control.hovered)
                        return Theme.fillSubtleSecondary
                    return "transparent"
                }
                if (mode === "subtle") {
                    if (control.down)
                        return Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.28)
                    if (control.hovered)
                        return Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.18)
                    return Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.12)
                }
                if (control.down)
                    return control.lightScheme
                        ? Qt.tint(Theme.accent, Qt.rgba(1, 1, 1, 0.2))
                        : Qt.tint(Theme.accent, Qt.rgba(0, 0, 0, 0.2))
                if (control.hovered)
                    return control.lightScheme
                        ? Qt.tint(Theme.accent, Qt.rgba(1, 1, 1, 0.1))
                        : Qt.tint(Theme.accent, Qt.rgba(0, 0, 0, 0.1))
                return Theme.accent
            }
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
        }

        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
            frameRadius: Theme.cornerControl
        }
    }

    contentItem: RowLayout {
        spacing: 8
        FontIcon {
            visible: control.effectiveIconGlyph.length > 0
            glyph: control.effectiveIconGlyph
            fontSize: control.iconSize
            iconColor: control._labelColor
            microMotionEnabled: false
            Layout.alignment: Qt.AlignVCenter
        }
        Text {
            text: control.text
            font: control.font
            color: control._labelColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            Layout.alignment: Qt.AlignVCenter
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
        }
    }
}
