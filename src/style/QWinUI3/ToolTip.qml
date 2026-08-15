import QtQuick
import QtQuick.Templates as T
import QtQuick.Effects
import QWinUI3.Theme

T.ToolTip {
    id: control

    x: parent ? (parent.width - implicitWidth) / 2 : 0
    y: parent ? -implicitHeight - 6 : 0

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    padding: 8
    topInset: -6
    bottomInset: -6
    leftInset: -6
    rightInset: -6
    delay: 400
    timeout: 5000
    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent
                 | T.Popup.CloseOnReleaseOutsideParent
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontCaption

    contentItem: Text {
        text: control.text
        font: control.font
        wrapMode: Text.Wrap
        color: Theme.textPrimary
    }

    background: Item {
        implicitHeight: 30

        MultiEffect {
            x: -control.leftInset
            y: -control.topInset
            width: source.width
            height: source.height
            source: Rectangle {
                width: control.background.width + control.leftInset + control.rightInset
                height: control.background.height + control.topInset + control.bottomInset
                color: Theme.bgCard
                border.width: 1
                border.color: Theme.strokeCard
                radius: Theme.cornerControl
            }
            shadowEnabled: true
            shadowOpacity: Theme.dark ? 0.26 : 0.14
            shadowColor: "#000000"
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 4
            blurMax: 24
        }
    }

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0; to: 1
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingEnter
        }
        NumberAnimation {
            property: "scale"
            from: 0.96; to: 1
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingEnter
        }
    }
    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1; to: 0
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingExit
        }
    }
}
