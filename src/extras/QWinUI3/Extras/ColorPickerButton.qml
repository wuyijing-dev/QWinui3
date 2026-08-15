import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// ColorPickerButton — Color swatch button that opens ColorPicker.
//
//   ColorPickerButton { selectedColor: Theme.accent }

T.AbstractButton {
    id: control

    // Currently selected color
    property color selectedColor: Theme.accent
    // Picker flyout open
    property bool pickerOpen: false
    // Open / visible state
    property alias isOpen: control.pickerOpen
    // Show alpha channel editor
    property bool showAlpha: false
    // Show hex text on the button
    property bool showHexLabel: true
    // MenuFlyout placement
    property int flyoutPlacement: Qt.AlignBottom
    // Emitted when a color is chosen
    signal colorChosen(color color)

    // Formatted hex color text
    readonly property string hexText: {
        // Hex2
        function hex2(n) {
            var v = Math.max(0, Math.min(255, Math.round(n * 255)))
            var s = v.toString(16).toUpperCase()
            return s.length < 2 ? ("0" + s) : s
        }
        var c = selectedColor
        var base = "#" + hex2(c.r) + hex2(c.g) + hex2(c.b)
        if (showAlpha && c.a < 0.999)
            return base + hex2(c.a)
        return base
    }

    implicitWidth: Math.max(120, contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Theme.controlHeight
    leftPadding: 10
    rightPadding: 10
    hoverEnabled: true
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    text: qsTr("Color")
    Accessible.role: Accessible.Button
    Accessible.name: text + " " + hexText
    Accessible.description: qsTr("Selected color %1").arg(hexText)

    scale: down && !Theme.reducedMotion ? 0.98 : 1
    Behavior on scale {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingStandard
        }
    }

    // Open
    function open() { pickerOpen = true }
    // Close
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
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation { duration: Theme.duration(Theme.motionNormal) }
            }
        }
        Text {
            text: control.text
            font: control.font
            color: control.enabled ? Theme.textPrimary : Theme.textDisabled
            verticalAlignment: Text.AlignVCenter
        }
        Text {
            visible: control.showHexLabel
            text: control.hexText
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
            verticalAlignment: Text.AlignVCenter
        }
        Text {
            text: FluentIcons.ChevronDown
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

    background: Item {
        implicitWidth: Math.max(120, control.contentItem.implicitWidth + 20)
        implicitHeight: Theme.controlHeight
        Rectangle {
            anchors.fill: parent
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

    Popup {
        id: popup
        x: {
            switch (control.flyoutPlacement) {
            case Qt.AlignRight: return control.width + 4
            case Qt.AlignLeft: return -implicitWidth - 4
            default: return 0
            }
        }
        y: {
            switch (control.flyoutPlacement) {
            case Qt.AlignTop: return -implicitHeight - 4
            case Qt.AlignRight:
            case Qt.AlignLeft: return 0
            default: return control.height + 4
            }
        }
        padding: 0
        visible: control.pickerOpen
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        onClosed: control.pickerOpen = false
        transformOrigin: {
            switch (control.flyoutPlacement) {
            case Qt.AlignTop: return Item.Bottom
            case Qt.AlignLeft: return Item.Right
            case Qt.AlignRight: return Item.Left
            default: return Item.Top
            }
        }

        background: ElevatedChrome {
            color: Theme.bgCardElevated
            radius: Theme.cornerOverlay
            borderColor: Theme.strokeCard
            borderWidth: 1
            elevation: 6
            shadowOpacity: Theme.dark ? 0.28 : 0.14
        }

        contentItem: ColorPicker {
            selectedColor: control.selectedColor
            showAlpha: control.showAlpha
            onColorChosen: function (c) {
                control.selectedColor = c
                control.colorChosen(c)
            }
        }

        enter: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0; to: 1
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingEnter
            }
            NumberAnimation {
                property: "scale"
                from: 0.96; to: 1
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingEnter
            }
        }
        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1; to: 0
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingExit
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
