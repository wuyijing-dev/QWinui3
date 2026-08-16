import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SwipeControl.
//
// Reveal actions with ElevatedChrome panel, keyboard arrows / Esc, and isOpen. API: docs/components/SwipeControl.md

CatalogPage {
    title: qsTr("SwipeControl")
    subtitle: qsTr("Reveal actions with ElevatedChrome panel, keyboard arrows / Esc, and isOpen.")

    ControlExample {
        headerText: qsTr("Mail item")
        qmlSource: "SwipeControl {\n    leftActions: SwipeAction { symbol: FluentIcons.Flag }\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                id: swipeStatus
                text: qsTr("Closed")
                color: Theme.textSecondary
            }
            SwipeControl {
                id: swipe
                Layout.fillWidth: true
                Layout.maximumWidth: 420
                leftActions: [
                    SwipeAction {
                        width: 72
                        height: parent.height
                        leading: true
                        text: qsTr("Flag")
                        symbol: FluentIcons.Flag
                        color: Theme.systemCaution
                        onClicked: swipeStatus.text = qsTr("Flag")
                    }
                ]
                rightActions: [
                    SwipeAction {
                        width: 72
                        height: parent.height
                        text: qsTr("Delete")
                        symbol: FluentIcons.Delete
                        behaviorOnInvoked: "close"
                        onTriggered: swipeStatus.text = qsTr("Delete")
                    },
                    SwipeAction {
                        width: 72
                        height: parent.height
                        text: qsTr("Copy")
                        symbol: FluentIcons.Copy
                        color: Theme.systemAttention
                        behaviorOnInvoked: "remainOpen"
                        onTriggered: swipeStatus.text = qsTr("Copy (remain open)")
                    }
                ]
                content: [
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 2
                        Label {
                            text: qsTr("Weekly design sync")
                            font.weight: Theme.fontWeightSemiBold
                        }
                        Label {
                            text: qsTr("Swipe or use ← → / Esc")
                            color: Theme.textSecondary
                        }
                    }
                ]
                onOpened: function (mode) {
                    swipeStatus.text = mode === swipe.leftOpen
                            ? qsTr("Left open") : qsTr("Right open")
                }
                onClosed: swipeStatus.text = qsTr("Closed")
            }
            RowLayout {
                spacing: Theme.spacing
                Button { text: qsTr("Open left"); onClicked: swipe.openLeft() }
                Button { text: qsTr("Open right"); onClicked: swipe.openRight() }
                Button { text: qsTr("Close"); onClicked: swipe.close() }
            }
        }
    }
    ControlExample {
        headerText: qsTr("Execute mode")
        qmlSource: "SwipeControl {\n    swipeMode: \"execute\"\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                id: execStatus
                text: qsTr("Swipe past threshold to invoke")
                color: Theme.textSecondary
            }
            SwipeControl {
                Layout.fillWidth: true
                Layout.maximumWidth: 420
                swipeMode: "execute"
                rightActions: [
                    SwipeAction {
                        width: 88
                        height: parent.height
                        text: qsTr("Archive")
                        symbol: FluentIcons.Folder
                        color: Theme.systemAttention
                        behaviorOnInvoked: "close"
                        onTriggered: execStatus.text = qsTr("Archived (execute)")
                    }
                ]
                content: [
                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Swipe left to archive")
                    }
                ]
            }
        }
    }
}
