import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Keyboard-first cookbook (1.44). docs/keyboard.md

CatalogPage {
    id: page
    title: qsTr("Keyboard-first")
    subtitle: qsTr("Chords → palette → dialogs → lists — docs/keyboard.md (1.44).")

    signal openControl(var item)

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    ControlExample {
        headerText: qsTr("End-to-end path")
        qmlSource: "Ctrl+K CommandPalette\nEnter/Esc ContentDialog · arrows in lists"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("1) Global chord opens CommandPalette. 2) Enter activates the highlighted command. 3) ContentDialog: Enter = defaultButton, Esc = close path (onClosing can cancel). 4) Lists/DataTable: arrows, Home/End, optional Ctrl+A. Full checklist also on Accessibility.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                Button {
                    text: qsTr("CommandPalette")
                    highlighted: true
                    onClicked: page.openComp("CommandPalettePage")
                }
                Button {
                    text: qsTr("ContentDialog")
                    onClicked: page.openComp("ContentDialogPage")
                }
                Button {
                    text: qsTr("Accessibility tour")
                    onClicked: page.openComp("AccessibilityPage")
                }
                Button {
                    text: qsTr("Commands hub")
                    onClicked: page.openComp("CommandsHubPage")
                }
            }
        }
    }
}
