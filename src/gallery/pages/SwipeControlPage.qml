import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

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
                subtitle: qsTr("Drag content to reveal actions; openMode / opened / closed track state.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Mail item")
                qmlSource: "SwipeControl {\n    onOpened: …\n    leftActions: ToolButton { ... }\n}"
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
                            ToolButton {
                                width: 72
                                height: parent.height
                                text: "\uE8F5"
                                font.family: Theme.fontFamilyIcon
                                ToolTip.text: qsTr("Flag")
                                background: Rectangle { color: Theme.systemCautionBg }
                            }
                        ]
                        rightActions: [
                            ToolButton {
                                width: 72
                                height: parent.height
                                text: "\uE74D"
                                font.family: Theme.fontFamilyIcon
                                ToolTip.text: qsTr("Delete")
                                background: Rectangle { color: Theme.systemCriticalBg }
                            },
                            ToolButton {
                                width: 72
                                height: parent.height
                                text: "\uE8C8"
                                font.family: Theme.fontFamilyIcon
                                ToolTip.text: qsTr("Archive")
                                background: Rectangle { color: Theme.systemAttentionBg }
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
                                    text: qsTr("Swipe left or right to reveal actions")
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
