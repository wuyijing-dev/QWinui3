import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

Page {
    padding: 0

    Component {
        id: homePage
        ColumnLayout {
            spacing: Theme.spacing
            Label {
                text: qsTr("Home")
                font.pixelSize: Theme.fontSubtitle
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                color: Theme.textSecondary
                text: qsTr("Custom page Component hosted by Pivot via model[].page.")
            }
            Button { text: qsTr("Primary action") }
        }
    }
    Component {
        id: recentPage
        ListView {
            clip: true
            model: [qsTr("Report.docx"), qsTr("Budget.xlsx"), qsTr("Notes.txt")]
            delegate: ItemDelegate {
                required property string modelData
                width: ListView.view.width
                text: modelData
            }
        }
    }

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
                subtitle: qsTr("Headered multi-view with Fluent symbols, keyboard arrows, and Component pages.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Pages + keyboard")
                qmlSource: "Pivot {\n    model: [{ title, symbol: FluentIcons.Home, page }]\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    Pivot {
                        id: pivot
                        Layout.fillWidth: true
                        Layout.preferredHeight: 260
                        focus: true
                        model: [
                            { title: qsTr("Home"), symbol: FluentIcons.Home, page: homePage },
                            { title: qsTr("Recent"), symbol: FluentIcons.History, page: recentPage },
                            { title: qsTr("Shared"), symbol: FluentIcons.Share, content: qsTr("Items shared with you.") }
                        ]
                        onSelectionChanged: function (index) {
                            status.text = qsTr("Selected index %1").arg(index)
                        }
                    }
                    Label {
                        id: status
                        text: qsTr("Focus the Pivot and use ← → to change tabs.")
                        color: Theme.textSecondary
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
