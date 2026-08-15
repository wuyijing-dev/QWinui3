import QtQuick.Controls

// WinUI MenuFlyout: styled Menu with showAt placement helper.
Menu {
    id: root

    property int placement: Qt.AlignBottom
    property bool isLightDismissEnabled: true

    closePolicy: isLightDismissEnabled
                 ? (Popup.CloseOnEscape | Popup.CloseOnPressOutside)
                 : Popup.CloseOnEscape

    function showAt(targetItem, offsetX, offsetY) {
        if (!targetItem) {
            open()
            return
        }
        var ox = offsetX === undefined ? 0 : offsetX
        var oy = offsetY === undefined ? 0 : offsetY
        var px = ox
        var py = oy
        switch (placement) {
        case Qt.AlignTop:
            py = -implicitHeight + oy
            break
        case Qt.AlignRight:
            px = targetItem.width + 4 + ox
            py = oy
            break
        case Qt.AlignLeft:
            px = -implicitWidth - 4 + ox
            py = oy
            break
        default:
            py = targetItem.height + 4 + oy
            break
        }
        popup(targetItem, px, py)
    }

    function hide() {
        close()
    }
}
