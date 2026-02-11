import QtQuick
import QtQuick.Layouts
import md3.Core
Item {
    id: root
    implicitWidth: 320
    implicitHeight: 320

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
        radius: 32
        color: Theme.color.surfaceContainerHighest

        // Time "12 36"
        Text {
            id: timeText
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 40
            text: Qt.formatTime(root.currentDate, "hh mm")
            font.family: Theme.typography.displayLarge.family
            font.pixelSize: 84
            font.weight: Font.Bold
            color: Theme.color.onSurfaceColor
        }

        // Day Bubble
        Item {
            id: bubble
            width: dayText.contentWidth + 48
            height: 44
            anchors.left: parent.left
            anchors.leftMargin: 24
            anchors.top: timeText.bottom
            anchors.topMargin: 24

            // Bubble Body
            Rectangle {
                anchors.fill: parent
                radius: 22
                color: Theme.color.primary
            }

            // Tail
            Rectangle {
                width: 16
                height: 16
                color: Theme.color.primary
                rotation: 45
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: 24
                anchors.bottomMargin: -6
            }

            // Day Text
            Text {
                id: dayText
                anchors.centerIn: parent
                text: Qt.formatDate(root.currentDate, "dddd").toUpperCase()
                font.family: Theme.typography.labelLarge.family
                font.pixelSize: 18
                font.weight: Font.Bold
                color: Theme.color.onPrimaryColor
            }
        }

        // Ghost Character
        Item {
            id: ghost
            width: 130
            height: 110
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: 24
            
            // Body (Round Top)
            Rectangle {
                anchors.fill: parent
                color: Theme.color.secondary
                radius: width / 2
                
                // Square Bottom
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: parent.height / 2
                    color: parent.color
                }
            }
            
            // Eyes
            Row {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -8
                anchors.horizontalCenterOffset: -4
                spacing: -4

                // Left Eye
                Rectangle {
                    width: 36
                    height: 36
                    radius: 18
                    color: "#FFFFFF"
                    
                    // Pupil
                    Rectangle {
                        width: 14
                        height: 14
                        radius: 7
                        color: "#000000"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 4
                    }
                }

                // Right Eye
                Rectangle {
                    width: 36
                    height: 36
                    radius: 18
                    color: "#FFFFFF"
                    
                    // Pupil
                    Rectangle {
                        width: 14
                        height: 14
                        radius: 7
                        color: "#000000"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 4
                    }
                }
            }
        }
    }
}

