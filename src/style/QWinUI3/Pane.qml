import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

T.Pane {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    padding: Theme.spacingLoose
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    background: ElevatedChrome {
        color: Theme.bgCard
        radius: Theme.cornerCard
        borderColor: Theme.strokeCard
        borderWidth: 1
        elevation: 2
        shadowOpacity: Theme.dark ? 0.22 : 0.08
    }
}
