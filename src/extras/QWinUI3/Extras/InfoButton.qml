import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QWinUI3.Theme

// InfoButton — Icon button that opens a TeachingTip.
//
//   InfoButton {
//       tipTitle: qsTr("Density")
//       tipSubtitle: qsTr("Compact shrinks control metrics.")
//   }
//
//   // --- API ---
//   // tipTitle / tipSubtitle / tipSymbol, isOpen, open()/close()
//   // property alias tip: teachingTip
//
// @notes
//   Fluent Info glyph; hosts TeachingTip anchored to itself (overlay-parented). Prefer for settings help.

IconButton {
    id: root

    property string tipTitle: ""
    property string tipSubtitle: ""
    property var tipSymbol: FluentIcons.Info
    property alias tip: tip
    property alias isOpen: tip.isOpen
    property int preferredPlacement: Qt.AlignTop

    symbol: FluentIcons.Info
    Accessible.role: Accessible.Button
    Accessible.name: tipTitle.length ? tipTitle : qsTr("More information")
    Accessible.description: tipSubtitle
    ToolTip.visible: hovered && !tip.isOpen && tipSubtitle.length === 0 && tipTitle.length > 0
    ToolTip.text: tipTitle

    onClicked: tip.isOpen = !tip.isOpen

    function open() { tip.isOpen = true }
    function close() { tip.isOpen = false }

    TeachingTip {
        id: tip
        target: root
        title: root.tipTitle
        subtitle: root.tipSubtitle
        symbol: root.tipSymbol
        preferredPlacement: root.preferredPlacement
        isCloseButtonVisible: true
    }
}
