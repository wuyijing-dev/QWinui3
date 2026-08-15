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
                title: qsTr("CommandBar")
                subtitle: qsTr("Toolbar with DefaultLabelPosition, ClosedDisplayMode, secondaryCommands, and open/close signals.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Primary commands")
                qmlSource: "CommandBar {\n    secondaryCommands: [ … ]\n    onOpened: …\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Theme.spacing
                        Label { text: qsTr("Label"); color: Theme.textSecondary }
                        ComboBox {
                            id: labelPos
                            model: ["bottom", "right", "collapsed"]
                            currentIndex: 0
                            Layout.preferredWidth: 140
                        }
                        Label { text: qsTr("Closed"); color: Theme.textSecondary }
                        ComboBox {
                            id: closedMode
                            model: ["compact", "minimal", "hidden"]
                            currentIndex: 0
                            Layout.preferredWidth: 140
                        }
                    }
                    CommandBar {
                        id: cmdBar
                        Layout.fillWidth: true
                        defaultLabelPosition: labelPos.currentText
                        closedDisplayMode: closedMode.currentText
                        secondaryCommands: [
                            {
                                text: qsTr("Select all"),
                                triggered: function () { status.text = qsTr("Select all") }
                            },
                            {
                                text: qsTr("Find"),
                                triggered: function () { status.text = qsTr("Find") }
                            }
                        ]
                        onOpened: status.text = qsTr("Command bar opened")
                        onClosed: status.text = qsTr("Command bar closed")
                        AppBarButton {
                            iconGlyph: "\uE8C8"
                            text: qsTr("Copy")
                            onClicked: status.text = qsTr("Copy")
                        }
                        AppBarButton {
                            iconGlyph: "\uE77F"
                            text: qsTr("Cut")
                            onClicked: status.text = qsTr("Cut")
                        }
                        AppBarSeparator {}
                        AppBarButton {
                            iconGlyph: "\uE74D"
                            text: qsTr("Delete")
                            onClicked: status.text = qsTr("Delete")
                        }
                    }
                    Label {
                        id: status
                        text: qsTr("Ready — use the chevron to collapse the bar.")
                        color: Theme.textSecondary
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
