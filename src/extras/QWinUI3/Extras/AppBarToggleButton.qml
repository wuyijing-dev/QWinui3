import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QWinUI3.Theme

// AppBarToggleButton — Checkable AppBarButton for CommandBar.
//
//   AppBarToggleButton {
//       text: qsTr("Pin")
//       checkable: true
//   }
//
// @notes
//   Checkable AppBarButton for CommandBar toggles.
//   isCompact + keyboardAcceleratorText mirror AppBarButton.

IconicButton {
    id: control

    // bottom | right | collapsed
    property string labelPosition: ""
    // WinUI IsCompact — hide label, icon-only
    property bool isCompact: false
    // Shortcut hint (WinUI KeyboardAcceleratorText)
    property string keyboardAcceleratorText: ""

    // Resolved label position
    readonly property string effectiveLabelPosition: {
        if (control.isCompact)
            return "collapsed"
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
    readonly property bool _showAccel: keyboardAcceleratorText.length > 0 && _showLabel

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
    checkable: true
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontCaption
    iconSize: 18

    contentItem: GridLayout {
        columns: control._labelRight ? 2 : 1
        rows: control._labelRight ? 1 : 2
        columnSpacing: 8
        rowSpacing: 2
        flow: GridLayout.LeftToRight

        Text {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.row: 0
            Layout.column: 0
            text: control.effectiveIconGlyph
            font.family: Theme.fontFamilyIcon
            font.pixelSize: control.iconSize
            color: {
                if (!control.enabled)
                    return Theme.textDisabled
                if (control.checked || control.highlighted)
                    return Theme.accent
                return Theme.textPrimary
            }
            scale: control.down ? 0.92 : 1
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
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
        ColumnLayout {
            Layout.alignment: control._labelRight ? (Qt.AlignLeft | Qt.AlignVCenter)
                                                  : Qt.AlignHCenter
            Layout.fillWidth: control._labelRight
            Layout.row: control._labelRight ? 0 : 1
            Layout.column: control._labelRight ? 1 : 0
            spacing: 0
            visible: control._showLabel

            Text {
                Layout.alignment: control._labelRight ? (Qt.AlignLeft | Qt.AlignVCenter)
                                                      : Qt.AlignHCenter
                Layout.fillWidth: control._labelRight
                text: control.text
                font.family: control.font.family
                font.pixelSize: control.font.pixelSize
                color: control.enabled ? Theme.textPrimary : Theme.textDisabled
                elide: Text.ElideRight
                horizontalAlignment: control._labelRight ? Text.AlignLeft : Text.AlignHCenter
                maximumLineCount: 1
            }
            Text {
                Layout.alignment: control._labelRight ? (Qt.AlignLeft | Qt.AlignVCenter)
                                                      : Qt.AlignHCenter
                visible: control._showAccel
                text: control.keyboardAcceleratorText
                font.family: control.font.family
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
                elide: Text.ElideRight
                horizontalAlignment: control._labelRight ? Text.AlignLeft : Text.AlignHCenter
                maximumLineCount: 1
            }
        }
    }

    background: Item {
        Rectangle {
            anchors.fill: parent
            radius: Theme.cornerControl
            color: {
                if (!control.enabled)
                    return Theme.fillControlDisabled
                if (control.down)
                    return Theme.fillSubtleTertiary
                if (control.checked)
                    return Theme.fillSubtle
                if (control.hovered)
                    return Theme.fillSubtleSecondary
                if (control.flat)
                    return "transparent"
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
        }
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2
            width: control.checked ? Math.min(parent.width - 16, 24) : 0
            height: 3
            radius: 1.5
            color: Theme.accent
            opacity: control.checked ? 1 : 0
            Behavior on width {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on opacity {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                }
            }
        }
    }
}
