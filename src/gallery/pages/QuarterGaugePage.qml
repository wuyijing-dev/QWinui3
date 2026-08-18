import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

CatalogPage {
    title: qsTr("QuarterGauge")
    subtitle: qsTr("Experimental 90° quadrant meter. Prefer RadialGauge for a full needle scale.")

    ControlExample {
        headerText: qsTr("Load")
        qmlSource: "QuarterGauge { value: 72; unit: \"%\" }"
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingSection
            QuarterGauge {
                id: qg
                Layout.preferredWidth: 168
                Layout.preferredHeight: 148
                title: qsTr("CPU")
                value: 72
                unit: "%"
                isInteractive: true
            }
            Slider {
                Layout.fillWidth: true
                Layout.minimumWidth: 120
                Layout.alignment: Qt.AlignVCenter
                from: 0
                to: 100
                value: qg.value
                onMoved: qg.setValue(value)
            }
        }
    }
}
