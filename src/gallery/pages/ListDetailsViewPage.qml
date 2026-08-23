import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ListDetailsView.
//
// Recipe: docs/adaptive-layout.md (1.42) · docs/data-collections.md

CatalogPage {
    title: qsTr("ListDetailsView")
    subtitle: qsTr("Master–detail · filter + multi-select toolbar (2.64) — docs/collection-perf-264.md.")

    ControlExample {
        headerText: qsTr("Bulk mail actions (2.64)")
        qmlSource: "ListDetailsView {\n    multiSelectEnabled: true\n    detailToolbar: RowLayout { … }\n}"
        ListDetailsView {
            id: bulkMail
            Layout.fillWidth: true
            Layout.preferredHeight: 380
            multiSelectEnabled: true
            model: [
                { title: qsTr("Quarterly review"), subtitle: qsTr("boss@contoso.com"), body: qsTr("Please review attached deck.") },
                { title: qsTr("Build green"), subtitle: qsTr("ci@contoso.com"), body: qsTr("All checks passed.") },
                { title: qsTr("Design sync"), subtitle: qsTr("calendar"), body: qsTr("Thursday 10:00.") },
                { title: qsTr("Invoice #4421"), subtitle: qsTr("billing@vendor.com"), body: qsTr("Payment due Friday.") }
            ]
            Component.onCompleted: select(0)
            detailToolbar: RowLayout {
                spacing: Theme.spacing
                Label {
                    text: qsTr("%1 selected").arg(bulkMail.selectionCount)
                    color: Theme.textSecondary
                }
                Button {
                    text: qsTr("Archive")
                    enabled: bulkMail.selectionCount > 0
                    onClicked: archiveHint.text = qsTr("Archived %1 messages (demo)")
                                                   .arg(bulkMail.selectionCount)
                }
                Button {
                    flat: true
                    text: qsTr("Clear")
                    visible: bulkMail.selectionCount > 0
                    onClicked: bulkMail.clearMultiSelection()
                }
            }
            details: ColumnLayout {
                anchors.fill: parent
                spacing: Theme.spacing
                Label {
                    text: bulkMail.selectedItem ? bulkMail.selectedItem.title : ""
                    font.pixelSize: Theme.fontSubtitle
                    font.weight: Theme.fontWeightSemiBold
                }
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                    text: bulkMail.selectedItem ? bulkMail.selectedItem.body : ""
                }
            }
        }
        Label {
            id: archiveHint
            Layout.fillWidth: true
            color: Theme.textSecondary
            text: qsTr("Ctrl+click · Shift+range · Ctrl+A · checkboxes — detailToolbar for bulk commands.")
        }
    }

    ControlExample {
        headerText: qsTr("Adaptive breakpoints (1.42)")
        qmlSource: "ListDetailsView { minWideWidth: 720 }\n// Nav autoCompactThreshold: 1008"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Default minWideWidth=720 → Wide list|details; narrower → SinglePane with Back/Esc to the list. NavigationView auto uses 1008 for the rail. Density does not change these breakpoints — docs/adaptive-layout.md · docs/density.md.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Mail-style list (wide)")
        qmlSource: "ListDetailsView {\n    model: […]\n    filterText: …\n    details: Label { … }\n}"
        TextField {
            Layout.fillWidth: true
            placeholderText: qsTr("Filter list (debounced · selection by object — 2.18)")
            text: listDetails.filterText
            onTextChanged: listDetails.filterText = text
        }
        ListDetailsView {
            id: listDetails
            Layout.fillWidth: true
            Layout.preferredHeight: 360
            model: [
                { title: qsTr("Welcome"), subtitle: qsTr("team@contoso.com"), body: qsTr("Thanks for trying QWinUI3.") },
                { title: qsTr("Build green"), subtitle: qsTr("ci@contoso.com"), body: qsTr("All checks passed on master.") },
                { title: qsTr("Design sync"), subtitle: qsTr("calendar"), body: qsTr("Thursday 10:00 — bring mockups.") }
            ]
            Component.onCompleted: select(0)
            details: ColumnLayout {
                anchors.fill: parent
                spacing: Theme.spacing
                Label {
                    text: listDetails.selectedItem
                          ? listDetails.selectedItem.title : ""
                    font.pixelSize: Theme.fontSubtitle
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                }
                Label {
                    text: listDetails.selectedItem
                          ? listDetails.selectedItem.subtitle : ""
                    color: Theme.textSecondary
                }
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                    text: listDetails.selectedItem
                          ? listDetails.selectedItem.body : ""
                    color: Theme.textPrimary
                }
            }
        }

        Label {
            Layout.fillWidth: true
            color: Theme.textSecondary
            text: qsTr("Arrows / Enter select · Esc or Back returns to the list when narrow. Filtered: %1 · minWideWidth=%2.")
                    .arg(listDetails.filteredCount)
                    .arg(Math.round(listDetails.minWideWidth))
        }
    }



    ControlExample {
        headerText: qsTr("Narrow (SinglePane + Back)")
        qmlSource: "ListDetailsView {\n    minWideWidth: 900\n    // Back + Esc → showList()\n}"

        ListDetailsView {
            id: narrowDetails
            Layout.fillWidth: true
            Layout.preferredHeight: 320
            // Force SinglePane inside a typical Gallery content width.
            minWideWidth: 900
            listPaneWidth: 240
            model: [
                { title: qsTr("Inbox"), subtitle: qsTr("12 unread"), body: qsTr("Open an item, then use Back or Esc.") },
                { title: qsTr("Archive"), subtitle: qsTr("Last week"), body: qsTr("Details replace the list on narrow layouts.") },
                { title: qsTr("Flagged"), subtitle: qsTr("2 items"), body: qsTr("showList() restores the master pane.") }
            ]
            Component.onCompleted: select(0)
            details: ColumnLayout {
                anchors.fill: parent
                spacing: Theme.spacing
                Label {
                    text: narrowDetails.selectedItem
                          ? narrowDetails.selectedItem.title : ""
                    font.pixelSize: Theme.fontSubtitle
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                }
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                    text: narrowDetails.selectedItem
                          ? narrowDetails.selectedItem.body : ""
                    color: Theme.textPrimary
                }
            }
        }

        Label {
            Layout.fillWidth: true
            color: Theme.textSecondary
            text: qsTr("Gallery forces minWideWidth=900 so SinglePane appears in the catalog column — product apps usually keep 720.")
        }
    }
}
