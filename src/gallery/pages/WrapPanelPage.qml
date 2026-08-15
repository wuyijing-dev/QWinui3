import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — WrapPanel.
//
// Wrapping rows/columns with RTL and childCount. API: docs/components/WrapPanel.md

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
                title: qsTr("WrapPanel")
                subtitle: qsTr("Wrapping rows/columns with RTL and childCount.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Horizontal wrap (RTL)")
                qmlSource: "WrapPanel {\n    layoutDirection: Qt.RightToLeft\n    Chip { text: \"One\" }\n}"
                WrapPanel {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    layoutDirection: Qt.RightToLeft
                    Chip { text: qsTr("Red") }
                    Chip { text: qsTr("Green") }
                    Chip { text: qsTr("Blue") }
                    Chip { text: qsTr("Yellow") }
                    Chip { text: qsTr("Purple") }
                    Chip { text: qsTr("Orange") }
                    Chip { text: qsTr("Teal") }
                    Chip { text: qsTr("Pink") }
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Uniform item size")
                qmlSource: "WrapPanel {\n    itemWidth: 100\n    itemHeight: 36\n}"
                WrapPanel {
                    Layout.fillWidth: true
                    itemWidth: 100
                    itemHeight: 36
                    spacing: 8
                    Repeater {
                        model: 8
                        Rectangle {
                            radius: Theme.cornerControl
                            color: Theme.fillSubtle
                            border.width: 1
                            border.color: Theme.strokeCard
                            Text {
                                anchors.centerIn: parent
                                text: qsTr("Item %1").arg(index + 1)
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
