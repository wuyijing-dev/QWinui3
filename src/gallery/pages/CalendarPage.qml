import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — Calendar.

CatalogPage {
    title: qsTr("Calendar")
    subtitle: qsTr("MonthGrid building blocks — for product month grid use CalendarView.")

    ControlExample {
        headerText: qsTr("Month view")
        qmlSource: "DayOfWeekRow { }\nMonthGrid {\n    onClicked: (date) => { … }\n}"
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: 320
            spacing: 4
            Label {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: grid.locale.standaloneMonthName(grid.month + 1) + " " + grid.year
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }
            DayOfWeekRow {
                Layout.fillWidth: true
                locale: grid.locale
            }
            MonthGrid {
                id: grid
                Layout.fillWidth: true
                month: new Date().getMonth()
                year: new Date().getFullYear()
                onClicked: function (date) {
                    chosen.text = qsTr("Clicked: %1").arg(Qt.formatDate(date, Qt.DefaultLocaleLongDate))
                }
            }
            Label {
                id: chosen
                text: qsTr("Click a day")
                color: Theme.textSecondary
            }
        }
    }
}
