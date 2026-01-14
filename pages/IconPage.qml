import QtQuick
import QtQuick.Layouts
import md3
import "../components" as Md3
import "../assets/IconData.js" as IconData

Item {
    anchors.fill: parent

    // Pagination Logic
    property int itemsPerPage: 60
    property int currentPage: 0
    property int totalItems: IconData.icons.length
    property int totalPages: Math.ceil(totalItems / itemsPerPage)
    
    // Slice of data for current page
    property var currentItems: {
        let start = currentPage * itemsPerPage
        let end = Math.min(start + itemsPerPage, totalItems)
        return IconData.icons.slice(start, end)
    }

    TextEdit {
        id: clipboardHelper
        visible: false
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header
        Text {
            text: "All Material Icons (" + totalItems + ")"
            font.family: Theme.typography.headlineMedium.family
            font.pixelSize: Theme.typography.headlineMedium.size
            font.weight: Theme.typography.headlineMedium.weight
            color: Theme.color.onSurfaceColor
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 24
            Layout.bottomMargin: 16
        }
        
        // Grid Content
        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: width
            contentHeight: flowContent.height
            clip: true

            Flow {
                id: flowContent
                width: parent.width
                padding: 24
                spacing: 16
                
                Repeater {
                    model: currentItems
                    
                    Rectangle {
                        width: 120
                        height: 100
                        radius: Theme.shape.cornerMedium
                        color: Theme.color.surfaceContainerHighest
                        
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 8
                            
                            Text {
                                text: modelData
                                font.family: Theme.iconFont.name
                                font.pixelSize: 32
                                color: Theme.color.onSurfaceVariantColor
                                Layout.alignment: Qt.AlignHCenter
                            }
                            
                            Text {
                                text: modelData
                                font.family: Theme.typography.bodySmall.family
                                font.pixelSize: Theme.typography.bodySmall.size
                                color: Theme.color.onSurfaceVariantColor
                                elide: Text.ElideRight
                                Layout.maximumWidth: 100
                                horizontalAlignment: Text.AlignHCenter
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.color = Theme.color.secondaryContainer
                            onExited: parent.color = Theme.color.surfaceContainerHighest
                            onClicked: {
                                clipboardHelper.text = modelData
                                clipboardHelper.selectAll()
                                clipboardHelper.copy()
                                copyToast.text = "Copied: " + modelData
                                copyToast.open()
                            }
                        }
                    }
                }
            }
        }

        // Pagination Controls
        Rectangle {
            Layout.fillWidth: true
            height: 64
            color: Theme.color.surfaceContainer
            
            RowLayout {
                anchors.centerIn: parent
                spacing: 24
                
                Md3.Button {
                    text: "Previous"
                    type: "text"
                    enabled: currentPage > 0
                    icon: "chevron_left"
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: if (currentPage > 0) currentPage--
                    }
                }
                
                Text {
                    text: "Page " + (currentPage + 1) + " of " + totalPages
                    font.family: Theme.typography.labelLarge.family
                    font.pixelSize: Theme.typography.labelLarge.size
                    color: Theme.color.onSurfaceVariantColor
                }
                
                Md3.Button {
                    text: "Next"
                    type: "text"
                    enabled: currentPage < totalPages - 1
                    icon: "chevron_right"
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: if (currentPage < totalPages - 1) currentPage++
                    }
                }
            }
        }
    }
    
    // Global ToolTip Overlay
    Md3.ToolTip {
        id: copyToast
    }
}
