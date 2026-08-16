import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — Tool / Round / Delay.

CatalogPage {
    title: qsTr("Tool / Round / Delay")
    subtitle: qsTr("Additional button variants for toolbars, compact actions, and hold-to-confirm.")

    ControlExample {
        headerText: qsTr("ToolButton and RoundButton")
        qmlSource: "ToolButton { text: \"Tool\" }\nRoundButton { text: \"+\" }\nRoundButton { text: \"A\"; highlighted: true }"

        Flow {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            ToolButton { text: qsTr("Tool") }
            RoundButton { text: "+" }
            RoundButton { text: "A"; highlighted: true }
        }
    }

    ControlExample {
        headerText: qsTr("DelayButton")
        qmlSource: "DelayButton {\n    text: \"Hold to confirm\"\n    delay: 1200\n    onActivated: text = \"Activated\"\n}"

        DelayButton {
            text: qsTr("Hold to confirm")
            delay: 1200
            onActivated: text = qsTr("Activated")
        }
    }
}
