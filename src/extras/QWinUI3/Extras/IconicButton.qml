import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// IconicButton — Base icon + label button used by AppBar* / IconButton.
//
//   IconicButton {
//       id: btn
//       text: qsTr("Open")
//       symbol: FluentIcons.Open
//       onClicked: open()
//   }
//
// @notes
//   Button with leading Fluent symbol + text. Prefer IconButton / AppBarButton
//   for specialized layouts; this type is usable standalone.
//   microMotionEnabled / hoverScale / pressScale / effectiveIconScale (1.49).

T.AbstractButton {
    id: control

    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""
    // Icon size in px
    property real iconSize: 16
    // Tooltip text
    property string toolTipText: ""
    // Show avatar badge
    property bool badgeVisible: false
    // Numeric badge value (-1 hides count)
    property int badgeValue: 0
    // Badge caption
    property string badgeText: ""
    // Badge max before +
    property int badgeMaxValue: 99
    // Emphasized / selected chrome
    property bool highlighted: false
    // Flat chrome without fill
    property bool flat: true
    // WinUI-style glyph hover/press micro-motion (1.49); off when Theme.reducedMotion
    property bool microMotionEnabled: true
    // Hover glyph scale when microMotionEnabled
    property real hoverScale: 1.06
    // Pressed glyph scale when microMotionEnabled
    property real pressScale: 0.92

    // Resolved glyph scale (1 when reduced motion / disabled)
    readonly property real effectiveIconScale: {
        if (!control.microMotionEnabled || Theme.reducedMotion || !control.enabled)
            return 1
        if (control.down)
            return control.pressScale
        if (control.hovered)
            return control.hoverScale
        return 1
    }

    // Resolved glyph string
    readonly property string effectiveIconGlyph: {
        var fromSymbol = IconSource.resolve(control.symbol, "")
        if (fromSymbol.length)
            return fromSymbol
        var fromGlyph = IconSource.resolve(control.iconGlyph, "")
        if (fromGlyph.length)
            return fromGlyph
        return FluentIcons.Placeholder
    }

    readonly property string _badgeLabel: {
        if (badgeText.length)
            return badgeText
        if (badgeValue <= 0)
            return ""
        if (badgeValue > badgeMaxValue)
            return badgeMaxValue + "+"
        return String(badgeValue)
    }

    hoverEnabled: true
    focusPolicy: Qt.StrongFocus

    PointerCursor { shape: Qt.PointingHandCursor }

    implicitWidth: Math.max(Theme.controlMinWidth,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(Theme.controlHeight,
                             contentItem.implicitHeight + topPadding + bottomPadding)
    leftPadding: Theme.paddingControlH
    rightPadding: Theme.paddingControlH
    topPadding: Theme.paddingControlV
    bottomPadding: Theme.paddingControlV
    font.pixelSize: Theme.fontBody
    ToolTip.visible: hovered && toolTipText.length > 0
    ToolTip.text: toolTipText
    Accessible.role: Accessible.Button
    Accessible.name: {
        if (toolTipText.length)
            return toolTipText
        if (control.text && control.text.length)
            return control.text
        return qsTr("Icon button")
    }
    Accessible.checkable: checkable
    Accessible.checked: checked
    Accessible.onPressAction: if (enabled) clicked()

    contentItem: RowLayout {
        spacing: Theme.spacing
        FontIcon {
            visible: control.effectiveIconGlyph.length > 0
            glyph: control.effectiveIconGlyph
            fontSize: control.iconSize
            selected: control.highlighted || control.checked
            iconColor: Theme.textPrimary
            microMotionEnabled: control.microMotionEnabled
            hoverScale: control.hoverScale
            pressScale: control.pressScale
            enabled: control.enabled
            Layout.alignment: Qt.AlignVCenter
        }
        Text {
            visible: control.text && control.text.length > 0
            text: control.text
            font: control.font
            color: control.enabled ? Theme.textPrimary : Theme.textDisabled
            elide: Text.ElideRight
            Layout.alignment: Qt.AlignVCenter
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
            width: Math.max(16, badgeLbl.implicitWidth + 8)
            height: 16
            radius: 8
            color: Theme.systemCritical
            z: 2
            Text {
                id: badgeLbl
                anchors.centerIn: parent
                text: control._badgeLabel
                color: Theme.textOnAccent
                font.pixelSize: 10
                font.weight: Theme.fontWeightSemiBold
            }
        }
    }
}
