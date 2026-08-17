import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Density & responsive shells (1.30). docs/density.md

CatalogPage {
    id: page
    title: qsTr("Density")
    subtitle: qsTr("uiScale / density tokens · narrow shells — docs/density.md (1.30).")

    signal openControl(var item)
    signal openSettings()

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    ControlExample {
        headerText: qsTr("Live Theme metrics")
        qmlSource: "Theme.uiScale · Theme.controlHeight · Theme.spacing"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Density and uiScale adjust control height, spacing, and type. Change them on Theme overrides or Settings. Narrow shells: NavigationView paneDisplayMode auto / ListDetailsView at ~720px — docs/density.md · docs/adaptive-layout.md.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: qsTr("uiScale=%1 · controlHeight=%2 · spacing=%3 · fontBody=%4 · navPaneWidth=%5")
                    .arg(Theme.uiScale)
                    .arg(Theme.controlHeight)
                    .arg(Theme.spacing)
                    .arg(Theme.fontBody)
                    .arg(Theme.navPaneWidth)
            }
            RowLayout {
                Button {
                    text: qsTr("Theme overrides")
                    highlighted: true
                    onClicked: page.openComp("ThemeOverridesPage")
                }
                Button {
                    text: qsTr("TwoPaneView")
                    onClicked: page.openComp("TwoPaneViewPage")
                }
                Button {
                    text: qsTr("Open Settings")
                    onClicked: page.openSettings()
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Responsive recipes")
        qmlSource: "NavigationView paneDisplayMode: \"auto\"\nListDetailsView / TwoPaneView @ 720"
        Label {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            color: Theme.textSecondary
            text: qsTr("Use auto/compact/overlay pane modes under ~1008px. TwoPaneView + ListDetailsView switch at ~720. Keep touch targets ≥ Theme.controlHeight when scaling down.")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
        }
    }
}
