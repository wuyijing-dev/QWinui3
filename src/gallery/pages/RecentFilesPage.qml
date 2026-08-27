import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — RecentFiles + file association opt-in.

CatalogPage {
    id: page
    title: qsTr("RecentFiles")
    subtitle: qsTr("Settings-backed recent paths + WindowHelper.addToRecentDocuments.")

    RecentFiles {
        id: recent
        category: "GalleryRecentFilesDemo"
        maxCount: 8
        onChanged: listLabel.text = recent.list().join("\n") || qsTr("(empty)")
    }

    Component.onCompleted: listLabel.text = recent.list().join("\n") || qsTr("(empty)")

    ControlExample {
        headerText: qsTr("Add / clear")
        qmlSource: "RecentFiles { id: recent }\nrecent.add(path)\nrecent.clear()"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            RowLayout {
                Layout.fillWidth: true
                TextField {
                    id: pathField
                    Layout.fillWidth: true
                    placeholderText: qsTr("C:/docs/report.docx")
                    text: qsTr("C:/Users/Public/Documents/demo.txt")
                }
                Button {
                    text: qsTr("Add")
                    onClicked: recent.add(pathField.text)
                }
                Button {
                    text: qsTr("Clear")
                    onClicked: recent.clear()
                }
            }
            Label {
                id: listLabel
                Layout.fillWidth: true
                wrapMode: Text.WrapAnywhere
                color: Theme.textPrimary
                font.pixelSize: Theme.fontCaption
            }
        }
    }

    ControlExample {
        headerText: qsTr("File association (opt-in)")
        qmlSource: "WindowHelper.registerFileAssociation(\".qwinuidemo\", \"QWinUI3.GalleryDemo\", …)"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                color: Theme.textSecondary
                text: qsTr("HKCU / ~/.local only — see docs/file-association.md. Unregister when done testing.")
            }
            RowLayout {
                Button {
                    text: qsTr("Register .qwinuidemo")
                    onClicked: {
                        var ok = WindowHelper.registerFileAssociation(
                                    ".qwinuidemo",
                                    "QWinUI3.GalleryDemo",
                                    qsTr("QWinUI3 Gallery demo"),
                                    "")
                        assocHint.text = ok ? qsTr("Registered (user scope).")
                                            : qsTr("Registration failed on this platform.")
                    }
                }
                Button {
                    text: qsTr("Unregister")
                    onClicked: {
                        var ok = WindowHelper.unregisterFileAssociation(".qwinuidemo", "QWinUI3.GalleryDemo")
                        assocHint.text = ok ? qsTr("Unregistered.")
                                            : qsTr("Unregister failed or nothing to remove.")
                    }
                }
            }
            Label {
                id: assocHint
                Layout.fillWidth: true
                color: Theme.textSecondary
                wrapMode: Text.Wrap
            }
        }
    }
}
