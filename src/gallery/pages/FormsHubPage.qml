import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Forms & settings (full inline demos). docs/forms.md

CatalogPage {
    id: page
    title: qsTr("Forms & settings")
    subtitle: qsTr("FormLayout validation + LoB templates — docs/forms.md.")

    ControlExample {
        headerText: qsTr("When to use which")
        qmlSource: "FormLayout · SettingsCard · SettingsExpander\ndocs/forms.md"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("FormLayout for labeled fields with errorMessage / clear / collect. SettingsCard / SettingsExpander for preference rows. Pair Date/Time/Number pickers with description + hasError in forms.")
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }

    GalleryHubSection {
        title: qsTr("Registration template")
        description: qsTr("Sign-up form with validation and submit flow.")
        FormRegistrationTemplatePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("Admin CRUD template")
        description: qsTr("Create / edit / delete form patterns.")
        FormAdminCrudTemplatePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("Settings preferences template")
        description: qsTr("Preferences form with grouped fields.")
        SettingsPreferencesTemplatePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("Form validation")
        description: qsTr("Error states, collect, and inline validation.")
        FormValidationPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("HeaderedTextBox")
        description: qsTr("Labeled text field with header and description.")
        HeaderedTextBoxPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("HeaderedComboBox")
        description: qsTr("Labeled combo with header row.")
        HeaderedComboBoxPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("NumberBox")
        description: qsTr("Numeric input with spin buttons.")
        NumberBoxPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("DatePicker")
        description: qsTr("Calendar date selection control.")
        DatePickerPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("TimePicker")
        description: qsTr("Time-of-day selection control.")
        TimePickerPage { hubEmbed: true; width: parent.width }
    }
}
