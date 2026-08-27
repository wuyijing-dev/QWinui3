import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Wizard.
//
// Multi-step host with StepBar, validation gates, Back/Next/Finish.

CatalogPage {
    id: page

    title: qsTr("Wizard")
    subtitle: qsTr("Step host + per-step validation — docs/components/Wizard.md.")

    property string nameDraft: ""
    property string emailDraft: ""

    ControlExample {
        headerText: qsTr("Account → Profile → Finish")
        qmlSource: "Wizard {\n    model: [{ title: \"Account\" }, { title: \"Profile\" }]\n    stepValidators: […]\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                text: qsTr("Next stays disabled until the current stepValidator returns true.")
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
            }
            Wizard {
                id: wizard
                Layout.fillWidth: true
                Layout.preferredHeight: 280
                model: [
                    { title: qsTr("Account"), content: accountStep },
                    { title: qsTr("Profile"), content: profileStep },
                    { title: qsTr("Done"), content: doneStep }
                ]
                stepValidators: [
                    function () { return page.emailDraft.indexOf("@") > 0 },
                    function () { return page.nameDraft.trim().length >= 2 },
                    null
                ]
                onFinished: status.text = qsTr("Finished — %1 <%2>").arg(page.nameDraft).arg(page.emailDraft)
                onCancelled: status.text = qsTr("Cancelled")
                onStepChanged: function (i) {
                    status.text = qsTr("Step %1").arg(i + 1)
                }
            }
            Label {
                id: status
                text: qsTr("Ready")
                color: Theme.textSecondary
            }
        }
    }

    Component {
        id: accountStep
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Theme.spacing
            Label { text: qsTr("Email"); color: Theme.textSecondary }
            TextField {
                Layout.fillWidth: true
                placeholderText: qsTr("you@example.com")
                text: page.emailDraft
                onTextChanged: page.emailDraft = text
            }
        }
    }
    Component {
        id: profileStep
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Theme.spacing
            Label { text: qsTr("Display name"); color: Theme.textSecondary }
            TextField {
                Layout.fillWidth: true
                placeholderText: qsTr("Ada Lovelace")
                text: page.nameDraft
                onTextChanged: page.nameDraft = text
            }
        }
    }
    Component {
        id: doneStep
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                text: qsTr("Review and press Finish.")
                color: Theme.textPrimary
            }
            Label {
                text: qsTr("%1 · %2").arg(page.nameDraft).arg(page.emailDraft)
                color: Theme.textSecondary
            }
        }
    }
}
