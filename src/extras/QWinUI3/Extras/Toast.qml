import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

T.Control {
    id: control

    property string title: ""
    property string message: ""
    property int severity: informational
    property int durationMs: 3200
    property bool isOpen: false
    property string actionText: ""
    property bool showProgress: true
    property bool pauseOnHover: true
    signal actionClicked()
    signal closed()

    readonly property int informational: 0
    readonly property int success: 1
    readonly property int warning: 2
    readonly property int error: 3

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
    x: isOpen ? 0 : 12
    scale: isOpen ? 1 : 0.96
    transformOrigin: Item.Bottom
    hoverEnabled: pauseOnHover

    Behavior on opacity {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEnter
        }
    }
    Behavior on x {
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

    function show(msg, sev) {
        if (msg !== undefined)
            message = msg
        if (sev !== undefined)
            severity = sev
        isOpen = true
        Qt.callLater(function () {
            progressFill.width = Math.max(1, background.width)
            progressAnim.from = progressFill.width
            progressAnim.duration = control.durationMs
            progressAnim.restart()
        })
        hideTimer.restart()
    }

    function open() { show() }
    function close() { hide() }

    function hide() {
        isOpen = false
        hideTimer.stop()
        progressAnim.stop()
        closed()
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
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 16
            color: control._accent
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            Text {
                visible: control.title.length > 0
                text: control.title
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
                Layout.fillWidth: true
                wrapMode: Text.Wrap
            }
            Text {
                text: control.message
                font.family: Theme.fontFamily
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
            Accessible.name: qsTr("Close")
            onClicked: control.hide()
            contentItem: Text {
                text: FluentIcons.ChromeClose
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 10
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
