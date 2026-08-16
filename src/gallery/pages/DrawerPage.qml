import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — Drawer.
//
// A slide-out panel that presents navigation or contextual content from an edge. API: docs/components/Drawer.md

CatalogPage {
    title: qsTr("Drawer")
    subtitle: qsTr("A slide-out panel that presents navigation or contextual content from an edge.")

    overlay: Drawer {
        id: drawer
        // Explicit window overlay — CatalogPage.overlay would otherwise keep us in-pane.
        parent: Overlay.overlay
        edge: Qt.LeftEdge
        // Width is the panel size; height is bound to Overlay by the Drawer style.
        width: Math.min(Theme.dp(320), (Overlay.overlay ? Overlay.overlay.width : 1280) * 0.85)

        ColumnLayout {
            anchors.fill: parent
            spacing: Theme.spacingLoose

            Label {
                text: qsTr("Drawer content")
                font.pixelSize: Theme.fontSubtitle
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
                Layout.fillWidth: true
            }
            Label {
                text: qsTr("Use a Drawer for navigation or secondary actions.")
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                color: Theme.textSecondary
            }
            Item { Layout.fillHeight: true }
            Button {
                text: qsTr("Action")
                highlighted: true
                Layout.fillWidth: true
            }
            Button {
                text: qsTr("Close")
                Layout.fillWidth: true
                onClicked: drawer.close()
            }
        }
    }

    ControlExample {
        headerText: qsTr("Left edge Drawer")
        qmlSource: "Button {\n    text: \"Open drawer\"\n    onClicked: drawer.open()\n}\nDrawer {\n    edge: Qt.LeftEdge\n    // content…\n}"

        Button {
            text: qsTr("Open drawer")
            onClicked: drawer.open()
        }
    }
}
