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
                title: qsTr("Shimmer")
                subtitle: qsTr("Skeleton placeholders with isActive, durationMs, and custom colors.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Card skeleton")
                qmlSource: "Shimmer { shape: Shimmer.Circle; isActive: true }"
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose
                    Shimmer {
                        shape: Shimmer.Circle
                        implicitWidth: 48
                        implicitHeight: 48
                        isActive: true
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        Shimmer { Layout.fillWidth: true; implicitHeight: 14; shape: Shimmer.TextLine }
                        Shimmer { Layout.fillWidth: true; Layout.preferredWidth: parent.width * 0.7; implicitHeight: 12; shape: Shimmer.TextLine }
                        Shimmer {
                            Layout.fillWidth: true
                            implicitHeight: 64
                            cornerRadius: Theme.cornerCard
                            durationMs: 1000
                            baseColor: Theme.fillSubtleSecondary
                        }
                    }
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Paused")
                qmlSource: "Shimmer { isActive: false }"
                Shimmer {
                    Layout.fillWidth: true
                    implicitHeight: 20
                    isActive: false
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
