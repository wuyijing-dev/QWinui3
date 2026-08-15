import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Effects
import QWinUI3.Theme

// Button that previews a color and opens an embedded ColorPicker flyout.
T.AbstractButton {
    id: control

    property color selectedColor: Theme.accent
    property bool pickerOpen: false
    property alias isOpen: control.pickerOpen
    property bool showAlpha: false
    signal colorChosen(color color)

    implicitWidth: Math.max(120, contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Theme.controlHeight
    leftPadding: 10
    rightPadding: 10
    hoverEnabled: true
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    text: qsTr("Color")

    function open() { pickerOpen = true }
    function close() { pickerOpen = false }

    onClicked: pickerOpen = !pickerOpen

    contentItem: RowLayout {
        spacing: 8
        Rectangle {
            Layout.preferredWidth: 18
            Layout.preferredHeight: 18
            radius: 4
            color: control.selectedColor
            border.width: 1
            border.color: Theme.strokeControl
        }
        Text {
            text: control.text
            font: control.font
            color: control.enabled ? Theme.textPrimary : Theme.textDisabled
            verticalAlignment: Text.AlignVCenter
        }
        Text {
            text: "\uE70D"
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 10
            color: Theme.textSecondary
            rotation: control.pickerOpen ? 180 : 0
            Behavior on rotation {
                enabled: !Theme.reducedMotion
                NumberAnimation { duration: Theme.duration(Theme.motionNormal) }
            }
        }
    }

    background: Rectangle {
        radius: Theme.cornerControl
        color: {
            if (!control.enabled)
                return Theme.fillControlDisabled
            if (control.down || control.pickerOpen)
                return Theme.fillControlTertiary
            if (control.hovered)
                return Theme.fillControlSecondary
            return Theme.dark ? "#0FFFFFFF" : "#FFFFFF"
        }
        border.width: 1
        border.color: Theme.strokeControl
        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation { duration: Theme.duration(Theme.motionFast) }
        }
    }

    Popup {
        id: popup
        y: control.height + 4
        padding: 0
        visible: control.pickerOpen
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        onClosed: control.pickerOpen = false
        transformOrigin: Item.Top

        background: Rectangle {
            color: Theme.bgCardElevated
            radius: Theme.cornerOverlay
            border.width: 1
            border.color: Theme.strokeCard
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowOpacity: Theme.dark ? 0.28 : 0.14
                shadowColor: "#000000"
                shadowVerticalOffset: 8
                blurMax: 28
                autoPaddingEnabled: true
            }
        }

        contentItem: ColorPicker {
            selectedColor: control.selectedColor
            showAlpha: control.showAlpha
            onColorChosen: function (c) {
                control.selectedColor = c
                control.colorChosen(c)
            }
        }
    }

    onPickerOpenChanged: {
        if (pickerOpen)
            popup.open()
        else
            popup.close()
    }
}
