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
                title: qsTr("ZoneGauge")
                subtitle: qsTr("Drag needle; activeZoneIndex / label; zone colors and ticks.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Interactive zones")
                qmlSource: "ZoneGauge {\n    isInteractive: true\n    zones: [{ from, to, color, label }]\n}"
                ColumnLayout {
                    spacing: Theme.spacingLoose
                    Label {
                        text: qsTr("Active zone: %1 (%2)")
                              .arg(temp.activeZoneLabel)
                              .arg(temp.activeZoneIndex)
                        color: temp.activeZoneColor
                    }
                    RowLayout {
                        spacing: Theme.spacingSection
                        ZoneGauge {
                            id: temp
                            width: 168
                            height: 168
                            title: qsTr("CPU")
                            value: 64
                            unit: "°C"
                            maximum: 100
                            isInteractive: true
                            stepSize: 1
                            showTicks: true
                            zones: [
                                { from: 0, to: 0.55, color: Theme.systemSuccess, label: qsTr("Cool") },
                                { from: 0.55, to: 0.8, color: Theme.systemCaution, label: qsTr("Warm") },
                                { from: 0.8, to: 1.0, color: Theme.systemCritical, label: qsTr("Hot") }
                            ]
                        }
                        ZoneGauge {
                            width: 148
                            height: 148
                            title: qsTr("Pressure")
                            value: 32
                            maximum: 60
                            unit: " psi"
                            isInteractive: true
                            zones: [
                                { from: 0, to: 0.35, color: Theme.systemCritical, label: qsTr("Low") },
                                { from: 0.35, to: 0.7, color: Theme.systemSuccess, label: qsTr("OK") },
                                { from: 0.7, to: 1.0, color: Theme.systemCaution, label: qsTr("High") }
                            ]
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
