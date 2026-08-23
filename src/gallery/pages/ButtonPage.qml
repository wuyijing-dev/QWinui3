import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — Button.
//
// A control that responds to user input and raises a Click event. API: docs/components/Button.md

CatalogPage {
    title: qsTr("Button")
    subtitle: qsTr("Click / tap — keep hits ≥ Theme.controlHeight. Touch: docs/touch-pointer.md (1.57).")

    ControlExample {
        headerText: qsTr("Touch & pointer (1.57)")
        qmlSource: "docs/touch-pointer.md\nTheme.controlHeight floor"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Touch cookbook: docs/touch-pointer.md. Keep primary / icon-only hits ≥ Theme.controlHeight; prefer density \"standard\" for finger-first. Related: Density page.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Standard")
        qmlSource: "Button {\n    text: \"Button\"\n}\nButton {\n    text: \"Disabled\"\n    enabled: false\n}"

        Flow {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Button { text: qsTr("Button") }
            Button { text: qsTr("Disabled"); enabled: false }
        }
    }

    ControlExample {
        headerText: qsTr("Appearances (2.66 A1)")
        qmlSource: "Button { appearance: \"filled\" }\nButton { appearance: \"subtle\" }\nButton { appearance: \"outline\" }\nButton { appearance: \"ghost\" }"

        Flow {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Button { text: qsTr("Filled"); appearance: "filled" }
            Button { text: qsTr("Subtle"); appearance: "subtle" }
            Button { text: qsTr("Outline"); appearance: "outline" }
            Button { text: qsTr("Ghost"); appearance: "ghost" }
        }
    }

    ControlExample {
        headerText: qsTr("Accent")
        qmlSource: "Button {\n    text: \"Accent\"\n    highlighted: true\n}\nButton {\n    text: \"Accent disabled\"\n    highlighted: true\n    enabled: false\n}"

        Flow {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Button { text: qsTr("Accent"); highlighted: true }
            Button { text: qsTr("Accent disabled"); highlighted: true; enabled: false }
        }
    }
}
