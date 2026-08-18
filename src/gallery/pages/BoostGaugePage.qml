import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

CatalogPage {
    title: qsTr("BoostGauge")
    subtitle: qsTr("Experimental vacuum/boost needle. Prefer RadialGauge for a generic scale.")

    ControlExample {
        headerText: qsTr("Turbo")
        qmlSource: "BoostGauge { value: 0.6; minimum: -1; maximum: 1.5 }"
        RowLayout {
            spacing: Theme.spacingSection
            BoostGauge {
                id: boost
                title: qsTr("MAP")
                value: 0.6
                isInteractive: true
            }
            Slider {
                from: -1
                to: 1.5
                value: boost.value
                onMoved: boost.setValue(value)
            }
        }
    }
}
