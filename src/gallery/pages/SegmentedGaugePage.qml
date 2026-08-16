import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SegmentedGauge.
//
// fillMode discrete|partial; tap segments when isInteractive. API: docs/components/SegmentedGauge.md

CatalogPage {
    title: qsTr("SegmentedGauge")
    subtitle: qsTr("fillMode discrete|partial; tap segments when isInteractive.")

    ControlExample {
        headerText: qsTr("Discrete + partial")
        qmlSource: "SegmentedGauge {\n    fillMode: \"partial\"\n    isInteractive: true\n}"
        ColumnLayout {
            spacing: Theme.spacingLoose
            RowLayout {
                Label { text: qsTr("Fill mode"); color: Theme.textSecondary }
                ComboBox {
                    id: modeBox
                    model: ["discrete", "partial"]
                    currentIndex: 1
                    Layout.preferredWidth: 140
                }
            }
            RowLayout {
                spacing: Theme.spacingSection
                SegmentedGauge {
                    id: steps
                    width: 148
                    height: 148
                    title: qsTr("Steps")
                    value: 8.4
                    maximum: 12
                    segmentCount: 12
                    fillMode: modeBox.currentText
                    isInteractive: true
                    caption: qsTr("%1 / 12").arg(Number(steps.value).toFixed(1))
                    cautionThreshold: 0.75
                    criticalThreshold: 0.92
                    onSegmentClicked: function (i) {
                        segMsg.text = qsTr("segmentClicked: %1").arg(i)
                    }
                }
                SegmentedGauge {
                    width: 120
                    height: 120
                    title: qsTr("Quota")
                    value: 7
                    maximum: 10
                    segmentCount: 10
                    gapDegrees: 8
                    fillMode: "discrete"
                    isInteractive: true
                    fillColor: Theme.systemAttention
                    caption: qsTr("7 / 10")
                }
            }
            Label {
                id: segMsg
                text: qsTr("Tap a segment")
                color: Theme.textSecondary
            }
        }
    }
}
