import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Extras.Charts

// Gallery — FunnelChart.

CatalogPage {
    title: qsTr("FunnelChart")
    subtitle: qsTr("Experimental conversion funnel. Prefer DonutChart for part-to-whole.")

    ControlExample {
        headerText: qsTr("Signup funnel")
        qmlSource: "FunnelChart {\n    stages: [{ value: 1200, label: \"Visit\" }]\n}"
        FunnelChart {
            Layout.fillWidth: true
            Layout.preferredHeight: 260
            title: qsTr("This week")
            stages: [
                { value: 2400, label: qsTr("Visits") },
                { value: 860, label: qsTr("Sign-up") },
                { value: 310, label: qsTr("Activated") },
                { value: 94, label: qsTr("Paid") }
            ]
        }
    }
}
