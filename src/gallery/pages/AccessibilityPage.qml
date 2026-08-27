import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Accessibility checklist + keyboard tour.
// Recipe: docs/accessibility.md · docs/keyboard.md

CatalogPage {
    id: page
    title: qsTr("Accessibility")
    subtitle: qsTr("Focus, contrast, reduced motion, and screen-reader recipes — docs/accessibility.md.")

    readonly property var a11yTableRows: [
        { name: "Alex Chen", role: "Design", status: "Active" },
        { name: "Jordan Lee", role: "Engineering", status: "Away" },
        { name: "Sam Rivera", role: "Product", status: "Active" }
    ]

    overlay: [
        ContentDialog {
            id: a11yDialog
            parent: Overlay.overlay
            anchors.centerIn: Overlay.overlay
            title: qsTr("Focus return")
            primaryButtonText: qsTr("OK")
            closeButtonText: qsTr("Cancel")
            defaultButton: "primary"
            Label {
                text: qsTr("Close this dialog. Focus should return to the button that opened it.")
                wrapMode: Text.Wrap
                color: Theme.textPrimary
            }
        },
        Flyout {
            id: a11yFlyout
            title: qsTr("Focus return")
            Label {
                text: qsTr("Esc or click outside. Focus returns to the opener.")
                wrapMode: Text.Wrap
                color: Theme.textPrimary
            }
        }
    ]

    ControlExample {
        headerText: qsTr("tree + breadcrumb")
        qmlSource: "TreeDataGrid.announceChanges · FileTree.announceChanges\nBreadcrumbBar.announceChanges · ItemsWrapGrid.accessibleName"

        ColumnLayout {
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("TreeDataGrid: arrow rows, Left/Right expand branches — hear selection + expand. BreadcrumbBar: Tab, Left/Right, Enter — hear Navigated to …. ItemsWrapGrid: set accessibleName and name each delegate chip.")
            }
            TreeDataGrid {
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                accessibleName: qsTr("Org sample")
                columns: [
                    { title: qsTr("Name"), role: "name", width: 140, sortable: true },
                    { title: qsTr("Role"), role: "role", width: 100 }
                ]
                rows: [
                    {
                        name: qsTr("Engineering"),
                        role: qsTr("Group"),
                        children: [
                            { name: qsTr("Alex"), role: qsTr("Engineer") },
                            { name: qsTr("Blake"), role: qsTr("Engineer") }
                        ]
                    }
                ]
                Component.onCompleted: expandAll()
            }
            BreadcrumbBar {
                Layout.fillWidth: true
                accessibleName: qsTr("Document path")
                model: [
                    { title: qsTr("Home"), symbol: FluentIcons.Home },
                    { title: qsTr("Docs") },
                    qsTr("Accessibility")
                ]
            }
        }
    }

    ControlExample {
        headerText: qsTr("collection live regions")
        qmlSource: "DataTable.announceChanges · ListDetailsView.announceChanges\nNavigationView.announceChanges"

        ColumnLayout {
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("Arrow through the table or list — Narrator should announce selection (Qt 6.8+ Accessible.announce). Sort a column or type in the filter to hear row counts. NavigationView announces page changes in Gallery Main when you switch nav items.")
            }
            DataTable {
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                accessibleName: qsTr("Team roster")
                filterPlaceholder: qsTr("Filter team")
                columns: [
                    { title: qsTr("Name"), role: "name", width: 140, sortable: true },
                    { title: qsTr("Role"), role: "role", width: 120, sortable: true },
                    { title: qsTr("Status"), role: "status", width: 100 }
                ]
                rows: page.a11yTableRows
            }
            ListDetailsView {
                id: listDetails
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                accessibleName: qsTr("Team details sample")
                listAccessibleName: qsTr("Team members")
                minWideWidth: 480
                model: page.a11yTableRows
                titleRole: "name"
                subtitleRole: "role"
                Component.onCompleted: select(0)
                details: Label {
                    anchors.fill: parent
                    wrapMode: Text.Wrap
                    color: Theme.textPrimary
                    text: listDetails.selectedItem
                          ? qsTr("Status: %1").arg(listDetails.selectedItem.status || "")
                          : ""
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("pin / group / bulk")
        qmlSource: "DataTable { groupRole; columns: [{ pinned: true }] }\nListDetailsView { multiSelectEnabled }"
        Label {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            color: Theme.textSecondary
            text: qsTr("Group headers are StaticText (not selectable). Pinned column headers announce “pinned”. Multi-select checkboxes are named Select {title}. docs/collection-perf-264.md")
        }
    }

    ControlExample {
        headerText: qsTr("focus return + live region")
        qmlSource: "ContentDialog / Flyout close → opener\nInfoBar AlertMessage + announce"

        ColumnLayout {
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("Tab to a button, activate it, then Esc. The same button should take focus again. Opening the InfoBar announces title + message (Qt 6.8+ Accessible.announce; 6.5 keeps AlertMessage). IME candidate live region is on the On-screen keyboard page.")
            }
            RowLayout {
                spacing: Theme.spacing
                Button {
                    id: a11yDialogBtn
                    text: qsTr("Open dialog")
                    onClicked: a11yDialog.show()
                }
                Button {
                    id: a11yFlyoutBtn
                    text: qsTr("Open flyout")
                    onClicked: a11yFlyout.showAt(a11yFlyoutBtn)
                }
                Button {
                    text: qsTr("Show InfoBar")
                    onClicked: a11yInfoBar.open()
                }
            }
            InfoBar {
                id: a11yInfoBar
                Layout.fillWidth: true
                title: qsTr("Saved")
                message: qsTr("Changes stored. Screen readers should hear this banner.")
                severity: success
                isOpen: false
                closable: true
            }
        }
    }

    ControlExample {
        headerText: qsTr("Touch & pointer")
        qmlSource: "docs/touch-pointer.md · Theme.controlHeight"
        ColumnLayout {
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Finger targets, scroll vs drag, and pen hover notes: docs/touch-pointer.md. Prefer density \"standard\" for touch-first shells; do not put required UI only on hovered.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Keyboard-first tour")
        qmlSource: "// Ctrl+K → CommandPalette\n// Esc/Enter dialogs · arrows lists\n// docs/keyboard.md"
        ColumnLayout {
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("End-to-end cookbook: docs/keyboard.md. Surface details: docs/commands.md · docs/dialogs-flyouts.md · docs/data-collections.md. Complete the critical Gallery flows below without a mouse.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: qsTr("• Ctrl+K → CommandPalette (type, ↑↓, Enter, Esc).\n"
                           + "• ContentDialog: Esc closes; Enter activates default; focus returns to the opener.\n"
                           + "• DataTable / ListDetailsView: arrows · Enter · Esc/Back as documented.\n"
                           + "• Settings toggle cards: Tab + Space/Enter.\n"
                           + "• Icon-only buttons: toolTipText / Accessible.name.\n"
                           + "• CommandBar: Tab into strip; F10 / Alt+↓ overflow.")
            }
            RowLayout {
                spacing: Theme.spacing
                KeyChordVisual { shortcut: "Ctrl+K" }
                KeyChordVisual { shortcut: "Esc" }
                KeyChordVisual { shortcut: "Enter" }
                Label {
                    text: qsTr("Open CommandPalette page to try Ctrl+K live.")
                    color: Theme.textSecondary
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("High-traffic surfaces")
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
        headerText: qsTr("Collection & form surfaces")
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
                           + "• ContentDialog / Flyout / TeachingTip / onboarding coach / Drawer: docs/dialogs-flyouts.md · docs/feedback.md.")
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
        headerText: qsTr("Form + list names")
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
                text: qsTr("Theme.reducedMotion / Theme.highContrast follow the OS when Theme.followSystemAccessibility is on (ThemeSync on StandardWindow / ShellWindow — not Gallery-only). Override from ThemeAppearanceSettings when follow is off.")
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
                             : qsTr("Strengthens borders and focus cues (Theme.highContrast). Accent AA checks: Theme overrides / docs/color-contrast.md.")
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
                text: qsTr("Brand contrast diagnostics (textPrimary / accent on bgCard): Gallery Theme overrides — docs/color-contrast.md.")
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
        }
    }
}
