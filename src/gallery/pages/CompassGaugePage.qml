import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — CompassGauge.

CatalogPage {
    title: qsTr("CompassGauge")
    subtitle: qsTr("Experimental heading compass (0–360° wrap). Prefer RadialGauge for linear scales.")

    ControlExample {
        headerText: qsTr("Bearing")
        qmlSource: "CompassGauge {\n    heading: 42\n    isInteractive: true\n}"
        RowLayout {
            spacing: Theme.spacingSection
            CompassGauge {
                id: compass
                heading: 42
                title: qsTr("Nav")
                isInteractive: true
            }
            ColumnLayout {
                Label {
                    text: qsTr("%1° %2").arg(Math.round(compass.heading)).arg(compass.cardinal)
                    color: Theme.textSecondary
                }
                Slider {
                    from: 0
                    to: 359
                    value: compass.heading
                    onMoved: compass.setHeading(value)
                }
            }
        }
    }
}
