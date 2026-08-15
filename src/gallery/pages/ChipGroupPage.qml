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
                title: qsTr("ChipGroup")
                subtitle: qsTr("selectionMode + selectedIndex; model.symbol: FluentIcons.*. select()/clearSelection().")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Exclusive")
                qmlSource: "ChipGroup {\n    selectionMode: \"single\"\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    ChipGroup {
                        id: exclusiveGroup
                        Layout.fillWidth: true
                        selectionMode: "single"
                        currentIndex: 0
                        model: [qsTr("All"), qsTr("Apps"), qsTr("Documents"), qsTr("Photos")]
                    }
                    Label {
                        text: qsTr("Selected: %1").arg(exclusiveGroup.currentIndex)
                        color: Theme.textSecondary
                    }
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Multi-select (max 2)")
                qmlSource: "ChipGroup {\n    selectionMode: \"multiple\"\n    maxSelected: 2\n}"
                ChipGroup {
                    Layout.fillWidth: true
                    selectionMode: "multiple"
                    maxSelected: 2
                    chipSize: "small"
                    model: [
                        { title: qsTr("Open"), symbol: FluentIcons.Document },
                        { title: qsTr("In progress"), symbol: FluentIcons.Refresh },
                        { title: qsTr("Done"), symbol: FluentIcons.Accept },
                        { title: qsTr("Blocked"), symbol: FluentIcons.Error }
                    ]
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
