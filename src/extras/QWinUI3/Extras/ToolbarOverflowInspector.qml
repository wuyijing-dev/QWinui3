import QtQuick
import QtQuick.Layouts
import QWinUI3.Theme
import QWinUI3.Extras

// ToolbarOverflowInspector — show live overflow configuration + diagnostics.
//
// @notes
//   This is intentionally lightweight: it surfaces the “combo knobs” that most
//   frequently cause CommandBar to look broken (compact/collapsed, overflow toggles).

Item {
    id: root

    property var commandBar: null
    property bool enabled: true

    visible: root.enabled && root.commandBar !== null

    implicitWidth: 360
    implicitHeight: 160

    Rectangle {
        anchors.fill: parent
        radius: Theme.cornerControl
        color: Theme.bgCard
        border.width: 1
        border.color: Theme.strokeCard
        opacity: Theme.dark ? 0.92 : 0.98
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 6

        Text {
            Layout.fillWidth: true
            font.pixelSize: Theme.fontBodyLarge
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textPrimary
            text: qsTr("Toolbar overflow inspector")
            wrapMode: Text.NoWrap
        }

        function _v(x) { return x === undefined || x === null ? "—" : String(x) }

        Text { color: Theme.textSecondary; font.pixelSize: Theme.fontCaption; text: qsTr("compact: %1").arg(_v(root.commandBar.compact)) }
        Text { color: Theme.textSecondary; font.pixelSize: Theme.fontCaption; text: qsTr("defaultLabelPosition: %1").arg(_v(root.commandBar.defaultLabelPosition)) }
        Text { color: Theme.textSecondary; font.pixelSize: Theme.fontCaption; text: qsTr("isDynamicOverflowEnabled: %1").arg(_v(root.commandBar.isDynamicOverflowEnabled)) }
        Text { color: Theme.textSecondary; font.pixelSize: Theme.fontCaption; text: qsTr("isToggleButtonVisible: %1").arg(_v(root.commandBar.isToggleButtonVisible)) }
        Text {
            color: Theme.textSecondary
            font.pixelSize: Theme.fontCaption
            text: qsTr("isMoreButtonVisible: %1").arg(_v(root.commandBar.isMoreButtonVisible))
        }

        Text {
            visible: root.commandBar._hasDynamicOverflow || root.commandBar._overflowedPrimaries
            color: Theme.textSecondary
            font.pixelSize: Theme.fontCaption
            text: qsTr("overflowedPrimaries: %1").arg(_v(root.commandBar._overflowedPrimaries && root.commandBar._overflowedPrimaries.length !== undefined ? root.commandBar._overflowedPrimaries.length : "—"))
        }
    }
}

