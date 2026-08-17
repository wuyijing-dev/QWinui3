import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Feedback surfaces chooser (1.34). docs/feedback.md

CatalogPage {
    id: page
    title: qsTr("Feedback surfaces")
    subtitle: qsTr("InfoBar / Toast / TeachingTip / Progress — docs/feedback.md (1.34).")

    signal openControl(var item)

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    ControlExample {
        headerText: qsTr("When to use which")
        qmlSource: "InfoBar · ToastHost · TeachingTip · ProgressBar\ndocs/feedback.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("InfoBar for in-page durable status (maxVisible via InfoBarHost). ToastHost for transient queued toasts. TeachingTip for coach marks (return focus to target). Progress for determinate work — not a toast substitute. Blocking confirms → ContentDialog.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Repeater {
                model: [
                    { label: qsTr("InfoBar"), page: "InfoBarPage" },
                    { label: qsTr("InfoBarHost"), page: "InfoBarHostPage" },
                    { label: qsTr("Toast / ToastHost"), page: "ToastHostPage" },
                    { label: qsTr("TeachingTip"), page: "TeachingTipPage" },
                    { label: qsTr("InfoBar + TeachingTip recipe"), page: "InfoTeachingRecipePage" },
                    { label: qsTr("ProgressBar"), page: "ProgressBarPage" },
                    { label: qsTr("ContentDialog (modal)"), page: "ContentDialogPage" }
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
