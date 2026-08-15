import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// ToolTip — Fluent styled ToolTip.
//
//   Button {
//       text: qsTr("Hover")
//       ToolTip.visible: hovered
//       ToolTip.text: qsTr("Help")
//   }

T.ToolTip {
    id: control

    x: parent ? (parent.width - implicitWidth) / 2 : 0
    y: parent ? -implicitHeight - 6 : 0

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    padding: 8
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

    background: ElevatedChrome {
        implicitHeight: 30
        color: Theme.bgCard
        borderColor: Theme.strokeCard
        borderWidth: 1
        radius: Theme.cornerControl
        elevation: 4
        shadowOpacity: Theme.dark ? 0.26 : 0.14
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
