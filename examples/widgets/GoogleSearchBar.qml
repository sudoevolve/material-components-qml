import QtQuick
import QtQuick.Layouts
import md3

Item {
    id: root
    implicitWidth: 320
    implicitHeight: 60

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: Theme.color.surfaceContainerHigh

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 24
            anchors.rightMargin: 24
            spacing: 16

            // Google Icon (Simulated with Text)
            Text {
                text: "G"
                font.family: Theme.typography.titleLarge.family
                font.pixelSize: 26
                font.weight: Font.Bold
                color: Theme.color.primary
            }

            // Spacer
            Item {
                Layout.fillWidth: true
            }

            // Mic Icon
            Text {
                text: "mic"
                font.family: Theme.iconFont.name
                font.pixelSize: 24
                color: Theme.color.onSurfaceVariantColor
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                }
            }

            // Lens/Menu Icon
            Text {
                text: "lens" 
                font.family: Theme.iconFont.name
                font.pixelSize: 24
                color: Theme.color.onSurfaceVariantColor
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }
}
