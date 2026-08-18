import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

CatalogPage {
    title: qsTr("PressureGauge")
    subtitle: qsTr("Experimental zoned needle. Prefer RadialGauge for a generic scale.")

    ControlExample {
        headerText: qsTr("Loop")
        qmlSource: "PressureGauge { value: 6.2; unit: \"bar\" }"
        RowLayout {
            spacing: Theme.spacingSection
            PressureGauge {
                id: pg
                title: qsTr("P1")
                value: 6.2
                maximum: 10
                unit: "bar"
                isInteractive: true
            }
            Slider {
                from: 0
                to: 10
                value: pg.value
                onMoved: pg.setValue(value)
            }
        }
    }
}
