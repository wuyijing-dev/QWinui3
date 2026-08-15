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
                title: qsTr("AcrylicSurface")
                subtitle: qsTr("Frosted ElevatedChrome surface with tint, cornerRadius, and Accessible pane.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Default / elevated / custom tint")
                qmlSource: "AcrylicSurface {\n    elevated: true\n    cornerRadius: 12\n}"
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose
                    AcrylicSurface {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 120
                        Label {
                            text: qsTr("Acrylic surface")
                            color: Theme.textPrimary
                        }
                    }
                    AcrylicSurface {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 120
                        elevated: true
                        cornerRadius: 16
                        Label {
                            text: qsTr("Elevated acrylic")
                            color: Theme.textPrimary
                        }
                    }
                    AcrylicSurface {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 120
                        tintColor: Theme.accent
                        frostOpacity: Theme.dark ? 0.28 : 0.18
                        showLuminantEdge: false
                        Label {
                            text: qsTr("Custom tint")
                            color: Theme.textPrimary
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
