import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QWinUI3.Theme

// ToggleButton — Checkable button with Fluent chrome.
//
//   ToggleButton { text: qsTr("Bold"); checkable: true }

Button {
    id: control

    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""
    property real iconSize: 14

    readonly property string effectiveIconGlyph: IconSource.resolve(symbol, iconGlyph)
    readonly property bool lightScheme: !Theme.dark
    readonly property bool accented: control.checked || control.highlighted

    checkable: true
    implicitHeight: Theme.controlHeight
    leftPadding: Theme.paddingControlH
    rightPadding: Theme.paddingControlH
    hoverEnabled: true
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

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
                if (control.accented) {
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
                if (control.flat) {
                    if (control.down)
                        return Theme.dark ? Qt.rgba(1, 1, 1, 0.04) : Qt.rgba(0, 0, 0, 0.02)
                    if (control.hovered)
                        return Theme.dark ? Qt.rgba(1, 1, 1, 0.06) : Qt.rgba(0, 0, 0, 0.04)
                    return "transparent"
                }
                if (!control.enabled)
                    return Theme.dark ? "#0BFFFFFF" : "#4DF9F9F9"
                if (control.down)
                    return control.lightScheme ? "#4DF9F9F9" : "#08FFFFFF"
                if (control.hovered)
                    return control.lightScheme ? "#80F9F9F9" : "#15FFFFFF"
                return control.lightScheme ? "#FFFFFF" : "#0FFFFFFF"
            }
            border.width: (control.accented || control.flat) ? 0 : 1
            border.color: Theme.strokeControl
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
            color: label.color
            Layout.alignment: Qt.AlignVCenter
        }
        Text {
            id: label
            visible: control.text.length > 0
            text: control.text
            font: control.font
            color: {
                if (control.accented)
                    return Theme.textOnAccent
                if (!control.enabled)
                    return Theme.textDisabled
                if (control.down)
                    return Theme.dark ? Qt.rgba(1, 1, 1, 0.7725) : Qt.rgba(0, 0, 0, 0.62)
                return Theme.textPrimary
            }
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
