import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — Calendar.
//
// MonthGrid and DayOfWeekRow for building calendar views.

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
                title: qsTr("Calendar")
                subtitle: qsTr("MonthGrid and DayOfWeekRow for building calendar views.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
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
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
