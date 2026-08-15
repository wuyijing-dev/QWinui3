import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// WinUI AccentButton — always-accent primary CTA with optional Fluent symbol.
Button {
    id: control

    property var symbol: ""
    property string iconGlyph: ""
    property real iconSize: 14

    readonly property string effectiveIconGlyph: IconSource.resolve(symbol, iconGlyph)
    readonly property bool lightScheme: !Theme.dark

    highlighted: true
    implicitHeight: Theme.controlHeight
    leftPadding: Theme.paddingControlH
    rightPadding: Theme.paddingControlH
    font.family: Theme.fontFamily
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
            color: {
                if (!control.enabled)
                    return Theme.dark ? "#28FFFFFF" : "#37000000"
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

        Rectangle {
            anchors.fill: parent
            anchors.margins: -2
            radius: Theme.cornerControl + 2
            color: "transparent"
            border.width: control.visualFocus ? 2 : 0
            border.color: Theme.focusOuter
            visible: control.visualFocus
        }
    }

    contentItem: RowLayout {
        spacing: 8
        Text {
            visible: control.effectiveIconGlyph.length > 0
            text: control.effectiveIconGlyph
            font.family: Theme.fontFamilyIcon
            font.pixelSize: control.iconSize
            color: control.enabled ? Theme.textOnAccent : Theme.textDisabled
            Layout.alignment: Qt.AlignVCenter
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation { duration: Theme.duration(Theme.motionFast) }
            }
        }
        Text {
            text: control.text
            font: control.font
            color: control.enabled ? Theme.textOnAccent : Theme.textDisabled
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
