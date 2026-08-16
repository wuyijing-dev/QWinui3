import QtQuick
import QtQuick.Controls.impl
import QtQuick.Templates as T
import QWinUI3.Theme

// Tumbler — Fluent styled Tumbler.
//
//   Tumbler {
//       id: hours
//       model: 24
//       currentIndex: 8
//       visibleItemCount: 5
//       onCurrentIndexChanged: applyHour(hours.currentIndex)
//   }
//   // --- API ---
//   // hours.model / currentIndex / visibleItemCount
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls Tumbler.
//   Public API is the Qt Quick Controls Tumbler type; this file supplies visuals/metrics only.

T.Tumbler {
    id: control


    Accessible.role: Accessible.List
    Accessible.name: qsTr("Tumbler")
    Accessible.description: qsTr("Item %1 of %2").arg(control.currentIndex + 1).arg(Math.max(1, control.count))
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    visibleItemCount: 5

    readonly property real __delegateHeight: availableHeight / visibleItemCount

    delegate: Text {
        required property var modelData
        required property int index
        text: modelData
        font.family: control.font.family
        font.pixelSize: control.font.pixelSize
        font.weight: Math.abs(Tumbler.displacement) < 0.5
                     ? Theme.fontWeightSemiBold : Theme.fontWeightRegular
        color: Math.abs(Tumbler.displacement) < 0.5
               ? Theme.textPrimary : Theme.textSecondary
        opacity: 1.0 - Math.abs(Tumbler.displacement) / (control.visibleItemCount / 2)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    contentItem: TumblerView {
        implicitWidth: 72
        implicitHeight: 180
        model: control.model
        delegate: control.delegate
        path: Path {
            startX: control.contentItem.width / 2
            startY: -control.__delegateHeight / 2
            PathLine {
                x: control.contentItem.width / 2
                y: (control.visibleItemCount + 1) * control.__delegateHeight - control.__delegateHeight / 2
            }
        }
    }

    background: Item {
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: control.__delegateHeight
            color: Theme.fillSubtle
            radius: Theme.cornerControl
            border.width: 1
            border.color: Theme.strokeCard
        }
        Rectangle {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 3
            height: control.__delegateHeight - 8
            radius: 1.5
            color: Theme.accent
        }
    }
}
