import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ItemsView recipe.

CatalogPage {
    id: page
    title: qsTr("ItemsView")
    subtitle: qsTr("List recipe: sections, multi-select, keyboard, filter-above — docs/search.md (1.59).")

    property var sampleModel: [
        { title: qsTr("Design doc"), subtitle: qsTr("Updated yesterday"), group: qsTr("Documents"), symbol: FluentIcons.Document },
        { title: qsTr("Roadmap"), subtitle: qsTr("Q3 planning"), group: qsTr("Documents"), symbol: FluentIcons.Calendar },
        { title: qsTr("Build pipeline"), subtitle: qsTr("CI green"), group: qsTr("Engineering"), symbol: FluentIcons.Sync },
        { title: qsTr("Crash reports"), subtitle: qsTr("3 open"), group: qsTr("Engineering"), symbol: FluentIcons.Error },
        { title: qsTr("Office lease"), subtitle: qsTr("Renewal"), group: qsTr("Admin"), symbol: FluentIcons.Home }
    ]
    property string filterQuery: ""
    property bool showEmpty: false

    readonly property var filteredModel: {
        if (page.showEmpty)
            return []
        var q = (page.filterQuery || "").trim().toLowerCase()
        if (!q.length)
            return page.sampleModel
        var out = []
        for (var i = 0; i < page.sampleModel.length; ++i) {
            var it = page.sampleModel[i]
            var hay = (it.title + " " + it.subtitle + " " + it.group).toLowerCase()
            if (hay.indexOf(q) >= 0)
                out.push(it)
        }
        return out
    }

    overlay: ToastHost {
        id: toasts
        width: 360
        placement: ToastHost.BottomCenter
    }

    ControlExample {
        headerText: qsTr("Grouped multi-select")
        qmlSource: "ItemsView {\n    sectionRole: \"group\"\n    selectionMode: ItemsView.SelectionMultiple\n    contextMenu: ctx\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            TextField {
                Layout.fillWidth: true
                placeholderText: qsTr("Filter titles (app-side — ItemsView has no built-in filter)")
                text: page.filterQuery
                onTextChanged: page.filterQuery = text
            }

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
                model: page.filteredModel
                sectionRole: "group"
                selectionMode: ItemsView.SelectionMultiple
                emptyTitle: qsTr("No files")
                emptyMessage: qsTr("Add documents, clear the filter, or restore the sample list.")
                emptyActionText: qsTr("Restore")
                contextMenu: ctx
                onEmptyActionClicked: {
                    page.showEmpty = false
                    page.filterQuery = ""
                }
            }

            Label {
                Layout.fillWidth: true
                color: Theme.textSecondary
                text: qsTr("Tab into the list · arrows / Page / Space / Ctrl+A / Esc")
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
