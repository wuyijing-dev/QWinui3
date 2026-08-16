import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ItemsView recipe.

CatalogPage {
    id: page
    title: qsTr("ItemsView")
    subtitle: qsTr("List recipe: sections, multi-select, context menu, empty state.")

    property var sampleModel: [
        { title: qsTr("Design doc"), subtitle: qsTr("Updated yesterday"), group: qsTr("Documents"), symbol: FluentIcons.Document },
        { title: qsTr("Roadmap"), subtitle: qsTr("Q3 planning"), group: qsTr("Documents"), symbol: FluentIcons.Calendar },
        { title: qsTr("Build pipeline"), subtitle: qsTr("CI green"), group: qsTr("Engineering"), symbol: FluentIcons.Sync },
        { title: qsTr("Crash reports"), subtitle: qsTr("3 open"), group: qsTr("Engineering"), symbol: FluentIcons.Error },
        { title: qsTr("Office lease"), subtitle: qsTr("Renewal"), group: qsTr("Admin"), symbol: FluentIcons.Home }
    ]
    property bool showEmpty: false

    overlay: ToastHost {
        id: toasts
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24
        width: 360
    }

    ControlExample {
        headerText: qsTr("Grouped multi-select")
        qmlSource: "ItemsView {\n    sectionRole: \"group\"\n    selectionMode: ItemsView.selectionMultiple\n    contextMenu: ctx\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            RowLayout {
                Button {
                    text: page.showEmpty ? qsTr("Restore items") : qsTr("Show empty")
                    onClicked: page.showEmpty = !page.showEmpty
                }
                Button {
                    flat: true
                    text: qsTr("Select all")
                    onClicked: items.selectAll()
                }
                Button {
                    flat: true
                    text: qsTr("Clear")
                    onClicked: items.clearSelection()
                }
                Label {
                    text: qsTr("Selected: %1").arg(items.selectedIndexes.length)
                    color: Theme.textSecondary
                }
            }

            ItemsView {
                id: items
                Layout.fillWidth: true
                Layout.preferredHeight: 360
                model: page.showEmpty ? [] : page.sampleModel
                sectionRole: "group"
                selectionMode: ItemsView.selectionMultiple
                emptyTitle: qsTr("No files")
                emptyMessage: qsTr("Add documents or restore the sample list.")
                emptyActionText: qsTr("Restore")
                contextMenu: ctx
                onEmptyActionClicked: page.showEmpty = false
            }

            MenuFlyout {
                id: ctx
                MenuFlyoutItem {
                    text: qsTr("Open")
                    symbol: FluentIcons.OpenFile
                    onTriggered: toasts.info(qsTr("Index %1").arg(items.selectedIndexes[0]), qsTr("Open"))
                }
                MenuFlyoutItem {
                    text: qsTr("Delete")
                    symbol: FluentIcons.Delete
                    onTriggered: toasts.warningToast(qsTr("%1 item(s)").arg(items.selectedIndexes.length), qsTr("Delete"))
                }
            }
        }
    }
}
