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
                title: qsTr("ProgressRing")
                subtitle: qsTr("Circular progress with fillColor, showValue, and Active/Paused indeterminate.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Determinate and indeterminate")
                qmlSource: "ProgressRing { value: 0.65; showValue: true }\nProgressRing { indeterminate: true }"

                Flow {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose
                    ProgressRing {
                        width: 64
                        height: 64
                        value: 0.65
                        showValue: true
                        fillColor: Theme.accent
                    }
                    ProgressRing {
                        width: 48
                        height: 48
                        value: 0.4
                        fillColor: Theme.systemSuccess
                    }
                    ProgressRing {
                        width: 48
                        height: 48
                        indeterminate: true
                        isActive: true
                    }
                    ProgressRing {
                        width: 48
                        height: 48
                        indeterminate: true
                        isActive: false
                        fillColor: Theme.systemCaution
                    }
                }
                Label {
                    text: qsTr("Indeterminate Active vs Paused (right)")
                    color: Theme.textSecondary
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
