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
                title: qsTr("DockPanel")
                subtitle: qsTr("Edge docking with lastChildFill and childCount.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Edges + fill")
                qmlSource: "DockPanel {\n    lastChildFill: true\n    Item { dock: DockPanel.Left }\n}"
                DockPanel {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 240
                    spacing: 4
                    lastChildFill: true

                    Rectangle {
                        property int dock: DockPanel.Top
                        implicitHeight: 40
                        color: Theme.fillSubtle
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Top")
                            color: Theme.textPrimary
                        }
                    }
                    Rectangle {
                        property int dock: DockPanel.Left
                        implicitWidth: 100
                        color: Theme.systemAttentionBg
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Left")
                            color: Theme.textPrimary
                        }
                    }
                    Rectangle {
                        property int dock: DockPanel.Right
                        implicitWidth: 100
                        color: Theme.systemCautionBg
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Right")
                            color: Theme.textPrimary
                        }
                    }
                    Rectangle {
                        property int dock: DockPanel.Bottom
                        implicitHeight: 36
                        color: Theme.fillSubtleSecondary
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Bottom")
                            color: Theme.textPrimary
                        }
                    }
                    Rectangle {
                        property int dock: DockPanel.Fill
                        color: Theme.bgCard
                        border.width: 1
                        border.color: Theme.strokeCard
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Fill")
                            font.weight: Theme.fontWeightSemiBold
                            color: Theme.textPrimary
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
