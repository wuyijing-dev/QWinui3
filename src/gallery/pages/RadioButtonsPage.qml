import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — RadioButtons.
//
// Mutually exclusive options with selectedIndex, select(), and keyboard navigation. API: docs/components/RadioButtons.md

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
                title: qsTr("RadioButtons")
                subtitle: qsTr("Mutually exclusive options with selectedIndex, select(), and keyboard navigation.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("With item descriptions")
                qmlSource: "RadioButtons {\n    model: [{ title: \"PDF\", description: \"…\" }]\n}"
                RadioButtons {
                    header: qsTr("Export format")
                    description: qsTr("Choose how the document is saved.")
                    model: [
                        { title: qsTr("PDF"), description: qsTr("Best for sharing and printing") },
                        { title: qsTr("PNG"), description: qsTr("Raster image for slides") },
                        { title: qsTr("SVG"), description: qsTr("Scalable vector"), enabled: false }
                    ]
                    currentIndex: 0
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Horizontal")
                qmlSource: "RadioButtons {\n    horizontal: true\n}"
                RadioButtons {
                    horizontal: true
                    header: qsTr("Priority")
                    model: [qsTr("Low"), qsTr("Medium"), qsTr("High")]
                    currentIndex: 1
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
