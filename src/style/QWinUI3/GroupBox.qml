import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// GroupBox — Fluent styled GroupBox.
//
//   GroupBox {
//       title: qsTr("Options")
//       Column {
//           CheckBox { text: qsTr("A") }
//           CheckBox { text: qsTr("B") }
//       }
//   }
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls GroupBox.
//   Public API is the Qt Quick Controls GroupBox type; this file supplies visuals/metrics only.

T.GroupBox {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding,
                            implicitLabelWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    spacing: 8
    padding: 12
    topPadding: padding + (label && label.implicitWidth > 0 ? label.implicitHeight + spacing : 0)
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    label: Text {
        x: control.leftPadding
        width: control.availableWidth
        text: control.title
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontCaption
        font.weight: Theme.fontWeightSemiBold
        color: Theme.textSecondary
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        y: control.topPadding - control.padding
        height: parent.height - control.topPadding + control.padding
        radius: Theme.cornerOverlay
        color: Theme.fillSubtleSecondary
        border.width: 1
        border.color: Theme.strokeCard
    }
}
