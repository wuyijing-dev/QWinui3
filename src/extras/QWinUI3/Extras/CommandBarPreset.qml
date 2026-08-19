import QtQuick
import QWinUI3.Extras

// CommandBarPreset — product default preset to avoid “looks broken” combos.
//
// @notes
//   Use this in LoB shells instead of setting many CommandBar properties ad-hoc.

CommandBar {
    id: root

    // Product preset: label + spacing should look like a normal app toolbar.
    compact: false

    // Move overflowing primary commands into (…) menu (WinUI IsDynamicOverflowEnabled).
    isDynamicOverflowEnabled: true

    // Keep toggle/chevron visible so labels can expand/collapse reliably.
    isToggleButtonVisible: true

    // Use bottom (WinUI default for typical app toolbars).
    defaultLabelPosition: "bottom"

    // Typical top-toolbar opens upward when space is tight.
    overflowOpensUpward: false
}

