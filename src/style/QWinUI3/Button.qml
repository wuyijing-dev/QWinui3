import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

T.Button {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    topPadding: Theme.paddingControlV
    bottomPadding: Theme.paddingControlV
    leftPadding: Theme.paddingControlH
    rightPadding: Theme.paddingControlH
    spacing: Theme.spacing
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    hoverEnabled: true

    readonly property bool accented: control.highlighted || control.checked
    readonly property bool lightScheme: !Theme.dark

    readonly property color __buttonText: {
        if (control.down) {
            if (control.accented)
                return Theme.textOnAccentSecondary
            return Theme.dark
                ? Qt.rgba(1, 1, 1, 0.7725)
                : Qt.rgba(0, 0, 0, 0.62)
        }
        if (control.accented) {
            if (!control.enabled)
                return Theme.dark ? Qt.rgba(1, 1, 1, 0.5302) : Theme.textOnAccent
            return Theme.textOnAccent
        }
        if (!control.enabled)
            return Theme.textDisabled
        return Theme.textPrimary
    }

    readonly property color __fill: {
        if (control.accented) {
            if (!control.enabled)
                return Theme.dark ? "#28FFFFFF" : "#37000000"
            if (control.down)
                return control.lightScheme
                    ? Qt.tint(Theme.accent, Qt.rgba(1, 1, 1, 0.2))
                    : Qt.tint(Theme.accent, Qt.rgba(0, 0, 0, 0.2))
            if (control.hovered)
                return control.lightScheme
                    ? Qt.tint(Theme.accent, Qt.rgba(1, 1, 1, 0.1))
                    : Qt.tint(Theme.accent, Qt.rgba(0, 0, 0, 0.1))
            return Theme.accent
        }
        if (control.flat) {
            if (control.down)
                return Theme.dark ? Qt.rgba(1, 1, 1, 0.04) : Qt.rgba(0, 0, 0, 0.02)
            if (control.hovered)
                return Theme.dark ? Qt.rgba(1, 1, 1, 0.06) : Qt.rgba(0, 0, 0, 0.04)
            return "transparent"
        }
        if (!control.enabled)
            return Theme.dark ? "#0BFFFFFF" : "#4DF9F9F9"
        if (control.down)
            return control.lightScheme ? "#4DF9F9F9" : "#08FFFFFF"
        if (control.hovered)
            return control.lightScheme ? "#80F9F9F9" : "#15FFFFFF"
        return control.lightScheme ? "#FFFFFF" : "#0FFFFFFF"
    }

    contentItem: Text {
        text: control.text
        font: control.font
        color: control.__buttonText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        scale: control.down && !Theme.reducedMotion ? 0.98 : 1

        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionNormal)
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

    background: Item {
        implicitWidth: Math.max(Theme.controlMinWidth, control.contentItem.implicitWidth + 24)
        implicitHeight: Theme.controlHeight
        scale: control.down && !Theme.reducedMotion ? 0.98 : 1

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
            visible: !control.flat || control.down || control.hovered || control.accented

            readonly property bool hasSolidStroke: !control.flat
                && (control.down || (!control.enabled && !control.accented) || (Theme.dark && !control.accented))
            readonly property bool hasGradientStroke: !hasSolidStroke && !control.flat && control.enabled && !control.accented
            // WinUI ControlStrokeDefault / Secondary — keep soft, not StrongStroke
            readonly property color topStroke: Theme.dark ? "#12FFFFFF" : "#0F000000"
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
                readonly property bool inset: strokeShell.hasGradientStroke
                x: inset ? 1 : 0
                y: inset ? 1 : 0
                width: inset ? parent.width - 2 : parent.width
                height: inset ? parent.height - 2 : parent.height
                radius: inset ? Theme.cornerControl - 1 : Theme.cornerControl
                border.width: {
                    if (control.flat || strokeShell.hasGradientStroke)
                        return 0
                    if (control.accented)
                        return control.enabled && !control.down ? 0 : 0
                    return 1
                }
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

        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
            frameRadius: Theme.cornerControl
        }
    }
}
