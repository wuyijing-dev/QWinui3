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
                title: qsTr("SearchBox")
                subtitle: qsTr("Search field with clear button and QuerySubmitted. No suggestion popup.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Search")
                qmlSource: "SearchBox {\n    onQuerySubmitted: …\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.maximumWidth: 360
                    spacing: Theme.spacing
                    SearchBox {
                        id: box
                        Layout.fillWidth: true
                        placeholderText: qsTr("Search files")
                        queryIcon: "\uE721"
                        onQuerySubmitted: function (query) {
                            status.text = qsTr("QuerySubmitted: %1").arg(query)
                        }
                        onCleared: status.text = qsTr("Cleared")
                    }
                    Label {
                        id: status
                        text: qsTr("Type and press Enter, or clear with the X.")
                        color: Theme.textSecondary
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
