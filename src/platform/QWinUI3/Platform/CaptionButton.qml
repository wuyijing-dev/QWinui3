import QtQuick
import QtQuick.Controls
import QWinUI3.Theme

AbstractButton {
    id: control

    property string glyph: ""
    property bool destructive: false
    // When native chrome owns hit-testing, drive visuals from WindowHelper.
    property bool forceHovered: false
    property bool forcePressed: false
    property bool interactive: true

    readonly property bool visualHovered: forceHovered || (interactive && hovered)
    readonly property bool visualPressed: forcePressed || (interactive && down)

    implicitWidth: 46
    implicitHeight: 32
    hoverEnabled: interactive
    focusPolicy: Qt.NoFocus
    // When interactive is false, native WM_NCHITTEST owns input;
    // keep the control enabled so chrome colors stay active.

    contentItem: Text {
        text: control.glyph
        font.family: Theme.fontFamilyIcon
        font.pixelSize: 10
        color: {
            if (!control.enabled)
                return Theme.textDisabled
            if (control.destructive && control.visualHovered)
                return "#FFFFFF"
            return Theme.textPrimary
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        color: {
            if (!control.enabled)
                return "transparent"
            if (control.destructive && control.visualPressed)
                return "#C50F1F"
            if (control.destructive && control.visualHovered)
                return "#E81123"
            if (control.visualPressed)
                return Theme.fillSubtleTertiary
            if (control.visualHovered)
                return Theme.fillSubtle
            return "transparent"
        }
        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }
    }
}
