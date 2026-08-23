import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

Page {
    padding: Theme.spacingSection

    DashboardShell {
        anchors.fill: parent
        title: qsTr("Welcome")
        subtitle: qsTr("Bootstrap + NavigationWindow + DashboardShell — copy this folder to start.")

        kpiRow: RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            KpiTile {
                title: qsTr("Active users")
                value: 1284
                delta: 4.2
                symbol: FluentIcons.People
            }
            KpiTile {
                title: qsTr("Errors")
                value: 3
                delta: -12.0
                invertDeltaColors: true
                symbol: FluentIcons.StatusErrorFull
            }
        }

        ContentCard {
            Layout.fillWidth: true
            title: qsTr("Hour checklist")
            subtitle: qsTr("1) cmake Release + build this target  2) read docs/first-app-252.md shell tree  3) run lint_qml_imports.py before shipping  4) graduate to gallery-shell when you need Settings + ThemeAppearanceSettings.")
        }
        ContentCard {
            Layout.fillWidth: true
            title: qsTr("Shell ladder")
            subtitle: qsTr("first-app (here) → gallery-shell (Settings) → dashboard (stable six charts) → find-package-consumer (Path C).")
        }
        Item { Layout.fillHeight: true }
    }
}
