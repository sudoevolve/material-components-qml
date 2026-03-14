import QtQuick
import QtQuick.Layouts
import md3.Core
import md3.Extras.DataGrid 1.0

Item {
    id: root
    
    signal backClicked()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        RowLayout {
            Layout.fillWidth: true
            spacing: 16
            
            // Back Button
            Item {
                width: 40
                height: 40
                
                Rectangle {
                    anchors.fill: parent
                    radius: 20
                    color: backMouse.containsMouse ? Theme.color.surfaceContainerHigh : "transparent"
                    
                    Text {
                        anchors.centerIn: parent
                        text: "arrow_back"
                        font.family: Theme.iconFont.name
                        font.pixelSize: 24
                        color: Theme.color.onSurfaceColor
                    }
                    
                    MouseArea {
                        id: backMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.backClicked()
                    }
                }
            }
            
            Text {
                text: "DataGrid"
                font.family: Theme.typography.headlineSmall.family
                font.pixelSize: Theme.typography.headlineSmall.size
                font.weight: Theme.typography.headlineSmall.weight
                color: Theme.color.onSurfaceColor
            }
            
            Item { Layout.fillWidth: true }
            
            Text {
                text: "100,000 Rows"
                font.family: Theme.typography.labelLarge.family
                font.pixelSize: Theme.typography.labelLarge.size
                color: Theme.color.primary
            }
        }

        // DataGrid Container
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.color.surface
            border.color: Theme.color.outlineVariant
            border.width: 1
            clip: true
            
            DataGrid {
                anchors.fill: parent
                anchors.margins: 1
                
                model: GridModel {
                    id: demoModel
                }
            }
        }
    }
}
