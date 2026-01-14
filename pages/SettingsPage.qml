import QtQuick
import QtQuick.Layouts
import QtQuick.Dialogs
import md3
import "../components" as Md3

Item {
    anchors.fill: parent

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 32
        spacing: 24

        Text {
            text: "Settings"
            font.family: Theme.typography.headlineMedium.family
            font.pixelSize: Theme.typography.headlineMedium.size
            font.weight: Theme.typography.headlineMedium.weight
            color: Theme.color.onSurfaceColor
        }

        // Dark Mode
        RowLayout {
            spacing: 16
            Text {
                text: "Dark Mode"
                color: Theme.color.onSurfaceColor
                font.family: Theme.typography.titleMedium.family
                font.pixelSize: Theme.typography.titleMedium.size
                font.weight: Theme.typography.titleMedium.weight
            }
            
            // Simple Switch implementation
            Md3.Switch {
                checked: StyleManager.isDarkTheme
                icon: "dark_mode"
                onClicked: StyleManager.isDarkTheme = checked
            }
        }

        // Divider
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.color.outlineVariant
        }

        // Dynamic Color from Image
        Text {
            text: "Dynamic Color"
            color: Theme.color.onSurfaceColor
            font.family: Theme.typography.titleMedium.family
            font.pixelSize: Theme.typography.titleMedium.size
            font.weight: Theme.typography.titleMedium.weight
        }
        
        RowLayout {
            spacing: 16
            Md3.Button {
                text: "Pick Image"
                icon: "image"
                type: "filled"
                onClicked: fileDialog.open()
            }
            
            Text {
                text: "Upload an image to extract color scheme"
                color: Theme.color.onSurfaceVariantColor
                font.family: Theme.typography.bodyMedium.family
                font.pixelSize: Theme.typography.bodyMedium.size
            }
        }

        Image {
            id: previewImage
            Layout.preferredWidth: 200
            Layout.preferredHeight: 200
            Layout.maximumWidth: 400
            Layout.maximumHeight: 400
            fillMode: Image.PreserveAspectFit
            visible: source != ""
            
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: Theme.color.outlineVariant
                border.width: 1
                visible: parent.status === Image.Ready
            }
        }
        
        FileDialog {
            id: fileDialog
            title: "Please choose an image"
            nameFilters: ["Image files (*.jpg *.png *.jpeg)"]
            onAccepted: {
                previewImage.source = selectedFile
                StyleManager.setSourceImage(selectedFile)
            }
        }

        // Divider
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.color.outlineVariant
        }

        // Manual Color Input
        Text {
            text: "Or Pick a Primary Color"
            color: Theme.color.onSurfaceColor
            font.family: Theme.typography.titleMedium.family
            font.pixelSize: Theme.typography.titleMedium.size
            font.weight: Theme.typography.titleMedium.weight
        }
        
        GridLayout {
            columns: 8
            rowSpacing: 12
            columnSpacing: 12
            
            Repeater {
                model: ["#6750a4", "#9C27B0", "#E91E63", "#F44336", "#b3261e", "#795548", 
                        "#3F51B5", "#2196F3", "#00BCD4", "#009688", "#4CAF50", "#8BC34A", 
                        "#CDDC39", "#FFEB3B", "#FFC107", "#FF9800"]
                delegate: Rectangle {
                    width: 40
                    height: 40
                    radius: 20
                    color: modelData
                    
                    // Selection indicator
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -4
                        radius: 24
                        color: "transparent"
                        border.width: 2
                        border.color: Theme.color.primary
                        visible: Qt.colorEqual(StyleManager.seedColor, modelData)
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: StyleManager.seedColor = modelData
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }

        Item { Layout.fillHeight: true }
    }
}
