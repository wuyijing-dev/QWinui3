import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

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
                title: qsTr("Tumbler")
                subtitle: qsTr("A spinning wheel for selecting values from a list.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Hours")
                qmlSource: "Tumbler { model: 24 }"
                Tumbler {
                    Layout.alignment: Qt.AlignHCenter
                    model: 24
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
