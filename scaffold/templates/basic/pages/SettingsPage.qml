import QtQuick
import QtQuick.Layouts
import md3
import "../components" as Md3

ColumnLayout {
    width: parent.width
    height: parent.height
    spacing: 20

    Text {
        text: "Settings Page"
        font.pixelSize: 32
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: 60
        color: Theme.color.onBackgroundColor
    }
    
    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: 16
        
        Text {
            text: "Dark Mode"
            color: Theme.color.onSurfaceColor
            font.family: Theme.typography.bodyLarge.family
            font.pixelSize: Theme.typography.bodyLarge.size
        }

        Md3.Switch {
            checked: StyleManager.isDarkTheme
            onCheckedChanged: StyleManager.isDarkTheme = checked
        }
    }

    Item { Layout.fillHeight: true }
}
