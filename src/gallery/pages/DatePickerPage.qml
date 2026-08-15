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
                title: qsTr("DatePicker")
                subtitle: qsTr("Fluent Calendar icon, dateFormat, selectedDate, and Accessible.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
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
                    }
                    DatePicker {
                        id: picker
                        header: qsTr("Start date")
                        dateFormat: fmt.currentText
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
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
