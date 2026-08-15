import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// WinUI-style keyboard key chrome (accelerator hint). Not Qt Virtual Keyboard.
T.AbstractButton {
    id: root

    // Display label for the key (e.g. "Ctrl", "P", "Esc").
    property string keyText: ""
    // Optional Segoe Fluent glyph instead of / beside keyText.
    property string iconGlyph: ""
    // "small" | "medium" | "large"
    property string size: "medium"
    // Filled accent chrome for primary shortcuts.
    property bool emphasized: false
    property string toolTipText: ""
    property real minWidth: {
        switch (size) {
        case "small": return 22
        case "large": return 36
        default: return 28
        }
    }

    readonly property int _padH: size === "small" ? 6 : (size === "large" ? 10 : 8)
    readonly property int _padV: size === "small" ? 2 : (size === "large" ? 6 : 4)
    readonly property int _fontPx: size === "small" ? 10 : (size === "large" ? Theme.fontBody : Theme.fontCaption)
    readonly property int _iconPx: size === "small" ? 10 : (size === "large" ? 14 : 12)
    readonly property int _radius: size === "small" ? 3 : 4

    hoverEnabled: true
    focusPolicy: Qt.TabFocus
    ToolTip.visible: hovered && toolTipText.length > 0
    ToolTip.text: toolTipText
    ToolTip.delay: 400
    Accessible.name: toolTipText.length ? toolTipText : (keyText.length ? keyText : iconGlyph)
    implicitWidth: Math.max(minWidth, contentRow.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(size === "small" ? 22 : (size === "large" ? 34 : 28),
                             contentRow.implicitHeight + topPadding + bottomPadding)
    leftPadding: _padH
    rightPadding: _padH
    topPadding: _padV
    bottomPadding: _padV
    font.family: Theme.fontFamily
    font.pixelSize: _fontPx

    scale: down && enabled && !Theme.reducedMotion ? 0.96 : 1
    Behavior on scale {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingStandard
        }
    }

    contentItem: Item {
        implicitWidth: contentRow.implicitWidth
        implicitHeight: contentRow.implicitHeight
        Row {
            id: contentRow
            anchors.centerIn: parent
            spacing: 4
            Text {
                visible: root.iconGlyph.length > 0
                text: root.iconGlyph
                font.family: Theme.fontFamilyIcon
                font.pixelSize: root._iconPx
                color: label.color
                verticalAlignment: Text.AlignVCenter
            }
            Text {
                id: label
                visible: root.keyText.length > 0
                text: root.keyText
                font.family: root.font.family
                font.pixelSize: root.font.pixelSize
                font.weight: Theme.fontWeightSemiBold
                color: {
                    if (!root.enabled)
                        return Theme.textDisabled
                    if (root.emphasized)
                        return Theme.textOnAccent
                    return Theme.textPrimary
                }
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    background: Rectangle {
        radius: root._radius
        color: {
            if (!root.enabled)
                return Theme.fillControlDisabled
            if (root.emphasized) {
                if (root.down)
                    return Theme.accentDark1
                if (root.hovered)
                    return Theme.accentLight1
                return Theme.accent
            }
            if (root.down)
                return Theme.fillControlTertiary
            if (root.hovered)
                return Theme.fillControlSecondary
            return Theme.fillSubtle
        }
        border.width: root.emphasized ? 0 : 1
        border.color: root.enabled ? Theme.strokeControl : Theme.strokeControlStrong
        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }

        // Soft “key bed” shadow
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: root.size === "small" ? 1 : 2
            visible: root.enabled && !root.emphasized && !root.down
            color: Theme.dark ? "#22000000" : "#14000000"
            radius: 1
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: -3
            radius: parent.radius + 2
            color: "transparent"
            border.width: root.visualFocus ? Theme.strokeFocusOuter : 0
            border.color: Theme.focusOuter
        }
    }
}
