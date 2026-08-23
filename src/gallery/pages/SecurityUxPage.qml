import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SensitiveField + ConfirmWithReason (2.79).

CatalogPage {
    id: page
    title: qsTr("Security UX")
    subtitle: qsTr("SensitiveField reveal · ConfirmWithReason dialog.")

    property string lastReason: qsTr("(none)")

    ConfirmWithReason {
        id: confirm
        title: qsTr("Confirm destructive action")
        message: qsTr("Type a short reason to continue.")
        onAccepted: function (reason) {
            page.lastReason = reason
        }
    }

    ControlExample {
        headerText: qsTr("SensitiveField")
        qmlSource: "SensitiveField { header: qsTr(\"API token\") }"
        SensitiveField {
            Layout.fillWidth: true
            Layout.maximumWidth: 360
            header: qsTr("API token")
            placeholderText: qsTr("Paste token")
        }
    }

    ControlExample {
        headerText: qsTr("ConfirmWithReason")
        qmlSource: "ConfirmWithReason {\n    onAccepted: function (reason) { … }\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Button {
                text: qsTr("Open confirm dialog")
                onClicked: confirm.show()
            }
            Label {
                text: qsTr("Last reason: %1").arg(page.lastReason)
                color: Theme.textSecondary
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }
    }
}
