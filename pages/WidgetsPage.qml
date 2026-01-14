import QtQuick
import QtQuick.Layouts
import md3

Item {
    id: root
    anchors.fill: parent

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 16

        Text {
            text: "Widgets"
            font.family: Theme.typography.displayMedium.family
            font.pixelSize: Theme.typography.displayMedium.size
            font.weight: Theme.typography.displayMedium.weight
            color: Theme.color.onSurfaceColor
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "Coming Soon"
            font.family: Theme.typography.headlineMedium.family
            font.pixelSize: Theme.typography.headlineMedium.size
            font.weight: Theme.typography.headlineMedium.weight
            color: Theme.color.onSurfaceVariantColor
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
