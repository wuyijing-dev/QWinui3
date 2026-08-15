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
                title: qsTr("EmptyState")
                subtitle: qsTr("Empty collection messaging with symbol, AccentButton CTA, and enter motion.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Default")
                qmlSource: "EmptyState {\n    symbol: FluentIcons.Search\n    actionText: \"Clear filters\"\n}"
                EmptyState {
                    Layout.fillWidth: true
                    symbol: FluentIcons.Search
                    glyphColor: Theme.accent
                    title: qsTr("No results")
                    message: qsTr("Try adjusting your search or filters to find what you need.")
                    actionText: qsTr("Clear filters")
                    secondaryActionText: qsTr("Learn more")
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Compact / borderless")
                qmlSource: "EmptyState {\n    compact: true\n    bordered: false\n    symbol: FluentIcons.Mail\n}"
                EmptyState {
                    Layout.fillWidth: true
                    compact: true
                    bordered: false
                    symbol: FluentIcons.Mail
                    glyphColor: Theme.systemSuccess
                    title: qsTr("Inbox zero")
                    message: qsTr("You're all caught up.")
                    actionText: qsTr("Compose")
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
