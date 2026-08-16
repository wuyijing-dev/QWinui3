import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — i18n / RTL baseline (1.13).
//
// Toggle Settings → Right-to-left layout, or the switch below, then watch FormLayout
// left headers, SettingsCard rows, and nav-adjacent chrome mirror. Recipe: docs/i18n-rtl.md.

CatalogPage {
    id: page
    title: qsTr("i18n / RTL")
    subtitle: qsTr("LayoutMirroring baseline for shells, forms, and settings. qsTr + .ts workflow: docs/i18n-rtl.md.")

    ControlExample {
        headerText: qsTr("Session RTL toggle")
        qmlSource: "Qt.application.layoutDirection = Qt.RightToLeft\nLayoutMirroring.enabled: …"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Gallery Main.qml mirrors when layoutDirection is RTL. Same pattern is in examples/nav-settings. LTR remains the default.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            SettingsToggleCard {
                Layout.fillWidth: true
                title: qsTr("Right-to-left layout")
                description: qsTr("Mirrors NavigationView, FormLayout left headers, and settings rows for this session.")
                symbol: FluentIcons.Globe
                checked: Qt.application.layoutDirection === Qt.RightToLeft
                onToggled: {
                    Qt.application.layoutDirection = checked ? Qt.RightToLeft : Qt.LeftToRight
                }
            }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Direction now: %1").arg(
                          Qt.application.layoutDirection === Qt.RightToLeft
                          ? qsTr("Right to left") : qsTr("Left to right"))
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textPrimary
            }
        }
    }

    ControlExample {
        headerText: qsTr("FormLayout left headers")
        qmlSource: "FormLayout {\n    fieldHeaderPlacement: \"left\"\n    HeaderedTextBox { … }\n}"

        FormLayout {
            Layout.fillWidth: true
            fieldHeaderPlacement: "left"
            labelWidth: 110
            HeaderedTextBox {
                header: qsTr("Display name")
                placeholderText: qsTr("Required")
                text: qsTr("Sample")
            }
            HeaderedComboBox {
                header: qsTr("Plan")
                model: [qsTr("Free"), qsTr("Pro"), qsTr("Enterprise")]
                currentIndex: 1
            }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Labels use AlignLeading so they stay on the start edge under LayoutMirroring.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Settings rows")
        qmlSource: "SettingsCard { title; description; toggle: true }"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            SettingsCard {
                Layout.fillWidth: true
                title: qsTr("Notifications")
                description: qsTr("Icon + title + trailing toggle should flip as a row when RTL is on.")
                symbol: FluentIcons.Notification
                toggle: true
                checked: true
            }
            SettingsCard {
                Layout.fillWidth: true
                title: qsTr("Language packs")
                description: qsTr("Full Gallery translation is out of scope for 1.13 — use lupdate on src/gallery (see docs/i18n-rtl.md and translations/README.md).")
                symbol: FluentIcons.Globe
            }
        }
    }

    ControlExample {
        headerText: qsTr("qsTr reminder")
        qmlSource: "title: qsTr(\"Home\")"

        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Gallery and examples already wrap UI strings in qsTr. Extract with lupdate into src/gallery/translations/, translate, lrelease, then QTranslator::load. See docs/i18n-rtl.md for the copy-paste workflow.")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }
}
