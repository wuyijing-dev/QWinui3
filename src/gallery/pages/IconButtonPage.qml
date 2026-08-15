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
                title: qsTr("IconButton")
                subtitle: qsTr("Icon-only button with Fluent symbol, badge, and Accessible name from toolTip.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Icons")
                qmlSource: "IconButton {\n    symbol: FluentIcons.Copy\n    badgeValue: 3\n}"
                ColumnLayout {
                    spacing: Theme.spacing
                    RowLayout {
                        spacing: Theme.spacing
                        IconButton {
                            symbol: FluentIcons.Copy
                            toolTipText: qsTr("Copy")
                            onClicked: status.text = qsTr("Copy")
                        }
                        IconButton {
                            symbol: FluentIcons.Cut
                            toolTipText: qsTr("Cut")
                            onClicked: status.text = qsTr("Cut")
                        }
                        IconButton {
                            symbol: FluentIcons.Delete
                            highlighted: true
                            toolTipText: qsTr("Delete")
                            onClicked: status.text = qsTr("Delete")
                        }
                        IconButton {
                            symbol: FluentIcons.Refresh
                            flat: false
                            toolTipText: qsTr("Refresh")
                            onClicked: status.text = qsTr("Refresh")
                        }
                        IconButton {
                            symbol: FluentIcons.Mail
                            toolTipText: qsTr("Notifications")
                            badgeValue: 3
                            onClicked: status.text = qsTr("Notifications")
                        }
                        IconButton { symbol: FluentIcons.ChromeClose; enabled: false }
                    }
                    Label {
                        id: status
                        text: qsTr("Ready")
                        color: Theme.textSecondary
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
