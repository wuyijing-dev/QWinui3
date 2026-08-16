import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — SpinBox.

CatalogPage {
    title: qsTr("SpinBox")
    subtitle: qsTr("Numeric stepper with Fluent chevron glyphs.")

    ControlExample {
        headerText: qsTr("A simple SpinBox")
        qmlSource: "SpinBox {\n    from: 0\n    to: 100\n    value: 42\n}\nSpinBox {\n    from: 0\n    to: 10\n    value: 3\n    enabled: false\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            SpinBox {
                from: 0
                to: 100
                value: 42
            }
            SpinBox {
                from: 0
                to: 10
                value: 3
                enabled: false
            }
        }
    }
}
