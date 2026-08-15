import QtQuick.Controls
import QWinUI3.Theme

// MenuFlyoutSeparator — MenuFlyout divider.
//
//   MenuFlyoutSeparator { }

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
