import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Forms & settings chooser (1.08 / 1.28). docs/forms.md · docs/pickers.md

CatalogPage {
    id: page
    title: qsTr("Forms & settings")
    subtitle: qsTr("FormLayout validation + industry LoB templates — docs/forms.md (2.25).")

    signal openControl(var item)

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    ControlExample {
        headerText: qsTr("When to use which")
        qmlSource: "FormLayout · SettingsCard · SettingsExpander\ndocs/forms.md · docs/pickers.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("FormLayout for labeled fields with errorMessage / clear / collect. SettingsCard / SettingsExpander for preference rows. Pair Date/Time/Number pickers with description + hasError in forms (1.28).")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Repeater {
                model: [
                    { label: qsTr("Registration template (2.25)"), page: "FormRegistrationTemplatePage" },
                    { label: qsTr("Admin CRUD template (2.25)"), page: "FormAdminCrudTemplatePage" },
                    { label: qsTr("Preferences template (2.25)"), page: "SettingsPreferencesTemplatePage" },
                    { label: qsTr("Form validation"), page: "FormValidationPage" },
                    { label: qsTr("SettingsCard"), page: "SettingsCardPage" },
                    { label: qsTr("SettingsExpander"), page: "SettingsExpanderPage" },
                    { label: qsTr("SettingsGroup"), page: "SettingsGroupPage" },
                    { label: qsTr("HeaderedTextBox"), page: "HeaderedTextBoxPage" },
                    { label: qsTr("NumberBox"), page: "NumberBoxPage" },
                    { label: qsTr("DatePicker"), page: "DatePickerPage" },
                    { label: qsTr("TimePicker"), page: "TimePickerPage" }
                ]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    Label {
                        Layout.fillWidth: true
                        text: modelData.label
                        color: Theme.textPrimary
                    }
                    Button {
                        text: qsTr("Open")
                        onClicked: page.openComp(modelData.page)
                    }
                }
            }
        }
    }
}
