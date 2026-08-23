import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — MaskedTextField (2.71).

CatalogPage {
    id: page
    title: qsTr("MaskedTextField")
    subtitle: qsTr("Simple digit/letter masks for phone and ID patterns — not a full locale engine.")

    ControlExample {
        headerText: qsTr("Phone mask")
        qmlSource: "MaskedTextField { mask: \"(###) ###-####\" }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            MaskedTextField {
                id: phone
                Layout.fillWidth: true
                Layout.maximumWidth: 280
                mask: "(###) ###-####"
                placeholderText: qsTr("(555) 010-0100")
            }
            Label {
                text: qsTr("rawText: %1 · complete: %2")
                        .arg(phone.rawText)
                        .arg(phone.acceptableInput ? qsTr("yes") : qsTr("no"))
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
            }
        }
    }

    ControlExample {
        headerText: qsTr("Alphanumeric ID")
        qmlSource: "MaskedTextField { mask: \"AA-####\" }"
        MaskedTextField {
            Layout.fillWidth: true
            Layout.maximumWidth: 200
            mask: "AA-####"
            placeholderText: qsTr("AB-1234")
        }
    }
}
