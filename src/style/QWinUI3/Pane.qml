import QtQuick
import QtQuick.Templates as T
import QtQuick.Effects
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

    background: Rectangle {
        color: Theme.bgCard
        radius: Theme.cornerCard
        border.width: 1
        border.color: Theme.strokeCard

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowOpacity: Theme.dark ? 0.2 : 0.08
            shadowColor: "#000000"
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 2
            blurMax: 12
            autoPaddingEnabled: true
        }
    }
}
