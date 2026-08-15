import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// MenuFlyoutItem — Menu row with glyph and accelerator text.
//
//   MenuFlyout {
//       MenuFlyoutItem {
//           text: qsTr("Copy")
//           symbol: FluentIcons.Copy
//           onClicked: copy()
//       }
//   }

MenuItem {
    id: control

    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""
    // Accelerator caption (Ctrl+C)
    property string keyboardAcceleratorText: ""
    // When true, render accelerator as KeyChordVisual chrome instead of plain text.
    property bool keyVisualAccelerator: false
    // Icon color
    property color iconColor: Theme.textPrimary

    // Resolved glyph string
    readonly property string effectiveIconGlyph: IconSource.resolve(symbol, iconGlyph)

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
            FontIcon {
                anchors.centerIn: parent
                visible: control.effectiveIconGlyph.length > 0
                glyph: control.effectiveIconGlyph
                fontSize: 14
                iconColor: {
                    if (!control.enabled)
                        return Theme.textDisabled
                    if (control.down)
                        return Theme.textSecondary
                    return control.iconColor
                }
            }
        }

        Text {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            text: control.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            elide: Text.ElideRight
            color: {
                if (!control.enabled)
                    return Theme.textDisabled
                if (control.down)
                    return Theme.textSecondary
                return Theme.textPrimary
            }
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }

        Text {
            visible: control.keyboardAcceleratorText.length > 0 && !control.keyVisualAccelerator
            Layout.alignment: Qt.AlignVCenter
            text: control.keyboardAcceleratorText
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: control.enabled ? Theme.textSecondary : Theme.textDisabled
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionFast)
                }
            }
        }

        KeyChordVisual {
            visible: control.keyboardAcceleratorText.length > 0 && control.keyVisualAccelerator
            Layout.alignment: Qt.AlignVCenter
            shortcut: control.keyboardAcceleratorText
            size: "small"
            enabled: control.enabled
        }
    }
}
