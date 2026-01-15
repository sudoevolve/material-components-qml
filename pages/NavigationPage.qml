import QtQuick
import QtQuick.Layouts
import md3
import "../components" as Md3

Item {
    id: root
    anchors.fill: parent

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Left Navigation Drawer (Standard/Permanent)
        Md3.NavigationDrawer {
            id: navDrawer
            modal: false // Standard mode (side-by-side)
            drawerWidth: 240
            Layout.fillHeight: true
            
            ColumnLayout {
                width: parent.width
                spacing: 0
                
                // Drawer Items
                Repeater {
                    model: [
                        {icon: "widgets", text: "Components"},
                        {icon: "inbox", text: "Inbox"},
                        {icon: "send", text: "Outbox"},
                        {icon: "favorite", text: "Favorites"}
                    ]
                    
                    delegate: Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 56
                        color: contentStack.currentIndex === index ? Theme.color.secondaryContainer : "transparent"
                        radius: 28
                        
                        // Interaction
                        Md3.Ripple {
                            anchors.fill: parent
                            clipRadius: 28
                            onClicked: {
                                contentStack.currentIndex = index
                            }
                        }
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 24
                            anchors.rightMargin: 24
                            spacing: 12
                            
                            Text {
                                text: modelData.icon
                                font.family: Theme.iconFont.name
                                font.pixelSize: 24
                                color: contentStack.currentIndex === index ? Theme.color.onSecondaryContainerColor : Theme.color.onSurfaceVariantColor
                            }
                            
                            Text {
                                Layout.fillWidth: true
                                text: modelData.text
                                font.family: Theme.typography.labelLarge.family
                                font.pixelSize: Theme.typography.labelLarge.size
                                color: contentStack.currentIndex === index ? Theme.color.onSecondaryContainerColor : Theme.color.onSurfaceVariantColor
                            }
                        }
                    }
                }
            }
        }

        // Right Content Area
        StackLayout {
            id: contentStack
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: 0
            
            // Page 0: Components Gallery (The previous content)
            Flickable {
                contentWidth: width
                contentHeight: galleryContent.implicitHeight + 64
                clip: true
                
                ColumnLayout {
                    id: galleryContent
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 32
                    spacing: 48

                    Text {
                        text: "Navigation Components"
                        font.pixelSize: Theme.typography.headlineMedium.size
                        color: Theme.color.onSurfaceColor
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Text {
                        text: "Try clicking the drawer items on the left!"
                        font.pixelSize: Theme.typography.bodyLarge.size
                        color: Theme.color.primary
                        Layout.alignment: Qt.AlignHCenter
                    }

                    // Top App Bar Demo
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        
                        Text {
                            text: "Top App Bar"
                            font.pixelSize: Theme.typography.titleMedium.size
                            color: Theme.color.primary
                        }
                        
                        Rectangle {
                            Layout.fillWidth: true
                            height: 200
                            color: Theme.color.surfaceContainerLowest
                            border.color: Theme.color.outlineVariant
                            border.width: 1
                            radius: 12
                            clip: true
                            
                            ColumnLayout {
                                anchors.fill: parent
                                spacing: 0
                                
                                Md3.TopAppBar {
                                    Layout.fillWidth: true
                                    title: "Page Title"
                                    showNavigationIcon: true
                                    
                                    actions: RowLayout {
                                        spacing: 0
                                        Md3.IconButton { icon: "attach_file" }
                                        Md3.IconButton { icon: "calendar_today" }
                                        Md3.IconButton { icon: "more_vert" }
                                    }
                                }
                                
                                Item { Layout.fillHeight: true }
                            }
                        }
                    }

                    // Navigation Bar (Bottom Nav) Demo
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        
                        Text {
                            text: "Navigation Bar"
                            font.pixelSize: Theme.typography.titleMedium.size
                            color: Theme.color.primary
                        }
                        
                        Rectangle {
                            Layout.fillWidth: true
                            height: 300
                            color: Theme.color.surfaceContainerLowest
                            border.color: Theme.color.outlineVariant
                            border.width: 1
                            radius: 12
                            clip: true
                            
                            Md3.NavigationBar {
                                anchors.fill: parent
                                model: [
                                    {icon: "mail", text: "Mail"},
                                    {icon: "chat", text: "Chat"},
                                    {icon: "groups", text: "Rooms"}
                                ]
                                
                                // Content Views
                                Rectangle { color: "#FFF0F0"; Text { anchors.centerIn: parent; text: "Mail View" } }
                                Rectangle { color: "#F0FFF0"; Text { anchors.centerIn: parent; text: "Chat View" } }
                                Rectangle { color: "#F0F0FF"; Text { anchors.centerIn: parent; text: "Rooms View" } }
                            }
                        }
                    }

                    // Tabs Demo
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        
                        Text {
                            text: "Tabs"
                            font.pixelSize: Theme.typography.titleMedium.size
                            color: Theme.color.primary
                        }
                        
                        Rectangle {
                            Layout.fillWidth: true
                            height: 200
                            color: Theme.color.surfaceContainerLowest
                            border.color: Theme.color.outlineVariant
                            border.width: 1
                            radius: 12
                            clip: true
                            
                            Md3.Tabs {
                                anchors.fill: parent
                                model: [
                                    {text: "Video", icon: "videocam"},
                                    {text: "Photos", icon: "photo"},
                                    {text: "Audio", icon: "audiotrack"}
                                ]
                                
                                // Content Views
                                Rectangle { color: "#FFE0E0"; Text { anchors.centerIn: parent; text: "Video Content" } }
                                Rectangle { color: "#E0FFE0"; Text { anchors.centerIn: parent; text: "Photo Content" } }
                                Rectangle { color: "#E0E0FF"; Text { anchors.centerIn: parent; text: "Audio Content" } }
                            }
                        }
                    }
                    
                    // Breadcrumbs Demo
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        
                        Text {
                            text: "Breadcrumbs"
                            font.pixelSize: Theme.typography.titleMedium.size
                            color: Theme.color.primary
                        }
                        
                        Md3.Breadcrumb {
                            model: ["Home", "Components", "Navigation"]
                        }
                    }

                    // Side Sheet Demo
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        
                        Text {
                            text: "Side Sheet (Right Drawer)"
                            font.pixelSize: Theme.typography.titleMedium.size
                            color: Theme.color.primary
                        }
                        
                        Md3.Button {
                            text: "Open Right Drawer"
                            type: "filled"
                            onClicked: rightDrawer.open()
                        }
                    }
                    
                    Item { Layout.preferredHeight: 64 }
                }
            }
            
            // Page 1: Inbox
            Rectangle {
                color: Theme.color.surface
                ColumnLayout {
                    anchors.centerIn: parent
                    Text {
                        text: "Inbox"
                        font.pixelSize: Theme.typography.displayLarge.size
                        color: Theme.color.onSurfaceColor
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        text: "This is the Inbox page content"
                        font.pixelSize: Theme.typography.bodyLarge.size
                        color: Theme.color.onSurfaceVariantColor
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
            
            // Page 2: Outbox
            Rectangle {
                color: Theme.color.surface
                ColumnLayout {
                    anchors.centerIn: parent
                    Text {
                        text: "Outbox"
                        font.pixelSize: Theme.typography.displayLarge.size
                        color: Theme.color.onSurfaceColor
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        text: "This is the Outbox page content"
                        font.pixelSize: Theme.typography.bodyLarge.size
                        color: Theme.color.onSurfaceVariantColor
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
            
            // Page 3: Favorites
            Rectangle {
                color: Theme.color.surface
                ColumnLayout {
                    anchors.centerIn: parent
                    Text {
                        text: "Favorites"
                        font.pixelSize: Theme.typography.displayLarge.size
                        color: Theme.color.onSurfaceColor
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        text: "This is the Favorites page content"
                        font.pixelSize: Theme.typography.bodyLarge.size
                        color: Theme.color.onSurfaceVariantColor
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }

    }

    // Right Drawer (Side Sheet)
    Md3.SideSheet {
        id: rightDrawer
        title: "Right Drawer"

        ListView {
            anchors.fill: parent
            clip: true
            model: 20
            delegate: Item {
                width: parent.width
                height: 56
                
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                    text: "Menu Item " + (index + 1)
                    font.pixelSize: Theme.typography.bodyLarge.size
                    color: Theme.color.onSurfaceColor
                }
                
                Md3.Ripple {
                    anchors.fill: parent
                    onClicked: console.log("Clicked item", index)
                }
            }
        }
    }
}
