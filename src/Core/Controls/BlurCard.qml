// EBlurCard
import QtQuick
import QtQuick.Effects
import md3.Core

Item {
    id: root

    // Public Properties
    property Item blurSource
    property real blurAmount: 1
    property bool dragable: false

    property real blurMax: 64
    property real borderRadius: 24
    property color borderColor: "transparent"
    property real borderWidth: 0

    default property alias content: contentItem.data

    width: 300
    height: 200

    // Drag Functionality
    MouseArea {
        anchors.fill: parent
        drag.target: root
        drag.axis: Drag.XAndYAxis
        enabled: root.dragable
    }

    // Capture Background Content
    ShaderEffectSource {
        id: effectSource
        anchors.fill: parent
        sourceItem: root.blurSource
        sourceRect: root.blurSource
            ? Qt.rect(root.x - root.blurSource.x, root.y - root.blurSource.y, root.width, root.height)
            : Qt.rect(0, 0, 0, 0)
        textureSize: Qt.size(Math.max(1, root.width), Math.max(1, root.height))
        live: true
        recursive: false
        visible: true
        opacity: 0
    }

    // Create Mask
    Item {
        id: maskItem
        anchors.fill: parent
        layer.enabled: true
        layer.smooth: true
        visible: true
        opacity: 0
        Rectangle {
            anchors.fill: parent
            radius: root.borderRadius
            color: "white"  // Must be opaque, otherwise mask won't work
        }
    }
    // Enable Mask
    MultiEffect {
        anchors.fill: effectSource
        source: effectSource
        autoPaddingEnabled: false
        blurEnabled: true
        blurMax: root.blurMax
        blur: root.blurMax > 0 ? Math.max(0, Math.min(1, root.blurAmount / root.blurMax)) : 0
        maskEnabled: true
        maskSource: maskItem
    }

    // Overlay Theme Color, avoid being too bright/transparent
    Rectangle {
        anchors.fill: parent
        radius: root.borderRadius
        color: Theme.color.surface
        z: 1
        opacity: 0.2 // Lower opacity to make blur more visible
        border.color: root.borderColor
        border.width: root.borderWidth
    }

    // Content Container
    Item {
        id: contentItem
        anchors.fill: parent
        clip: true
        z: 2
    }
}
