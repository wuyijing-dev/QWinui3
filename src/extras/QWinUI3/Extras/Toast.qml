import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// Toast — Transient toast item.
//
//   Toast {
//       id: toast
//       title: qsTr("Saved"); message: qsTr("OK")
//   }
//
//   // --- API ---
//   // signals: onActionClicked, onClosed
//   // methods: show(msg, sev), open(), close(), hide()
//   // toast.show(msg, sev)
//   // toast.open()
//   // toast.close()
//   // toast.hide()
//
// @notes
//   Transient toast content; prefer ToastHost.info/success/warning/error helpers.

T.Control {
    id: control

    // Primary title text
    property string title: ""
    // Body / message text
    property string message: ""
    // Status severity enum
    property int severity: informational
    // Auto-dismiss duration; 0 keeps open
    property int durationMs: 3200
    // Open / visible state
    property bool isOpen: false
    // Optional action button label
    property string actionText: ""
    // Show progress indicator
    property bool showProgress: true
    // Pause auto-advance while hovered
    property bool pauseOnHover: true
    // Slide enter from bottom (false = from top) — set by ToastHost placement
    property bool slideFromBottom: true
    // Emitted when action is clicked
    signal actionClicked()
    // Swipe content closed
    signal closed()

    // Informational severity constant
    readonly property int informational: 0
    // Success severity constant
    readonly property int success: 1
    // Warning severity constant
    readonly property int warning: 2
    // Error severity constant
    readonly property int error: 3

    // Severity as string name
    readonly property string severityName: {
        switch (severity) {
        case success: return qsTr("Success")
        case warning: return qsTr("Warning")
        case error: return qsTr("Error")
        default: return qsTr("Informational")
        }
    }

    padding: 12
    leftPadding: 16
    rightPadding: 12
    implicitWidth: Math.min(420, Math.max(260, contentItem.implicitWidth + leftPadding + rightPadding))
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding + (showProgress ? 3 : 0)
    opacity: isOpen ? 1 : 0
    visible: opacity > 0.01
    z: 1000
    // Animate via transform so anchors (ToastHost placement / Gallery overlay) stay stable.
    scale: isOpen ? 1 : 0.96
    transformOrigin: slideFromBottom ? Item.Bottom : Item.Top
    transform: Translate {
        id: slide
        y: control.isOpen ? 0 : (control.slideFromBottom ? 10 : -10)
        Behavior on y {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingEnter
            }
        }
    }
    hoverEnabled: pauseOnHover

    Accessible.role: Accessible.AlertMessage
    Accessible.name: title.length ? title : severityName
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
        if (event.key === Qt.Key_Escape) {
            hide()
            event.accepted = true
        }
    }

    Behavior on opacity {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEnter
        }
    }
    Behavior on scale {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEnter
        }
    }

    // Show the control
    function show(msg, sev) {
        if (msg !== undefined)
            message = msg
        if (sev !== undefined)
            severity = sev
        isOpen = true
        Qt.callLater(function () {
            if (!control || !control.isOpen || !progressFill || !background)
                return
            progressFill.width = Math.max(1, background.width)
            progressAnim.from = progressFill.width
            progressAnim.duration = control.durationMs
            progressAnim.restart()
        })
        hideTimer.restart()
    }

    // Open / show
    function open() { show() }
    // Close / dismiss
    function close() { hide() }

    // Hide the control
    function hide() {
        if (closeAnimTimer.running)
            return
        if (!isOpen) {
            hideTimer.stop()
            progressAnim.stop()
            closed()
            return
        }
        isOpen = false
        hideTimer.stop()
        progressAnim.stop()
        closeAnimTimer.restart()
    }

    Timer {
        id: closeAnimTimer
        interval: Theme.reducedMotion ? 1 : Theme.duration(Theme.motionNormal)
        onTriggered: control.closed()
    }

    Timer {
        id: hideTimer
        interval: control.durationMs
        onTriggered: control.hide()
    }

    onHoveredChanged: {
        if (!pauseOnHover || !isOpen)
            return
        if (hovered) {
            hideTimer.stop()
            progressAnim.pause()
        } else {
            hideTimer.interval = Math.max(400, progressAnim.duration * (progressFill.width / Math.max(1, background.width)))
            hideTimer.restart()
            progressAnim.resume()
        }
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

    readonly property string _glyph: {
        switch (severity) {
        case success: return FluentIcons.Accept
        case warning: return FluentIcons.Warning
        case error: return FluentIcons.Error
        default: return FluentIcons.Info
        }
    }

    background: ElevatedChrome {
        color: control._bg
        radius: Theme.cornerOverlay
        borderColor: Theme.strokeCard
        borderWidth: 1
        elevation: 6
        shadowOpacity: Theme.dark ? 0.32 : 0.16

        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 1
            width: 3
            radius: 1.5
            color: control._accent
        }

        Rectangle {
            id: progressBar
            visible: control.showProgress && control.isOpen
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 3
            color: "transparent"

            Rectangle {
                id: progressFill
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width
                // Match toast bottom corners so a full-width bar does not square them.
                bottomLeftRadius: Theme.cornerOverlay
                bottomRightRadius: Theme.cornerOverlay
                color: control._accent
                opacity: 0.55
            }

            NumberAnimation {
                id: progressAnim
                target: progressFill
                property: "width"
                from: 100
                to: 0
                duration: control.durationMs
                running: false
            }
        }
    }

    contentItem: RowLayout {
        spacing: Theme.spacingLoose
        Item { Layout.preferredWidth: 4 }

        Text {
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 2
            text: control._glyph
            font: Theme.iconFontFor(16)
            color: control._accent
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            Text {
                visible: control.title.length > 0
                text: control.title
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
                Layout.fillWidth: true
                wrapMode: Text.Wrap
            }
            Text {
                text: control.message
                font.pixelSize: Theme.fontBody
                color: Theme.textPrimary
                Layout.fillWidth: true
                wrapMode: Text.Wrap
            }
        }

        HyperlinkButton {
            visible: control.actionText.length > 0
            text: control.actionText
            onClicked: control.actionClicked()
        }

        T.AbstractButton {
            id: toastClose
            implicitWidth: 28
            implicitHeight: 28
            hoverEnabled: true
            focusPolicy: Qt.StrongFocus
            activeFocusOnTab: control.isOpen
            Accessible.role: Accessible.Button
            Accessible.name: qsTr("Close")
            onClicked: control.hide()
            Keys.onReturnPressed: toastClose.clicked()
            Keys.onEnterPressed: toastClose.clicked()
            Keys.onSpacePressed: toastClose.clicked()
            contentItem: Text {
                text: FluentIcons.ChromeClose
                font: Theme.iconFontFor(10)
                color: toastClose.hovered ? Theme.textPrimary : Theme.textSecondary
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                radius: Theme.cornerControl
                color: toastClose.down ? Theme.fillSubtleTertiary
                     : (toastClose.hovered ? Theme.fillSubtle : "transparent")
            }
        }
    }
}
