import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — RangeSlider.

CatalogPage {
    title: qsTr("RangeSlider")
    subtitle: qsTr("A control for selecting a continuous range between two values.")

    ControlExample {
        headerText: qsTr("A simple RangeSlider")
        qmlSource: "RangeSlider {\n    from: 0\n    to: 100\n    first.value: 20\n    second.value: 70\n}"

        RangeSlider {
            Layout.preferredWidth: 320
            from: 0
            to: 100
            first.value: 20
            second.value: 70
        }
    }
}
