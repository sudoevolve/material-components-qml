import QtQuick
import md3.Core

Window {
    id: shellWindow
    width: 1280
    height: 800
    visible: true
    title: "MD3 qml Components"
    color: Theme.color.background
    property var appFeatures: (typeof AppFeatures !== "undefined" && AppFeatures) ? AppFeatures : ({})
    property bool canHotReload: !!appFeatures.hotReload && HotReloadEnabled && ProjectSourceDir

    Loader {
        anchors.fill: parent
        sourceComponent: shellWindow.canHotReload ? devRoot : prodRoot
    }

    Component {
        id: prodRoot
        Loader {
            anchors.fill: parent
            source: "AppRoot.qml"
        }
    }

    Component {
        id: devRoot
        Loader {
            anchors.fill: parent
            source: "qrc:/qt/qml/md3/Extras/HotReload/HotReloadLoader.qml"
            onLoaded: {
                if (!item) return
                item.sourcePath = ProjectSourceDir + "/src/App/AppRoot.qml"
                item.reloadOnAnyChange = true
            }
        }
    }
}
