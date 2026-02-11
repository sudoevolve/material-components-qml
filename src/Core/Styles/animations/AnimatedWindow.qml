// EAnimatedWindow.qml
import QtQuick
import md3.Core
import md3.Core.Controls

Item {
    id: animationWrapper
    z: 999
    visible: false
    state: "iconState"
    width: parent.width
    height: parent.height
    focus: visible && state === "fullscreenState"

    // ===== Configurable Properties =====
    property int animDuration: 500
    property real segment1Progress: 0.8
    property real segment1DurationFactor: 0.3
    property real segment2DurationFactor: 0.7
    property real maxTiltAngle: 35
    property color textColor: Theme.color.onSurfaceColor
    property color fullscreenColor: Theme.color.surface
    // Click mask to close window (default false)
    property bool dismissOnOverlay: false

    default property alias contentData: contentArea.data  // Allows adding children externally

    // Initial button color
    property color buttonColor: Theme.color.secondaryContainer

    // ===== Internal State Properties =====
    property bool isAnimating: false
    property var startState: ({
        x: 0,
        y: 0,
        width: 100,
        height: 100,
        radius: 55,
        color: Qt.transparent,
        rotationX: 0,
        rotationY: 0,
        sourceItem: null
    })

    // ===== Public Interface Functions =====
    function open(source, txt = "") {
        if (isAnimating || state === "fullscreenState") return;

        isAnimating = true;
        startState.sourceItem = source;

        // 1. Get source control center mapped to animationWrapper
        var map = startState.sourceItem.mapToItem(
            animationWrapper,
            startState.sourceItem.width / 2,
            startState.sourceItem.height / 2
        );

        // 2. Set top-left based on center alignment
        startState.x = map.x - startState.sourceItem.width / 2;
        startState.y = map.y - startState.sourceItem.height / 2;

        // 3. Record size, radius, color
        startState.width = startState.sourceItem.width;
        startState.height = startState.sourceItem.height;
        startState.radius = startState.sourceItem.radius !== undefined ? startState.sourceItem.radius : 30;

        // Color transparency check
        function isVisibleColor(c) {
            if (!c) return false;
            if (c === "transparent" || c === Qt.transparent) return false;
            if (c.a !== undefined && c.a <= 0.01) return false;
            return true;
        }
        function findNonTransparentColor(item) {
            if (!item || !item.visible || item.opacity <= 0.01) return null;

            if (item.containerColor && isVisibleColor(item.containerColor)) {
                return item.containerColor;
            }

            if (item.color && isVisibleColor(item.color)) {
                return item.color;
            }

            if (item.textColor && isVisibleColor(item.textColor)) {
                return item.textColor;
            }

            for (var i = 0; i < item.children.length; ++i) {
                var child = item.children[i];
                var foundColor = findNonTransparentColor(child);
                if (foundColor) {
                    return foundColor;
                }
            }

            return null;
        }

        startState.color = findNonTransparentColor(startState.sourceItem);
        if (!isVisibleColor(startState.color)) {
            startState.color = Theme.color.secondaryContainer;
        }

        // 4. Calculate initial 3D tilt
        var sourceCenterX = startState.x + startState.width / 2;
        var sourceCenterY = startState.y + startState.height / 2;
        var windowCenterX = width / 2;
        var windowCenterY = height / 2;
        var deltaX_norm = (sourceCenterX - windowCenterX) / windowCenterX;
        var deltaY_norm = (sourceCenterY - windowCenterY) / windowCenterY;
        startState.rotationX = -deltaY_norm * maxTiltAngle;
        startState.rotationY = deltaX_norm * maxTiltAngle;

        // Manually emit signal
        startStateChanged();

        // 5. Set appContainer initial state
        appContainer.x = startState.x;
        appContainer.y = startState.y;
        appContainer.width = startState.width;
        appContainer.height = startState.height;
        appContainer.radius = startState.radius;
        appContainer.color = startState.color;
        rotationX.angle = startState.rotationX;
        rotationY.angle = startState.rotationY;
        if (startState.sourceItem) startState.sourceItem.opacity = 0;

        // 6. Start animation
        visible = true;
        state = "fullscreenState";
    }

    function updateStartStatePosition() {
        if (startState.sourceItem) {
            var map = startState.sourceItem.mapToItem(
                animationWrapper,
                startState.sourceItem.width / 2,
                startState.sourceItem.height / 2
            );
            startState.x = map.x - startState.sourceItem.width / 2;
            startState.y = map.y - startState.sourceItem.height / 2;

            startState.width = startState.sourceItem.width;
            startState.height = startState.sourceItem.height;

            var sourceCenterX = startState.x + startState.width / 2;
            var sourceCenterY = startState.y + startState.height / 2;
            var windowCenterX = width / 2;
            var windowCenterY = height / 2;
            var deltaX_norm = (sourceCenterX - windowCenterX) / windowCenterX;
            var deltaY_norm = (sourceCenterY - windowCenterY) / windowCenterY;
            startState.rotationX = -deltaY_norm * maxTiltAngle;
            startState.rotationY = deltaX_norm * maxTiltAngle;

            startStateChanged();
        }
    }

    // Respond to window size changes
    onWidthChanged: {
        if (state === "fullscreenState" && !isAnimating) {
            appContainer.width = width
            updateStartStatePosition()
        }
    }
    onHeightChanged: {
        if (state === "fullscreenState" && !isAnimating) {
            appContainer.height = height
            updateStartStatePosition()
        }
    }

    Connections {
        target: Theme
        function onColorChanged() {
            if (startState.sourceItem) updateStartStatePosition()
        }
    }

    // ===== UI Elements =====
    Rectangle {
        id: appContainer
        clip: true
        transform: [
            Rotation { id: rotationY; axis { x: 0; y: 1; z: 0 } origin.x: appContainer.width / 2; origin.y: appContainer.height / 2 },
            Rotation { id: rotationX; axis { x: 1; y: 0; z: 0 } origin.x: appContainer.width / 2; origin.y: appContainer.height / 2 }
        ]

        // Click blocker (enabled only in fullscreen)
        MouseArea {
            id: modalBlocker
            anchors.fill: parent
            z: 0
            enabled: animationWrapper.visible && animationWrapper.state === "fullscreenState"
            hoverEnabled: true
            acceptedButtons: Qt.AllButtons
            preventStealing: true
            propagateComposedEvents: false
            onClicked: {
                // Intercept click and optionally dismiss
                if (animationWrapper.dismissOnOverlay) {
                    if (animationWrapper.isAnimating) return;
                    animationWrapper.isAnimating = true;
                    animationWrapper.state = "iconState";
                }
            }
            onPressed: function(mouse) { mouse.accepted = true }
            onReleased: function(mouse) { mouse.accepted = true }
            onDoubleClicked: function(mouse) { mouse.accepted = true }
            onWheel: function(wheel) { wheel.accepted = true }
        }

        Item {
            id: windowContent
            anchors.fill: parent
            clip: true
            opacity: 0
            layer.enabled: true
            z: 1

            Item {
                id: contentArea
                anchors.fill: parent
                // External content is added here automatically
            }
        }
    }

    // ==== States ====
    states: [
        State {
            name: "iconState"
            PropertyChanges { target: appContainer; x: startState.x; y: startState.y; width: startState.width; height: startState.height }
            PropertyChanges { target: appContainer; radius: startState.radius; color: startState.color }
            PropertyChanges { target: rotationX; angle: startState.rotationX }
            PropertyChanges { target: rotationY; angle: startState.rotationY }
            PropertyChanges { target: windowContent; opacity: 0 }
        },
        State {
            name: "fullscreenState"
            PropertyChanges { target: appContainer; x: 0; y: 0; width: animationWrapper.width; height: animationWrapper.height }
            PropertyChanges { target: appContainer; radius: 0; color: fullscreenColor }
            PropertyChanges { target: rotationX; angle: 0 }
            PropertyChanges { target: rotationY; angle: 0 }
            PropertyChanges { target: windowContent; opacity: 1 }
        }
    ]

    // ==== 动画过渡 (Transitions) ====
    transitions: [
        Transition {
            from: "iconState"; to: "fullscreenState"
            onRunningChanged: if (!running) animationWrapper.isAnimating = false

            ParallelAnimation {
                SequentialAnimation {
                    ParallelAnimation {
                        PropertyAnimation { target: rotationX; property:"angle"; to: startState.rotationX * (1 - segment1Progress); duration: animDuration * segment1DurationFactor; easing.type: Easing.InQuad }
                        PropertyAnimation { target: rotationY; property:"angle"; to: startState.rotationY * (1 - segment1Progress); duration: animDuration * segment1DurationFactor; easing.type: Easing.InQuad }
                        PropertyAnimation { target: appContainer; property:"radius"; to: startState.radius; duration: animDuration * segment1DurationFactor; easing.type: Easing.InQuad }
                        PropertyAnimation { target: appContainer; property:"width"; to: startState.width + (animationWrapper.width - startState.width) * segment1Progress; duration: animDuration * segment1DurationFactor; easing.type: Easing.InQuad }
                        PropertyAnimation { target: appContainer; property:"height"; to: startState.height + (animationWrapper.height - startState.height) * segment1Progress; duration: animDuration * segment1DurationFactor; easing.type: Easing.InQuad }
                        PropertyAnimation { target: appContainer; property:"x"; to: startState.x * (1 - segment1Progress); duration: animDuration * segment1DurationFactor; easing.type: Easing.InQuad }
                        PropertyAnimation { target: appContainer; property:"y"; to: startState.y * (1 - segment1Progress); duration: animDuration * segment1DurationFactor; easing.type: Easing.InQuad }
                        ColorAnimation { target: appContainer; property:"color"; to: fullscreenColor; duration: animDuration * segment1DurationFactor }
                    }
                    ParallelAnimation {
                        PropertyAnimation { target: rotationX; property:"angle"; to: 0; duration: animDuration * segment2DurationFactor; easing.type: Easing.OutQuad }
                        PropertyAnimation { target: rotationY; property:"angle"; to: 0; duration: animDuration * segment2DurationFactor; easing.type: Easing.OutQuad }
                        PropertyAnimation { target: appContainer; property:"radius"; to: 0; duration: animDuration * segment2DurationFactor; easing.type: Easing.OutQuad }
                        PropertyAnimation { target: appContainer; property:"width"; to: animationWrapper.width; duration: animDuration * segment2DurationFactor; easing.type: Easing.OutQuad }
                        PropertyAnimation { target: appContainer; property:"height"; to: animationWrapper.height; duration: animDuration * segment2DurationFactor; easing.type: Easing.OutQuad }
                        PropertyAnimation { target: appContainer; property:"x"; to: 0; duration: animDuration * segment2DurationFactor; easing.type: Easing.OutQuad }
                        PropertyAnimation { target: appContainer; property:"y"; to: 0; duration: animDuration * segment2DurationFactor; easing.type: Easing.OutQuad }
                    }
                }
                NumberAnimation { target: windowContent; property:"opacity"; to: 1; duration: animDuration * 0.24; easing.type: Easing.OutQuart }
            }
        },

        Transition {
            from: "fullscreenState"; to: "iconState"
            onRunningChanged: {
                if (!running) {
                    animationWrapper.isAnimating = false;
                    animationWrapper.visible = false;
                    if (startState.sourceItem) {
                        startState.sourceItem.opacity = 1;
                        startState.sourceItem = null;
                    }
                }
            }

            ParallelAnimation {
                SequentialAnimation {
                    ParallelAnimation {
                        PropertyAnimation { target: rotationX; property:"angle"; to: startState.rotationX * segment1Progress; duration: animDuration * segment1DurationFactor; easing.type: Easing.InQuad }
                        PropertyAnimation { target: rotationY; property:"angle"; to: startState.rotationY * segment1Progress; duration: animDuration * segment1DurationFactor; easing.type: Easing.InQuad }
                        PropertyAnimation { target: appContainer; property:"radius"; to: startState.radius * segment1Progress; duration: animDuration * segment1DurationFactor; easing.type: Easing.InQuad }
                        PropertyAnimation { target: appContainer; property:"width"; to: startState.width + (animationWrapper.width - startState.width) * (1 - segment1Progress); duration: animDuration * segment1DurationFactor; easing.type: Easing.InQuad }
                        PropertyAnimation { target: appContainer; property:"height"; to: startState.height + (animationWrapper.height - startState.height) * (1 - segment1Progress); duration: animDuration * segment1DurationFactor; easing.type: Easing.InQuad }
                        PropertyAnimation { target: appContainer; property:"x"; to: startState.x * segment1Progress; duration: animDuration * segment1DurationFactor; easing.type: Easing.InQuad }
                        PropertyAnimation { target: appContainer; property:"y"; to: startState.y * segment1Progress; duration: animDuration * segment1DurationFactor; easing.type: Easing.InQuad }
                    }
                    ParallelAnimation {
                        PropertyAnimation { target: rotationX; property:"angle"; to: 0; duration: animDuration * segment2DurationFactor; easing.type: Easing.OutQuad }
                        PropertyAnimation { target: rotationY; property:"angle"; to: 0; duration: animDuration * segment2DurationFactor; easing.type: Easing.OutQuad }
                        PropertyAnimation { target: appContainer; property:"radius"; to: startState.radius; duration: animDuration * segment2DurationFactor; easing.type: Easing.OutQuad }
                        PropertyAnimation { target: appContainer; property:"width"; to: startState.width; duration: animDuration * segment2DurationFactor; easing.type: Easing.OutQuad }
                        PropertyAnimation { target: appContainer; property:"height"; to: startState.height; duration: animDuration * segment2DurationFactor; easing.type: Easing.OutQuad }
                        PropertyAnimation { target: appContainer; property:"x"; to: startState.x; duration: animDuration * segment2DurationFactor; easing.type: Easing.OutQuad }
                        PropertyAnimation { target: appContainer; property:"y"; to: startState.y; duration: animDuration * segment2DurationFactor; easing.type: Easing.OutQuad }
                    }
                }

                ColorAnimation { target: appContainer; property:"color"; to: startState.color; duration: animDuration }
                NumberAnimation { target: windowContent; property:"opacity"; to: 0; duration: animDuration * 0.4 }
            }
        }
    ]
}
