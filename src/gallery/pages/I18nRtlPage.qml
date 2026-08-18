import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — i18n / RTL (1.13) + full locale switch (runtime GalleryLanguage).

CatalogPage {
    id: page
    title: qsTr("i18n / RTL")
    subtitle: qsTr("Live language switch + full Gallery catalogs — docs/i18n-rtl.md (2.35: de_DE seed).")

    ControlExample {
        headerText: qsTr("Localization wave 4 (2.35)")
        qmlSource: "GalleryLanguage.applyLocale(\"de_DE\")"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Fourth seed locale: Deutsch (de_DE). Control pages from 2.21…2.34 must keep qsTr titles — python scripts/check_localization_wave4.py.")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }

    ControlExample {
        headerText: qsTr("Display language (live)")
        qmlSource: "GalleryLanguage.applyLocale(\"zh_CN\")\n// QQmlEngine.retranslate()"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Pick a locale below — the whole Gallery retranslates without restart. Settings → Display language uses the same API. ~3600 strings extracted via lupdate; translate .ts in Linguist, rebuild Release for .qm. CLI: --lang zh_CN still works at startup.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Text {
                    text: qsTr("Language")
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontBody
                    color: Theme.textPrimary
                }
                ComboBox {
                    id: langPick
                    Layout.fillWidth: true
                    model: GalleryLanguage.localeLabels
                    currentIndex: GalleryLanguage.indexOfLocale(GalleryLanguage.currentLocale)
                    onActivated: function (index) {
                        GalleryLanguage.applyLocale(GalleryLanguage.availableLocales[index])
                    }
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontCaption
                color: Theme.textPrimary
                text: GalleryLanguage.translatorActive
                      ? qsTr("Active: %1").arg(GalleryLanguage.labelForLocale(GalleryLanguage.currentLocale))
                      : qsTr("Active: English (default)")
            }
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAnywhere
                    font.pixelSize: Theme.fontCaption
                    text: "python scripts/check_gallery_translations.py"
                }
                CopyButton {
                    textToCopy: "python scripts/check_gallery_translations.py"
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
                description: qsTr("Full Gallery lupdate (~3600 strings). Settings or this page switch locale live.")
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
            text: qsTr("Gallery wraps UI strings in qsTr. lupdate src/gallery into translations/*.ts, translate in Linguist, Release build embeds .qm via qt_add_translations. See docs/i18n-rtl.md.")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }
}
