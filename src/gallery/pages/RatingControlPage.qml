import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — RatingControl.
//
// Fluent OutlineStar / FavoriteStarFill; drag to pick whole, half, or fine ratings. API: docs/components/RatingControl.md

CatalogPage {
    id: page
    title: qsTr("RatingControl")
    subtitle: qsTr("Fluent OutlineStar / FavoriteStarFill; drag or Tab+arrows (Home/End). Whole, half, or fine ratings.")

    property real liveValue: 3.5

    ControlExample {
        headerText: qsTr("Half-star mouse pick")
        qmlSource: "RatingControl {\n    value: 3.5\n    stepSize: 0.5\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            RatingControl {
                id: halfRating
                caption: qsTr("Your rating")
                value: page.liveValue
                stepSize: 0.5
                onValueEdited: (v) => page.liveValue = v
            }
            CheckBox {
                text: qsTr("Enabled")
                checked: halfRating.enabled
                onToggled: halfRating.enabled = checked
            }
            Label {
                color: Theme.textSecondary
                text: qsTr("Value: %1 (disabledGlyph when not enabled)").arg(Number(page.liveValue).toFixed(1))
            }
        }
    }

    ControlExample {
        headerText: qsTr("Continuous (fine step)")
        qmlSource: "RatingControl { stepSize: 0.1 }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            RatingControl {
                id: fineRating
                value: 2.4
                stepSize: 0.1
                maxRating: 5
            }
            Label {
                color: Theme.textSecondary
                text: qsTr("Value: %1  — drag across stars for any point")
                    .arg(Number(fineRating.value).toFixed(1))
            }
        }
    }

    ControlExample {
        headerText: qsTr("Whole stars · clear · read-only")
        qmlSource: "RatingControl { stepSize: 1 }\nRatingControl { readOnly: true }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            RatingControl {
                value: 3
                stepSize: 1
                isClearEnabled: true
            }
            RatingControl {
                value: 4.5
                stepSize: 0.5
                isReadOnly: true
                caption: qsTr("Read-only")
            }
            RatingControl {
                value: 0
                initialSetValue: 3
                stepSize: 1
                caption: qsTr("InitialSetValue → 3 on first pick")
            }
            RatingControl {
                value: 4
                stepSize: 1
                emptyGlyph: FluentIcons.OutlineStar
                filledGlyph: FluentIcons.SolidStar
                caption: qsTr("Custom ItemInfo glyphs")
            }
            RatingControl {
                value: 0
                placeholderValue: 4
                placeholderGlyph: FluentIcons.FavoriteStarFill
                stepSize: 1
                caption: qsTr("PlaceholderGlyph until first pick")
            }
            Label {
                color: Theme.textSecondary
                text: qsTr("Placeholder shows until the user picks a rating. Click the same value again to clear.")
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
        }
    }

    ControlExample {
        headerText: qsTr("Custom scale")
        qmlSource: "RatingControl { maxRating: 10; stepSize: 0.5 }"
        RatingControl {
            maxRating: 10
            value: 7.5
            stepSize: 0.5
            font.pixelSize: 16
        }
    }
}
