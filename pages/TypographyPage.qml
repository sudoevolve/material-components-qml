import QtQuick
import QtQuick.Layouts
import md3

Flickable {
    anchors.fill: parent
    contentWidth: width
    contentHeight: contentColumn.height
    clip: true
    
    ColumnLayout {
        id: contentColumn
        width: parent.width
        spacing: 24
        
        Text {
            text: "Typography"
            font.family: Theme.typography.headlineMedium.family
            font.pixelSize: Theme.typography.headlineMedium.size
            font.weight: Theme.typography.headlineMedium.weight
            color: Theme.color.onSurfaceColor
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 24
        }
        
        ColumnLayout {
            Layout.fillWidth: true
            Layout.margins: 24
            spacing: 32
            
            Repeater {
                model: [
                    { name: "Display Large", style: Theme.typography.displayLarge },
                    { name: "Display Medium", style: Theme.typography.displayMedium },
                    { name: "Display Small", style: Theme.typography.displaySmall },
                    
                    { name: "Headline Large", style: Theme.typography.headlineLarge },
                    { name: "Headline Medium", style: Theme.typography.headlineMedium },
                    { name: "Headline Small", style: Theme.typography.headlineSmall },
                    
                    { name: "Title Large", style: Theme.typography.titleLarge },
                    { name: "Title Medium", style: Theme.typography.titleMedium },
                    { name: "Title Small", style: Theme.typography.titleSmall },
                    
                    { name: "Label Large", style: Theme.typography.labelLarge },
                    { name: "Label Medium", style: Theme.typography.labelMedium },
                    { name: "Label Small", style: Theme.typography.labelSmall },
                    
                    { name: "Body Large", style: Theme.typography.bodyLarge },
                    { name: "Body Medium", style: Theme.typography.bodyMedium },
                    { name: "Body Small", style: Theme.typography.bodySmall }
                ]
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    
                    Text {
                        text: modelData.name + " (" + modelData.style.size + "px)"
                        font.family: Theme.typography.labelSmall.family
                        font.pixelSize: Theme.typography.labelSmall.size
                        font.weight: Theme.typography.labelSmall.weight
                        color: Theme.color.primary
                    }
                    
                    Text {
                        text: "The quick brown fox jumps over the lazy dog."
                        font.family: modelData.style.family
                        font.pixelSize: modelData.style.size
                        font.weight: modelData.style.weight
                        lineHeight: modelData.style.lineHeight
                        lineHeightMode: Text.FixedHeight
                        color: Theme.color.onSurfaceColor
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Theme.color.outlineVariant
                        visible: index < 14
                    }
                }
            }
        }
    }
}
