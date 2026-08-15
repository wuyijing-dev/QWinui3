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
                title: qsTr("SelectorBar")
                subtitle: qsTr("Segmented options with selectedIndex alias and select().")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("View mode")
                qmlSource: "SelectorBar {\n    selectedIndex: 1\n    onSelected: …\n}"
                ColumnLayout {
                    spacing: Theme.spacing
                    Layout.alignment: Qt.AlignHCenter
                    width: parent ? Math.min(parent.width, implicitWidth) : implicitWidth

                    SelectorBar {
                        id: bar
                        Layout.alignment: Qt.AlignHCenter
                        model: [
                            { title: qsTr("Day"), icon: "\uE787" },
                            { title: qsTr("Week"), icon: "\uE8BF" },
                            { title: qsTr("Month"), icon: "\uE787" }
                        ]
                        selectedIndex: 1
                        onSelected: function (index, item) {
                            status.text = qsTr("Selected: %1").arg(item.title || item)
                        }
                    }
                    SelectorBar {
                        Layout.alignment: Qt.AlignHCenter
                        selectionStyle: "underline"
                        model: [qsTr("Overview"), qsTr("Details"), qsTr("History")]
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
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
