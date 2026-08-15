import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

T.Popup {
    id: root

    property int placement: Qt.AlignBottom
    property alias preferredPlacement: root.placement
    property Item target: null
    property bool isLightDismissEnabled: true
    property bool isOpen: false
    default property alias contentData: body.data

    padding: 12
    modal: false
    dim: false
    closePolicy: isLightDismissEnabled
                 ? (T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside)
                 : T.Popup.CloseOnEscape
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    implicitWidth: Math.max(180, contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    onIsOpenChanged: {
        if (isOpen)
            open()
        else if (visible)
            close()
    }
    onOpened: isOpen = true
    onClosed: isOpen = false

    transformOrigin: {
        switch (placement) {
        case Qt.AlignTop: return Item.Bottom
        case Qt.AlignLeft: return Item.Right
        case Qt.AlignRight: return Item.Left
        default: return Item.Top
        }
    }

    function showAt(item, place) {
        if (item) {
            root.target = item
            root.parent = item
        }
        if (place !== undefined && place !== null)
            root.placement = place
        root.isOpen = true
    }

    function show() { isOpen = true }
    function hide() { isOpen = false }

    x: {
        if (!parent)
            return 0
        switch (placement) {
        case Qt.AlignRight: return parent.width + 8
        case Qt.AlignLeft: return -implicitWidth - 8
        default: return Math.max(0, (parent.width - implicitWidth) / 2)
        }
    }
    y: {
        if (!parent)
            return 0
        switch (placement) {
        case Qt.AlignTop: return -implicitHeight - 8
        case Qt.AlignRight:
        case Qt.AlignLeft: return Math.max(0, (parent.height - implicitHeight) / 2)
        default: return parent.height + 8
        }
    }

    contentItem: ColumnLayout {
        id: body
        spacing: Theme.spacing
    }

    background: ElevatedChrome {
        color: Theme.bgCard
        radius: Theme.cornerOverlay
        borderColor: Theme.strokeCard
        borderWidth: 1
        elevation: 6
        shadowOpacity: Theme.dark ? 0.28 : 0.16
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
        NumberAnimation {
            property: "scale"
            from: 1; to: 0.96
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingExit
        }
    }
}
