import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// SettingsComboCard — SettingsCard with a built-in ComboBox action.
//
//   SettingsComboCard {
//       title: qsTr("Density")
//       model: [qsTr("Standard"), qsTr("Compact")]
//       currentIndex: 0
//       onActivated: (i) => { … }
//   }
//
// @notes
//   Convenience over SettingsCard { action: ComboBox {…} }. Prefer for settings rows.

SettingsCard {
    id: root

    Accessible.description: {
        var parts = []
        if (description.length)
            parts.push(description)
        if (combo.currentText.length)
            parts.push(combo.currentText)
        return parts.join(". ")
    }

    property alias model: combo.model
    property alias currentIndex: combo.currentIndex
    property alias currentText: combo.currentText
    property alias currentValue: combo.currentValue
    property alias textRole: combo.textRole
    property alias valueRole: combo.valueRole
    property alias comboBox: combo
    signal activated(int index)

    action: ComboBox {
        id: combo
        implicitWidth: Math.max(140, implicitContentWidth + leftPadding + rightPadding)
        onActivated: function (index) { root.activated(index) }
    }
}
