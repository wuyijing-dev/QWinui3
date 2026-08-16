import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — TextArea.

CatalogPage {
    title: qsTr("TextArea")
    subtitle: qsTr("A multi-line text input control.")

    ControlExample {
        headerText: qsTr("A simple TextArea")
        qmlSource: "TextArea {\n    placeholderText: \"Multi-line text…\"\n    Layout.preferredWidth: 420\n    Layout.preferredHeight: 120\n}"

        TextArea {
            Layout.preferredWidth: 420
            Layout.preferredHeight: 120
            placeholderText: qsTr("Multi-line text…")
        }
    }
}
