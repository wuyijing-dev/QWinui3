import QtQuick
import QWinUI3.Extras

// RatingStars — semantic star-rating wrapper around RatingControl.
//
// @notes
//   This component exists mostly to align naming with product author intent
//   (“RatingStars” / “stars”) instead of the more generic “RatingControl”.

RatingControl {
    id: root

    // Whole/half steps are the most common Windows-like star ratings.
    stepSize: allowHalf ? 0.5 : 1.0

    // Allow half-stars.
    property bool allowHalf: true

    // Keep the defaults stable: 0..5 stars, outline/filled glyphs.
    maxRating: 5

    // Default glyphs: use RatingControl's built-in Fluent defaults when empty.
    // Callers can override emptyGlyph/filledGlyph/placeholderGlyph as needed.
}

