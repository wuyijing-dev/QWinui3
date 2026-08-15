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
                title: qsTr("RadialGauge")
                subtitle: qsTr("Animated arc with title, caption, needle, and setValue().")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Interactive")
                qmlSource: "RadialGauge {\n    title: \"CPU\"\n    value: 72\n    unit: \"%\"\n}"
                ColumnLayout {
                    spacing: Theme.spacingLoose
                    RowLayout {
                        spacing: Theme.spacingSection
                        RadialGauge {
                            id: gauge
                            width: 168
                            height: 168
                            value: slider.value
                            unit: "%"
                            title: qsTr("CPU")
                            tickCount: 9
                            showNeedle: true
                        }
                        RadialGauge {
                            width: 128
                            height: 128
                            value: 36.5
                            maximum: 50
                            valuePrecision: 1
                            fillColor: Theme.systemSuccess
                            showValue: true
                            showNeedle: false
                            unit: "°C"
                            caption: qsTr("Ambient")
                        }
                    }
                    Slider {
                        id: slider
                        from: 0
                        to: 100
                        value: 72
                        Layout.fillWidth: true
                        Layout.maximumWidth: 360
                        onMoved: gauge.setValue(value)
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
