import QtQuick

// PointerCursor — Hover cursor affordance for styled controls (2.66 M8).
//
//   PointerCursor { shape: Qt.PointingHandCursor }
//
// @notes
//   Qt Quick Templates (T.TextField, T.Button, …) do not expose cursorShape;
//   use this HoverHandler wrapper instead of assigning on the control root.

HoverHandler {
    property int shape: Qt.ArrowCursor
    cursorShape: shape
}
