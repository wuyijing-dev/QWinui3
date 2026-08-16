import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — HeaderedComboBox.

CatalogPage {
    title: qsTr("HeaderedComboBox")
    subtitle: qsTr("Labeled ComboBox with FormLayout push and errorMessage chrome.")

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
    ControlExample {
        headerText: qsTr("errorMessage")
        qmlSource: "HeaderedComboBox { errorMessage: qsTr(\"Choose a plan.\") }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            HeaderedComboBox {
                id: errCombo
                Layout.maximumWidth: 360
                header: qsTr("Plan")
                description: qsTr("Description hides while errored.")
                model: [qsTr("Free"), qsTr("Pro"), qsTr("Team")]
                currentIndex: 0
                errorMessage: qsTr("Choose Pro or Team.")
            }
            Button {
                flat: true
                text: qsTr("Toggle error")
                onClicked: errCombo.errorMessage = errCombo.errorMessage.length
                           ? "" : qsTr("Choose Pro or Team.")
            }
        }
    }
}
