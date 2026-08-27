import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — RangeSlider (WinUI tick marks + vertical range).

CatalogPage {
    title: qsTr("RangeSlider")
    subtitle: qsTr("Dual-thumb range with tick marks and vertical fill — docs/components/RangeSlider.md")

    ControlExample {
        headerText: qsTr("A simple RangeSlider")
        qmlSource: "RangeSlider {\n    from: 0; to: 100\n    first.value: 20; second.value: 70\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            RangeSlider {
                Layout.preferredWidth: 360
                from: 0
                to: 100
                first.value: 20
                second.value: 70
            }
            RangeSlider {
                Layout.preferredWidth: 360
                from: 0
                to: 100
                first.value: 30
                second.value: 60
                enabled: false
            }
        }
    }

    ControlExample {
        headerText: qsTr("A RangeSlider with tick marks")
        qmlSource: "RangeSlider {\n    from: 0; to: 100; stepSize: 10\n    tickMarksVisible: true\n    tickPlacement: \"both\"\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Select a continuous range between two values. Ticks use stepSize; snap when stepSize is set.")
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            RangeSlider {
                Layout.preferredWidth: 360
                from: 0
                to: 100
                stepSize: 10
                first.value: 20
                second.value: 80
                tickMarksVisible: true
                tickPlacement: "both"
                snapMode: RangeSlider.SnapAlways
            }
            RangeSlider {
                Layout.preferredWidth: 360
                from: 0
                to: 100
                stepSize: 25
                first.value: 25
                second.value: 75
                tickMarksVisible: true
                tickPlacement: "both"
                snapMode: RangeSlider.SnapAlways
            }
        }
    }

    ControlExample {
        headerText: qsTr("A vertical RangeSlider with tick marks")
        qmlSource: "RangeSlider {\n    orientation: Qt.Vertical\n    height: 220\n    tickMarksVisible: true\n}"
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            ColumnLayout {
                spacing: Theme.spacing
                Label { text: qsTr("Price range"); font.bold: true }
                Text {
                    wrapMode: Text.WordWrap
                    Layout.preferredWidth: 180
                    text: qsTr("Thick accent fill between thumbs; ticks on left and right.")
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
                }
            }
            RangeSlider {
                orientation: Qt.Vertical
                Layout.preferredHeight: 220
                from: 0
                to: 100
                stepSize: 25
                first.value: 25
                second.value: 75
                tickMarksVisible: true
                tickPlacement: "both"
                snapMode: RangeSlider.SnapAlways
            }
            RangeSlider {
                orientation: Qt.Vertical
                Layout.preferredHeight: 220
                from: 0
                to: 100
                stepSize: 10
                first.value: 10
                second.value: 40
                tickMarksVisible: true
                tickPlacement: "left"
            }
        }
    }
}
