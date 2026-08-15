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
                title: qsTr("TabView")
                subtitle: qsTr("WinUI TabView: closable, reorderable tabs, add button, and TabWidthMode.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Add tab + equal width")
                qmlSource: "TabView {\n    isAddTabButtonVisible: true\n    tabWidthMode: \"equal\"\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    Label {
                        text: qsTr("Click + to add. Drag to reorder. × closes. Width mode: Equal.")
                        color: Theme.textSecondary
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                    }
                    TabView {
                        id: tabs
                        Layout.fillWidth: true
                        Layout.preferredHeight: 220
                        tabsReorderable: true
                        isAddTabButtonVisible: true
                        tabWidthMode: "equal"
                        model: [
                            { title: qsTr("Home"), icon: "\uE80F", content: qsTr("Home document content") },
                            { title: qsTr("Reports"), icon: "\uE9D2", content: qsTr("Reports document content") },
                            { title: qsTr("Settings"), icon: "\uE713", content: qsTr("Settings document content") }
                        ]
                        onAddTabButtonClicked: { /* addTab() already appended */ }
                    }
                    RowLayout {
                        spacing: 8
                        Button {
                            text: qsTr("Size to content")
                            onClicked: tabs.tabWidthMode = "sizeToContent"
                        }
                        Button {
                            text: qsTr("Equal")
                            onClicked: tabs.tabWidthMode = "equal"
                        }
                        Button {
                            text: qsTr("Compact")
                            onClicked: tabs.tabWidthMode = "compact"
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
