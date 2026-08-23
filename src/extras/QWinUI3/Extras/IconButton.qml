import QtQuick
import QtQuick.Controls
import QWinUI3.Theme

// IconButton — Icon-only button helper.
//
//   IconButton {
//       id: btn
//       symbol: FluentIcons.Settings
//       accentIcon: true   // accent-colored icon (alias of highlighted; ratings, favorites)
//       loading: true       // inline ring; defers press animation (2.67 — I5/M11)
//       onClicked: openSettings()
//   }
//
// @notes
//   Icon-only Button helper; set symbol / iconGlyph; inherits clicked().
//   Glyph hover/press micro-motion via FontIcon (1.49); Theme.reducedMotion disables.
//   Touch floor ≥ 40×40 logical px (M11).

IconicButton {
    id: control

    // Accent-colored icon (rating stars, favorited toolbar). Alias of highlighted.
    property alias accentIcon: control.highlighted
    // Async action — shows ProgressRing, disables click (2.67 — I5/M11)
    property bool loading: false

    // When true, the icon behaves like a toggle (uses `checked` state).
    property bool toggleMode: false
    checkable: toggleMode

    hoverEnabled: enabled && !loading
    opacity: enabled && !loading ? 1 : (enabled ? 0.72 : 1)

    Accessible.role: Accessible.Button
    Accessible.name: {
        if (toolTipText.length)
            return toolTipText
        if (control.text.length)
            return control.text
        return qsTr("Icon button")
    }
    Accessible.description: loading ? qsTr("Loading") : ""

    implicitWidth: Math.max(Theme.dp(40), Theme.controlHeight)
    implicitHeight: Math.max(Theme.dp(40), Theme.controlHeight)
    padding: 0

    contentItem: Item {
        implicitWidth: control.iconSize * 1.25
        implicitHeight: control.iconSize * 1.25

        FontIcon {
            anchors.centerIn: parent
            visible: !control.loading
            glyph: control.effectiveIconGlyph
            fontSize: control.iconSize
            selected: control.highlighted || control.checked
            iconColor: Theme.textPrimary
            microMotionEnabled: control.microMotionEnabled && !control.loading
            hoverScale: control.hoverScale
            pressScale: control.pressScale
            enabled: control.enabled
        }

        ProgressRing {
            anchors.centerIn: parent
            visible: control.loading
            indeterminate: true
            isActive: control.loading
            size: Theme.dp(16)
            strokeWidth: 2
            showValue: false
            Accessible.ignored: true
        }
    }

    background: Rectangle {
        radius: width / 2
        scale: control.down && !Theme.reducedMotion && !control.loading ? 0.94 : 1
        color: {
            if (control.flat && !control.hovered && !control.down && !control.checked
                    && !control.visualFocus)
                return "transparent"
            if (!control.enabled)
                return Theme.fillControlDisabled
            if (control.down || control.checked)
                return Theme.fillSubtleTertiary
            if (control.hovered)
                return Theme.fillSubtle
            return Theme.fillControl
        }
        border.width: control.flat ? 0 : 1
        border.color: Theme.strokeControl

        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.motionMs("fast")
                easing.type: Theme.motionEasing("standard")
            }
        }
        Behavior on scale {
            enabled: !Theme.reducedMotion && !control.loading
            NumberAnimation {
                duration: Theme.motionMs("fast")
                easing.type: Theme.motionEasing("standard")
            }
        }

        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
            frameRadius: width / 2
        }

        Rectangle {
            visible: control.badgeVisible || control._badgeLabel.length > 0
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: -2
            width: Math.max(16, badgeLabel.implicitWidth + 8)
            height: 16
            radius: 8
            color: Theme.systemCritical
            z: 2

            Text {
                id: badgeLabel
                anchors.centerIn: parent
                text: control._badgeLabel.length ? control._badgeLabel : ""
                font.family: Theme.fontFamily
                font.pixelSize: 10
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textOnAccent
                visible: text.length > 0
            }
        }
    }
}
