import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// ValidationSummary — Lists form-level validation errors (pairs with FormLayout).
//
//   FormLayout {
//       id: form
//       ValidationSummary {
//           errors: form.errors
//           visible: form.errors.length > 0
//       }
//       HeaderedTextBox { … }
//   }
//
// @notes
//   Error banner + bullet list. Bind errors to FormLayout.errors after validate().
//   Optional title; uses Theme.systemCritical for severity styling.

T.Control {
    id: root

    Layout.fillWidth: true

    // Error strings to display
    property var errors: []
    // Banner title
    property string title: qsTr("Please fix the following")
    // Show even when errors is empty (for layout testing)
    property bool forceVisible: false

    property int _lastAnnouncedCount: -1

    onErrorsChanged: {
        var n = (errors && errors.length) || 0
        Accessible.description = n ? errors.join("; ") : ""
        if (_lastAnnouncedCount >= 0 && n !== _lastAnnouncedCount) {
            if (n > 0)
                Accessible.announce(qsTr("%1 validation errors").arg(n))
            else
                Accessible.announce(qsTr("Validation errors cleared"))
        }
        _lastAnnouncedCount = n
    }

    visible: forceVisible || (errors && errors.length > 0)
    implicitWidth: 320
    implicitHeight: visible ? (contentItem.implicitHeight + topPadding + bottomPadding) : 0
    padding: 12
    leftPadding: 16
    rightPadding: 16
    Accessible.role: Accessible.AlertMessage
    Accessible.name: title
    Accessible.description: (errors && errors.length) ? errors.join("; ") : ""

    background: Rectangle {
        radius: Theme.cornerControl
        color: Theme.systemCriticalBg
        border.width: Theme.highContrast ? 2 : 1
        border.color: Theme.systemCritical

        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 1
            width: 3
            radius: 1.5
            color: Theme.systemCritical
        }
    }

    contentItem: ColumnLayout {
        spacing: 6

        RowLayout {
            spacing: Theme.spacing
            Text {
                text: FluentIcons.Error
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 16
                color: Theme.systemCritical
            }
            Text {
                Layout.fillWidth: true
                text: root.title
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
                wrapMode: Text.WordWrap
            }
        }

        Repeater {
            model: root.errors || []
            Text {
                required property var modelData
                Layout.fillWidth: true
                Layout.leftMargin: 24
                text: "• " + modelData
                font.pixelSize: Theme.fontCaption
                color: Theme.textPrimary
                wrapMode: Text.WordWrap
            }
        }
    }
}
