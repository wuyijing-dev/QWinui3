import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// DialogButtonBox — Fluent styled DialogButtonBox.
//
//   DialogButtonBox { standardButtons: Dialog.Ok | Dialog.Cancel }

T.DialogButtonBox {
    id: control

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: Math.max(Theme.controlHeight + topPadding + bottomPadding,
                             contentItem.implicitHeight + topPadding + bottomPadding)

    spacing: Theme.spacing
    padding: 24
    topPadding: 12
    bottomPadding: 16
    // Always pack actions together on the trailing edge (never spread L/R).
    alignment: Qt.AlignRight

    contentItem: ListView {
        implicitWidth: contentWidth
        implicitHeight: contentHeight
        width: contentWidth
        model: control.contentModel
        spacing: control.spacing
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
        snapMode: ListView.SnapToItem
        interactive: false
        layoutDirection: control.mirrored ? Qt.RightToLeft : Qt.LeftToRight
    }

    background: Item {
        implicitHeight: Theme.controlHeight + control.topPadding + control.bottomPadding
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 1
            color: Theme.strokeDivider
            opacity: 0.7
        }
    }

    delegate: Button {
        width: implicitWidth
    }
}
