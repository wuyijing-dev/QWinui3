import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QtQuick.Effects
import QWinUI3.Theme

T.Popup {
    id: root

    readonly property alias primaryCommands: primaryRow
    readonly property alias secondaryCommands: secondaryCol
    // Default children land in the primary command strip
    default property alias primaryData: primaryRow.data

    readonly property bool showSecondary: secondaryCol.children.length > 0

    function showAt(item) {
        if (item)
            root.parent = item
        root.open()
    }

    padding: 6
    modal: false
    dim: false
    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside
    transformOrigin: Item.Top
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    implicitWidth: Math.max(200, contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    x: parent ? Math.max(0, (parent.width - implicitWidth) / 2) : 0
    y: parent ? parent.height + 8 : 0

    contentItem: ColumnLayout {
        spacing: 4

        RowLayout {
            id: primaryRow
            spacing: 2
            Layout.fillWidth: true
        }

        Rectangle {
            visible: root.showSecondary
            Layout.fillWidth: true
            Layout.leftMargin: 4
            Layout.rightMargin: 4
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            height: 1
            color: Theme.strokeDivider
            opacity: 0.9
        }

        ColumnLayout {
            id: secondaryCol
            visible: root.showSecondary
            spacing: 2
            Layout.fillWidth: true
        }
    }

    background: Rectangle {
        radius: Theme.cornerOverlay
        color: Theme.bgCardElevated
        border.width: 1
        border.color: Theme.strokeCard

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowOpacity: Theme.dark ? 0.32 : 0.18
            shadowColor: "#000000"
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 8
            blurMax: 28
            autoPaddingEnabled: true
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

    function show() { open() }
    function hide() { close() }
}
