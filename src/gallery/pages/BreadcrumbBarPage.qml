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
                title: qsTr("BreadcrumbBar")
                subtitle: qsTr("Shows the current path. Use itemInvoked to navigate ancestors; long paths collapse with ….")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Path")
                qmlSource: "BreadcrumbBar {\n    model: [\"Home\", \"Library\", \"Docs\"]\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    BreadcrumbBar {
                        id: crumbs
                        Layout.fillWidth: true
                        maxVisibleItems: 4
                        model: [
                            { title: qsTr("Home"), icon: "\uE80F" },
                            { title: qsTr("Library"), icon: "\uE8B7" },
                            qsTr("Documents"),
                            qsTr("Projects"),
                            qsTr("2026"),
                            qsTr("Reports")
                        ]
                        onItemInvoked: function (index) {
                            crumbs.model = crumbs.model.slice(0, index + 1)
                        }
                    }
                    Label {
                        text: qsTr("Long paths collapse with an ellipsis; icons are optional.")
                        color: Theme.textSecondary
                        font.pixelSize: Theme.fontCaption
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
