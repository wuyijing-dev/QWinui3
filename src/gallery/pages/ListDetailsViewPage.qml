import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ListDetailsView.

CatalogPage {
    title: qsTr("ListDetailsView")
    subtitle: qsTr("Master–detail recipe on TwoPaneView with list selection.")

    ControlExample {
        headerText: qsTr("Mail-style list")
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
    }
}
