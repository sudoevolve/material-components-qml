import QtQuick
import QtQuick.Layouts
import md3.Core
import md3.Extras.HotReload

Item {
        id: root
        signal backClicked()

        // Use the injected ProjectSourceDir to construct the absolute path dynamically.
        // This ensures it works on any machine/environment.
        property string targetFile: ProjectSourceDir ? ProjectSourceDir + "/src/App/pages/extras/LivePreview.qml" : ""

        ColumnLayout {
        anchors.fill: parent
        anchors.margins: 0
        spacing: 0

        // AppBar
        Rectangle {
            Layout.fillWidth: true
            height: 64
            color: Theme.color.surface
            
            // Add a bottom divider shadow or line
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: Theme.color.outlineVariant
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 4
                anchors.rightMargin: 16
                spacing: 12

                IconButton {
                    icon: "arrow_back"
                    onClicked: root.backClicked()
                }

                Text {
                    text: "Hot Reload Monitor"
                    font: Theme.typography.titleLarge
                    color: Theme.color.onSurfaceColor
                }
                
                Item { Layout.fillWidth: true }
            }
        }

        // Main Content
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 24
            spacing: 24

            // Info Panel
            Rectangle {
                Layout.fillWidth: true
                height: col.height + 48
                color: Theme.color.surfaceContainerHighest
                radius: 16

                ColumnLayout {
                    id: col
                    anchors.centerIn: parent
                    width: parent.width - 48
                    spacing: 8

                    Text {
                        text: "Watching File"
                        font: Theme.typography.labelLarge
                        color: Theme.color.primary
                    }
                    
                    Text {
                        text: root.targetFile
                        font: Theme.typography.bodyLarge
                        color: Theme.color.onSurfaceColor
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                    }
                    
                    Item { height: 4 }
                    
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        
                        Text {
                            text: "info"
                            font.family: Theme.iconFont.name
                            font.pixelSize: 18
                            color: Theme.color.onSurfaceVariantColor
                        }
                        
                        Text {
                            text: "Edit the file externally to see changes below."
                            font: Theme.typography.bodyMedium
                            color: Theme.color.onSurfaceVariantColor
                            wrapMode: Text.Wrap
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            // Live Preview Area
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Theme.color.surface
                border.width: 1
                border.color: Theme.color.outlineVariant
                clip: true

                HotReloadLoader {
                    anchors.fill: parent
                    anchors.margins: 2
                    sourcePath: root.targetFile
                    autoWatch: true
                }
                
                // Label tag
                Rectangle {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.topMargin: 16
                    anchors.rightMargin: 16
                    width: 80
                    height: 28
                    radius: 8
                    color: Theme.color.secondaryContainer
                    
                    Text {
                        anchors.centerIn: parent
                        text: "PREVIEW"
                        font: Theme.typography.labelSmall
                        color: Theme.color.onSecondaryContainerColor
                    }
                }
            }
        }
    }
}
