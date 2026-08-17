import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — i18n / RTL (1.13) + locale packs (1.45).
//
// Toggle Settings → Right-to-left layout, or the switch below, then watch FormLayout
// left headers, SettingsCard rows, and nav-adjacent chrome mirror.
// Recipe: docs/i18n-rtl.md · --lang zh_CN after lrelease.

CatalogPage {
    id: page
    title: qsTr("i18n / RTL")
    subtitle: qsTr("qsTr + zh_CN seed + RTL — docs/i18n-rtl.md (1.45).")

    ControlExample {
        headerText: qsTr("Locale packs (1.45)")
        qmlSource: "lupdate / lrelease\nqwinui3_gallery --lang zh_CN"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Seed catalogs live in src/gallery/translations/ (en + zh_CN). Validate with python scripts/check_gallery_translations.py. After lrelease, run Gallery with --lang zh_CN to load qwinui3_gallery_zh_CN.qm. RTL is separate (toggle below). Full recipe: docs/i18n-rtl.md.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAnywhere
                    text: "python scripts/check_gallery_translations.py"
                    font.pixelSize: Theme.fontCaption
                }
                CopyButton {
                    textToCopy: "python scripts/check_gallery_translations.py"
                }
            }
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAnywhere
                    text: "qwinui3_gallery.exe --lang zh_CN"
                    font.pixelSize: Theme.fontCaption
                }
                CopyButton {
                    textToCopy: "qwinui3_gallery.exe --lang zh_CN"
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("RTL regression checklist (1.45)")
        qmlSource: "Settings → Right-to-left layout"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("After adding strings or shell chrome, enable RTL and smoke:")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            CheckBox { text: qsTr("Gallery Home featured cards / nav rail") }
            CheckBox { text: qsTr("This page FormLayout left headers + SettingsCard rows") }
            CheckBox { text: qsTr("ContentDialog / CommandPalette overlay centering") }
            CheckBox { text: qsTr("ListDetailsView / TwoPaneView (master on start edge)") }
            CheckBox { text: qsTr("examples/nav-settings Settings RTL toggle") }
        }
    }

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
                description: qsTr("Seed packs: en + zh_CN (1.45). lupdate / --lang / check_gallery_translations.py — docs/i18n-rtl.md.")
                symbol: FluentIcons.Globe
            }
        }
    }

    ControlExample {
        headerText: qsTr("qsTr reminder")
        qmlSource: "title: qsTr(\"Home\")"

        Text {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            text: qsTr("Gallery and examples already wrap UI strings in qsTr. Extract with lupdate into src/gallery/translations/, translate, lrelease, then QTranslator::load or Gallery --lang. See docs/i18n-rtl.md.")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }
}
