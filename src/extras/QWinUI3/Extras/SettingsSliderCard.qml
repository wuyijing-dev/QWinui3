import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// SettingsSliderCard — SettingsCard with a built-in value Slider action.
//
//   SettingsSliderCard {
//       title: qsTr("Volume")
//       from: 0; to: 100; value: 40
//       onMoved: { … }
//   }
//
// @notes
//   Convenience over SettingsCard { action: Slider {…} }. Shows a live value label.

SettingsCard {
    id: root

    property alias from: slider.from
    property alias to: slider.to
    property alias value: slider.value
    property alias stepSize: slider.stepSize
    property alias slider: slider
    property int valuePrecision: 0
    signal moved()
    signal valueEdited(real value)

    action: RowLayout {
        spacing: Theme.spacing
        Label {
            text: Number(slider.value).toFixed(root.valuePrecision)
            color: Theme.textSecondary
            Layout.preferredWidth: 36
            horizontalAlignment: Text.AlignRight
        }
        Slider {
            id: slider
            Layout.preferredWidth: 140
            onMoved: {
                root.moved()
                root.valueEdited(value)
            }
        }
    }
}
