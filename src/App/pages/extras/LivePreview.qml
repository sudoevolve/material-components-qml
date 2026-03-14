import QtQuick
import md3.Core

Rectangle {
    anchors.fill: parent

    color: Theme.color.surfaceContainerLow
    
    Column {
        anchors.centerIn: parent
        spacing: 16

        Text {
            text: "rocket_launch"
            font.family: Theme.iconFont.name
            font.pixelSize: 64
            color: Theme.color.primary
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: "Hello Hot Reload!"
            font: Theme.typography.headlineMedium
            color: Theme.color.onSurfaceColor
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        Text {
            text: "Edit this file externally to see changes."
            font: Theme.typography.bodyLarge
            color: Theme.color.onSurfaceVariantColor
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        Button {
            text: "I am a button"
            type: "tonal"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
