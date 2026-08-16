import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.impl
import QWinUI3.Theme

// ItemDelegate — Fluent styled ItemDelegate.
//
//   ListView {
//       model: 5
//       delegate: ItemDelegate {
//           text: "Item " + index
//           width: ListView.view.width
//           onClicked: select(index)
//       }
//   }
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls ItemDelegate.
//   Public API is the Qt Quick Controls ItemDelegate type; this file supplies visuals/metrics only.

T.ItemDelegate {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(Theme.navItemHeight,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 8
    leftPadding: 12
    rightPadding: 12
    topPadding: 6
    bottomPadding: 6
    spacing: 12
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    hoverEnabled: true
    icon.width: 16
    icon.height: 16
    icon.color: control.down
                ? (Theme.dark ? Qt.rgba(1, 1, 1, 0.7725) : Qt.rgba(0, 0, 0, 0.62))
                : Theme.textPrimary

    contentItem: IconLabel {
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        alignment: Qt.AlignLeft | Qt.AlignVCenter
        icon: control.icon
        text: control.text
        font: control.font
        color: control.enabled ? Theme.textPrimary : Theme.textDisabled
        leftPadding: 4
    }

    background: Item {
        implicitHeight: Theme.navItemHeight
        implicitWidth: 160

        Rectangle {
            anchors.fill: parent
            anchors.leftMargin: 4
            anchors.rightMargin: 4
            anchors.topMargin: 2
            anchors.bottomMargin: 2
            radius: Theme.cornerControl
            color: {
                if (!control.enabled)
                    return "transparent"
                if (control.down)
                    return Theme.fillSubtleTertiary
                if (control.highlighted || control.checked)
                    return Theme.fillSubtle
                if (control.hovered)
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

        FocusStroke {
            anchors.fill: parent
            anchors.margins: 2
            show: control.visualFocus
            frameRadius: Theme.cornerControl
        }

        Rectangle {
            id: indicator
            anchors.left: parent.left
            anchors.leftMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            width: 3
            height: {
                if (!(control.highlighted || control.checked || control.visualFocus || control.hovered))
                    return 0
                return control.down ? 10 : 16
            }
            radius: 1.5
            color: Theme.accent

            Behavior on height {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
        }
    }
}
