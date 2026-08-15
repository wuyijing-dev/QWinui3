import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// InfoBar — Inline severity banner with optional action.
//
//   InfoBar {
//       title: qsTr("Saved")
//       message: qsTr("All changes stored.")
//       severity: InfoBar.Success
//   }

T.Control {
    id: root

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
    // Open / visible state
    property bool isOpen: true
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
    // Custom action slot
    property alias action: actionSlot.data
    // Auto-dismiss duration; 0 keeps open
    property int durationMs: 0 // >0 auto-dismisses after open
    // Convenience string: "informational" | "success" | "warning" | "error"
    readonly property string severityName: {
        switch (severity) {
        case success: return "success"
        case warning: return "warning"
        case error: return "error"
        default: return "informational"
        }
    }

    // Close button clicked
    signal closeClicked()
    // Emitted when action is clicked
    signal actionClicked()
    // Swipe content closed
    signal closed()
    // Emitted when opened
    signal opened()

    // Open
    function open() { isOpen = true }
    // Close
    function close() { isOpen = false }

    // Set Severity Name
    function setSeverityName(name) {
        switch (String(name).toLowerCase()) {
        case "success": severity = success; break
        case "warning": severity = warning; break
        case "error": severity = error; break
        default: severity = informational; break
        }
    }

    Accessible.role: Accessible.AlertMessage
    Accessible.name: title.length ? title : qsTr("Info bar")
    Accessible.description: message

    padding: isOpen ? 12 : 0
    leftPadding: isOpen ? 16 : 0
    rightPadding: isOpen ? padding : 0
    topPadding: isOpen ? 12 : 0
    bottomPadding: isOpen ? 12 : 0
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    implicitWidth: Math.max(280, contentItem.implicitWidth + leftPadding + rightPadding)
    // WinUI: closed InfoBar collapses layout height (no reserved gap).
    implicitHeight: isOpen ? (contentItem.implicitHeight + topPadding + bottomPadding) : 0
    Layout.preferredHeight: implicitHeight

    visible: isOpen || opacity > 0.01
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
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 2
            text: root._severityGlyph
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 16
            color: root._accent
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                visible: root.title.length > 0
                text: root.title
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            Text {
                text: root.message
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textPrimary
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
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
            Accessible.name: qsTr("Close")
            onClicked: {
                root.isOpen = false
                root.closeClicked()
            }

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
