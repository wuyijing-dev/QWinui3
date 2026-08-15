import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// RadioMenuFlyoutItem — Exclusive radio MenuFlyout item.
//
//   RadioMenuFlyoutItem { text: qsTr("Option") }

MenuItem {
    id: control

    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""
    // Accelerator caption (Ctrl+C)
    property string keyboardAcceleratorText: ""
    // Show KeyVisual for accelerator
    property bool keyVisualAccelerator: false

    // Resolved glyph string
    readonly property string effectiveIconGlyph: IconSource.resolve(symbol, iconGlyph)

    checkable: true
    autoExclusive: true
    implicitWidth: Math.max(200, contentRow.implicitWidth + leftPadding + rightPadding)
    leftPadding: 12
    rightPadding: 12
    spacing: Theme.spacing

    contentItem: RowLayout {
        id: contentRow
        spacing: control.spacing
        scale: control.down && !Theme.reducedMotion ? 0.98 : 1
        Behavior on scale {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }

        Item {
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
            Layout.alignment: Qt.AlignVCenter

            // Prefer radio indicator; optional trailing symbol is shown next to text when unchecked glyph wanted
            Rectangle {
                anchors.centerIn: parent
                width: 16
                height: 16
                radius: 8
                color: "transparent"
                border.width: 1.5
                border.color: {
                    if (!control.enabled)
                        return Theme.textDisabled
                    if (control.checked)
                        return Theme.accent
                    return Theme.strokeControlStrong
                }
                Behavior on border.color {
                    enabled: !Theme.reducedMotion
                    ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                }

                Rectangle {
                    anchors.centerIn: parent
                    width: 8
                    height: 8
                    radius: 4
                    color: Theme.accent
                    visible: control.checked
                    scale: control.checked ? 1 : 0.4
                    Behavior on scale {
                        enabled: !Theme.reducedMotion
                        NumberAnimation {
                            duration: Theme.duration(Theme.motionFast)
                            easing.type: Theme.easingEnter
                        }
                    }
                }
            }
        }

        FontIcon {
            visible: control.effectiveIconGlyph.length > 0
            Layout.alignment: Qt.AlignVCenter
            glyph: control.effectiveIconGlyph
            fontSize: 14
            iconColor: control.enabled ? Theme.textPrimary : Theme.textDisabled
        }

        Text {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            text: control.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            font.weight: control.checked ? Theme.fontWeightSemiBold : Theme.fontWeightRegular
            elide: Text.ElideRight
            color: control.enabled ? Theme.textPrimary : Theme.textDisabled
        }

        Text {
            visible: control.keyboardAcceleratorText.length > 0 && !control.keyVisualAccelerator
            text: control.keyboardAcceleratorText
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }

        KeyChordVisual {
            visible: control.keyboardAcceleratorText.length > 0 && control.keyVisualAccelerator
            shortcut: control.keyboardAcceleratorText
            size: "small"
        }
    }
}
