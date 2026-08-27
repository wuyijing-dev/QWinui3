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
    Accessible.name: control.text.length ? control.text : control._defaultAccessibleName

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

    // Sensible defaults for known chrome glyphs when text is empty (1.29).
    readonly property string _defaultAccessibleName: {
        if (glyph === FluentIcons.ChromeMinimize)
            return qsTr("Minimize")
        if (glyph === FluentIcons.ChromeMaximize)
            return qsTr("Maximize")
        if (glyph === FluentIcons.ChromeRestore)
            return qsTr("Restore")
        if (glyph === FluentIcons.ChromeClose || glyph === FluentIcons.ChromeCloseAlt)
            return qsTr("Close")
        return qsTr("Caption button")
    }

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
        font: Theme.iconFontFor(10)
        color: {
            if (!control.enabled)
                return Theme.textDisabled
            if (control.destructive && control.visualHovered)
                return "#FFFFFF"
            return control.foregroundColor
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        // Win11 title-bar glyph dip on press (2.67 — I10)
        opacity: {
            if (Theme.highContrast && !control.enabled)
                return 0.5
            if (control.visualPressed && control.enabled)
                return 0.72
            return 1
        }
        Behavior on opacity {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.motionMs("fast")
                easing.type: Theme.motionEasing("standard")
            }
        }
        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.motionMs("fast")
                easing.type: Theme.motionEasing("standard")
            }
        }
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
