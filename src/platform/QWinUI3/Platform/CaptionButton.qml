import QtQuick
import QtQuick.Controls
import QWinUI3.Theme
// CaptionButton — Native-chrome caption min/max/close button.
//
//   CaptionButton { glyph: FluentIcons.ChromeClose }
//
//   // --- API ---
//   // inherits AbstractButton (+ Qt Quick Controls base API)


AbstractButton {
    id: control

    Accessible.role: Accessible.Button
    Accessible.name: control.text.length ? control.text : qsTr("Caption button")

    // Fluent glyph drawn in the button
    property string glyph: ""
    // Use destructive (close) colors
    property bool destructive: false
    // Drive hover visuals from outside
    property bool forceHovered: false
    // Drive pressed visuals from outside
    property bool forcePressed: false
    // Enable hover / click interaction
    property bool interactive: true

    // Rest background
    property color backgroundColor: "transparent"
    // Hover background
    property color hoverColor: Theme.fillSubtle
    // Pressed background
    property color pressedColor: Theme.fillSubtleTertiary
    // Glyph / content color
    property color foregroundColor: Theme.textPrimary

    // Effective hovered visual
    readonly property bool visualHovered: forceHovered || (interactive && hovered)
    // Effective pressed visual
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
