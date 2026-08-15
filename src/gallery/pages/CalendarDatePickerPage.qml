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
                title: qsTr("CalendarDatePicker")
                subtitle: qsTr("Pick a date from a calendar flyout with optional header and range.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Select a date")
                qmlSource: "CalendarDatePicker {\n    header: \"Start date\"\n    isOpen: false\n}"
                ColumnLayout {
                    spacing: Theme.spacing
                    CalendarDatePicker {
                        id: picker
                        Layout.preferredWidth: 240
                        header: qsTr("Start date")
                        showTodayButton: true
                        hasMinDate: true
                        minDate: new Date(2020, 0, 1)
                        hasMaxDate: true
                        maxDate: new Date(2030, 11, 31)
                        onDateChosen: function (d) {
                            chosenLabel.text = qsTr("Chosen: %1").arg(Qt.formatDate(d, Qt.DefaultLocaleLongDate))
                        }
                    }
                    Label {
                        text: qsTr("Selected: %1").arg(Qt.formatDate(picker.selectedDate, Qt.DefaultLocaleLongDate))
                        color: Theme.textSecondary
                    }
                    Label {
                        id: chosenLabel
                        text: qsTr("Waiting for dateChosen…")
                        color: Theme.textSecondary
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
