import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — Slider (WinUI 3 tick marks + vertical range).

CatalogPage {
    title: qsTr("Slider")
    subtitle: qsTr("WinUI tick marks, vertical fill rail, ring thumb — docs/components/Slider.md")

    ControlExample {
        headerText: qsTr("A simple Slider")
        qmlSource: "Slider { from: 0; to: 100; value: 40 }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Slider {
                Layout.fillWidth: true
                Layout.preferredWidth: 360
                from: 0
                to: 100
                value: 40
            }
            Slider {
                Layout.fillWidth: true
                Layout.preferredWidth: 360
                from: 0
                to: 100
                value: 70
                enabled: false
            }
        }
    }

    ControlExample {
        headerText: qsTr("A Slider with tick marks")
        qmlSource: "Slider {\n    from: 0; to: 100; stepSize: 25\n    tickMarksVisible: true\n    tickPlacement: \"both\"\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Step ticks above and below the track (tickPlacement: both). Set stepSize to control tick interval.")
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            Slider {
                Layout.fillWidth: true
                Layout.preferredWidth: 360
                from: 0
                to: 100
                stepSize: 25
                value: 0
                tickMarksVisible: true
                tickPlacement: "both"
                snapMode: Slider.SnapAlways
            }
            Slider {
                Layout.fillWidth: true
                Layout.preferredWidth: 360
                from: 0
                to: 100
                stepSize: 25
                value: 50
                tickMarksVisible: true
                tickPlacement: "both"
                snapMode: Slider.SnapAlways
            }
        }
    }

    ControlExample {
        headerText: qsTr("A vertical slider with range and tick marks specified")
        qmlSource: "Slider {\n    orientation: Qt.Vertical\n    height: 220\n    from: 0; to: 100; stepSize: 25\n    tickMarksVisible: true\n}"
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            ColumnLayout {
                spacing: Theme.spacing
                Text {
                    Layout.preferredWidth: 220
                    wrapMode: Text.WordWrap
                    text: qsTr("Thick accent fill below the thumb; thin inactive rail above. Ticks on left and right.")
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
                }
                Slider {
                    Layout.preferredWidth: 56
                    Layout.preferredHeight: 220
                    orientation: Qt.Vertical
                    from: 0
                    to: 100
                    stepSize: 25
                    value: 33
                    tickMarksVisible: true
                    tickPlacement: "both"
                    snapMode: Slider.SnapAlways
                }
            }
            ColumnLayout {
                spacing: Theme.spacing
                Text {
                    Layout.preferredWidth: 220
                    wrapMode: Text.WordWrap
                    text: qsTr("Compare tickPlacement: left only vs right only.")
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
                }
                RowLayout {
                    spacing: Theme.spacingLoose
                    Slider {
                        Layout.preferredWidth: 48
                        Layout.preferredHeight: 200
                        orientation: Qt.Vertical
                        from: 0
                        to: 100
                        stepSize: 25
                        value: 66
                        tickMarksVisible: true
                        tickPlacement: "left"
                        snapMode: Slider.SnapAlways
                    }
                    Slider {
                        Layout.preferredWidth: 48
                        Layout.preferredHeight: 200
                        orientation: Qt.Vertical
                        from: 0
                        to: 100
                        stepSize: 25
                        value: 66
                        tickMarksVisible: true
                        tickPlacement: "right"
                        snapMode: Slider.SnapAlways
                    }
                }
            }
            Item { Layout.fillWidth: true }
        }
    }

    ControlExample {
        headerText: qsTr("Touch note")
        qmlSource: "docs/touch-pointer.md"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Thumbs follow Theme.sliderThumb. On touch devices avoid ultra-compact density for primary sliders — docs/touch-pointer.md.")
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }
}
