import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// SplitButton — Primary action + chevron menu.
//
//   SplitButton {
//       text: qsTr("Open")
//       MenuFlyoutItem { text: qsTr("Open with…") }
//   }

T.AbstractButton {
    id: control

    // Attached / owned Menu
    property alias menu: popupMenu
    // Menu children slot
    default property alias menuData: popupMenu.contentData
    // Emphasized / selected chrome
    property bool highlighted: false
    // Flat chrome without fill
    property bool flat: false
    // MenuFlyout placement
    property int flyoutPlacement: Qt.AlignBottom
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Open / visible state
    property alias isOpen: popupMenu.visible
    // Primary button clicked
    signal primaryClicked()

    // Resolved glyph string
    readonly property string effectiveIconGlyph: IconSource.resolve(symbol, iconGlyph)

    implicitWidth: Math.max(Theme.controlMinWidth,
                            primaryRow.implicitWidth + 32 + Theme.paddingControlH * 2 + 8)
    implicitHeight: Theme.controlHeight
    hoverEnabled: true
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    padding: 0
    spacing: 0
    Accessible.role: Accessible.Button
    Accessible.name: control.text.length ? control.text : qsTr("Split button")
    Accessible.description: popupMenu.visible ? qsTr("Menu open") : qsTr("Menu closed")

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

    // Dismiss the menu
    function closeMenu() { popupMenu.close() }

    // True in light theme
    readonly property bool lightScheme: !Theme.dark
    // Use accent chrome
    readonly property bool accented: highlighted
    // True if any child is hovered
    readonly property bool anyHovered: primaryBtn.hovered || chevronBtn.hovered || popupMenu.visible
    // True if any child is pressed
    readonly property bool anyDown: primaryBtn.down || chevronBtn.down

    readonly property color __fill: {
        if (control.accented) {
            if (!control.enabled)
                return Theme.dark ? "#28FFFFFF" : "#37000000"
            if (control.anyDown)
                return control.lightScheme
                    ? Qt.tint(Theme.accent, Qt.rgba(1, 1, 1, 0.2))
                    : Qt.tint(Theme.accent, Qt.rgba(0, 0, 0, 0.2))
            if (control.anyHovered)
                return control.lightScheme
                    ? Qt.tint(Theme.accent, Qt.rgba(1, 1, 1, 0.1))
                    : Qt.tint(Theme.accent, Qt.rgba(0, 0, 0, 0.1))
            return Theme.accent
        }
        if (control.flat) {
            if (control.anyDown)
                return Theme.dark ? Qt.rgba(1, 1, 1, 0.04) : Qt.rgba(0, 0, 0, 0.02)
            if (control.anyHovered)
                return Theme.dark ? Qt.rgba(1, 1, 1, 0.06) : Qt.rgba(0, 0, 0, 0.04)
            return "transparent"
        }
        if (!control.enabled)
            return Theme.dark ? "#0BFFFFFF" : "#4DF9F9F9"
        if (control.anyDown)
            return control.lightScheme ? "#4DF9F9F9" : "#08FFFFFF"
        if (control.anyHovered)
            return control.lightScheme ? "#80F9F9F9" : "#15FFFFFF"
        return control.lightScheme ? "#FFFFFF" : "#0FFFFFFF"
    }

    readonly property color __text: {
        if (!control.enabled)
            return Theme.textDisabled
        if (control.accented)
            return Theme.textOnAccent
        if (control.anyDown)
            return Theme.dark ? Qt.rgba(1, 1, 1, 0.7725) : Qt.rgba(0, 0, 0, 0.62)
        return Theme.textPrimary
    }

    contentItem: Item {
        Row {
            anchors.fill: parent
            spacing: 0

            T.AbstractButton {
                id: primaryBtn
                width: parent.width - 33
                height: parent.height
                hoverEnabled: true
                leftPadding: Theme.paddingControlH
                rightPadding: 8
                onClicked: control.primaryClicked()

                contentItem: Row {
                    id: primaryRow
                    spacing: 8
                    // Fill the padded content box; avoid anchors.centerIn (clips visual padding).
                    width: primaryBtn.availableWidth
                    height: primaryBtn.availableHeight

                    Text {
                        visible: control.effectiveIconGlyph.length > 0
                        width: visible ? 16 : 0
                        height: parent.height
                        text: control.effectiveIconGlyph
                        font.family: Theme.fontFamilyIcon
                        font.pixelSize: 14
                        color: control.__text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text {
                        id: primaryLabel
                        height: parent.height
                        text: control.text
                        font.family: control.font.family
                        font.pixelSize: control.font.pixelSize
                        color: control.__text
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter

                        Behavior on color {
                            enabled: !Theme.reducedMotion
                            ColorAnimation {
                                duration: Theme.duration(Theme.motionNormal)
                                easing.type: Theme.easingStandard
                            }
                        }
                    }
                }

                background: Rectangle {
                    color: {
                        if (!primaryBtn.hovered && !primaryBtn.down)
                            return "transparent"
                        if (control.accented)
                            return primaryBtn.down ? "#14000000" : "#0AFFFFFF"
                        return primaryBtn.down ? Theme.fillSubtleTertiary : Theme.fillSubtle
                    }
                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation {
                            duration: Theme.duration(Theme.motionFast)
                            easing.type: Theme.easingStandard
                        }
                    }
                }
            }

            Rectangle {
                width: 1
                height: parent.height - 12
                anchors.verticalCenter: parent.verticalCenter
                color: control.accented
                       ? Theme.strokeControlOnAccent
                       : (Theme.dark ? "#18FFFFFF" : "#29000000")
            }

            T.AbstractButton {
                id: chevronBtn
                width: 32
                height: parent.height
                hoverEnabled: true
                onClicked: popupMenu.visible ? popupMenu.close() : control.showMenu()

                contentItem: Text {
                    text: FluentIcons.ChevronDown
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 10
                    color: control.accented ? control.__text : Theme.textSecondary
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    rotation: popupMenu.visible ? 180 : 0

                    Behavior on rotation {
                        enabled: !Theme.reducedMotion
                        NumberAnimation {
                            duration: Theme.duration(Theme.motionNormal)
                            easing.type: Theme.easingStandard
                        }
                    }
                }

                background: Rectangle {
                    color: {
                        if (!chevronBtn.hovered && !chevronBtn.down && !popupMenu.visible)
                            return "transparent"
                        if (control.accented)
                            return (chevronBtn.down || popupMenu.visible) ? "#14000000" : "#0AFFFFFF"
                        return (chevronBtn.down || popupMenu.visible)
                               ? Theme.fillSubtleTertiary : Theme.fillSubtle
                    }
                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation {
                            duration: Theme.duration(Theme.motionFast)
                            easing.type: Theme.easingStandard
                        }
                    }
                }
            }
        }
    }

    background: Item {
        implicitWidth: Theme.controlMinWidth
        implicitHeight: Theme.controlHeight
        scale: control.anyDown && !Theme.reducedMotion ? 0.98 : 1

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
            visible: !control.flat || control.anyDown || control.anyHovered || control.accented

            // True when a solid stroke is configured
            readonly property bool hasSolidStroke: !control.flat
                && (control.anyDown || (!control.enabled && !control.accented) || (Theme.dark && !control.accented))
            // True when a gradient stroke is configured
            readonly property bool hasGradientStroke: !hasSolidStroke && !control.flat && control.enabled && !control.accented
            // Top edge stroke color
            readonly property color topStroke: Theme.dark ? "#12FFFFFF" : "#0F000000"
            // Bottom edge stroke color
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
                id: fillRect
                // Use inset stroke chrome
                readonly property bool inset: strokeShell.hasGradientStroke
                x: inset ? 1 : 0
                y: inset ? 1 : 0
                width: inset ? parent.width - 2 : parent.width
                height: inset ? parent.height - 2 : parent.height
                radius: inset ? Theme.cornerControl - 1 : Theme.cornerControl
                border.width: {
                    if (control.flat || strokeShell.hasGradientStroke)
                        return 0
                    return control.accented ? 0 : 1
                }
                border.color: Theme.strokeControl
                color: control.__fill
                clip: true

                Behavior on color {
                    enabled: !Theme.reducedMotion
                    ColorAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingStandard
                    }
                }
            }
        }
    }

    Menu {
        id: popupMenu
        y: control.height + 4
        width: Math.max(implicitWidth, control.width)
    }
}
