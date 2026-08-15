import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QWinUI3.Theme

// AppBarButton — CommandBar icon button with label position overrides.
//
//   AppBarButton {
//       text: qsTr("Add")
//       symbol: FluentIcons.Add
//   }
//
// @notes
//   CommandBar icon+label button; symbol / labelPosition for layout.

IconicButton {
    id: control

    // Override CommandBar.defaultLabelPosition when set (bottom | right | collapsed)
    property string labelPosition: ""

    // Resolved label position
    readonly property string effectiveLabelPosition: {
        if (control.labelPosition.length)
            return control.labelPosition
        var p = control.parent
        while (p) {
            if (typeof p.effectiveLabelPosition === "string")
                return p.effectiveLabelPosition
            if (typeof p.defaultLabelPosition === "string")
                return p.defaultLabelPosition
            p = p.parent
        }
        return "bottom"
    }

    readonly property bool _showLabel: effectiveLabelPosition !== "collapsed" && text.length > 0
    readonly property bool _labelRight: effectiveLabelPosition === "right"

    implicitWidth: {
        if (!_showLabel)
            return Math.max(40, Theme.controlHeight)
        if (_labelRight)
            return Math.max(72, contentItem.implicitWidth + leftPadding + rightPadding)
        return Math.max(64, contentItem.implicitWidth + leftPadding + rightPadding)
    }
    implicitHeight: {
        if (!_showLabel || _labelRight)
            return Math.max(Theme.controlHeight, contentItem.implicitHeight + topPadding + bottomPadding)
        return Math.max(Theme.controlHeight + 20, contentItem.implicitHeight + topPadding + bottomPadding)
    }
    leftPadding: _showLabel && _labelRight ? 10 : 8
    rightPadding: leftPadding
    topPadding: _showLabel && !_labelRight ? 6 : 4
    bottomPadding: topPadding
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontCaption
    checkable: false
    iconSize: 18

    contentItem: GridLayout {
        columns: control._labelRight ? 2 : 1
        rows: control._labelRight ? 1 : 2
        columnSpacing: 8
        rowSpacing: 4
        flow: GridLayout.LeftToRight

        Text {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            text: control.effectiveIconGlyph
            font.family: Theme.fontFamilyIcon
            font.pixelSize: control.iconSize
            color: {
                if (!control.enabled)
                    return Theme.textDisabled
                if (control.highlighted || control.checked)
                    return Theme.accent
                return Theme.textPrimary
            }
            scale: control.down ? 0.92 : 1
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionFast)
                }
            }
            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }
        Text {
            Layout.alignment: control._labelRight ? (Qt.AlignLeft | Qt.AlignVCenter)
                                                  : Qt.AlignHCenter
            Layout.fillWidth: control._labelRight
            visible: control._showLabel
            text: control.text
            font.family: control.font.family
            font.pixelSize: control.font.pixelSize
            color: control.enabled ? Theme.textPrimary : Theme.textDisabled
            elide: Text.ElideRight
            horizontalAlignment: control._labelRight ? Text.AlignLeft : Text.AlignHCenter
            maximumLineCount: 1
        }
    }

    background: Rectangle {
        radius: Theme.cornerControl
        color: {
            if (control.flat && !control.hovered && !control.down && !control.checked)
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
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
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
