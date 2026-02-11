import QtQuick
import QtQuick.Layouts
import md3.Core
Item {
    id: root
    implicitWidth: 320
    implicitHeight: 320

    property date currentDate: new Date()

    Timer {
        interval: 100
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.currentDate = new Date()
    }

    // Main Clock Background (Circle)
    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: Theme.color.surfaceContainerHighest
    }

    // Hands Container - Centered
    Item {
        anchors.centerIn: parent
        width: parent.width
        height: parent.height

        // Hour Hand (Thick, Dark Blue)
        Item {
            id: hourHandContainer
            anchors.fill: parent
            rotation: (root.currentDate.getHours() * 30) + (root.currentDate.getMinutes() * 0.5)
            
            Rectangle {
                width: 36
                height: parent.height * 0.35 // Length of hour hand
                radius: width / 2
                color: Theme.color.primary
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                anchors.bottomMargin: -width/2 // Overlap center slightly for rounded effect
            }
        }

        // Minute Hand (Thinner, Pink)
        Item {
            id: minuteHandContainer
            anchors.fill: parent
            rotation: (root.currentDate.getMinutes() * 6) + (root.currentDate.getSeconds() * 0.1)

            Rectangle {
                width: 18
                height: parent.height * 0.45 // Length of minute hand
                radius: width / 2
                color: Theme.color.tertiary
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                anchors.bottomMargin: -width/2
            }
        }

        // Second Hand (Dot)
        Item {
            id: secondHandContainer
            anchors.fill: parent
            rotation: root.currentDate.getSeconds() * 6

            // Dot at the tip
            Rectangle {
                width: 16
                height: 16
                radius: 8
                color: Theme.color.primary
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                anchors.bottomMargin: parent.height * 0.4 // Push out to the rim
            }
        }
        
        // Center Cap (Optional, to hide joints)
        // Image shows no center cap, but hands seem to merge. 
        // With current setup, they pivot at center.
    }
}

