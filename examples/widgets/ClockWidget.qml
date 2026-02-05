import QtQuick
import QtQuick.Layouts
import md3

Item {
    id: root
    implicitWidth: 380
    implicitHeight: 110

    property date currentDate: new Date()

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.currentDate = new Date()
    }

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: Theme.color.surfaceContainerHigh

        RowLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // Time
            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.minimumWidth: 140
                
                Text {
                    anchors.centerIn: parent
                    text: Qt.formatTime(root.currentDate, "hh:mm")
                    font.family: Theme.typography.displayMedium.family
                    font.pixelSize: 52
                    font.weight: Font.Bold
                    color: Theme.color.onSurfaceColor
                }
            }

            // Date Circle
            Rectangle {
                Layout.preferredWidth: 78
                Layout.preferredHeight: 78
                radius: width / 2
                color: Theme.color.primary
                
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: -4
                    
                    Text {
                        text: Qt.formatDate(root.currentDate, "dd")
                        font.family: Theme.typography.titleLarge.family
                        font.pixelSize: 28
                        font.weight: Font.Bold
                        color: Theme.color.onPrimaryColor
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // Day Circle
            Rectangle {
                Layout.preferredWidth: 78
                Layout.preferredHeight: 78
                radius: width / 2
                color: Theme.color.secondaryContainer
                
                Text {
                    anchors.centerIn: parent
                    text: Qt.formatDate(root.currentDate, "ddd").toUpperCase()
                    font.family: Theme.typography.titleMedium.family
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    color: Theme.color.onSecondaryContainerColor
                }
            }
        }
    }
}
