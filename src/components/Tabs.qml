import QtQuick
import QtQuick.Layouts
import md3

Item {
    id: root
    
    // Properties
    property var model: [] // Array of {icon: "name", text: "label"}
    default property alias content: stackLayout.data
    property int currentIndex: 0
    
    implicitWidth: 400
    implicitHeight: 300
    
    // Tab Bar
    Rectangle {
        id: tabBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 48
        color: Theme.color.surface
        
        RowLayout {
            anchors.fill: parent
            spacing: 0
            
            Repeater {
                id: tabRepeater
                model: root.model
                
                Item {
                    id: tabItem
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    
                    property bool selected: index === root.currentIndex
                    property var itemData: modelData
                    
                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 2
                        
                        // Icon (Optional)
                        Text {
                            visible: !!itemData.icon
                            Layout.alignment: Qt.AlignHCenter
                            text: itemData.icon || ""
                            font.family: Theme.iconFont.name
                            font.pixelSize: 24
                            color: tabItem.selected ? Theme.color.primary : Theme.color.onSurfaceVariantColor
                        }

                        // Label
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: itemData.text || ""
                            font.family: Theme.typography.titleSmall.family
                            font.pixelSize: Theme.typography.titleSmall.size
                            font.weight: Theme.typography.titleSmall.weight
                            color: tabItem.selected ? Theme.color.primary : Theme.color.onSurfaceVariantColor
                        }
                    }
                    
                    Ripple {
                        anchors.fill: parent
                        onClicked: root.currentIndex = index
                    }
                }
            }
        }
        
        // Sliding Indicator
        Rectangle {
            id: indicator
            anchors.bottom: parent.bottom
            height: 3
            radius: 3
            color: Theme.color.primary
            
            // Calculate width and position based on current index
            property var currentTab: tabRepeater.itemAt(root.currentIndex)
            x: currentTab ? currentTab.x : 0
            width: currentTab ? currentTab.width : 0
            
            Behavior on x { NumberAnimation { duration: 250; easing.type: Easing.OutQuad } }
            Behavior on width { NumberAnimation { duration: 250; easing.type: Easing.OutQuad } }
        }
        
        // Bottom border
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: Theme.color.surfaceVariant
            z: -1
        }
    }
    
    // Content Area
    StackLayout {
        id: stackLayout
        anchors.top: tabBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        currentIndex: root.currentIndex
        clip: true
    }
}
