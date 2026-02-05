import QtQuick
import QtQuick.Layouts
import md3
import "../components" as Md3

ColumnLayout {
    width: parent.width
    height: parent.height
    spacing: 20

    Text {
        text: "Home Page"
        font.pixelSize: 32
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: 60
        color: Theme.color.onBackgroundColor
    }
    
    Md3.Button {
        text: "Click Me"
        Layout.alignment: Qt.AlignHCenter
        onClicked: console.log("Button clicked!")
    }

    Item { Layout.fillHeight: true }
}
