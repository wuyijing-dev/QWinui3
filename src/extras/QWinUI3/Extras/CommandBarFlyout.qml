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
    property alias secondaryData: secondaryCol.data

    property bool isOpen: false
    property bool isLightDismissEnabled: true
    property Item target: null
    property int placement: Qt.AlignBottom
    property alias preferredPlacement: root.placement

    readonly property bool showSecondary: secondaryCol.children.length > 0

    function showAt(item, preferredPlacement) {
        if (preferredPlacement !== undefined && preferredPlacement !== null)
            root.placement = preferredPlacement
        if (item) {
            root.target = item
            root.parent = item
            root.x = 0
            root.y = 0
            switch (root.placement) {
            case Qt.AlignTop:
                root.y = -root.implicitHeight - 8
                break
            case Qt.AlignRight:
                root.x = item.width + 8
                root.y = 0
                break
            case Qt.AlignLeft:
                root.x = -root.implicitWidth - 8
                root.y = 0
                break
            default:
                root.x = Math.max(0, (item.width - root.implicitWidth) / 2)
                root.y = item.height + 8
                break
            }
        }
        root.isOpen = true
    }

    function show() { isOpen = true }
    function hide() { isOpen = false }
    function openFlyout() { show() }
    function closeFlyout() { hide() }

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
    transformOrigin: {
        switch (placement) {
        case Qt.AlignTop: return Item.Bottom
        case Qt.AlignLeft: return Item.Right
        case Qt.AlignRight: return Item.Left
        default: return Item.Top
        }
    }
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    Accessible.role: Accessible.PopupMenu
    Accessible.name: qsTr("Command bar flyout")

    implicitWidth: Math.max(200, contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

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
