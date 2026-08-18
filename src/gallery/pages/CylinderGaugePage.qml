import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

CatalogPage {
    title: qsTr("CylinderGauge")
    subtitle: qsTr("Experimental isometric cylinder. Prefer TankGauge for a 2D reservoir.")

    ControlExample {
        headerText: qsTr("Coolant")
        qmlSource: "CylinderGauge { value: 62; isInteractive: true }"
        RowLayout {
            spacing: Theme.spacingSection
            CylinderGauge {
                id: cyl
                title: qsTr("Loop")
                value: 62
                isInteractive: true
            }
            Slider {
                from: 0
                to: 100
                orientation: Qt.Vertical
                Layout.preferredHeight: 140
                value: cyl.value
                onMoved: cyl.setValue(value)
            }
        }
    }
}
