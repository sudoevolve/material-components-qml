import QtQuick
import QtQuick.Layouts
import md3.Core
Item {
    id: root
    width: parent.width
    height: parent.height

    property bool isRail: true

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Navigation Rail (Handles both Rail and Drawer states)
        NavigationRail {
            id: navRail
            Layout.fillHeight: true
            
            // Toggle between Rail (80dp) and Extended (240dp)
            extended: !isRail
            
            // Model
            model: [
                {icon: "widgets", text: "Components"},
                {icon: "inbox", text: "Inbox"},
                {icon: "send", text: "Outbox"},
                {icon: "favorite", text: "Favorites"}
            ]
            
            currentIndex: contentStack.currentIndex
            onItemClicked: (index) => contentStack.currentIndex = index
            
            // Header Component (Menu + FAB)
            header: Component {
                ColumnLayout {
                    width: parent.width
                    spacing: 0
                    
                    // Menu Button
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 64
                        
                        IconButton {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            // Center in Rail mode, Left align in Extended mode
                            anchors.leftMargin: isRail ? (parent.width - width) / 2 : 12
                            
                            icon: "menu"
                            onClicked: isRail = !isRail
                            
                            Behavior on anchors.leftMargin { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                        }
                    }
                    
                    // FAB (Pencil)
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                        
                        FAB {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: isRail ? (parent.width - width) / 2 : 16
                            
                            icon: "edit"
                            type: isRail ? "standard" : "extended"
                            text: isRail ? "" : "Compose"
                            
                            Behavior on anchors.leftMargin { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
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
                                
                                TopAppBar {
                                    Layout.fillWidth: true
                                    title: "Page Title"
                                    showNavigationIcon: true
                                    
                                    actions: RowLayout {
                                        spacing: 0
                                        IconButton { icon: "attach_file" }
                                        IconButton { icon: "calendar_today" }
                                        IconButton { icon: "more_vert" }
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
                            
                            NavigationBar {
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

                    // Tabs Demo (Primary - Icon + Text)
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        
                        Text {
                            text: "Primary Tabs"
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
                            
                            Tabs {
                                anchors.fill: parent
                                type: "primary"
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

                    // Tabs Demo (Primary - Text Only)
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        
                        Text {
                            text: "Primary Tabs (Text Only)"
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
                            
                            Tabs {
                                anchors.fill: parent
                                type: "primary"
                                model: [
                                    {text: "Overview", icon: ""},
                                    {text: "Specs", icon: ""},
                                    {text: "Reviews", icon: ""}
                                ]
                                
                                // Content Views
                                Rectangle { color: "#F0F0FF"; Text { anchors.centerIn: parent; text: "Overview Content" } }
                                Rectangle { color: "#FFF0F0"; Text { anchors.centerIn: parent; text: "Specs Content" } }
                                Rectangle { color: "#F0FFF0"; Text { anchors.centerIn: parent; text: "Reviews Content" } }
                            }
                        }
                    }

                    // Tabs Demo (Secondary)
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        
                        Text {
                            text: "Secondary Tabs"
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
                            
                            Tabs {
                                anchors.fill: parent
                                type: "secondary"
                                model: [
                                    {text: "Explore", icon: ""},
                                    {text: "Flights", icon: ""},
                                    {text: "Trips", icon: ""}
                                ]
                                
                                // Content Views
                                Rectangle { color: "#F0F0FF"; Text { anchors.centerIn: parent; text: "Explore Content" } }
                                Rectangle { color: "#FFF0F0"; Text { anchors.centerIn: parent; text: "Flights Content" } }
                                Rectangle { color: "#F0FFF0"; Text { anchors.centerIn: parent; text: "Trips Content" } }
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
                        
                        Breadcrumb {
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
                        
                        Button {
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
    SideSheet {
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
                
                Ripple {
                    anchors.fill: parent
                    onClicked: console.log("Clicked item", index)
                }
            }
        }
    }
}


