import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

T.Popup {
    id: root

    readonly property alias primaryCommands: primaryRow
    readonly property alias secondaryCommands: secondaryCol
    default property alias primaryData: primaryRow.data

    property bool isOpen: false
    property bool isLightDismissEnabled: true
    property Item target: null

    readonly property bool showSecondary: secondaryCol.children.length > 0

    function showAt(item) {
        if (item) {
            root.target = item
            root.parent = item
        }
        root.isOpen = true
    }

    function show() { isOpen = true }
    function hide() { isOpen = false }

    onIsOpenChanged: {
        if (isOpen)
            open()
        else if (visible)
            close()
    }
    onOpened: isOpen = true
    onClosed: isOpen = false

    padding: 6
    modal: false
    dim: false
    closePolicy: isLightDismissEnabled
                 ? (T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside)
                 : T.Popup.CloseOnEscape
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

    background: ElevatedChrome {
        color: Theme.bgCardElevated
        radius: Theme.cornerOverlay
        borderColor: Theme.strokeCard
        borderWidth: 1
        elevation: 6
        shadowOpacity: Theme.dark ? 0.32 : 0.18
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
