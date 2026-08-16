import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — RadioButtons.
//
// Mutually exclusive options with selectedIndex, select(), and keyboard navigation. API: docs/components/RadioButtons.md

CatalogPage {
    title: qsTr("RadioButtons")
    subtitle: qsTr("Mutually exclusive options with selectedIndex, select(), and keyboard navigation.")

    ControlExample {
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
        headerText: qsTr("MaxColumns + selectedItem")
        qmlSource: "RadioButtons {\n    itemsSource: […]\n    maxColumns: 2\n}"
        ColumnLayout {
            spacing: Theme.spacing
            RadioButtons {
                id: gridRadios
                Layout.fillWidth: true
                maxColumns: 2
                header: qsTr("Theme accent")
                itemsSource: [
                    qsTr("Blue"), qsTr("Purple"), qsTr("Green"),
                    qsTr("Orange"), qsTr("Red"), qsTr("Teal")
                ]
                currentIndex: 0
            }
            Label {
                text: qsTr("selectedItem: %1").arg(gridRadios.selectedItem || "")
                color: Theme.textSecondary
            }
        }
    }
    ControlExample {
        headerText: qsTr("Horizontal")
        qmlSource: "RadioButtons {\n    horizontal: true\n}"
        RadioButtons {
            horizontal: true
            header: qsTr("Priority")
            model: [qsTr("Low"), qsTr("Medium"), qsTr("High")]
            currentIndex: 1
        }
    }
}
