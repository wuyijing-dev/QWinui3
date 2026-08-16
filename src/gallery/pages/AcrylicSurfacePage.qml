import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — AcrylicSurface.
//
// Frosted ElevatedChrome surface with tint, cornerRadius, and Accessible pane. API: docs/components/AcrylicSurface.md

CatalogPage {
    title: qsTr("AcrylicSurface")
    subtitle: qsTr("Frosted ElevatedChrome surface with tint, cornerRadius, and Accessible pane.")

    ControlExample {
        headerText: qsTr("Default / elevated / custom tint")
        qmlSource: "AcrylicSurface {\n    elevated: true\n    cornerRadius: 12\n}"
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            AcrylicSurface {
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                Label {
                    text: qsTr("Acrylic surface")
                    color: Theme.textPrimary
                }
            }
            AcrylicSurface {
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                elevated: true
                cornerRadius: 16
                Label {
                    text: qsTr("Elevated acrylic")
                    color: Theme.textPrimary
                }
            }
            AcrylicSurface {
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                tintColor: Theme.accent
                frostOpacity: Theme.dark ? 0.28 : 0.18
                showLuminantEdge: false
                Label {
                    text: qsTr("Custom tint")
                    color: Theme.textPrimary
                }
            }
        }
    }
}
