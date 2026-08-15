import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Checkable MenuFlyout item with Fluent check glyph.
MenuItem {
    id: control

    property var symbol: ""
    property string iconGlyph: ""
    property string keyboardAcceleratorText: ""
    property bool keyVisualAccelerator: false

    readonly property string effectiveIconGlyph: IconSource.resolve(symbol, iconGlyph)

    checkable: true
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
                glyph: control.checked ? FluentIcons.Accept : control.effectiveIconGlyph
                fontSize: 12
                visible: control.checked || control.effectiveIconGlyph.length > 0
                iconColor: control.checked ? Theme.accent
                                           : (control.enabled ? Theme.textPrimary : Theme.textDisabled)
                scale: control.checked ? 1 : 0.85
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingEnter
                    }
                }
            }
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
