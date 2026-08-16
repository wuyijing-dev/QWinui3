import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Accessibility patterns (Accessible.name, composite keyboard, Theme flags).

CatalogPage {
    title: qsTr("Accessibility")
    subtitle: qsTr("Accessible names, composite keyboard focus, and Theme accessibility flags. See docs/conventions.md.")

    ControlExample {
        headerText: qsTr("Icon-only names")
        qmlSource: "IconButton {\n    symbol: FluentIcons.Copy\n    toolTipText: qsTr(\"Copy\")\n}"

        ColumnLayout {
            spacing: Theme.spacing
            Label {
                text: qsTr("Prefer toolTipText (or Accessible.name) on icon-only buttons — glyph alone is not announced.")
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                color: Theme.textSecondary
            }
            RowLayout {
                spacing: Theme.spacingLoose
                IconButton {
                    symbol: FluentIcons.Copy
                    toolTipText: qsTr("Copy")
                }
                IconButton {
                    symbol: FluentIcons.Delete
                    toolTipText: qsTr("Delete")
                }
                IconButton {
                    // Intentionally missing name — screen readers hear a generic fallback.
                    symbol: FluentIcons.FavoriteStar
                }
                Label {
                    text: qsTr("← last has no toolTipText")
                    color: Theme.systemCaution
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Composite keyboard (Tab once, then arrows)")
        qmlSource: "RadioButtons { … }\nSegmentedControl { … }\nChipGroup { … }"

        ColumnLayout {
            spacing: Theme.spacingLoose
            Label {
                text: qsTr("Tab focuses the group; Left/Right (or Up/Down) move selection. Home/End jump to ends.")
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                color: Theme.textSecondary
            }
            RadioButtons {
                header: qsTr("Export")
                model: [qsTr("PDF"), qsTr("PNG"), qsTr("SVG")]
                currentIndex: 0
            }
            SegmentedControl {
                model: [qsTr("Day"), qsTr("Week"), qsTr("Month")]
                currentIndex: 1
            }
            ChipGroup {
                model: [qsTr("All"), qsTr("Open"), qsTr("Closed")]
                currentIndex: 0
            }
            PagerControl {
                numberOfPages: 8
                selectedIndex: 2
            }
        }
    }

    ControlExample {
        headerText: qsTr("Theme accessibility flags")
        qmlSource: "Theme.reducedMotion / Theme.highContrast\n// Settings → Follow system accessibility"

        ColumnLayout {
            spacing: Theme.spacing
            Label {
                text: qsTr("Gallery Settings can follow system SPI or override reduced motion and high contrast.")
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                color: Theme.textSecondary
            }
            SettingsToggleCard {
                title: qsTr("Reduced motion")
                description: Theme.followSystemAccessibility
                             ? qsTr("Following system — turn off Follow system accessibility in Settings to override.")
                             : qsTr("Collapses Theme.duration() animations.")
                checked: Theme.reducedMotion
                toggleEnabled: !Theme.followSystemAccessibility
                onToggled: {
                    if (!Theme.followSystemAccessibility)
                        Theme.reducedMotion = checked
                }
            }
            SettingsToggleCard {
                title: qsTr("High contrast")
                description: Theme.followSystemAccessibility
                             ? qsTr("Following system — turn off Follow system accessibility in Settings to override.")
                             : qsTr("Strengthens borders and focus cues (Theme.highContrast).")
                checked: Theme.highContrast
                toggleEnabled: !Theme.followSystemAccessibility
                onToggled: {
                    if (!Theme.followSystemAccessibility)
                        Theme.highContrast = checked
                }
            }
        }
    }
}
