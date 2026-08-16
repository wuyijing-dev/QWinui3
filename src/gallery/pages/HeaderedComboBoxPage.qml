import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — HeaderedComboBox.

CatalogPage {
    title: qsTr("HeaderedComboBox")
    subtitle: qsTr("Labeled ComboBox with FormLayout labelWidth / headerPlacement push.")

    ControlExample {
        headerText: qsTr("Plan")
        qmlSource: "HeaderedComboBox {\n    header: \"Plan\"\n    model: [\"Free\", \"Pro\"]\n}"
        HeaderedComboBox {
            Layout.maximumWidth: 360
            header: qsTr("Plan")
            description: qsTr("Choose a subscription tier.")
            model: [qsTr("Free"), qsTr("Pro"), qsTr("Team")]
            currentIndex: 1
        }
    }
    ControlExample {
        headerText: qsTr("Left header")
        qmlSource: "HeaderedComboBox { headerPlacement: \"left\" }"
        HeaderedComboBox {
            Layout.maximumWidth: 420
            header: qsTr("Region")
            headerPlacement: "left"
            model: [qsTr("Americas"), qsTr("EMEA"), qsTr("APAC")]
        }
    }
}
