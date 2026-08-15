import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// MenuSeparator — Fluent styled MenuSeparator.
//
//   MenuSeparator { }

T.MenuSeparator {
    id: control
    implicitWidth: 180
    implicitHeight: 9
    padding: 4
    leftPadding: 12
    rightPadding: 12

    contentItem: Rectangle {
        implicitHeight: 1
        color: Theme.strokeDivider
        opacity: 0.9
    }
}
