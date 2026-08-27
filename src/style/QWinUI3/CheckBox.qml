import QtQuick
import QtQuick.Templates as T
import QtQuick.Shapes
import QWinUI3.Theme

// CheckBox — Fluent / WinUI 3 CheckBox (description, three-state).
//
//   CheckBox {
//       text: qsTr("Remember me")
//       description: qsTr("Stay signed in on this device.")
//       checked: true
//   }
//
//   CheckBox {
//       text: qsTr("Select all")
//       tristate: true   // or isThreeState: true
//       checkState: Qt.PartiallyChecked
//   }
//
// @notes
//   Fluent chrome with optional description caption. isThreeState aliases Qt tristate.

T.CheckBox {
    id: control

    // Supporting caption under the label (Fluent settings pattern)
    property string description: ""
    // WinUI Header alias of text
    property alias header: control.text
    // WinUI IsThreeState alias of tristate
    property alias isThreeState: control.tristate

    Accessible.role: Accessible.CheckBox
    Accessible.name: control.text.length ? control.text : qsTr("Check box")
    Accessible.description: control.description
    Accessible.checkable: true
    Accessible.checked: control.checkState === Qt.Checked
    Accessible.onToggleAction: if (control.enabled) control.toggle()

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    spacing: Theme.spacing
    padding: 0
    font.pixelSize: Theme.fontBody
    hoverEnabled: true

    PointerCursor { shape: Qt.PointingHandCursor }

    indicator: Item {
        implicitWidth: Theme.checkSize
        implicitHeight: Theme.checkSize
        x: control.mirrored ? control.width - width - control.rightPadding
                            : control.leftPadding
        y: control.topPadding
           + Math.max(0, (Theme.fontBody + 4 - height) / 2)

        Rectangle {
            id: box
            anchors.fill: parent
            radius: 4
            color: {
                if (control.checkState !== Qt.Unchecked) {
                    if (!control.enabled)
                        return Theme.dark ? "#28FFFFFF" : "#37000000"
                    if (control.down)
                        return Qt.tint(Theme.accent, Theme.dark ? Qt.rgba(0, 0, 0, 0.2) : Qt.rgba(1, 1, 1, 0.2))
                    if (control.hovered)
                        return Qt.tint(Theme.accent, Theme.dark ? Qt.rgba(0, 0, 0, 0.1) : Qt.rgba(1, 1, 1, 0.1))
                    return Theme.accent
                }
                if (!control.enabled)
                    return Theme.fillControlDisabled
                if (control.down)
                    return Theme.fillControlTertiary
                if (control.hovered)
                    return Theme.fillControlSecondary
                return Theme.bgControlRest
            }
            border.width: control.checkState === Qt.Unchecked ? 1 : 0
            border.color: {
                if (control.checkState !== Qt.Unchecked)
                    return "transparent"
                if (!control.enabled)
                    return Theme.strokeControl
                if (control.hovered)
                    return Theme.accent
                return Theme.strokeControlStrong
            }
            scale: control.down ? 0.9 : 1

            Behavior on color {
                enabled: !Theme.reducedMotion
                         && (control.hovered || control.down
                             || control.checkState !== Qt.Unchecked)
                ColorAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on scale {
                enabled: !Theme.reducedMotion && (control.hovered || control.down)
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on border.width {
                enabled: !Theme.reducedMotion
                         && (control.hovered || control.down
                             || control.checkState !== Qt.Unchecked)
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }

        Shape {
            id: checkMark
            anchors.centerIn: parent
            width: 12
            height: 12
            opacity: control.checkState === Qt.Checked ? 1 : 0
            scale: control.checkState === Qt.Checked ? 1 : 0
            antialiasing: true
            preferredRendererType: Shape.CurveRenderer
            visible: opacity > 0.01

            Behavior on opacity {
                enabled: !Theme.reducedMotion
                         && (control.hovered || control.down
                             || control.checkState === Qt.Checked)
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on scale {
                enabled: !Theme.reducedMotion
                         && (control.hovered || control.down
                             || control.checkState === Qt.Checked)
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }

            ShapePath {
                strokeWidth: 1.5
                strokeColor: {
                    if (control.down)
                        return Theme.textOnAccentSecondary
                    if (!control.enabled && Theme.dark)
                        return Theme.textDisabled
                    return Theme.dark ? "#000000" : "#FFFFFF"
                }
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.RoundJoin
                startX: 1; startY: 6
                PathLine { x: 5; y: 10 }
                PathLine { x: 11; y: 3 }
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: 8
            height: 1.5
            radius: 1
            opacity: control.checkState === Qt.PartiallyChecked ? 1 : 0
            scale: control.checkState === Qt.PartiallyChecked ? 1 : 0.5
            color: Theme.dark ? "#000000" : "#FFFFFF"
            visible: opacity > 0.01

            Behavior on opacity {
                enabled: !Theme.reducedMotion
                         && (control.hovered || control.down
                             || control.checkState === Qt.PartiallyChecked)
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on scale {
                enabled: !Theme.reducedMotion
                         && (control.hovered || control.down
                             || control.checkState === Qt.PartiallyChecked)
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
        }

        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
            frameRadius: 4
        }
    }

    contentItem: Item {
        readonly property real _indGap: control.indicator
                                        ? control.indicator.width + control.spacing : 0
        implicitWidth: labelCol.implicitWidth + _indGap
        implicitHeight: Math.max(Theme.checkSize, labelCol.implicitHeight)

        Column {
            id: labelCol
            x: control.mirrored ? 0 : parent._indGap
            width: Math.max(0, parent.width - parent._indGap)
            spacing: 2

            Text {
                width: parent.width
                visible: control.text.length > 0
                text: control.text
                font: control.font
                color: control.enabled ? Theme.textPrimary : Theme.textDisabled
                wrapMode: Text.WordWrap
            }
            Text {
                width: parent.width
                visible: control.description.length > 0
                text: control.description
                font.pixelSize: Theme.fontCaption
                color: control.enabled ? Theme.textSecondary : Theme.textDisabled
                wrapMode: Text.WordWrap
            }
        }
    }
}
