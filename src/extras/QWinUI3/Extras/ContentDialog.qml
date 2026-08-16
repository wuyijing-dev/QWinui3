import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// ContentDialog — Modal dialog with primary / secondary / close actions.
//
//   ContentDialog {
//       id: dlg
//       title: qsTr("Confirm")
//       primaryButtonText: qsTr("OK")
//       secondaryButtonText: qsTr("More")
//       closeButtonText: qsTr("Cancel")
//       onPrimaryClicked: { /* … */ }
//       onSecondaryClicked: { /* … */ }
//       onCloseClicked: { /* … */ }
//   }
//
//   // --- API ---
//   // dlg.show()          // enqueue via ContentDialogQueue (preferred)
//   // dlg.hide()          // close
//   // dlg.activateDefault()
//   // signals: onPrimaryClicked, onSecondaryClicked, onCloseClicked
//   // inherits Dialog: open(), close(), title, accepted(), rejected()
//
// @notes
//   Prefer show() -> ContentDialogQueue so dialogs open one-at-a-time.
//   Empty primary/secondary/closeButtonText hides that button.
//   defaultButton: primary | secondary | close | none (or isPrimaryDefault).
//   fullSizeDesired expands toward the overlay (WinUI FullSizeDesired).
//   dialogResult: none | primary | secondary | close (WinUI ContentDialogResult).
//   primaryButton / secondaryButton / closeButton slots override text buttons.
//   Body: put content as children (moved into the dialog body slot).

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
    // Enable primary button
    property bool isPrimaryButtonEnabled: true
    // Enable secondary button
    property bool isSecondaryButtonEnabled: true
    // Enable close button
    property bool isCloseButtonEnabled: true
    // WinUI FullSizeDesired — nearly fill the overlay when true
    property bool fullSizeDesired: false
    // WinUI ContentDialogResult: none | primary | secondary | close
    // (dialogResult — cannot redeclare Dialog.result which is FINAL)
    property string dialogResult: "none"
    // Custom primary button content (overrides primaryButtonText when set)
    property alias primaryButton: primarySlot.data
    // Custom secondary button content
    property alias secondaryButton: secondarySlot.data
    // Custom close button content
    property alias closeButton: closeSlot.data
    // Bindable open state (alias of visible)
    property alias isOpen: root.visible
    property bool __queueWired: false

    Accessible.role: Accessible.Dialog
    Accessible.name: title
    Accessible.description: primaryButtonText.length
                            ? qsTr("%1 dialog").arg(title)
                            : title

    // Primary button clicked
    signal primaryClicked()
    // Secondary button clicked
    signal secondaryClicked()
    // Close button clicked
    signal closeClicked()
    // Closed with a ContentDialogResult
    signal resultReady(string result)
    // WinUI Closing — set args.cancel = true to keep the dialog open
    signal closing(var args)

    // Enqueue via ContentDialogQueue (preferred over open())
    function show() { ContentDialogQueue.enqueue(root) }
    // Hide the control (respects Closing cancel)
    function hide() { requestClose(root.dialogResult !== "none" ? root.dialogResult : "close") }

    function requestClose(kind) {
        var args = { cancel: false, result: kind || "none" }
        closing(args)
        if (args.cancel)
            return false
        if (kind && kind !== "none")
            _finish(kind)
        close()
        return true
    }

    // Open the next queued dialog
    function openQueued() { ContentDialogQueue.enqueue(root) }

    readonly property string _defaultButton: {
        if (defaultButton.length)
            return defaultButton
        return isPrimaryDefault ? "primary" : "none"
    }
    readonly property bool _hasPrimaryCustom: primarySlot.children.length > 0
    readonly property bool _hasSecondaryCustom: secondarySlot.children.length > 0
    readonly property bool _hasCloseCustom: closeSlot.children.length > 0

    function _finish(kind) {
        root.dialogResult = kind
        root.resultReady(kind)
    }

    onAboutToShow: {
        root.dialogResult = "none"
        syncBody()
    }
    onAccepted: {
        if (root.dialogResult === "none")
            _finish("primary")
    }
    onRejected: {
        if (root.dialogResult === "none")
            _finish("close")
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
    // WinUI FullSizeDesired: expand toward the overlay with a margin.
    width: {
        if (fullSizeDesired && Overlay.overlay)
            return Math.max(320, Overlay.overlay.width - 48)
        return Math.max(320, Math.min(440, column.implicitWidth))
    }
    height: {
        if (fullSizeDesired && Overlay.overlay)
            return Math.max(column.implicitHeight, Overlay.overlay.height - 48)
        return column.implicitHeight
    }
    header: Item { implicitHeight: 0; implicitWidth: 0; visible: false }
    footer: Item { implicitHeight: 0; implicitWidth: 0; visible: false }

    Keys.onReturnPressed: event => { activateDefault(); event.accepted = true }
    Keys.onEnterPressed: event => { activateDefault(); event.accepted = true }

    // Activate the default button / action
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
            Layout.fillHeight: root.fullSizeDesired
            Layout.leftMargin: 24
            Layout.rightMargin: 24
            Layout.preferredHeight: root.fullSizeDesired
                                   ? Math.max(120, childrenRect.height)
                                   : Math.max(1, childrenRect.height)
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
                    visible: !_hasPrimaryCustom && root.primaryButtonText.length > 0
                    enabled: root.isPrimaryButtonEnabled
                    highlighted: root._defaultButton === "primary"
                    onClicked: {
                        root.primaryClicked()
                        if (!root.requestClose("primary"))
                            return
                        // requestClose already dismissed; avoid double-close via accept()
                    }
                }
                Item {
                    id: primarySlot
                    visible: root._hasPrimaryCustom
                    width: visible ? Math.max(childrenRect.width, 1) : 0
                    height: visible ? Math.max(childrenRect.height, Theme.controlHeight) : 0
                }
                Button {
                    id: secondaryBtn
                    text: root.secondaryButtonText
                    visible: !_hasSecondaryCustom && root.secondaryButtonText.length > 0
                    enabled: root.isSecondaryButtonEnabled
                    highlighted: root._defaultButton === "secondary"
                    onClicked: {
                        root.secondaryClicked()
                        root.requestClose("secondary")
                    }
                }
                Item {
                    id: secondarySlot
                    visible: root._hasSecondaryCustom
                    width: visible ? Math.max(childrenRect.width, 1) : 0
                    height: visible ? Math.max(childrenRect.height, Theme.controlHeight) : 0
                }
                Button {
                    id: closeBtn
                    text: root.closeButtonText
                    visible: !_hasCloseCustom && root.closeButtonText.length > 0
                    enabled: root.isCloseButtonEnabled
                    highlighted: root._defaultButton === "close"
                    onClicked: {
                        root.closeClicked()
                        root.requestClose("close")
                    }
                }
                Item {
                    id: closeSlot
                    visible: root._hasCloseCustom
                    width: visible ? Math.max(childrenRect.width, 1) : 0
                    height: visible ? Math.max(childrenRect.height, Theme.controlHeight) : 0
                }
            }
        }
    }

    Component.onCompleted: Qt.callLater(syncBody)

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
