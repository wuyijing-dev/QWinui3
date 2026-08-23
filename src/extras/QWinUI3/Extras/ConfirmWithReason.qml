import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QWinUI3.Theme
import QWinUI3.Extras

// ConfirmWithReason — ContentDialog with a required reason field (2.79).
//
//   ConfirmWithReason {
//       id: confirm
//       title: qsTr("Delete project")
//       message: qsTr("Explain why this is needed.")
//       onConfirmed: function (reason) { … }
//   }
//   confirm.show()
//
// @notes
//   Primary stays disabled until reason is non-empty (unless requireReason is false).
//   Use confirmed(reason) — do not shadow Dialog's parameterless accepted().

ContentDialog {
    id: root

    property string message: qsTr("Please provide a short reason.")
    property string reasonPlaceholder: qsTr("Reason")
    property string reason: ""
    property bool requireReason: true
    property int minimumReasonLength: 1

    /// Reason text when the user confirms (keeps Dialog.accepted parameterless).
    signal confirmed(string reason)

    primaryButtonText: qsTr("Confirm")
    closeButtonText: qsTr("Cancel")
    isPrimaryButtonEnabled: !requireReason
                             || reason.trim().length >= minimumReasonLength

    onPrimaryClicked: {
        var r = reason.trim()
        if (requireReason && r.length < minimumReasonLength)
            return
        confirmed(r)
    }

    onOpened: {
        reason = ""
        reasonField.forceActiveFocus()
    }

    Column {
        width: parent ? parent.width : 360
        spacing: Theme.spacing

        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            text: root.message
            color: Theme.textSecondary
        }

        TextField {
            id: reasonField
            width: parent.width
            placeholderText: root.reasonPlaceholder
            text: root.reason
            onTextChanged: root.reason = text
            Accessible.name: root.reasonPlaceholder
        }
    }
}
