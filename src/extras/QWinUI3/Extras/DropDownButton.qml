import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// DropDownButton — Button that opens a MenuFlyout of actions.
//
//   DropDownButton {
//       id: dropDownButton
//       text: qsTr("Options")
//       MenuFlyoutItem { text: qsTr("A") }
//   }
//
//   // --- API ---
//   // methods: open(), close(), showMenu()
//   // dropDownButton.open()
//   // dropDownButton.close()
//   // dropDownButton.showMenu()
//   // inherits AbstractButton (+ Qt Quick Controls base API)

T.AbstractButton {
    id: control

    // Attached / owned Menu
    property alias menu: popupMenu
    // Menu children slot
    default property alias menuData: popupMenu.contentData
    // Emphasized / selected chrome
    property bool highlighted: false
    // MenuFlyout placement
    property int flyoutPlacement: Qt.AlignBottom
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Open / visible state
    property alias isOpen: popupMenu.visible

    // Resolved glyph string
    readonly property string effectiveIconGlyph: IconSource.resolve(symbol, iconGlyph)

    implicitWidth: Math.max(Theme.controlMinWidth,
                            contentItem.implicitWidth + leftPadding + rightPadding + 8)
    implicitHeight: Theme.controlHeight
    leftPadding: Theme.paddingControlH
    rightPadding: Theme.paddingControlH
    topPadding: Theme.paddingControlV
    bottomPadding: Theme.paddingControlV
    spacing: Theme.spacing
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    hoverEnabled: true
    Accessible.role: Accessible.Button
    Accessible.name: control.text.length ? control.text : qsTr("Drop down")
    Accessible.description: control.menuOpen ? qsTr("Menu open") : qsTr("Menu closed")

    // True in light theme
    readonly property bool lightScheme: !Theme.dark
    // Menu currently open
    readonly property bool menuOpen: popupMenu.visible
    readonly property color __fill: {
        if (control.highlighted) {
            if (!control.enabled)
                return Theme.dark ? "#28FFFFFF" : "#37000000"
            if (control.down || control.menuOpen)
                return control.lightScheme
                    ? Qt.tint(Theme.accent, Qt.rgba(1, 1, 1, 0.2))
                    : Qt.tint(Theme.accent, Qt.rgba(0, 0, 0, 0.2))
            if (control.hovered)
                return control.lightScheme
                    ? Qt.tint(Theme.accent, Qt.rgba(1, 1, 1, 0.1))
                    : Qt.tint(Theme.accent, Qt.rgba(0, 0, 0, 0.1))
            return Theme.accent
        }
        if (!control.enabled)
            return Theme.dark ? "#0BFFFFFF" : "#4DF9F9F9"
        if (control.down || control.menuOpen)
            return control.lightScheme ? "#4DF9F9F9" : "#08FFFFFF"
        if (control.hovered)
            return control.lightScheme ? "#80F9F9F9" : "#15FFFFFF"
        return control.lightScheme ? "#FFFFFF" : "#0FFFFFFF"
    }

    // Open / show
    function open() { showMenu() }
    // Close / dismiss
    function close() { popupMenu.close() }

    // Open the associated menu
    function showMenu() {
        var ox = 0
        var oy = control.height + 4
        switch (flyoutPlacement) {
        case Qt.AlignTop:
            oy = -popupMenu.implicitHeight - 4
            break
        case Qt.AlignRight:
            ox = control.width + 4
            oy = 0
            break
        case Qt.AlignLeft:
            ox = -popupMenu.implicitWidth - 4
            oy = 0
            break
        }
        popupMenu.popup(control, ox, oy)
    }

    contentItem: RowLayout {
        spacing: 8
        Text {
            visible: control.effectiveIconGlyph.length > 0
            text: control.effectiveIconGlyph
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 14
            color: {
                if (!control.enabled)
                    return Theme.textDisabled
                if (control.highlighted)
                    return Theme.textOnAccent
                return Theme.textPrimary
            }
            Layout.alignment: Qt.AlignVCenter
        }
        Text {
            text: control.text
            font: control.font
            color: {
                if (!control.enabled)
                    return Theme.textDisabled
                if (control.highlighted)
                    return Theme.textOnAccent
                if (control.down || control.menuOpen)
                    return Theme.dark ? Qt.rgba(1, 1, 1, 0.7725) : Qt.rgba(0, 0, 0, 0.62)
                return Theme.textPrimary
            }
            elide: Text.ElideRight
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter

            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
        }
        Text {
            id: chevron
            text: FluentIcons.ChevronDown
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 10
            color: control.highlighted
                   ? (control.enabled ? Theme.textOnAccent : Theme.textDisabled)
                   : Theme.textSecondary
            rotation: control.menuOpen ? 180 : 0

            Behavior on rotation {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
        }
    }

    background: Item {
        implicitWidth: Theme.controlMinWidth
        implicitHeight: Theme.controlHeight
        scale: (control.down || control.menuOpen) && !Theme.reducedMotion ? 0.98 : 1

        Behavior on scale {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }

        Rectangle {
            id: strokeShell
            anchors.fill: parent
            radius: Theme.cornerControl

            // Draw solid stroke chrome
            readonly property bool hasSolidStroke: control.down || control.menuOpen || !control.enabled || Theme.dark
            // Draw gradient stroke chrome
            readonly property bool hasGradientStroke: !hasSolidStroke && control.enabled
            // Top edge stroke width
            readonly property color topStroke: Theme.dark ? "#12FFFFFF" : "#0F000000"
            // Bottom edge stroke width
            readonly property color bottomStroke: Theme.dark ? "#18FFFFFF" : "#29000000"

            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: strokeShell.hasGradientStroke ? strokeShell.topStroke : "transparent"
                }
                GradientStop {
                    position: 0.91
                    color: strokeShell.hasGradientStroke ? strokeShell.topStroke : "transparent"
                }
                GradientStop {
                    position: 1.0
                    color: strokeShell.hasGradientStroke ? strokeShell.bottomStroke : "transparent"
                }
            }

            Rectangle {
                // Content inset
                readonly property bool inset: strokeShell.hasGradientStroke
                x: inset ? 1 : 0
                y: inset ? 1 : 0
                width: inset ? parent.width - 2 : parent.width
                height: inset ? parent.height - 2 : parent.height
                radius: inset ? Theme.cornerControl - 1 : Theme.cornerControl
                border.width: strokeShell.hasGradientStroke ? 0 : 1
                border.color: Theme.strokeControl
                color: control.__fill

                Behavior on color {
                    enabled: !Theme.reducedMotion
                    ColorAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingStandard
                    }
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: -2
            radius: Theme.cornerControl + 2
            color: "transparent"
            border.width: control.visualFocus ? 2 : 0
            border.color: Theme.focusOuter
            visible: control.visualFocus
        }
    }

    onClicked: popupMenu.visible ? popupMenu.close() : control.showMenu()

    Menu {
        id: popupMenu
        y: control.height + 4
        width: Math.max(implicitWidth, control.width)
    }
}
