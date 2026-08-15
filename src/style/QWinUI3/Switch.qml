import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

T.Switch {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding,
                            implicitIndicatorWidth)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    spacing: Theme.spacing
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    hoverEnabled: true

    indicator: Item {
        implicitWidth: Theme.switchWidth
        implicitHeight: Theme.switchHeight
        x: control.text ? (control.mirrored ? control.width - width - control.rightPadding : control.leftPadding)
                        : control.leftPadding + (control.availableWidth - width) / 2
        y: control.topPadding + (control.availableHeight - height) / 2

        Rectangle {
            id: track
            anchors.fill: parent
            radius: height * 0.5
            border.width: control.checked ? 0 : 1
            border.color: control.enabled
                ? (Theme.dark ? "#9CFFFFFF" : "#9C000000")
                : (Theme.dark ? "#28FFFFFF" : "#37000000")
            color: {
                if (control.checked) {
                    if (!control.enabled)
                        return Theme.dark ? "#28FFFFFF" : "#37000000"
                    if (control.down)
                        return Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.8)
                    if (control.hovered)
                        return Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.902)
                    return Theme.accent
                }
                if (!control.enabled)
                    return "transparent"
                if (control.down)
                    return Theme.dark ? "#12FFFFFF" : "#18000000"
                if (control.hovered)
                    return Theme.dark ? "#0BFFFFFF" : "#0F000000"
                return Theme.dark ? "#19000000" : "#06000000"
            }

            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on border.width {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }

            Rectangle {
                id: thumb
                x: Math.max(0, Math.min(parent.width - width,
                           control.visualPosition * parent.width - width / 2))
                y: (parent.height - height) / 2
                width: control.down ? Theme.switchThumb + 3 : Theme.switchThumb + 4
                height: Theme.switchThumb + 4
                radius: height / 2
                scale: control.hovered && control.enabled ? 0.82 : 0.72
                color: "transparent"

                Rectangle {
                    anchors.centerIn: parent
                    width: Theme.switchThumb
                    height: Theme.switchThumb
                    radius: height / 2
                    color: {
                        if (!control.checked)
                            return control.enabled
                                ? Theme.textSecondary
                                : Theme.textDisabled
                        return Theme.dark ? "#000000" : "#FFFFFF"
                    }

                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation {
                            duration: Theme.duration(Theme.motionNormal)
                            easing.type: Theme.easingStandard
                        }
                    }
                }

                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingStandard
                    }
                }
                Behavior on x {
                    enabled: !control.down && !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingStandard
                    }
                }
                Behavior on width {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingStandard
                    }
                }
            }
        }

        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
            frameRadius: height / 2
        }
    }

    contentItem: Text {
        leftPadding: control.indicator && !control.mirrored ? control.indicator.width + control.spacing : 0
        rightPadding: control.indicator && control.mirrored ? control.indicator.width + control.spacing : 0
        text: control.text
        font: control.font
        color: control.enabled ? Theme.textPrimary : Theme.textDisabled
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }
}
