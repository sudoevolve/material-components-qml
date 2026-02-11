import QtQuick
import md3.Core

Window {
    id: shellWindow
    width: 1280
    height: 800
    visible: true
    title: "MD3 qml Components"
    color: Theme.color.background

    Loader {
        anchors.fill: parent
        source: "AppRoot.qml"
    }
}
