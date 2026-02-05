import QtQuick
import QtQuick.Effects
import md3

Item {
    id: root

    property alias model: listView.model
    property Component delegate
    property alias count: listView.count
    property alias currentIndex: listView.currentIndex
    
    // Layout properties
    property real itemWidth: 280
    property real itemHeight: 200
    property real spacing: 8
    
    // "multi-browse", "hero", "uncontained", "centered"
    property string type: "multi-browse"
    property real radius: 24
    
    implicitWidth: parent ? parent.width : 400
    implicitHeight: itemHeight

    Component {
        id: defaultDelegateComponent

        Item {
            id: defaultDelegateRoot
            anchors.fill: parent

            property real scrollProgress: 0
            property var modelData

            Rectangle {
                id: background
                anchors.fill: parent
                radius: root.radius
                color: Theme.color.surfaceContainerHigh
            }

            Item {
                id: imageContainer
                anchors.fill: background
                clip: true

                layer.enabled: true
                layer.effect: MultiEffect {
                    maskEnabled: true
                    maskSource: containerMask
                    autoPaddingEnabled: false
                    antialiasing: true
                    maskThresholdMin: 0.5
                    maskSpreadAtMin: 1.0
                }

                Image {
                    id: sourceImage
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * 1.4
                    height: parent.height * 1.4
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    cache: true
                    opacity: 1

                    property string baseSource: typeof modelData === "string"
                                                ? modelData
                                                : (modelData && modelData.src ? modelData.src : "")

                    property int targetWidth: Math.round(root.itemWidth * 1.4)
                    property int targetHeight: Math.round(root.itemHeight * 1.4)

                    sourceSize.width: targetWidth
                    sourceSize.height: targetHeight

                    source: {
                        if (!baseSource) return ""
                        if (baseSource.toString().indexOf("http") === 0) {
                            if (baseSource.toString().indexOf("bing.com") !== -1) {
                                if (baseSource.indexOf("?") === -1)
                                    return baseSource + "?w=" + targetWidth + "&h=" + targetHeight
                                else
                                    return baseSource + "&w=" + targetWidth + "&h=" + targetHeight
                            }
                        }
                        return baseSource
                    }

                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter

                    x: (parent.width - width) / 2 + scrollProgress * 60
                }


                Item {
                    id: containerMask
                    anchors.fill: parent
                    layer.enabled: true
                    visible: false

                    Rectangle {
                        anchors.fill: parent
                        radius: background.radius
                        color: "black"
                    }
                }

                LoadingIndicator {
                    anchors.centerIn: parent
                    size: 48
                    running: sourceImage.status === Image.Loading
                    visible: sourceImage.status === Image.Loading
                    withContainer: true
                    z: 99
                }
            }
        }
    }

        ListView {
            id: listView
            anchors.fill: parent
            orientation: ListView.Horizontal
            clip: true
            spacing: root.spacing
            cacheBuffer: 5000 //  Increase the cache area to avoid frequent destruction of reconstruction delegates that lead to duplicate requests
        
        delegate: Item {
            id: wrapper
            width: root.itemWidth
            height: root.itemHeight
            
            property real scrollProgress: {
                var centerX = x + width / 2
                var viewCenterX = ListView.view.contentX + ListView.view.width / 2
                return (centerX - viewCenterX) / width
            }
            
            scale: 1.0
            transformOrigin: Item.Center

            Loader {
                anchors.fill: parent
                sourceComponent: root.delegate ? root.delegate : defaultDelegateComponent
                
                onLoaded: {
                    if (item) {
                        if (item.hasOwnProperty("scrollProgress")) {
                            item.scrollProgress = Qt.binding(function() { return wrapper.scrollProgress })
                        }
                        
                        if (item.hasOwnProperty("index")) {
                             item.index = Qt.binding(function() { return index })
                        }
                        
                        if (item.hasOwnProperty("modelData")) {
                             item.modelData = Qt.binding(function() { return modelData })
                        }
                    }
                }
            }
        }

        // Snapping behavior
        snapMode: {
            if (root.type === "uncontained") return ListView.NoSnap
            return ListView.SnapToItem
        }
        
        // Alignment behavior
        highlightRangeMode: {
            if (root.type === "hero" || root.type === "centered") return ListView.StrictlyEnforceRange
            return ListView.NoHighlightRange
        }
        
        preferredHighlightBegin: {
            if (root.type === "centered") return (width - root.itemWidth) / 2
            if (root.type === "hero") return 0
            return 0
        }
        
        preferredHighlightEnd: {
            if (root.type === "centered") return (width + root.itemWidth) / 2
            if (root.type === "hero") return root.itemWidth
            return 0
        }
        
        highlightMoveDuration: 250
        boundsBehavior: Flickable.StopAtBounds
    }
}
