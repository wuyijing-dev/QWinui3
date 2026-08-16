import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — ToolTip.

CatalogPage {
    title: qsTr("ToolTip")
    subtitle: qsTr("Displays informational text when the user hovers over an element.")

    ControlExample {
        headerText: qsTr("A simple ToolTip")
        qmlSource: "Button {\n    text: \"Hover me\"\n    ToolTip.visible: hovered\n    ToolTip.text: \"Fluent-style tooltip\"\n    ToolTip.delay: 400\n}"

        Button {
            text: qsTr("Hover me")
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Fluent-style tooltip")
            ToolTip.delay: 400
        }
    }
}
