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
                title: qsTr("AnnotatedScrollBar")
                subtitle: qsTr("A scrollable region whose scrollbar shows a label while you drag or hover the thumb.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Percentage labels")
                qmlSource: "AnnotatedScrollBar {\n    /* content */\n}"
                AnnotatedScrollBar {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 220
                    contentWidth: width
                    contentHeight: col.implicitHeight
                    Column {
                        id: col
                        width: parent.width
                        spacing: 8
                        Repeater {
                            model: 24
                            Rectangle {
                                width: col.width - 8
                                height: 36
                                radius: Theme.cornerControl
                                color: Theme.fillSubtle
                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("Row %1").arg(index + 1)
                                    font.family: Theme.fontFamily
                                    color: Theme.textPrimary
                                }
                            }
                        }
                    }
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Custom labels")
                qmlSource: "AnnotatedScrollBar {\n    labels: [\"A\", \"B\", \"C\"]\n}"
                AnnotatedScrollBar {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 180
                    labels: ["A", "B", "C", "D", "E", "F"]
                    contentWidth: width
                    contentHeight: 600
                    Rectangle {
                        width: parent.width
                        height: 600
                        gradient: Gradient {
                            GradientStop { position: 0; color: Theme.fillSubtle }
                            GradientStop { position: 1; color: Theme.fillSubtleSecondary }
                        }
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Scroll to see letter labels")
                            color: Theme.textSecondary
                            font.family: Theme.fontFamily
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
