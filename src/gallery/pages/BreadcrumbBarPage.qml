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
                subtitle: qsTr("Path trail with overflow ellipsis. Current crumb is non-clickable by default (lastItemClickable).")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Path")
                qmlSource: "BreadcrumbBar {\n    lastItemClickable: false\n    maxVisibleItems: 4\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    CheckBox {
                        id: lastClickable
                        text: qsTr("Last item clickable")
                    }
                    BreadcrumbBar {
                        id: crumbs
                        Layout.fillWidth: true
                        maxVisibleItems: 4
                        lastItemClickable: lastClickable.checked
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
                        text: qsTr("Index %1 — long paths collapse with …").arg(crumbs.currentIndex)
                        color: Theme.textSecondary
                        font.pixelSize: Theme.fontCaption
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
