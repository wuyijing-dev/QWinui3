import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

T.AbstractButton {
    id: control

    property url url: ""
    // WinUI NavigateUri
    property alias navigateUri: control.url
    // always | onHover | never
    property string underlineStyle: "onHover"

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 2
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    hoverEnabled: true
    Accessible.role: Accessible.Link

    contentItem: Text {
        text: control.text
        font.family: control.font.family
        font.pixelSize: control.font.pixelSize
        font.underline: {
            switch (control.underlineStyle) {
            case "always": return true
            case "never": return false
            default: return control.hovered || control.visualFocus
            }
        }
        color: !control.enabled ? Theme.textDisabled
             : (control.down ? Theme.accentDark1 : Theme.accent)
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter

        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
            }
        }
    }

    background: Item {
        implicitHeight: Theme.fontBody + 4
        Rectangle {
            anchors.fill: parent
            anchors.margins: -2
            radius: 2
            color: "transparent"
            border.width: control.visualFocus ? 2 : 0
            border.color: Theme.focusOuter
            visible: control.visualFocus
        }
    }

    onClicked: {
        if (control.url.toString().length > 0)
            Qt.openUrlExternally(control.url)
    }
}
