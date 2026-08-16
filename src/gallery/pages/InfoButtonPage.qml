import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — InfoButton.

CatalogPage {
    title: qsTr("InfoButton")
    subtitle: qsTr("Fluent Info glyph that opens a TeachingTip.")

    ControlExample {
        headerText: qsTr("Help next to a label")
        qmlSource: "InfoButton {\n    tipTitle: \"Density\"\n    tipSubtitle: \"…\"\n}"
        RowLayout {
            spacing: Theme.spacing
            Label {
                text: qsTr("Compact density")
                color: Theme.textPrimary
            }
            InfoButton {
                tipTitle: qsTr("Density")
                tipSubtitle: qsTr("Compact shrinks Theme.controlHeight, padding, and spacing.")
                preferredPlacement: Qt.AlignBottom
            }
        }
    }
}
