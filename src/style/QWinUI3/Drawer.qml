import QtQuick

import QtQuick.Templates as T

import QWinUI3.Theme



// Drawer — Fluent styled Drawer.
//
//   Drawer { // content }

T.Drawer {

    id: control



    parent: T.Overlay.overlay

    modal: true

    dim: true

    interactive: true

    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside

    padding: Theme.spacingSection

    font.family: Theme.fontFamily

    font.pixelSize: Theme.fontBody



    enter: Transition {

        NumberAnimation {

            property: "opacity"

            from: 0; to: 1

            duration: Theme.duration(Theme.motionNormal)

            easing.type: Theme.easingEnter

        }

        NumberAnimation {

            property: control.edge === Qt.LeftEdge || control.edge === Qt.RightEdge ? "x" : "y"

            duration: Theme.duration(Theme.motionNormal)

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



    background: ElevatedChrome {

        color: Theme.bgAcrylic

        radius: 0

        borderColor: Theme.strokeDivider

        borderWidth: 1

        elevation: 6

        shadowOpacity: Theme.dark ? 0.35 : 0.18

    }



    T.Overlay.modal: Rectangle {

        color: Theme.bgSmoke

        Behavior on opacity {

            NumberAnimation { duration: Theme.duration(Theme.motionFast) }

        }

    }

}

