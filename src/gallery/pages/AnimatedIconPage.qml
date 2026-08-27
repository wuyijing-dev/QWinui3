import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — AnimatedIcon. Thin state glyph swap — not Lottie.
// Cookbook: docs/icons.md · docs/animations.md

CatalogPage {
    title: qsTr("AnimatedIcon")
    subtitle: qsTr("Thin state glyph swap. Not Lottie / WinUI AnimatedIcon parity — docs/icons.md.")

    ControlExample {
        headerText: qsTr("Play / pause")
        qmlSource: "AnimatedIcon {\n    checked: playing\n    symbol: FluentIcons.Play\n    symbolChecked: FluentIcons.Pause\n}"
        ColumnLayout {
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Crossfade + scale kick between two FluentIcons. Theme.reducedMotion snaps instantly. Experimental — no Lottie runtime.")
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
            }
            RowLayout {
                spacing: Theme.spacingLoose
                AnimatedIcon {
                    id: playIcon
                    fontSize: 32
                    checked: playToggle.checked
                    symbol: FluentIcons.Play
                    symbolChecked: FluentIcons.Pause
                    accessibleName: playToggle.checked ? qsTr("Pause") : qsTr("Play")
                    toolTipText: accessibleName
                }
                Button {
                    id: playToggle
                    checkable: true
                    text: checked ? qsTr("Pause") : qsTr("Play")
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Expand / collapse")
        qmlSource: "AnimatedIcon {\n    iconState: expanded ? \"open\" : \"closed\"\n    iconStates: [\n        { name: \"closed\", symbol: FluentIcons.ChevronDown },\n        { name: \"open\", symbol: FluentIcons.ChevronUp }\n    ]\n}"
        ColumnLayout {
            spacing: Theme.spacing
            RowLayout {
                spacing: Theme.spacingLoose
                AnimatedIcon {
                    fontSize: 28
                    iconState: expandToggle.checked ? "open" : "closed"
                    iconStates: [
                        { name: "closed", symbol: FluentIcons.ChevronDown },
                        { name: "open", symbol: FluentIcons.ChevronUp }
                    ]
                    accessibleName: expandToggle.checked ? qsTr("Collapse") : qsTr("Expand")
                    toolTipText: accessibleName
                }
                Button {
                    id: expandToggle
                    checkable: true
                    text: checked ? qsTr("Collapse") : qsTr("Expand")
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Favorite toggle")
        qmlSource: "AnimatedIcon {\n    checked: fav\n    symbol: FluentIcons.Favorite\n    symbolChecked: FluentIcons.FavoriteStarFill\n    iconColor: Theme.accent\n}"
        ColumnLayout {
            spacing: Theme.spacing
            RowLayout {
                spacing: Theme.spacingLoose
                AnimatedIcon {
                    fontSize: 32
                    checked: favToggle.checked
                    symbol: FluentIcons.Favorite
                    symbolChecked: FluentIcons.FavoriteStarFill
                    iconColor: Theme.accent
                    accessibleName: favToggle.checked ? qsTr("Unfavorite") : qsTr("Favorite")
                    toolTipText: accessibleName
                }
                Button {
                    id: favToggle
                    checkable: true
                    text: checked ? qsTr("Unfavorite") : qsTr("Favorite")
                }
                CheckBox {
                    text: qsTr("Theme.reducedMotion")
                    checked: Theme.reducedMotion
                    onToggled: Theme.reducedMotion = checked
                }
            }
        }
    }
}
