import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// InfoBar — Inline severity banner with optional action and Content slot.
//
//   InfoBar {
//       id: infoBar
//       title: qsTr("Saved")
//       message: qsTr("All changes stored.")
//       severity: InfoBar.Success
//       Button { flat: true; text: qsTr("Details") }
//   }
//
//   // --- API ---
//   // signals: onCloseClicked, onActionClicked, onClosed, onOpened
//   // methods: open(), close(), setSeverityName(name)
//   // infoBar.open() / infoBar.close()
//
// @notes
//   Inline severity banner: informational | success | warning | error.
//   WinUI Content slot via default children (below message); actionText or action slot; isClosable.
//   Content-only (no title/message) promotes Content to the primary row — no empty title gap.
//   collapseWhenClosed (default) drops layout space immediately when closed (no Stack spacing).
//   Prefer InfoBarHost.info/success/warning/error for stacked banners.
//   AlertMessage role; Qt 6.8+ Accessible.announce on open (1.85).

T.Control {
    id: root

    Layout.fillWidth: true

    // Informational severity constant
    readonly property int informational: 0
    // Success severity constant
    readonly property int success: 1
    // Warning severity constant
    readonly property int warning: 2
    // Error severity constant
    readonly property int error: 3

    // Status severity enum
    property int severity: informational
    // Primary title text
    property string title: ""
    // Body / message text
    property string message: ""
    // WinUI / docs alias of message
    property alias description: root.message
    // Open / visible state
    property bool isOpen: true
    // When true, closed bars leave no Column/Stack spacing (unlike WinUI IsOpen=false)
    property bool collapseWhenClosed: true
    // Shows a close affordance when true
    property bool closable: true
    // Alias of closable
    property alias isClosable: root.closable
    // Show leading status icon
    property bool showIcon: true
    // Show leading status icon
    property alias isIconVisible: root.showIcon
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Optional action button label
    property string actionText: ""
    // Custom action slot (WinUI ActionButton)
    property alias action: actionSlot.data
    // WinUI Content — rich body below the message (or primary row when content-only)
    default property alias content: contentSlot.data
    // Auto-dismiss duration; 0 keeps open
    property int durationMs: 0
    // Convenience string: "informational" | "success" | "warning" | "error"
    readonly property string severityName: {
        switch (severity) {
        case success: return "success"
        case warning: return "warning"
        case error: return "error"
        default: return "informational"
        }
    }
    readonly property bool _contentOnly: title.length === 0 && message.length === 0
                                         && contentSlot.children.length > 0

    // Close button clicked
    signal closeClicked()
    // Emitted when action is clicked
    signal actionClicked()
    // Swipe content closed
    signal closed()
    // Emitted when opened
    signal opened()

    function open() { isOpen = true }
    function close() { isOpen = false }

    function setSeverityName(name) {
        switch (String(name).toLowerCase()) {
        case "success": severity = success; break
        case "warning": severity = warning; break
        case "error": severity = error; break
        default: severity = informational; break
        }
    }

    function _liveText() {
        var parts = []
        if (title.length)
            parts.push(title)
        if (message.length)
            parts.push(message)
        if (severityName.length)
            parts.push(severityName)
        return parts.join(". ")
    }

    function _announceLive(text) {
        if (!text || text.length === 0)
            return
        try {
            if (typeof Accessible.announce === "function")
                Accessible.announce(text)
        } catch (err) {
        }
    }

    Accessible.role: Accessible.AlertMessage
    Accessible.name: title.length ? title : qsTr("Info bar")
    Accessible.description: {
        var parts = [severityName]
        if (message.length)
            parts.push(message)
        return parts.join(". ")
    }
    focusPolicy: isOpen ? Qt.StrongFocus : Qt.NoFocus
    activeFocusOnTab: isOpen

    Keys.onPressed: function (event) {
        if (!isOpen)
            return
        if (event.key === Qt.Key_Escape && closable) {
            isOpen = false
            closeClicked()
            event.accepted = true
        }
    }

    padding: isOpen ? 12 : 0
    leftPadding: isOpen ? 16 : 0
    rightPadding: isOpen ? padding : 0
    topPadding: isOpen ? 12 : 0
    bottomPadding: isOpen ? 12 : 0
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    implicitWidth: Math.max(280, contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: isOpen ? (contentItem.implicitHeight + topPadding + bottomPadding) : 0
    Layout.preferredHeight: implicitHeight

    visible: isOpen || (!collapseWhenClosed && opacity > 0.01)
    opacity: isOpen ? 1 : 0
    scale: isOpen ? 1 : 0.98
    transformOrigin: Item.Top
    clip: true

    onIsOpenChanged: {
        if (isOpen && durationMs > 0)
            autoClose.restart()
        else
            autoClose.stop()
        if (isOpen)
            root.opened()
        else
            root.closed()
        if (isOpen)
            Qt.callLater(function () { root._announceLive(root._liveText()) })
    }

    Timer {
        id: autoClose
        interval: root.durationMs
        onTriggered: {
            root.isOpen = false
            root.closeClicked()
        }
    }

    Behavior on opacity {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingStandard
        }
    }
    Behavior on scale {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingStandard
        }
    }
    Behavior on implicitHeight {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingStandard
        }
    }
    Behavior on padding {
        enabled: !Theme.reducedMotion
        NumberAnimation { duration: Theme.duration(Theme.motionFast) }
    }

    readonly property color _accent: {
        switch (severity) {
        case success: return Theme.systemSuccess
        case warning: return Theme.systemCaution
        case error: return Theme.systemCritical
        default: return Theme.systemAttention
        }
    }

    readonly property color _bg: {
        switch (severity) {
        case success: return Theme.systemSuccessBg
        case warning: return Theme.systemCautionBg
        case error: return Theme.systemCriticalBg
        default: return Theme.systemAttentionBg
        }
    }

    readonly property string _severityGlyph: {
        var custom = IconSource.resolve(symbol, iconGlyph)
        if (custom.length)
            return custom
        switch (severity) {
        case success: return FluentIcons.Accept
        case warning: return FluentIcons.Warning
        case error: return FluentIcons.Error
        default: return FluentIcons.Info
        }
    }

    background: Rectangle {
        radius: Theme.cornerControl
        color: root._bg
        border.width: 1
        border.color: Theme.strokeCard

        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 1
            width: 3
            radius: 1.5
            color: root._accent
        }
    }

    contentItem: RowLayout {
        spacing: Theme.spacingLoose

        Item { Layout.preferredWidth: 4 }

        Text {
            visible: root.showIcon
            Layout.alignment: Qt.AlignVCenter
            text: root._severityGlyph
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 16
            color: root._accent
        }

        // Content-only: promote Content into the primary row (no empty title gap).
        Item {
            id: contentSlotPrimaryHost
            visible: root._contentOnly
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredHeight: visible ? Math.max(contentSlot.height, 1) : 0
            Layout.preferredWidth: visible ? Math.max(contentSlot.width, 1) : 0
        }

        ColumnLayout {
            visible: !root._contentOnly
            Layout.fillWidth: true
            spacing: 4

            Text {
                visible: root.title.length > 0
                text: root.title
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
                wrapMode: Text.Wrap
                elide: Text.ElideRight
                maximumLineCount: 2
                Layout.fillWidth: true
            }

            Text {
                visible: root.message.length > 0
                text: root.message
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textPrimary
                wrapMode: Text.Wrap
                elide: Text.ElideRight
                maximumLineCount: 4
                Layout.fillWidth: true
            }

            Item {
                id: contentSlotBelowHost
                visible: !root._contentOnly && contentSlot.children.length > 0
                Layout.fillWidth: true
                Layout.preferredHeight: visible ? Math.max(contentSlot.height, 1) : 0
            }
        }

        Item {
            id: contentSlot
            parent: root._contentOnly ? contentSlotPrimaryHost : contentSlotBelowHost
            width: childrenRect.width
            height: childrenRect.height
            visible: children.length > 0
        }

        Item {
            id: actionSlot
            visible: children.length > 0
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }

        Button {
            visible: root.actionText.length > 0
            Layout.alignment: Qt.AlignVCenter
            text: root.actionText
            flat: true
            onClicked: root.actionClicked()
        }

        T.AbstractButton {
            id: closeButton
            visible: root.closable
            implicitWidth: 32
            implicitHeight: 32
            hoverEnabled: true
            focusPolicy: Qt.StrongFocus
            activeFocusOnTab: root.isOpen
            Accessible.role: Accessible.Button
            Accessible.name: qsTr("Close")
            onClicked: {
                root.isOpen = false
                root.closeClicked()
            }
            Keys.onReturnPressed: closeButton.clicked()
            Keys.onEnterPressed: closeButton.clicked()
            Keys.onSpacePressed: closeButton.clicked()

            contentItem: Text {
                text: FluentIcons.ChromeClose
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 10
                color: Theme.textSecondary
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                scale: closeButton.down ? 0.9 : 1
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingStandard
                    }
                }
            }
            background: Rectangle {
                radius: Theme.cornerControl
                color: closeButton.down ? Theme.fillSubtleTertiary
                     : (closeButton.hovered ? Theme.fillSubtle : "transparent")
                Behavior on color {
                    enabled: !Theme.reducedMotion
                    ColorAnimation {
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingStandard
                    }
                }
            }
        }
    }
}
