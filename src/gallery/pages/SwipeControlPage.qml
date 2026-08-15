import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SwipeControl.
//
// Reveal actions with ElevatedChrome panel, keyboard arrows / Esc, and isOpen. API: docs/components/SwipeControl.md

Page {
    padding: 0
    ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        ColumnLayout {
            width: scroll.availableWidth
            spacing: Theme.spacingSection
            PageHeader {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.topMargin: Theme.spacingSection
                title: qsTr("SwipeControl")
                subtitle: qsTr("Reveal actions with ElevatedChrome panel, keyboard arrows / Esc, and isOpen.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
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
                                onClicked: swipe.close()
                            }
                        ]
                        rightActions: [
                            SwipeAction {
                                width: 72
                                height: parent.height
                                text: qsTr("Delete")
                                symbol: FluentIcons.Delete
                                onClicked: swipe.close()
                            },
                            SwipeAction {
                                width: 72
                                height: parent.height
                                text: qsTr("Copy")
                                symbol: FluentIcons.Copy
                                color: Theme.systemAttention
                                onClicked: swipe.close()
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
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
