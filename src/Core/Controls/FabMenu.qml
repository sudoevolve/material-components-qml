import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import md3.Core

Item {
    id: root
    
    // Public API
    property var model: [] // Array of objects: { text: string, icon: string, color: color }
    property bool expanded: false
    property color fabColor: Theme.color.primaryContainer
    property color fabContentColor: Theme.color.onPrimaryContainerColor
    
    signal itemClicked(int index, var itemData)

    implicitWidth: mainFab.width
    implicitHeight: mainLayout.implicitHeight

    // Main layout: Stacks items above FAB
    ColumnLayout {
        id: mainLayout
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        spacing: 16
        
        // Menu Items Container
        ColumnLayout {
            Layout.alignment: Qt.AlignRight
            spacing: 8
            
            Repeater {
                model: root.model
                
                Rectangle {
                    id: itemRect
                    
                    property var itemData: modelData
                    property bool isHovered: itemMouse.containsMouse
                    
                    Layout.alignment: Qt.AlignRight
                    implicitHeight: 48
                    implicitWidth: contentRow.implicitWidth + 32
                    radius: height / 2
                    color: itemData.color || Theme.color.secondaryContainer
                    
                    // Shadow effect
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: Theme.color.shadow
                        shadowBlur: 8
                        shadowVerticalOffset: 2
                        shadowOpacity: 0.2
                    }

                    // Visibility & Animation
                    visible: root.expanded
                    opacity: root.expanded ? 1 : 0
                    transform: Translate {
                        y: root.expanded ? 0 : 20
                        Behavior on y { NumberAnimation { duration: 250; easing.type: Easing.OutBack } }
                    }
                    Behavior on opacity { NumberAnimation { duration: 200 } }

                    RowLayout {
                        id: contentRow
                        anchors.centerIn: parent
                        spacing: 12
                        
                        Text {
                            text: itemData.icon
                            font.family: Theme.iconFont.name
                            font.pixelSize: 24
                            color: itemData.textColor || Theme.color.onSecondaryContainer
                            Layout.alignment: Qt.AlignVCenter
                        }
                        
                        Text {
                            text: itemData.text
                            font.family: Theme.typography.labelLarge.family
                            font.pixelSize: Theme.typography.labelLarge.size
                            font.weight: Theme.typography.labelLarge.weight
                            color: itemData.textColor || Theme.color.onSecondaryContainer
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }
                    
                    MouseArea {
                        id: itemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.itemClicked(index, itemData)
                            root.expanded = false
                        }
                    }
                    
                    // Hover effect
                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        color: Theme.color.onSurfaceColor
                        opacity: itemRect.isHovered ? 0.08 : 0
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                    }
                }
            }
        }

        // Main FAB (Toggle)
        Rectangle {
            id: mainFab
            Layout.alignment: Qt.AlignRight
            width: 56
            height: 56
            radius: 28
            color: root.expanded ? Theme.color.tertiaryContainer : root.fabColor
            
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: Theme.color.shadow
                shadowBlur: 8
                shadowVerticalOffset: 4
                shadowOpacity: 0.2
            }

            // Icon
            Text {
                id: fabIcon
                anchors.centerIn: parent
                text: "add" // Base icon, rotates to X
                font.family: Theme.iconFont.name
                font.pixelSize: 24
                color: root.expanded ? Theme.color.onTertiaryContainerColor : root.fabContentColor
                
                rotation: root.expanded ? 45 + 90 : 0 
                
                Behavior on rotation { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
                Behavior on color { ColorAnimation { duration: 200 } }
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.expanded = !root.expanded
            }
        }
    }
}
