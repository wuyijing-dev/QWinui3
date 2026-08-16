import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ListDetailsView.

CatalogPage {
    title: qsTr("ListDetailsView")
    subtitle: qsTr("Master–detail on TwoPaneView — keyboard, SinglePane Back, selection.")

    ControlExample {
        headerText: qsTr("Mail-style list (wide)")
        qmlSource: "ListDetailsView {\n    model: […]\n    details: Label { … }\n}"
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
            text: qsTr("Arrows / Enter select · Esc or Back returns to the list when narrow.")
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
    }
}
