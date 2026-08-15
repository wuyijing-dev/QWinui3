import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ArcGauge.
//
// Drag the arc; invertThresholds for battery-style low=critical. API: docs/components/ArcGauge.md

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
                title: qsTr("ArcGauge")
                subtitle: qsTr("Drag the arc; invertThresholds for battery-style low=critical.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Interactive arcs")
                qmlSource: "ArcGauge {\n    isInteractive: true\n    invertThresholds: true\n}"
                ColumnLayout {
                    spacing: Theme.spacingLoose
                    RowLayout {
                        spacing: Theme.spacingSection
                        ArcGauge {
                            id: arc
                            width: 180
                            height: 140
                            title: qsTr("Battery")
                            value: 76
                            unit: "%"
                            isInteractive: true
                            showMinMax: true
                            invertThresholds: true
                            cautionThreshold: 0.55
                            criticalThreshold: 0.8
                            fillColor: Theme.systemSuccess
                            caption: qsTr("Remaining")
                        }
                        ArcGauge {
                            width: 160
                            height: 130
                            title: qsTr("Upload")
                            value: 42
                            unit: " Mbps"
                            isInteractive: true
                            stepSize: 1
                            fillColor: Theme.accent
                            caption: qsTr("Link speed")
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
