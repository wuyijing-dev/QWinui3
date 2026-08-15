import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// ContentDialog — Modal dialog with primary / secondary / close actions.
//
//   ContentDialog {
//       title: qsTr("Confirm")
//       primaryButtonText: qsTr("OK")
//       closeButtonText: qsTr("Cancel")
//   }
//   // prefer dialog.show() → ContentDialogQueue

T.Dialog {
    id: root

    // Primary action label (accent); empty hides the button
    property string primaryButtonText: qsTr("OK")
    // Optional middle action; empty hides
    property string secondaryButtonText: ""
    // Dismiss / cancel label; empty hides
    property string closeButtonText: qsTr("Cancel")
    // Prefer defaultButton; isPrimaryDefault kept for compatibility
    property bool isPrimaryDefault: true
    // WinUI DefaultButton: primary | secondary | close | none
    property string defaultButton: ""
    property bool isPrimaryButtonEnabled: true
    property bool isSecondaryButtonEnabled: true
    property bool isCloseButtonEnabled: true
    // Bindable open state (alias of visible)
    property alias isOpen: root.visible
    property bool __queueWired: false

    signal primaryClicked()
    signal secondaryClicked()
    signal closeClicked()

    // Enqueue via ContentDialogQueue (preferred over open())
    function show() { ContentDialogQueue.enqueue(root) }
    function hide() { close() }
    function openQueued() { ContentDialogQueue.enqueue(root) }

    readonly property string _defaultButton: {
        if (defaultButton.length)
            return defaultButton
        return isPrimaryDefault ? "primary" : "none"
    }

    modal: true
    focus: true
    anchors.centerIn: Overlay.overlay
    closePolicy: T.Popup.CloseOnEscape
    standardButtons: T.Dialog.NoButton
    padding: 0
    spacing: 0
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    title: ""
    transformOrigin: Item.Center

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
            from: 1; to: 0.98
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingExit
        }
    }

    // Lock geometry to the column — never let Popup stretch the middle.
    width: Math.max(320, Math.min(440, column.implicitWidth))
    height: column.implicitHeight

    header: Item { implicitHeight: 0; implicitWidth: 0; visible: false }
    footer: Item { implicitHeight: 0; implicitWidth: 0; visible: false }

    Keys.onReturnPressed: event => { activateDefault(); event.accepted = true }
    Keys.onEnterPressed: event => { activateDefault(); event.accepted = true }

    function activateDefault() {
        switch (root._defaultButton) {
        case "primary":
            if (primaryBtn.visible && primaryBtn.enabled)
                primaryBtn.clicked()
            break
        case "secondary":
            if (secondaryBtn.visible && secondaryBtn.enabled)
                secondaryBtn.clicked()
            break
        case "close":
            if (closeBtn.visible && closeBtn.enabled)
                closeBtn.clicked()
            break
        }
    }

    background: ElevatedChrome {
        color: Theme.bgCard
        radius: Theme.cornerOverlay
        borderColor: Theme.strokeCard
        borderWidth: 1
        elevation: 8
        shadowOpacity: 0.22
    }

    contentItem: ColumnLayout {
        id: column
        spacing: 0
        width: root.width > 0 ? root.width : 360

        Label {
            id: titleLabel
            Layout.fillWidth: true
            Layout.leftMargin: 24
            Layout.rightMargin: 24
            Layout.topMargin: 20
            Layout.bottomMargin: 8
            text: root.title
            visible: root.title.length > 0
            font.family: Theme.fontFamilyDisplay
            font.pixelSize: Theme.fontSubtitle
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textPrimary
            wrapMode: Text.Wrap
        }

        Item {
            id: body
            Layout.fillWidth: true
            Layout.leftMargin: 24
            Layout.rightMargin: 24
            Layout.preferredHeight: Math.max(1, childrenRect.height)
            Layout.bottomMargin: 16
            onWidthChanged: root._fitBodyChildren()
            onChildrenChanged: Qt.callLater(root._fitBodyChildren)
        }

        Rectangle {
            id: divider
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Theme.strokeDivider
            opacity: 0.7
        }

        Item {
            id: buttonBar
            Layout.fillWidth: true
            Layout.preferredHeight: buttonRow.implicitHeight + 32

            Row {
                id: buttonRow
                anchors.right: parent.right
                anchors.rightMargin: 24
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.spacing

                Button {
                    id: primaryBtn
                    text: root.primaryButtonText
                    visible: root.primaryButtonText.length > 0
                    enabled: root.isPrimaryButtonEnabled
                    highlighted: root._defaultButton === "primary"
                    onClicked: {
                        root.primaryClicked()
                        root.accept()
                    }
                }
                Button {
                    id: secondaryBtn
                    text: root.secondaryButtonText
                    visible: root.secondaryButtonText.length > 0
                    enabled: root.isSecondaryButtonEnabled
                    highlighted: root._defaultButton === "secondary"
                    onClicked: root.secondaryClicked()
                }
                Button {
                    id: closeBtn
                    text: root.closeButtonText
                    visible: root.closeButtonText.length > 0
                    enabled: root.isCloseButtonEnabled
                    highlighted: root._defaultButton === "close"
                    onClicked: {
                        root.closeClicked()
                        root.reject()
                    }
                }
            }
        }
    }

    Component.onCompleted: Qt.callLater(syncBody)
    onAboutToShow: syncBody()

    // Instance children land on contentItem; move them into the body slot.
    function syncBody() {
        var move = []
        for (var i = 0; i < column.children.length; ++i) {
            var ch = column.children[i]
            if (ch === titleLabel || ch === body || ch === divider || ch === buttonBar)
                continue
            move.push(ch)
        }
        for (i = 0; i < move.length; ++i)
            move[i].parent = body
        _fitBodyChildren()
    }

    function _fitBodyChildren() {
        for (var i = 0; i < body.children.length; ++i) {
            var ch = body.children[i]
            if (!ch)
                continue
            ch.width = body.width
            if (ch.wrapMode !== undefined && ch.wrapMode !== Text.NoWrap)
                ch.wrapMode = Text.Wrap
        }
    }

    T.Overlay.modal: Rectangle {
        color: Theme.bgSmoke
        Behavior on opacity {
            enabled: !Theme.reducedMotion
            NumberAnimation { duration: Theme.duration(Theme.motionFast) }
        }
    }
}
