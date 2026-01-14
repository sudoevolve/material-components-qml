import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import md3

Item {
    id: root
    
    // Layout properties for non-modal usage
    anchors.fill: modal ? parent : undefined
    Layout.fillHeight: !modal
    Layout.preferredWidth: !modal ? drawerWidth : 0
    
    z: modal ? 100 : 0 // Above everything if modal
    visible: modal ? _isOpen : true // Hidden by default if modal

    // Public properties
    default property alias content: contentLayout.data
    property string title: "Navigation Drawer"
    property real drawerWidth: 360 // Standard drawer width
    property bool modal: true

    // Internal state
    property bool _isOpen: false

    function open() {
        if (modal) {
            _isOpen = true
            scrim.opacity = 1
            drawerPanel.x = 0
        }
    }

    function close() {
        if (modal) {
            scrim.opacity = 0
            drawerPanel.x = -drawerPanel.width
            closeTimer.start()
        }
    }
    
    Timer {
        id: closeTimer
        interval: 300
        onTriggered: root._isOpen = false
    }

    // Scrim (Only for modal)
    Rectangle {
        id: scrim
        visible: root.modal
        anchors.fill: parent
        color: "#52000000" // Scrim opacity 32%
        opacity: 0
        Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
        
        MouseArea {
            anchors.fill: parent
            onClicked: root.close()
        }
    }

    // Drawer Panel
    Rectangle {
        id: drawerPanel
        width: root.drawerWidth
        height: parent.height
        color: Theme.color.surfaceContainer
        
        // Position logic
        x: root.modal ? -width : 0
        
        Behavior on x { 
            enabled: root.modal
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic } 
        }

        // Shadow (Only for modal)
        layer.enabled: root.modal
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowBlur: 1.0
            shadowColor: "#40000000"
            shadowVerticalOffset: 0
            shadowHorizontalOffset: 2
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0
            
            // Header
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                    text: root.title
                    font.pixelSize: Theme.typography.titleSmall.size
                    font.family: Theme.typography.titleSmall.family
                    font.weight: Font.Bold
                    color: Theme.color.onSurfaceVariantColor
                }
            }
            
            // Content Container
            Item {
                id: contentLayout
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
            }
        }
    }
}
