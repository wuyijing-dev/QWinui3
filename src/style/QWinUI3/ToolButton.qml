import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// ToolButton — Fluent styled ToolButton.
//
//   ToolBar {
//       ToolButton {
//           text: qsTr("Edit")
//           appearance: "subtle"
//           onClicked: startEdit()
//       }
//   }
//
// @notes
//   Style-only Fluent chrome. appearance: subtle | outline | ghost | "" (subtle default — 3.11).

T.ToolButton {
    id: control

    // Visual variant: subtle | outline | ghost | "" (subtle) — 3.11
    property string appearance: ""

    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.onPressAction: if (control.enabled) control.clicked()

    readonly property string _mode: {
        var a = String(appearance || "").toLowerCase()
        if (a === "outline" || a === "ghost" || a === "subtle")
            return a
        return "subtle"
    }

    implicitWidth: Math.max(32, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(32, implicitContentHeight + topPadding + bottomPadding)

    padding: 6
    spacing: 4
    font.pixelSize: Theme.fontBody
    hoverEnabled: true
    flat: true

    PointerCursor { shape: Qt.PointingHandCursor }

    contentItem: Text {
        text: control.text
        font: control.font
        color: {
            if (!control.enabled)
                return Theme.textDisabled
            if (control.checked)
                return Theme.accent
            return Theme.textPrimary
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        scale: control.down && !Theme.reducedMotion ? 0.94 : 1
        Behavior on color {
            enabled: !Theme.reducedMotion
                     && (control.hovered || control.down || control.checked)
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }
        Behavior on scale {
            enabled: !Theme.reducedMotion && (control.down || control.hovered)
            NumberAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }
    }

    background: Rectangle {
        radius: Theme.cornerControl
        scale: control.down && !Theme.reducedMotion ? 0.96 : 1
        border.width: control._mode === "outline" ? 1 : 0
        border.color: control.enabled
                      ? (control.checked ? Theme.accent : Theme.strokeControl)
                      : Theme.strokeControl
        color: {
            if (!control.enabled)
                return control.checked ? Theme.fillSubtle : "transparent"
            if (control._mode === "ghost") {
                if (control.down || control.checked)
                    return Theme.fillSubtleTertiary
                if (control.hovered)
                    return Theme.fillSubtleSecondary
                return "transparent"
            }
            if (control._mode === "outline") {
                if (control.down || control.checked)
                    return Theme.fillSubtleTertiary
                if (control.hovered)
                    return Theme.fillSubtleSecondary
                return "transparent"
            }
            // subtle
            if (control.down || control.checked)
                return Theme.fillSubtle
            if (control.hovered)
                return Theme.fillSubtleSecondary
            return control.checked ? Theme.fillSubtle : "transparent"
        }
        Behavior on color {
            enabled: !Theme.reducedMotion
                     && (control.hovered || control.down || control.checked)
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }
        Behavior on scale {
            enabled: !Theme.reducedMotion && (control.down || control.hovered)
            NumberAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }
        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
        }
    }
}
