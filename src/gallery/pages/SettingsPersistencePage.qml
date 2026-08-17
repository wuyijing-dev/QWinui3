import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtCore
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Settings persistence & roaming recipes (1.65).
// Recipe: docs/settings-persistence.md · docs/forms.md · docs/window-helper.md

CatalogPage {
    id: page
    title: qsTr("Settings persistence")
    subtitle: qsTr("QSettings / Settings · schemaVersion · portable Ini — docs/settings-persistence.md (1.65).")

    signal openControl(var item)

    Settings {
        id: prefs
        category: "SettingsPersistenceDemo"
        property int schemaVersion: 1
        property bool shareDiagnostics: true
        property bool demoFlag: false
    }

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    ControlExample {
        headerText: qsTr("When to use (1.65)")
        qmlSource: "Settings { category: \"Prefs\" }\ngeometryPersistenceKey: \"MyAppMain\"\n// docs/settings-persistence.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Keep window geometry on geometryPersistenceKey (kit schema). Put theme, toggles, and coach flags in QtCore Settings or your QSettings. Portable = Ini beside the exe. “Roaming” = copy Ini / export JSON — not a cloud product. Example: examples/form-settings.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Live Settings prefs")
        qmlSource: "Settings {\n    category: \"SettingsPersistenceDemo\"\n    property bool shareDiagnostics\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            SettingsGroup {
                Layout.fillWidth: true
                title: qsTr("Demo preferences")
                description: qsTr("Survives Gallery restart (same org/app).")
                symbol: FluentIcons.Save

                SettingsCard {
                    title: qsTr("Share diagnostics")
                    description: qsTr("Bound to Settings.shareDiagnostics")
                    toggle: true
                    checked: prefs.shareDiagnostics
                    onToggled: prefs.shareDiagnostics = checked
                }

                SettingsCard {
                    title: qsTr("Demo flag")
                    description: qsTr("schemaVersion=%1").arg(prefs.schemaVersion)
                    toggle: true
                    checked: prefs.demoFlag
                    onToggled: prefs.demoFlag = checked
                }
            }

            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
                text: qsTr("Geometry still uses shells’ geometryPersistenceKey → WindowGeometry/<key>. Do not store frame rects here.")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Related")
        qmlSource: "forms · window-helper · onboarding coach · form-settings"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Repeater {
                model: [
                    { label: qsTr("Forms & settings cards"), page: "FormsHubPage" },
                    { label: qsTr("SettingsCard"), page: "SettingsCardPage" },
                    { label: qsTr("Onboarding coach (don’t show again)"), page: "OnboardingCoachPage" },
                    { label: qsTr("Window shells / geometry"), page: "WindowParadigmPage" }
                ]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    Label {
                        Layout.fillWidth: true
                        text: modelData.label
                        color: Theme.textPrimary
                        wrapMode: Text.WordWrap
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
