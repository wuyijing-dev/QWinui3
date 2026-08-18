import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Tool / Round / Delay + button variants (full inline demos).

CatalogPage {
    id: page
    title: qsTr("Misc Buttons")
    subtitle: qsTr("ToolButton, RoundButton, DelayButton and other button variants.")

    ControlExample {
        headerText: qsTr("ToolButton and RoundButton")
        qmlSource: "ToolButton { text: \"Tool\" }\nRoundButton { text: \"+\" }"

        Flow {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            ToolButton { text: qsTr("Tool") }
            RoundButton { text: "+" }
            RoundButton { text: "A"; highlighted: true }
        }
    }

    ControlExample {
        headerText: qsTr("DelayButton")
        qmlSource: "DelayButton {\n    text: \"Hold to confirm\"\n    delay: 1200\n}"

        DelayButton {
            text: qsTr("Hold to confirm")
            delay: 1200
            onActivated: text = qsTr("Activated")
        }
    }

    GalleryHubSection {
        title: qsTr("AccentButton")
        description: qsTr("Accent-colored primary button variant.")
        AccentButtonPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("IconButton")
        description: qsTr("Icon-only command button.")
        IconButtonPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("IconicButton")
        description: qsTr("Icon + label button variant.")
        IconicButtonPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("HyperlinkButton")
        description: qsTr("Link-styled inline button.")
        HyperlinkButtonPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("ToggleSplitButton")
        description: qsTr("Split button with toggle primary action.")
        ToggleSplitButtonPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("CopyButton")
        description: qsTr("Copy-to-clipboard action button.")
        CopyButtonPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("ProgressButton")
        description: qsTr("Button with inline progress state.")
        ProgressButtonPage { hubEmbed: true; width: parent.width }
    }
}
