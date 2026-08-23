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
//   Keyboard (1.16): Enter/Return → activateDefault(); Esc → close path via requestClose
//   (honors onClosing { args.cancel = true }). Outside click does not dismiss.
//   On close, focus returns to the opener (1.85).

T.Dialog {
    id: root

    property string primaryButtonText: qsTr("OK")
    property string secondaryButtonText: ""
    property string closeButtonText: qsTr("Cancel")
    property bool isPrimaryDefault: true
    property string defaultButton: ""
    property bool isPrimaryButtonEnabled: true
    property bool isSecondaryButtonEnabled: true
    property bool isCloseButtonEnabled: true
    property bool fullSizeDesired: false
    property string dialogResult: "none"
    property alias primaryButton: primarySlot.data
    property alias secondaryButton: secondarySlot.data
    property alias closeButton: closeSlot.data
    property alias isOpen: root.visible
    property bool __queueWired: false
    property Item _focusReturn: null

    signal primaryClicked()
    signal secondaryClicked()
    signal closeClicked()
    signal resultReady(string result)
    signal closing(var args)

    function show() { ContentDialogQueue.enqueue(root) }
    function showFront() { ContentDialogQueue.enqueueFront(root) }
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

    function _captureFocusReturn() {
        var win = root.Window ? root.Window.window : null
        if (!win && typeof Overlay !== "undefined" && Overlay.overlay && Overlay.overlay.Window)
            win = Overlay.overlay.Window.window
        var item = (win && win.activeFocusItem) ? win.activeFocusItem : null
        var p = item
        while (p) {
            if (p === root) {
                item = null
                break
            }
            p = p.parent
        }
        _focusReturn = item
    }

    function _restoreFocusReturn() {
        var item = _focusReturn
        _focusReturn = null
        if (!item)
            return
        Qt.callLater(function () {
            if (item && item.visible && typeof item.forceActiveFocus === "function")
                item.forceActiveFocus()
        })
    }

    onAboutToShow: {
        root.dialogResult = "none"
        syncBody()
        _captureFocusReturn()
    }
    onOpened: Qt.callLater(function () { chrome.forceActiveFocus() })
    onClosed: _restoreFocusReturn()
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
    // Esc handled below so onClosing can cancel; do not light-dismiss on outside click.
    closePolicy: T.Popup.NoAutoClose
    standardButtons: T.Dialog.NoButton
    padding: 0
    topPadding: 0
    bottomPadding: 0
    leftPadding: 0
    rightPadding: 0
    spacing: 0
    font.pixelSize: Theme.fontBody
    title: ""
    transformOrigin: Item.Center

    // Size to chrome content — grow for the command bar; do not let Dialog stretch a hollow middle.
    readonly property real _buttonBarNeededWidth: buttonRow.implicitWidth + 48
    readonly property real _maxDialogWidth: Overlay.overlay ? Math.max(320, Overlay.overlay.width - 48) : 640
    implicitWidth: fullSizeDesired && Overlay.overlay
                   ? Math.max(320, Overlay.overlay.width - 48)
                   : Math.max(320, Math.min(_maxDialogWidth,
                                            Math.max(320, column.implicitWidth, _buttonBarNeededWidth)))
    implicitHeight: fullSizeDesired && Overlay.overlay
                    ? Math.max(column.implicitHeight, Overlay.overlay.height - 48)
                    : column.implicitHeight
    width: implicitWidth
    height: implicitHeight
    contentWidth: column.implicitWidth
    contentHeight: column.implicitHeight

    header: Item { implicitHeight: 0; implicitWidth: 0; visible: false; height: 0 }
    footer: Item { implicitHeight: 0; implicitWidth: 0; visible: false; height: 0 }

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

    Shortcut {
        sequences: ["Return", "Enter"]
        enabled: root.visible && root._defaultButton !== "none" && !root._focusIsMultiline()
        context: Qt.WindowShortcut
        onActivated: root.activateDefault()
    }
    Shortcut {
        sequences: ["Escape"]
        enabled: root.visible
        context: Qt.WindowShortcut
        onActivated: {
            if (closeBtn.visible && closeBtn.enabled)
                closeBtn.clicked()
            else
                root.requestClose("close")
        }
    }

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

    function _focusIsMultiline() {
        var win = root.Window ? root.Window.window : null
        if (!win || !win.activeFocusItem)
            return false
        var item = win.activeFocusItem
        var p = item
        var inside = false
        while (p) {
            if (p === root) {
                inside = true
                break
            }
            p = p.parent
        }
        if (!inside)
            return false
        return item instanceof TextArea
    }

    background: ElevatedChrome {
        color: Theme.bgCard
        radius: Theme.cornerOverlay
        borderColor: Theme.strokeCard
        borderWidth: 1
        elevation: 8
        shadowOpacity: 0.22
    }

    contentItem: Item {
        id: chrome
        // Match dialog size; column sizes to its children (WinUI packing).
        implicitWidth: column.implicitWidth
        implicitHeight: column.implicitHeight
        width: root.width
        height: root.fullSizeDesired ? root.height : column.implicitHeight
        clip: true
        focus: true
        Accessible.role: Accessible.Dialog
        Accessible.name: root.title.length ? root.title : qsTr("Dialog")
        Keys.onReturnPressed: function (event) {
            if (root._focusIsMultiline())
                return
            root.activateDefault()
            event.accepted = true
        }
        Keys.onEnterPressed: function (event) {
            if (root._focusIsMultiline())
                return
            root.activateDefault()
            event.accepted = true
        }
        Keys.onEscapePressed: function (event) {
            event.accepted = true
            if (closeBtn.visible && closeBtn.enabled)
                closeBtn.clicked()
            else
                root.requestClose("close")
        }
        // Do not echo title — body text is announced via children when present.

        Column {
            id: column
            width: parent.width
            spacing: 0

            Item {
                id: titleBlock
                width: parent.width
                height: root.title.length > 0 ? titleLabel.implicitHeight + 28 : 12

                Label {
                    id: titleLabel
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.leftMargin: 24
                    anchors.rightMargin: 24
                    anchors.topMargin: 20
                    text: root.title
                    visible: root.title.length > 0
                    font.pixelSize: Theme.fontSubtitle
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                    wrapMode: Text.Wrap
                }
            }

            Item {
                id: body
                width: parent.width
                // Content-sized; only grow under fullSizeDesired
                height: {
                    var h = Math.max(1, bodyContentHeight)
                    if (root.fullSizeDesired) {
                        var used = titleBlock.height + divider.height + buttonBar.height
                        return Math.max(h + 16, Math.max(120, chrome.height - used))
                    }
                    // 16px under body content before the command-bar divider (WinUI)
                    return h + 16
                }

                readonly property real bodyContentHeight: {
                    var maxBottom = 0
                    for (var i = 0; i < children.length; ++i) {
                        var ch = children[i]
                        if (!ch || !ch.visible)
                            continue
                        maxBottom = Math.max(maxBottom, ch.y + ch.height)
                    }
                    return maxBottom
                }

                onWidthChanged: root._fitBodyChildren()
                onChildrenChanged: Qt.callLater(root._fitBodyChildren)
            }

            Rectangle {
                id: divider
                width: parent.width
                height: 1
                color: Theme.strokeDivider
                opacity: 0.7
            }

            Item {
                id: buttonBar
                width: parent.width
                implicitWidth: buttonRow.implicitWidth + 48
                // Top 16 + button + bottom 24 — keeps actions inside rounded chrome
                height: Math.max(Theme.controlHeight, buttonRow.implicitHeight) + 40

                RowLayout {
                    id: buttonRow
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 24
                    anchors.rightMargin: 24
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 24
                    spacing: Theme.spacing

                    // Pack actions on the trailing edge without overflowing the chrome.
                    Item { Layout.fillWidth: true }

                    Button {
                        id: primaryBtn
                        text: root.primaryButtonText
                        visible: !_hasPrimaryCustom && root.primaryButtonText.length > 0
                        enabled: root.isPrimaryButtonEnabled
                        highlighted: root._defaultButton === "primary"
                        Layout.fillWidth: false
                        onClicked: {
                            root.primaryClicked()
                            root.requestClose("primary")
                        }
                    }
                    Item {
                        id: primarySlot
                        visible: root._hasPrimaryCustom
                        Layout.preferredWidth: visible ? Math.max(childrenRect.width, 1) : 0
                        Layout.preferredHeight: visible ? Math.max(childrenRect.height, Theme.controlHeight) : 0
                        width: Layout.preferredWidth
                        height: Layout.preferredHeight
                    }
                    Button {
                        id: secondaryBtn
                        text: root.secondaryButtonText
                        visible: !_hasSecondaryCustom && root.secondaryButtonText.length > 0
                        enabled: root.isSecondaryButtonEnabled
                        highlighted: root._defaultButton === "secondary"
                        Layout.fillWidth: false
                        onClicked: {
                            root.secondaryClicked()
                            root.requestClose("secondary")
                        }
                    }
                    Item {
                        id: secondarySlot
                        visible: root._hasSecondaryCustom
                        Layout.preferredWidth: visible ? Math.max(childrenRect.width, 1) : 0
                        Layout.preferredHeight: visible ? Math.max(childrenRect.height, Theme.controlHeight) : 0
                        width: Layout.preferredWidth
                        height: Layout.preferredHeight
                    }
                    Button {
                        id: closeBtn
                        text: root.closeButtonText
                        visible: !_hasCloseCustom && root.closeButtonText.length > 0
                        enabled: root.isCloseButtonEnabled
                        highlighted: root._defaultButton === "close"
                        Layout.fillWidth: false
                        onClicked: {
                            root.closeClicked()
                            root.requestClose("close")
                        }
                    }
                    Item {
                        id: closeSlot
                        visible: root._hasCloseCustom
                        Layout.preferredWidth: visible ? Math.max(childrenRect.width, 1) : 0
                        Layout.preferredHeight: visible ? Math.max(childrenRect.height, Theme.controlHeight) : 0
                        width: Layout.preferredWidth
                        height: Layout.preferredHeight
                    }
                }
            }
        }
    }

    Component.onCompleted: Qt.callLater(syncBody)

    function syncBody() {
        var move = []
        // Instance children may land on contentItem (chrome) or column
        var pools = [chrome, column]
        for (var p = 0; p < pools.length; ++p) {
            var host = pools[p]
            if (!host)
                continue
            for (var i = 0; i < host.children.length; ++i) {
                var ch = host.children[i]
                if (ch === column || ch === titleBlock || ch === body
                        || ch === divider || ch === buttonBar || ch === titleLabel)
                    continue
                // Skip structural pieces already under column
                if (ch.parent === column
                        && (ch === titleBlock || ch === body || ch === divider || ch === buttonBar))
                    continue
                if (ch === body || ch.parent === body)
                    continue
                move.push(ch)
            }
        }
        for (i = 0; i < move.length; ++i) {
            if (move[i].parent !== body)
                move[i].parent = body
        }
        _fitBodyChildren()
    }

    function _fitBodyChildren() {
        var x = 24
        var w = Math.max(1, body.width - 48)
        var y = 0
        for (var i = 0; i < body.children.length; ++i) {
            var ch = body.children[i]
            if (!ch || !ch.visible)
                continue
            ch.x = x
            ch.y = y
            ch.width = w
            if (ch.wrapMode !== undefined)
                ch.wrapMode = Text.Wrap
            // Prefer content height — avoid stretching labels into a tall empty body
            if (ch.implicitHeight > 0)
                ch.height = ch.implicitHeight
            y += ch.height + (i < body.children.length - 1 ? 8 : 0)
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
