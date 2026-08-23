import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// ErrorBoundary — Recovery UI for failed page / session loads (2.75).
//
//   ErrorBoundary {
//       id: boundary
//       title: qsTr("Something went wrong")
//       message: qsTr("Reload this view or restore the last session.")
//       sessionRestore: session // optional SessionRestore
//       onRetryRequested: loader.active = false; loader.active = true
//   }
//
// @notes
//   Shows an InfoBar-style recovery surface. Does not catch native crashes;
//   pair with QQmlEngine warnings / Loader status in app code.

Item {
    id: root

    property string title: qsTr("Something went wrong")
    property string message: qsTr("This view failed to load. You can retry or restore the last session.")
    property bool isOpen: true
    property var sessionRestore: null
    property bool showSessionRestore: sessionRestore !== null

    signal retryRequested()
    signal sessionRestoreRequested()

    implicitWidth: 360
    implicitHeight: column.implicitHeight
    visible: isOpen
    Accessible.role: Accessible.AlertMessage
    Accessible.name: title
    Accessible.description: message

    function open() { isOpen = true }
    function close() { isOpen = false }
    function retry() { retryRequested() }
    function restoreSession() {
        sessionRestoreRequested()
        if (sessionRestore && typeof sessionRestore.restore === "function")
            sessionRestore.restore()
    }

    ColumnLayout {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: Theme.spacing

        InfoBar {
            Layout.fillWidth: true
            severity: 3 // InfoBar error
            title: root.title
            message: root.message
            isOpen: true
            closable: false
            actionText: qsTr("Retry")
            onActionClicked: root.retry()
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            visible: root.showSessionRestore
            Button {
                text: qsTr("Restore session")
                onClicked: root.restoreSession()
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
                text: qsTr("Uses SessionRestore when wired (2.70).")
            }
        }
    }
}
