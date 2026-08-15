import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Exclusive radio-style MenuFlyout item.
MenuItem {
    id: control

    property string iconGlyph: ""
    property string keyboardAcceleratorText: ""

    checkable: true
    autoExclusive: true
    implicitWidth: Math.max(200, contentRow.implicitWidth + leftPadding + rightPadding)
    leftPadding: 12
    rightPadding: 12
    spacing: Theme.spacing

    contentItem: RowLayout {
        id: contentRow
        spacing: control.spacing

        Item {
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
            Layout.alignment: Qt.AlignVCenter

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

        Text {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            text: control.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            elide: Text.ElideRight
            color: control.enabled ? Theme.textPrimary : Theme.textDisabled
        }

        Text {
            visible: control.keyboardAcceleratorText.length > 0
            text: control.keyboardAcceleratorText
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }
    }
}
