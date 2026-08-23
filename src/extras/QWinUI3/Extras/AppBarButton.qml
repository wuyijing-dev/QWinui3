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
//   isCompact collapses the label (WinUI IsCompact); keyboardAcceleratorText shows a shortcut hint.
//   barCompact (from CommandBar.compact) shrinks icon-only hit target toward ~40px (Edge-like).

IconicButton {
    id: control

    // Override CommandBar label position when set (bottom | right | collapsed)
    property string labelPosition: ""
    // Injected by CommandBar (do not parent-walk)
    property string barLabelPosition: "bottom"
    // Injected by CommandBar.compact — denser icon-only sizing
    property bool barCompact: false
    // WinUI IsCompact — hide label, icon-only
    property bool isCompact: false
    // Shortcut hint shown under/beside the label (WinUI KeyboardAcceleratorText)
    property string keyboardAcceleratorText: ""

    // Resolved label position
    readonly property string effectiveLabelPosition: {
        if (control.isCompact || control.barCompact)
            return "collapsed"
        if (control.labelPosition.length)
            return control.labelPosition
        return control.barLabelPosition.length ? control.barLabelPosition : "bottom"
    }

    readonly property bool _showLabel: effectiveLabelPosition !== "collapsed" && text.length > 0
    readonly property bool _labelRight: effectiveLabelPosition === "right"
    readonly property bool _showAccel: keyboardAcceleratorText.length > 0 && _showLabel
    readonly property bool _dense: control.isCompact || control.barCompact

    implicitWidth: {
        if (!_showLabel)
            return _dense ? 40 : Math.max(40, Theme.controlHeight)
        if (_labelRight)
            return Math.max(_dense ? 64 : 72, contentItem.implicitWidth + leftPadding + rightPadding)
        return Math.max(_dense ? 56 : 64, contentItem.implicitWidth + leftPadding + rightPadding)
    }
    implicitHeight: {
        if (!_showLabel || _labelRight)
            return Math.max(_dense ? 32 : Theme.controlHeight,
                            contentItem.implicitHeight + topPadding + bottomPadding)
        return Math.max(Theme.controlHeight + (_dense ? 12 : 20),
                        contentItem.implicitHeight + topPadding + bottomPadding)
    }
    leftPadding: _showLabel && _labelRight ? (_dense ? 8 : 10) : (_dense ? 6 : 8)
    rightPadding: leftPadding
    topPadding: _dense ? 4 : 6
    bottomPadding: topPadding
    font.pixelSize: Theme.fontCaption
    checkable: false
    iconSize: _dense ? 16 : 18
    Accessible.role: Accessible.Button
    Accessible.name: {
        if (toolTipText.length)
            return toolTipText
        if (text.length)
            return text
        return qsTr("App bar button")
    }
    Accessible.description: keyboardAcceleratorText

    contentItem: GridLayout {
        columns: control._labelRight ? 2 : 1
        rows: control._labelRight ? 1 : 2
        columnSpacing: 8
        rowSpacing: 2
        flow: GridLayout.LeftToRight

        Item {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredWidth: control.iconSize
            Layout.preferredHeight: control.iconSize
            Layout.row: 0
            Layout.column: 0

            Text {
                anchors.centerIn: parent
                width: control.iconSize
                height: control.iconSize
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
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
                scale: control.effectiveIconScale
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

    background: Rectangle {
        radius: Theme.cornerControl
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
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }

        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
            frameRadius: Theme.cornerControl
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
                font.pixelSize: 10
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textOnAccent
                visible: text.length > 0
            }
        }
    }
}
