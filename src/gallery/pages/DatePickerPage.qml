import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — DatePicker.
//
// Tumbler date + header / errorMessage. Recipe: docs/pickers.md

CatalogPage {
    title: qsTr("DatePicker")
    subtitle: qsTr("Tumblers + header / errorMessage for FormLayout — docs/pickers.md.")

    ControlExample {
        headerText: qsTr("Default")
        qmlSource: "DatePicker {\n    header: \"Start date\"\n    dateFormat: \"yyyy-MM-dd\"\n}"
        ColumnLayout {
            spacing: Theme.spacing
            RowLayout {
                Label { text: qsTr("Format"); color: Theme.textSecondary }
                ComboBox {
                    id: fmt
                    model: ["yyyy-MM-dd", "MM/dd/yyyy", "dd/MM/yyyy"]
                    currentIndex: 0
                    Layout.preferredWidth: 160
                }
                Label { text: qsTr("Month"); color: Theme.textSecondary }
                ComboBox {
                    id: monthFmt
                    model: ["numeric", "abbreviated", "full"]
                    currentIndex: 0
                    Layout.preferredWidth: 140
                }
            }
            DatePicker {
                id: picker
                header: qsTr("Start date")
                dateFormat: fmt.currentText
                monthFormat: monthFmt.currentText
                onDateChosen: function (y, m, d) {
                    status.text = qsTr("Chosen %1").arg(picker.displayText)
                }
            }
            Label {
                id: status
                text: qsTr("Current: %1").arg(picker.displayText)
                color: Theme.textSecondary
            }
        }
    }
    ControlExample {
        headerText: qsTr("Day / Month / Year visible")
        qmlSource: "DatePicker {\n    dayVisible: false\n    yearVisible: true\n}"
        ColumnLayout {
            spacing: Theme.spacing
            RowLayout {
                CheckBox { id: yVis; text: qsTr("Year"); checked: true }
                CheckBox { id: mVis; text: qsTr("Month"); checked: true }
                CheckBox { id: dVis; text: qsTr("Day"); checked: false }
            }
            DatePicker {
                header: qsTr("Birthday (month + year)")
                yearVisible: yVis.checked
                monthVisible: mVis.checked
                dayVisible: dVis.checked
            }
        }
    }
}
