import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// RoundButton — Fluent styled RoundButton.
//
//   RoundButton {
//       text: "+"
//       appearance: "filled"   // filled | subtle | outline | ghost | "" (standard)
//       loading: false
//       onClicked: add()
//   }
//
// @notes
//   Style chrome. Empty appearance keeps bordered rest chrome; highlighted → accent.
//   loading shows BusyIndicator and blocks click (3.11 / M11).

T.RoundButton {
    id: control

    // Visual variant: filled | subtle | outline | ghost | "" (standard bordered) — 3.11
    property string appearance: ""
    // Async action — inline busy ring, disables click (3.11)
    property bool loading: false

    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: loading ? qsTr("Loading") : ""
    Accessible.onPressAction: if (control.enabled && !loading) control.clicked()

    readonly property string _mode: {
        var a = String(appearance || "").toLowerCase()
        if (a === "subtle" || a === "outline" || a === "ghost" || a === "filled")
            return a
        return control.highlighted ? "filled" : "standard"
    }

    hoverEnabled: enabled && !loading
    opacity: enabled && !loading ? 1 : (enabled ? 0.72 : 1)

    implicitWidth: Math.max(Theme.dp(40), 36, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(Theme.dp(40), 36, implicitContentHeight + topPadding + bottomPadding)

    radius: Math.min(width, height) / 2
    padding: 8
    font.pixelSize: Theme.fontBody

    PointerCursor {
        shape: enabled && !loading ? Qt.PointingHandCursor : Qt.ArrowCursor
    }

    contentItem: Item {
        implicitWidth: Math.max(label.implicitWidth, 16)
        implicitHeight: Math.max(label.implicitHeight, 16)

        BusyIndicator {
            anchors.centerIn: parent
            visible: control.loading
            running: control.loading
            width: Theme.dp(16)
            height: Theme.dp(16)
            Accessible.ignored: true
        }
        Text {
            id: label
            anchors.centerIn: parent
            visible: !control.loading
            text: control.text
            font: control.font
            color: {
                if (control._mode === "filled") {
                    if (!control.enabled)
                        return Theme.textDisabled
                    return Theme.textOnAccent
                }
                return control.enabled ? Theme.textPrimary : Theme.textDisabled
            }
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            scale: control.down && !Theme.reducedMotion && !control.loading ? 0.94 : 1
            Behavior on scale {
                enabled: !Theme.reducedMotion && (control.down || control.hovered) && !control.loading
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }
    }

    background: Rectangle {
        implicitWidth: Theme.dp(40)
        implicitHeight: Theme.dp(40)
        radius: control.radius
        scale: control.down && !Theme.reducedMotion && !control.loading ? 0.94 : 1
        border.width: control._mode === "filled" || control._mode === "ghost" || control._mode === "subtle"
                      ? 0 : 1
        border.color: Theme.strokeControl
        color: {
            if (control._mode === "ghost") {
                if (!control.enabled)
                    return "transparent"
                if (control.down)
                    return Theme.fillSubtleTertiary
                if (control.hovered)
                    return Theme.fillSubtleSecondary
                return "transparent"
            }
            if (control._mode === "subtle") {
                if (!control.enabled)
                    return Theme.fillControlDisabled
                if (control.down)
                    return Theme.fillSubtleTertiary
                if (control.hovered)
                    return Theme.fillSubtle
                return Theme.fillSubtleSecondary
            }
            if (control._mode === "outline") {
                if (!control.enabled)
                    return "transparent"
                if (control.down)
                    return Theme.fillSubtleTertiary
                if (control.hovered)
                    return Theme.fillSubtleSecondary
                return "transparent"
            }
            if (control._mode === "filled") {
                if (!control.enabled)
                    return Theme.fillControlDisabled
                if (control.down)
                    return Qt.tint(Theme.accent, Theme.dark ? Qt.rgba(0, 0, 0, 0.2) : Qt.rgba(1, 1, 1, 0.2))
                if (control.hovered)
                    return Qt.tint(Theme.accent, Theme.dark ? Qt.rgba(0, 0, 0, 0.1) : Qt.rgba(1, 1, 1, 0.1))
                return Theme.accent
            }
            // standard bordered
            if (!control.enabled)
                return Theme.fillControlDisabled
            if (control.down)
                return Theme.fillControlTertiary
            if (control.hovered)
                return Theme.fillControlSecondary
            return Theme.bgControlRest
        }
        Behavior on color {
            enabled: !Theme.reducedMotion
                     && (control.hovered || control.down || control.highlighted) && !control.loading
            ColorAnimation {
                duration: Theme.motionMs("normal")
                easing.type: Theme.motionEasing("standard")
            }
        }
        Behavior on scale {
            enabled: !Theme.reducedMotion && (control.down || control.hovered) && !control.loading
            NumberAnimation {
                duration: Theme.motionMs("fast")
                easing.type: Theme.motionEasing("standard")
            }
        }
        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
            frameRadius: control.radius
        }
        MouseArea {
            anchors.fill: parent
            enabled: control.loading
            z: 20
            onClicked: function (mouse) { mouse.accepted = true }
        }
    }
}
