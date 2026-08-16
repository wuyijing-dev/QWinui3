import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Accessibility checklist (1.02 high-traffic + 1.19 wave 2).
// Recipe: docs/accessibility.md

CatalogPage {
    title: qsTr("Accessibility")
    subtitle: qsTr("1.02 path + wave 2 (DataTable / lists / forms / commands / dialogs). docs/accessibility.md")

    ControlExample {
        headerText: qsTr("1.02 high-traffic checklist")
        qmlSource: "// SettingsCard { toggle: true }\n// NavigationView items + Esc on InfoBar/Toast"

        ColumnLayout {
            spacing: Theme.spacing
            Label {
                text: qsTr("Product apps that copy examples/nav-settings should verify:")
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                color: Theme.textSecondary
            }
            Label {
                text: qsTr("• Settings toggle rows: Tab focuses the card; Space/Enter toggles; screen reader hears the title as a checkbox.\n"
                           + "• NavigationView: Back / Expand / items / Settings footer announce names (not empty ListItem).\n"
                           + "• ContentDialog: Esc closes; Enter activates the default button; dialog name is the title.\n"
                           + "• InfoBar / Toast: Esc dismisses when closable; Close is keyboard-activatable; severity is in the description.\n"
                           + "• Theme.reducedMotion / highContrast: Gallery Settings → Follow system accessibility.")
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                color: Theme.textPrimary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Wave 2 checklist (1.19)")
        qmlSource: "// DataTable / ItemsView / ListDetailsView / FormLayout\n// CommandPalette / ContentDialog — docs/accessibility.md"

        ColumnLayout {
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: qsTr("• DataTable: accessibleName; filter + sortable headers; rows announce first cell; arrows / Enter.\n"
                           + "• ItemsView / ListDetailsView: accessibleName; row titles; Esc (details→list / clear multi-select).\n"
                           + "• FormLayout: accessibleName + error count; headered fields put errorMessage in description.\n"
                           + "• CommandPalette / CommandBar / MenuFlyout: see Commands pages + docs/commands.md.\n"
                           + "• ContentDialog / Flyout / TeachingTip / Drawer: docs/dialogs-flyouts.md.")
            }
        }
    }

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
                    text: qsTr("(no toolTipText on last button)")
                    color: Theme.systemCaution
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Settings toggle (row owns focus)")
        qmlSource: "SettingsToggleCard {\n    title: qsTr(\"Dark mode\")\n    checked: Theme.dark\n}"

        ColumnLayout {
            spacing: Theme.spacing
            Label {
                text: qsTr("Tab once onto the card, then Space. The built-in Switch is mouse-only so AT does not hear “Toggle” twice.")
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                color: Theme.textSecondary
            }
            SettingsToggleCard {
                title: qsTr("Demo toggle")
                description: qsTr("Accessible CheckBox named from the title.")
                checked: false
            }
        }
    }

    ControlExample {
        headerText: qsTr("Wave 2 sample — form + list names")
        qmlSource: "FormLayout { accessibleName: qsTr(\"Account\") }\nItemsView { accessibleName: qsTr(\"People\") }"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("Override accessibleName when several lists/forms share a page so Narrator can tell them apart.")
            }
            FormLayout {
                accessibleName: qsTr("Account form")
                Layout.fillWidth: true
                HeaderedTextBox {
                    header: qsTr("Display name")
                    placeholderText: qsTr("Required")
                }
            }
            ItemsView {
                accessibleName: qsTr("People")
                Layout.fillWidth: true
                Layout.preferredHeight: 160
                model: [
                    { title: qsTr("Alex"), subtitle: qsTr("Designer") },
                    { title: qsTr("Blake"), subtitle: qsTr("Engineer") }
                ]
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
                             : qsTr("Strengthens borders and focus cues (Theme.highContrast). Accent AA checks: Theme overrides / docs/color-contrast.md (1.43).")
                checked: Theme.highContrast
                toggleEnabled: !Theme.followSystemAccessibility
                onToggled: {
                    if (!Theme.followSystemAccessibility)
                        Theme.highContrast = checked
                }
            }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Brand contrast diagnostics (textPrimary / accent on bgCard): Gallery Theme overrides — docs/color-contrast.md (1.43).")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
        }
    }
}
