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
                title: qsTr("UniformGrid")
                subtitle: qsTr("A grid that sizes all cells equally, with cellSpacing and RTL.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("3 columns")
                qmlSource: "UniformGrid {\n    columns: 3\n    cellSpacing: 8\n}"
                UniformGrid {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 200
                    columns: 3
                    cellSpacing: 8
                    layoutDirection: Qt.LeftToRight
                    Repeater {
                        model: 6
                        Rectangle {
                            radius: Theme.cornerControl
                            color: Theme.fillSubtle
                            border.width: 1
                            border.color: Theme.strokeCard
                            Text {
                                anchors.centerIn: parent
                                text: qsTr("Cell %1").arg(index + 1)
                                font.family: Theme.fontFamily
                                color: Theme.textPrimary
                            }
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
