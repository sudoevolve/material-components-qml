import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import md3.Core
ColumnLayout {
    id: root
    
    property string folderPath: ExternalWidgetsPath
    spacing: 16
    
    Text {
        text: "External Widgets (Hot Reload)"
        font: Theme.typography.titleLarge
        color: Theme.color.onSurfaceColor
        Layout.alignment: Qt.AlignHCenter
    }
    
    Text {
        text: "Path: " + root.folderPath
        font: Theme.typography.bodySmall
        color: Theme.color.onSurfaceVariantColor
        Layout.alignment: Qt.AlignHCenter
        wrapMode: Text.Wrap
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignHCenter
    }

    Text {
        id: debugText
        text: "Waiting for changes..."
        font: Theme.typography.bodySmall
        color: Theme.color.primary
        Layout.alignment: Qt.AlignHCenter
        
        Connections {
            target: HotReloader
            function onFileChanged(path) {
                debugText.text = "Last change: " + path + " at " + new Date().toLocaleTimeString()
            }
        }
    }

    Flow {
        id: widgetFlow
        Layout.fillWidth: true
        spacing: 16
        
        // Logic to center items
        property int itemWidth: 340
        property int flowSpacing: spacing
        property int effectiveWidth: width
        
        // Calculate how many items fit in one row
        property int columns: Math.max(1, Math.floor((effectiveWidth + flowSpacing) / (itemWidth + flowSpacing)))
        
        // Calculate the total width of the content in one row
        property int rowContentWidth: columns * itemWidth + Math.max(0, columns - 1) * flowSpacing
        
        // Calculate padding to center the content
        leftPadding: Math.max(0, (effectiveWidth - rowContentWidth) / 2)

        Repeater {
            model: FolderListModel {
                id: folderModel
                folder: "file:///" + root.folderPath
                nameFilters: ["*.qml"]
                showDirs: false
            }
            
            delegate: DraggableWidgetWrapper {
                width: 340
                height: 340
                widgetSource: "file:///" + filePath
                
                Rectangle {
                    anchors.fill: parent
                    color: Theme.color.surfaceContainerLow
                    radius: 16
                    border.color: Theme.color.outlineVariant
                    border.width: 1
                    clip: true
                    
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 0
                        
                        Rectangle {
                            Layout.fillWidth: true
                            height: 40
                            color: Theme.color.surfaceContainerHighest
                            
                            Text {
                                anchors.centerIn: parent
                                text: fileName
                                font: Theme.typography.labelLarge
                                color: Theme.color.onSurfaceColor
                            }
                        }
                        
                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            
                            onWidthChanged: widgetLoader.updateScale()
                            onHeightChanged: widgetLoader.updateScale()

                            Loader {
                                id: widgetLoader
                                anchors.centerIn: parent
                                source: "file:///" + filePath
                                
                                function updateScale() {
                                    if (!item) return
                                    
                                    var pW = parent.width
                                    var pH = parent.height
                                    
                                    // Wait for valid geometry
                                    if (pW <= 0 || pH <= 0) return
                                    
                                    if (item.implicitWidth > 0 && item.implicitHeight > 0) {
                                        var availW = Math.max(1, pW - 40)
                                        var availH = Math.max(1, pH - 40)
                                        
                                        var scaleX = availW / item.implicitWidth
                                        var scaleY = availH / item.implicitHeight
                                        
                                        // Scale to fit, allowing both upscaling and downscaling
                                        item.scale = Math.min(scaleX, scaleY)
                                    } else {
                                        item.scale = 1.0
                                    }
                                }
                                
                                onLoaded: updateScale()
                            }
                        }
                    }
                }
                
                Connections {
                                target: HotReloader
                                function onFileChanged(path) {
                                    var changed = path.replace(/\\/g, "/")
                                    var current = filePath.toString().replace("file:///", "").replace(/\\/g, "/")
                                    
                                    // Normalize drive letters to lowercase for comparison
                                    if (changed.length > 1 && changed[1] === ':') {
                                        changed = changed[0].toLowerCase() + changed.substring(1)
                                    }
                                    if (current.length > 1 && current[1] === ':') {
                                        current = current[0].toLowerCase() + current.substring(1)
                                    }

                                    if (changed.toLowerCase() === current.toLowerCase()) {
                                        console.log("Reloading widget:", fileName)
                                        // Flash effect to show we caught the signal
                                        reloadIndicator.opacity = 1.0
                                        reloadTimer.restart()
                                    }
                                }
                            }
                            
                            Rectangle {
                                id: reloadIndicator
                                anchors.fill: parent
                                color: Theme.color.primary
                                opacity: 0
                                visible: opacity > 0
                                Behavior on opacity { NumberAnimation { duration: 200 } }
                                onOpacityChanged: {
                                    if (opacity === 1.0) opacity = 0.0
                                }
                                z: 99
                            }
                            
                            Timer {
                                id: reloadTimer
                                interval: 100
                                onTriggered: {
                                    // Step 1: Unload
                                    widgetLoader.active = false
                                    widgetLoader.source = ""
                                    // Step 2: Schedule reload
                                    restoreTimer.restart()
                                }
                            }
                            
                            Timer {
                                id: restoreTimer
                                interval: 50
                                onTriggered: {
                                    // Step 3: Reload
                                    // Add a timestamp query param to force reload and bypass any internal caching
                                    widgetLoader.source = "file:///" + filePath + "?t=" + Date.now()
                                    widgetLoader.active = true
                                }
                            }
                
                Component.onCompleted: {
                     var path = filePath.toString().replace("file:///", "")
                     HotReloader.watch(path)
                }
            }
        }
    }
}

