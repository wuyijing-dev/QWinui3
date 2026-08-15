import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Effects
import QWinUI3.Theme

T.Popup {
    id: root

    property Item target: null
    property string title: ""
    property string subtitle: ""
    property string actionText: ""
    property string iconGlyph: ""
    property bool isOpen: false
    // WinUI IsLightDismissEnabled
    property bool isLightDismissEnabled: true
    // WinUI CloseButtonVisibility — true shows the X
    property bool isCloseButtonVisible: true
    // Top / Bottom / Left / Right / Auto (prefer top, flip if needed)
    property int preferredPlacement: Qt.AlignTop
    property int effectivePlacement: Qt.AlignTop
    // WinUI HeroContent slot
    default property alias heroContent: heroSlot.data
    signal actionClicked()

    padding: 12
    modal: false
    closePolicy: isLightDismissEnabled
                 ? (T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside)
                 : T.Popup.CloseOnEscape
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    width: 320
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    onIsOpenChanged: {
        if (isOpen) {
            reanchor()
            open()
        } else {
            close()
        }
    }
    onOpened: {
        isOpen = true
        reanchor()
    }
    onClosed: isOpen = false

    function reanchor() {
        if (!target || !parent)
            return
        var p = target.mapToItem(parent, 0, 0)
        var gap = 12
        var place = preferredPlacement
        if (place === Qt.AlignTop || place === 0) {
            if (p.y - implicitHeight - gap < 8)
                place = Qt.AlignBottom
            else
                place = Qt.AlignTop
        } else if (place === Qt.AlignBottom) {
            if (p.y + target.height + gap + implicitHeight > parent.height - 8)
                place = Qt.AlignTop
        }
        effectivePlacement = place

        switch (place) {
        case Qt.AlignBottom:
            transformOrigin = Item.Top
            x = p.x + (target.width - width) / 2
            y = p.y + target.height + gap
            break
        case Qt.AlignLeft:
            transformOrigin = Item.Right
            x = p.x - width - gap
            y = p.y + (target.height - implicitHeight) / 2
            break
        case Qt.AlignRight:
            transformOrigin = Item.Left
            x = p.x + target.width + gap
            y = p.y + (target.height - implicitHeight) / 2
            break
        default: // Top
            transformOrigin = Item.Bottom
            x = p.x + (target.width - width) / 2
            y = p.y - implicitHeight - gap
            break
        }
        x = Math.max(8, Math.min(x, parent.width - width - 8))
        y = Math.max(8, Math.min(y, parent.height - implicitHeight - 8))
    }

    x: 0
    y: 0

    contentItem: ColumnLayout {
        spacing: 8

        Item {
            id: heroSlot
            visible: children.length > 0
            Layout.fillWidth: true
            Layout.preferredHeight: children.length > 0 ? Math.max(72, childrenRect.height) : 0
            clip: true
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Text {
                visible: root.iconGlyph.length > 0
                text: root.iconGlyph
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 18
                color: Theme.accent
                Layout.alignment: Qt.AlignTop
            }
            Text {
                text: root.title
                font.weight: Theme.fontWeightSemiBold
                font.pixelSize: Theme.fontBody
                color: Theme.textPrimary
                Layout.fillWidth: true
                wrapMode: Text.Wrap
            }
            T.AbstractButton {
                id: closeBtn
                visible: root.isCloseButtonVisible
                implicitWidth: 28
                implicitHeight: 28
                hoverEnabled: true
                focusPolicy: Qt.StrongFocus
                Accessible.name: qsTr("Close")
                onClicked: root.close()
                scale: down && !Theme.reducedMotion ? 0.92 : 1
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingStandard
                    }
                }
                contentItem: Text {
                    text: "\uE711"
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 10
                    color: closeBtn.down ? Theme.textPrimary : Theme.textSecondary
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation {
                            duration: Theme.duration(Theme.motionFast)
                        }
                    }
                }
                background: Rectangle {
                    radius: Theme.cornerControl
                    color: {
                        if (closeBtn.down)
                            return Theme.fillSubtleTertiary
                        if (closeBtn.hovered || closeBtn.visualFocus)
                            return Theme.fillSubtle
                        return "transparent"
                    }
                    border.width: closeBtn.visualFocus ? 1 : 0
                    border.color: Theme.accent
                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation {
                            duration: Theme.duration(Theme.motionFast)
                        }
                    }
                }
            }
        }

        Text {
            visible: root.subtitle.length > 0
            text: root.subtitle
            color: Theme.textSecondary
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }

        Button {
            visible: root.actionText.length > 0
            Layout.alignment: Qt.AlignRight
            text: root.actionText
            highlighted: true
            onClicked: {
                root.actionClicked()
                root.close()
            }
        }
    }

    background: Item {
        MultiEffect {
            anchors.fill: parent
            anchors.margins: -8
            source: tipPanel
            shadowEnabled: true
            shadowOpacity: Theme.dark ? 0.28 : 0.16
            shadowColor: "#000000"
            shadowVerticalOffset: 6
            blurMax: 28
            autoPaddingEnabled: true
        }
        Rectangle {
            id: tipPanel
            anchors.fill: parent
            radius: Theme.cornerOverlay
            color: Theme.bgCard
            border.width: 1
            border.color: Theme.strokeCard

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: 1
                width: 3
                radius: 1.5
                color: Theme.accent
                opacity: 0.85
            }
        }
        Rectangle {
            id: tipArrow
            width: 10
            height: 10
            rotation: 45
            color: Theme.bgCard
            border.width: 1
            border.color: Theme.strokeCard
            z: -1
            anchors.horizontalCenter: {
                if (root.effectivePlacement === Qt.AlignLeft || root.effectivePlacement === Qt.AlignRight)
                    return undefined
                return parent.horizontalCenter
            }
            anchors.verticalCenter: {
                if (root.effectivePlacement === Qt.AlignTop || root.effectivePlacement === Qt.AlignBottom)
                    return undefined
                return parent.verticalCenter
            }
            anchors.bottom: root.effectivePlacement === Qt.AlignTop ? parent.bottom : undefined
            anchors.top: root.effectivePlacement === Qt.AlignBottom ? parent.top : undefined
            anchors.right: root.effectivePlacement === Qt.AlignLeft ? parent.right : undefined
            anchors.left: root.effectivePlacement === Qt.AlignRight ? parent.left : undefined
            anchors.bottomMargin: root.effectivePlacement === Qt.AlignTop ? -5 : 0
            anchors.topMargin: root.effectivePlacement === Qt.AlignBottom ? -5 : 0
            anchors.rightMargin: root.effectivePlacement === Qt.AlignLeft ? -5 : 0
            anchors.leftMargin: root.effectivePlacement === Qt.AlignRight ? -5 : 0
        }
    }

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0; to: 1
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEnter
        }
        NumberAnimation {
            property: "scale"
            from: 0.96; to: 1
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
}
