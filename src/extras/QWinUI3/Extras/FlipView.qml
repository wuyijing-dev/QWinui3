import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

T.Control {
    id: control

    property alias currentIndex: swipe.currentIndex
    property alias count: swipe.count
    property alias interactive: swipe.interactive
    property bool buttonsVisible: true
    // WinUI-style alias
    property alias isButtonsVisible: control.buttonsVisible
    // always | onHover | hidden
    property string buttonVisibility: "onHover"
    property bool isIndicatorVisible: true
    property bool wrap: false
    default property alias contentData: swipe.contentData

    implicitWidth: 360
    implicitHeight: 200
    padding: 0
    hoverEnabled: true

    readonly property bool _showButtons: buttonsVisible && buttonVisibility !== "hidden"
    readonly property bool _buttonsAlways: buttonVisibility === "always"

    function goNext() {
        if (swipe.count <= 0)
            return
        if (swipe.currentIndex < swipe.count - 1)
            swipe.incrementCurrentIndex()
        else if (wrap)
            swipe.currentIndex = 0
    }

    function goPrevious() {
        if (swipe.count <= 0)
            return
        if (swipe.currentIndex > 0)
            swipe.decrementCurrentIndex()
        else if (wrap)
            swipe.currentIndex = swipe.count - 1
    }

    contentItem: Item {
        SwipeView {
            id: swipe
            anchors.fill: parent
            anchors.leftMargin: control._showButtons ? 40 : 0
            anchors.rightMargin: control._showButtons ? 40 : 0
            clip: true
        }

        RoundButton {
            id: prevBtn
            visible: control._showButtons
            anchors.left: parent.left
            anchors.leftMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            width: 36
            height: 36
            flat: true
            opacity: {
                if (!visible)
                    return 0
                if (control._buttonsAlways || control.hovered || prevBtn.hovered)
                    return enabled ? 1 : 0.4
                return 0
            }
            enabled: control.wrap || swipe.currentIndex > 0
            text: "\uE76B"
            font.family: Theme.fontFamilyIcon
            onClicked: control.goPrevious()
            Behavior on opacity {
                enabled: !Theme.reducedMotion
                NumberAnimation { duration: Theme.duration(Theme.motionFast) }
            }
        }

        RoundButton {
            id: nextBtn
            visible: control._showButtons
            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            width: 36
            height: 36
            flat: true
            opacity: {
                if (!visible)
                    return 0
                if (control._buttonsAlways || control.hovered || nextBtn.hovered)
                    return enabled ? 1 : 0.4
                return 0
            }
            enabled: control.wrap || swipe.currentIndex < swipe.count - 1
            text: "\uE76C"
            font.family: Theme.fontFamilyIcon
            onClicked: control.goNext()
            Behavior on opacity {
                enabled: !Theme.reducedMotion
                NumberAnimation { duration: Theme.duration(Theme.motionFast) }
            }
        }

        PageIndicator {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            count: swipe.count
            currentIndex: swipe.currentIndex
            visible: control.isIndicatorVisible && swipe.count > 1
            opacity: 0.9
        }
    }

    background: Rectangle {
        color: Theme.bgCard
        radius: Theme.cornerCard
        border.width: 1
        border.color: Theme.strokeCard
    }
}
