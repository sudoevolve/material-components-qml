import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import md3
import "../components" as Md3

Item {
    id: root
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 24
        
        // Avatar
        Item {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 120
            Layout.preferredHeight: 120
            
            Image { 
                id: sourceItem 
                source: "https://avatars.githubusercontent.com/u/46568635?v=4" 
                anchors.centerIn: parent 
                width: parent.width 
                height: parent.height 
                fillMode: Image.PreserveAspectCrop 
                visible: false 
                asynchronous: true
                cache: true
            } 
        
            MultiEffect { 
                id: multiEffect 
                source: sourceItem 
                anchors.fill: sourceItem 
                maskEnabled: true 
                maskSource: mask 
                maskThresholdMin: 0.5 
                maskSpreadAtMin: 1.0 
            } 
        
            Item { 
                id: mask 
                width: sourceItem.width 
                height: sourceItem.height 
                layer.enabled: true 
                visible: false 
                
                Rectangle { 
                    anchors.fill: parent 
                    radius: width / 2 
                    color: "black"
                } 
            } 
        }
        
        // Name & Title
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 8
            
            Text {
                text: "SudoEvolve"
                font.family: Theme.typography.headlineMedium.family
                font.pixelSize: Theme.typography.headlineMedium.size
                color: Theme.color.onSurfaceColor
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: "Qt/QML Developer"
                font.family: Theme.typography.bodyLarge.family
                font.pixelSize: Theme.typography.bodyLarge.size
                color: Theme.color.onSurfaceVariantColor
                Layout.alignment: Qt.AlignHCenter
            }
        }
        
        // Description
        Text {
            text: "Passionate about creating beautiful and functional user interfaces with Qt Quick and Material Design 3."
            font.family: Theme.typography.bodyMedium.family
            font.pixelSize: Theme.typography.bodyMedium.size
            color: Theme.color.onSurfaceVariantColor
            horizontalAlignment: Text.AlignHCenter
            Layout.maximumWidth: 400
            wrapMode: Text.WordWrap
            Layout.alignment: Qt.AlignHCenter
        }
        
        // Links
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 16
            
            Md3.Button {
                text: "GitHub"
                type: "tonal"
                icon: "code"
                onClicked: Qt.openUrlExternally("https://github.com/sudoevolve")
            }
            
            Md3.Button {
                text: "Website"
                type: "outlined"
                icon: "public"
                onClicked: Qt.openUrlExternally("https://sudoevolve.github.io/")
            }
        }

        // License Info
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 4
            Layout.topMargin: 32

            Text {
                text: "License"
                font.family: Theme.typography.titleMedium.family
                font.pixelSize: Theme.typography.titleMedium.size
                color: Theme.color.onSurfaceColor
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "Copyright © 2026 SudoEvolve\nLicensed under GNU LGPLv3\n(GNU Lesser General Public License v3.0)"
                font.family: Theme.typography.bodySmall.family
                font.pixelSize: Theme.typography.bodySmall.size
                color: Theme.color.onSurfaceVariantColor
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "Third-party Components"
                font.family: Theme.typography.titleSmall.family
                font.pixelSize: Theme.typography.titleSmall.size
                color: Theme.color.onSurfaceColor
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 16
            }

            Text {
                text: "material-color-utilities\nCopyright 2022 Google LLC\nLicensed under Apache License 2.0"
                font.family: Theme.typography.bodySmall.family
                font.pixelSize: Theme.typography.bodySmall.size
                color: Theme.color.onSurfaceVariantColor
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
