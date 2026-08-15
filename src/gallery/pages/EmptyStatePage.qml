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
                subtitle: qsTr("Empty collection messaging with bordered, glyphColor, and actions.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Default")
                qmlSource: "EmptyState {\n    actionText: \"Clear filters\"\n    glyphColor: Theme.accent\n}"
                EmptyState {
                    Layout.fillWidth: true
                    glyph: "\uE721"
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
                qmlSource: "EmptyState { compact: true; bordered: false }"
                EmptyState {
                    Layout.fillWidth: true
                    compact: true
                    bordered: false
                    glyph: "\uE715"
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
