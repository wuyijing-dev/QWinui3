import QtQuick
import QtQuick.Controls
import QWinUI3.Theme

// Non-interactive section header inside a MenuFlyout.
MenuItem {
    id: control

    enabled: false
    checkable: false
    implicitHeight: 28
    leftPadding: 12
    rightPadding: 12

    background: Item {}
    indicator: Item {}
    arrow: Item {}

    contentItem: Text {
        text: control.text
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontCaption
        font.weight: Theme.fontWeightSemiBold
        color: Theme.textSecondary
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
