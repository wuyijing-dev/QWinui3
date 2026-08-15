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
                title: qsTr("Pivot")
                subtitle: qsTr("Headered multi-view with accent underline. Headers support optional icons.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Basic")
                qmlSource: "Pivot {\n    model: [{ title: \"Home\", icon: \"\\uE80F\", content: \"...\" }]\n}"
                Pivot {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 220
                    model: [
                        { title: qsTr("Home"), icon: "\uE80F", content: qsTr("Welcome to the Home pivot page.") },
                        { title: qsTr("Recent"), icon: "\uE81C", content: qsTr("Recently opened documents appear here.") },
                        { title: qsTr("Shared"), icon: "\uE72D", content: qsTr("Items shared with you.") }
                    ]
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
