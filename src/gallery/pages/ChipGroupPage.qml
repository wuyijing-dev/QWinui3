import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ChipGroup.

CatalogPage {
    title: qsTr("ChipGroup")
    subtitle: qsTr("selectionMode + selectedIndex; model.symbol: FluentIcons.*. select()/clearSelection().")

    ControlExample {
        headerText: qsTr("Exclusive")
        qmlSource: "ChipGroup {\n    selectionMode: \"single\"\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            ChipGroup {
                id: exclusiveGroup
                selectionMode: "single"
                currentIndex: 0
                model: [qsTr("All"), qsTr("Apps"), qsTr("Documents"), qsTr("Photos")]
            }
            Label {
                text: qsTr("Selected index: %1 · item: %2")
                        .arg(exclusiveGroup.currentIndex)
                        .arg(exclusiveGroup.selectedItem !== null
                             && exclusiveGroup.selectedItem !== undefined
                             ? String(exclusiveGroup.selectedItem) : "—")
                color: Theme.textSecondary
            }
        }
    }
    ControlExample {
        headerText: qsTr("Multi-select (max 2)")
        qmlSource: "ChipGroup {\n    selectionMode: \"multiple\"\n    maxSelected: 2\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            ChipGroup {
                id: multiGroup
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
            Label {
                text: qsTr("selectedItems: %1").arg(multiGroup.selectedItems.length)
                color: Theme.textSecondary
            }
        }
    }
}
