import QtQuick.Controls
import QWinUI3.Theme

MenuSeparator {
    id: control
    topPadding: 4
    bottomPadding: 4
    contentItem: Rectangle {
        implicitWidth: 188
        implicitHeight: 1
        color: Theme.strokeDivider
    }
}
