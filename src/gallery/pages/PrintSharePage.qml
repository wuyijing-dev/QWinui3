import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — Print / share / export recipes.
// Recipe: docs/print-share.md · docs/system-integration.md · docs/drag-drop.md

CatalogPage {
    id: page
    title: qsTr("Print / share / export")
    subtitle: qsTr("grabToImage → FilePicker.saveFile → reveal — docs/print-share.md.")

    property string statusText: qsTr("Export the sample card as PNG, then reveal in the file manager.")
    property string lastPath: ""

    function doExport() {
        FilePicker.saveFile(
            qsTr("Export PNG"),
            ["PNG (*.png)", "All (*.*)"],
            function (path) {
                if (!path || !path.length) {
                    page.statusText = qsTr("Save cancelled")
                    return
                }
                sampleCard.grabToImage(function (result) {
                    if (!result || !result.saveToFile(path)) {
                        page.statusText = qsTr("grabToImage / save failed: %1").arg(path)
                        return
                    }
                    page.lastPath = path
                    var revealed = WindowHelper.revealFileInFolder(path, page.Window.window)
                    page.statusText = revealed
                            ? qsTr("Saved + revealed:\n%1").arg(path)
                            : qsTr("Saved (reveal failed):\n%1").arg(path)
                })
            },
            "png",
            Window.window)
    }

    ControlExample {
        headerText: qsTr("When to use")
        qmlSource: "grabToImage → FilePicker.saveFile → revealFileInFolder\n// docs/print-share.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("LoB “send this view somewhere” without a QWinUI3 print engine. PNG export is the portable path. System print / PDF via Qt PrintSupport stays in your app CMake — not a kit dependency. Win/Linux FilePicker + reveal notes: docs/print-share.md · docs/platform-linux-wayland.md.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Sample card → PNG → reveal")
        qmlSource: "sample.grabToImage(function (r) { r.saveToFile(path) })\nWindowHelper.revealFileInFolder(path)"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            Rectangle {
                id: sampleCard
                Layout.fillWidth: true
                Layout.preferredHeight: 160
                radius: Theme.controlCornerRadius
                color: Theme.bgCard
                border.width: 1
                border.color: Theme.strokeCard

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.spacingSection
                    spacing: Theme.spacingLoose

                    Rectangle {
                        width: 56
                        height: 56
                        radius: width / 2
                        color: Theme.accent
                        Layout.alignment: Qt.AlignVCenter
                        Text {
                            anchors.centerIn: parent
                            text: FluentIcons.Share
                            font: Theme.iconFontFor(28)
                            color: Theme.textOnAccent
                        }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        spacing: 4
                        Label {
                            Layout.fillWidth: true
                            text: qsTr("Export preview")
                            font.pixelSize: Theme.fontTitle
                            font.weight: Theme.fontWeightSemiBold
                            color: Theme.textPrimary
                            wrapMode: Text.WordWrap
                        }
                        Label {
                            Layout.fillWidth: true
                            text: qsTr("Theme tokens · accent glyph · card chrome — grabbed as one bitmap.")
                            color: Theme.textSecondary
                            wrapMode: Text.WordWrap
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Button {
                    text: qsTr("Export PNG…")
                    highlighted: true
                    onClicked: page.doExport()
                }
                CopyButton {
                    enabled: page.lastPath.length > 0
                    textToCopy: page.lastPath
                    text: qsTr("Copy path")
                }
                Button {
                    text: qsTr("Reveal again")
                    enabled: page.lastPath.length > 0
                    onClicked: {
                        if (!WindowHelper.revealFileInFolder(page.lastPath, page.Window.window))
                            page.statusText = qsTr("Reveal failed:\n%1").arg(page.lastPath)
                    }
                }
                Item { Layout.fillWidth: true }
            }

            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: page.statusText
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
            }
        }
    }

    ControlExample {
        headerText: qsTr("Print / PDF (app-side)")
        qmlSource: "find_package(Qt6 COMPONENTS PrintSupport)\nQPrinter · QPainter — docs/print-share.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("QWinUI3 does not ship PrintSupport. Add it in your app if you need the system print dialog or QPrinter::PdfFormat. Grab a PNG first (above), then print the image — or paint with QPainter. Caveats: docs/print-share.md.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }
}
