import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// MenuItem — Fluent styled MenuItem.
//
//   MenuItem { text: qsTr("Paste") }

T.MenuItem {
    id: control

    implicitWidth: Math.max(180, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Theme.controlHeight

    padding: 8
    leftPadding: 12
    rightPadding: 12
    spacing: Theme.spacing
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    hoverEnabled: true

    contentItem: Text {
        leftPadding: control.checkable ? control.indicator.width + control.spacing : 0
        text: control.text
        font: control.font
        color: {
            if (!control.enabled)
                return Theme.textDisabled
            if (control.down)
                return Theme.dark ? Qt.rgba(1, 1, 1, 0.7725) : Qt.rgba(0, 0, 0, 0.62)
            return Theme.textPrimary
        }
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter

        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }
    }

    indicator: Item {
        width: 16
        height: 16
        x: control.leftPadding
        y: (control.height - height) / 2
        visible: control.checkable
        opacity: control.checked ? 1 : 0
        scale: control.checked ? 1 : 0.6

        Behavior on opacity {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingEnter
            }
        }
        Behavior on scale {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingEnter
            }
        }

        Text {
            anchors.centerIn: parent
            text: FluentIcons.Accept
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 12
            color: Theme.accent
        }
    }

    arrow: Text {
        x: control.mirrored ? control.leftPadding : control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        visible: control.subMenu
        text: control.mirrored ? FluentIcons.ChevronLeft : FluentIcons.ChevronRight
        font.family: Theme.fontFamilyIcon
        font.pixelSize: 10
        color: Theme.textSecondary
    }

    background: Item {
        implicitWidth: 180
        implicitHeight: Theme.controlHeight

        Rectangle {
            anchors.fill: parent
            anchors.leftMargin: 4
            anchors.rightMargin: 4
            anchors.topMargin: 1
            anchors.bottomMargin: 1
            radius: Theme.cornerControl
            color: {
                if (!control.enabled)
                    return "transparent"
                if (control.down)
                    return Theme.fillSubtleTertiary
                if (control.highlighted || control.hovered)
                    return Theme.fillSubtle
                if (control.checkable && control.checked)
                    return Theme.fillSubtleSecondary
                return "transparent"
            }

            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }
        // Accent pip is owned by Menu (SelectionPip) — tracks currentIndex
    }
}
