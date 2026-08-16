import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SelectorBar.
//
// Segmented options with keyboard nav and symbol: FluentIcons.* in the model. API: docs/components/SelectorBar.md

CatalogPage {
    title: qsTr("SelectorBar")
    subtitle: qsTr("Segmented options with keyboard nav and symbol: FluentIcons.* in the model.")

    ControlExample {
        headerText: qsTr("View mode")
        qmlSource: "SelectorBar {\n    selectedIndex: 1\n    model: [{ title: \"Day\", symbol: FluentIcons.Calendar }]\n}"
        ColumnLayout {
            spacing: Theme.spacing
            Layout.alignment: Qt.AlignHCenter
            width: parent ? Math.min(parent.width, implicitWidth) : implicitWidth

            SelectorBar {
                id: bar
                Layout.alignment: Qt.AlignHCenter
                model: [
                    { title: qsTr("Day"), symbol: FluentIcons.Calendar },
                    { title: qsTr("Week"), symbol: FluentIcons.Calendar },
                    { title: qsTr("Month"), symbol: FluentIcons.Calendar }
                ]
                selectedIndex: 1
                onSelected: function (index, item) {
                    status.text = qsTr("SelectedItem: %1").arg(item.title || item)
                }
            }
            SelectorBar {
                Layout.alignment: Qt.AlignHCenter
                selectionStyle: "underline"
                model: [qsTr("Overview"), qsTr("Details"), qsTr("History")]
            }
            Label {
                Layout.alignment: Qt.AlignHCenter
                text: {
                    var it = bar.selectedItem
                    return qsTr("selectedItem: %1").arg(it && it.title ? it.title : String(it || "—"))
                }
                color: Theme.textSecondary
            }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: Theme.spacing
                Button { text: qsTr("Day"); onClicked: bar.select(0) }
                Button { text: qsTr("Week"); onClicked: bar.select(1) }
                Button { text: qsTr("Month"); onClicked: bar.select(2) }
            }
            Label {
                id: status
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Selected: Week")
                color: Theme.textSecondary
            }
        }
    }
}
