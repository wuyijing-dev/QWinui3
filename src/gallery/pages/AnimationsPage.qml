import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Animations & transitions chooser (1.22).
//
// Recipe: docs/animations.md

CatalogPage {
    title: qsTr("Animations")
    subtitle: qsTr("Connected morph, page enter, content swap. Recipe: docs/animations.md — honors Theme.reducedMotion.")

    ControlExample {
        headerText: qsTr("When to use which (1.22)")
        qmlSource: "// ConnectedAnimation — list→detail\n// EntranceThemeTransition — section enter\n// ContentThemeTransition — panel swap\n// docs/animations.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Use ConnectedAnimation / ConnectedAnimationService for shared-element list→detail. EntranceThemeTransition for first show of a section. ContentThemeTransition when swapping panel identity. RepositionThemeTransition for Flow/Grid reflow. Theme.dark/accent: Behavior + Theme.duration — do not animate the whole title bar.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("All helpers skip or snap when Theme.reducedMotion is true (Gallery mirrors WindowHelper.systemReducedMotion when followSystemAccessibility is on).")
                font.pixelSize: Theme.fontCaption
                color: Theme.textPrimary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Reduced motion (live)")
        qmlSource: "Theme.reducedMotion = true\n// Theme.duration(ms) → 1"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Switch {
                text: qsTr("Theme.reducedMotion")
                checked: Theme.reducedMotion
                onToggled: Theme.reducedMotion = checked
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Toggle, then open ConnectedAnimation / Entrance / Theme transitions demos — morphs and entrances should skip or snap.")
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Open related demos")
        qmlSource: "// Gallery: ConnectedAnimation, EntranceThemeTransition, Theme transitions"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("• ConnectedAnimation — list→detail + ListDetailsView handoff\n• EntranceThemeTransition — fade + rise + scale\n• Theme transitions — ContentThemeTransition + RepositionThemeTransition\n• ItemsRepeater — extra ConnectedAnimation sample")
                color: Theme.textPrimary
            }
        }
    }
}
