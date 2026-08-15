import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

T.Page {
    id: control
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    background: Rectangle {
        color: Theme.bgLayer
    }
}
