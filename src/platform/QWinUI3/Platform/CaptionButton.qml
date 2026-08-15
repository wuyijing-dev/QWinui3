import QtQuick
import QtQuick.Controls
import QWinUI3.Theme
// CaptionButton — Native-chrome caption min/max/close button.
//
//   CaptionButton { glyph: FluentIcons.ChromeClose }


AbstractButton {
    id: control

    property string glyph: ""
    property bool destructive: false
    property bool forceHovered: false
    property bool forcePressed: false
    property bool interactive: true

    property color backgroundColor: "transparent"
    property color hoverColor: Theme.fillSubtle
    property color pressedColor: Theme.fillSubtleTertiary
    property color foregroundColor: Theme.textPrimary

    readonly property bool visualHovered: forceHovered || (interactive && hovered)
    readonly property bool visualPressed: forcePressed || (interactive && down)

    implicitWidth: 46
    implicitHeight: 32
    hoverEnabled: interactive
    focusPolicy: Qt.NoFocus

    contentItem: Text {
        text: control.glyph
        font.family: Theme.fontFamilyIcon
        font.pixelSize: 10
        color: {
            if (!control.enabled)
                return Theme.textDisabled
            if (control.destructive && control.visualHovered)
                return "#FFFFFF"
            return control.foregroundColor
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        opacity: Theme.highContrast && !control.enabled ? 0.5 : 1
    }

    background: Rectangle {
        color: {
            if (!control.enabled)
                return "transparent"
            if (control.destructive && control.visualPressed)
                return control.pressedColor
            if (control.destructive && control.visualHovered)
                return control.hoverColor
            if (control.visualPressed)
                return control.pressedColor
            if (control.visualHovered)
                return control.hoverColor
            return control.backgroundColor
        }
        border.width: Theme.highContrast ? 1 : 0
        border.color: Theme.highContrast ? Theme.strokeControlStrong : "transparent"
        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }
    }
}
