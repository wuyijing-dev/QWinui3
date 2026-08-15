import QtQuick
import QtQuick.Templates as T
import QtQuick.Effects
import QWinUI3.Theme

T.Menu {
    id: control

    implicitWidth: Math.max(160, contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    leftPadding: 5
    topPadding: 5
    rightPadding: 5
    bottomPadding: 5
    overlap: 4
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    transformOrigin: Item.Top

    delegate: MenuItem {}

    onAboutToShow: {
        // Prefer checked item, else keep/restore currentIndex
        var checked = -1
        for (var i = 0; i < count; ++i) {
            var it = itemAt(i)
            if (it && it.checkable && it.checked) {
                checked = i
                break
            }
        }
        if (checked >= 0)
            currentIndex = checked
        menuList.positionViewAtIndex(Math.max(0, currentIndex), ListView.Contain)
        selectionPip.snapTo(currentIndex)
    }

    contentItem: Item {
        implicitHeight: menuList.contentHeight

        ListView {
            id: menuList
            anchors.fill: parent
            implicitHeight: contentHeight
            model: control.contentModel
            interactive: Window.window
                         ? contentHeight + control.topPadding + control.bottomPadding > control.height
                         : false
            clip: true
            currentIndex: control.currentIndex
            spacing: 2
            highlightMoveDuration: 0
            ScrollIndicator.vertical: ScrollIndicator {}

            onCurrentIndexChanged: {
                if (control.visible && currentIndex >= 0)
                    selectionPip.animateTo(currentIndex)
            }
        }

        SelectionPip {
            id: selectionPip
            listView: menuList
            // While open, follow active row; otherwise hide until shown
            targetIndex: control.visible ? control.currentIndex : -1
        }
    }

    background: Rectangle {
        implicitWidth: 160
        implicitHeight: 40
        radius: Theme.cornerOverlay
        color: Theme.bgCardElevated
        border.width: 1
        border.color: Theme.strokeCard

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowOpacity: Theme.dark ? 0.28 : 0.14
            shadowColor: "#000000"
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 8
            blurMax: 28
            autoPaddingEnabled: true
        }
    }

    enter: Transition {
        NumberAnimation {
            property: "height"
            from: control.implicitHeight * 0.33
            to: control.implicitHeight
            easing.type: Theme.easingEnter
            duration: Theme.duration(Theme.motionSlow)
        }
        NumberAnimation {
            property: "opacity"
            from: 0
            to: 1
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEnter
        }
    }
    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1
            to: 0
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingExit
        }
    }
}
