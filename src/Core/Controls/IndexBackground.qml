import QtQuick
import md3.Core

Item {
    id: root

    property bool running: true
    property bool particlesEnabled: true
    property bool orbsEnabled: true
    property bool noiseEnabled: true
    property bool mouseTrackingEnabled: true
    property int targetFps: 24
    property int maxParticles: 80
    property real repelDistance: 150
    property real connectDistance: 120
    property real orbsRenderScale: 0.35
    property real particlesRenderScale: 0.55

    property real particlesOpacity: 0.5
    property real orbsOpacity: StyleManager.isDarkTheme ? 0.3 : 0.6
    property real noiseOpacity: 0.08

    property color primaryColor: Theme.color.primary
    property color primaryContainerColor: Theme.color.primaryContainer
    property color secondaryContainerColor: Theme.color.secondaryContainer
    property color tertiaryContainerColor: Theme.color.tertiaryContainer

    implicitWidth: 600
    implicitHeight: 360

    function _rgbaWithAlpha(c, a) {
        return Qt.rgba(c.r, c.g, c.b, a)
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.color.surface
    }

    Item {
        id: orbsLayer
        anchors.fill: parent
        visible: root.orbsEnabled
        opacity: root.orbsOpacity

        Canvas {
            id: orbsCanvas
            x: 0
            y: 0
            width: Math.max(1, Math.round(orbsLayer.width * Math.max(0.35, Math.min(1.0, root.orbsRenderScale))))
            height: Math.max(1, Math.round(orbsLayer.height * Math.max(0.35, Math.min(1.0, root.orbsRenderScale))))
            scale: 1 / Math.max(0.35, Math.min(1.0, root.orbsRenderScale))
            transformOrigin: Item.TopLeft
            antialiasing: true
            renderTarget: Canvas.FramebufferObject
            renderStrategy: Canvas.Threaded

            property real phase: 0

            NumberAnimation on phase {
                running: root.running && root.visible && root.orbsEnabled
                from: 0
                to: Math.PI * 2
                duration: 20000
                loops: Animation.Infinite
            }

            Timer {
                interval: Math.round(1000 / Math.max(1, root.targetFps))
                repeat: true
                running: root.running && root.visible && root.orbsEnabled
                onTriggered: orbsCanvas.requestPaint()
            }

            onWidthChanged: requestPaint()
            onHeightChanged: requestPaint()
            onVisibleChanged: if (visible) requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.clearRect(0, 0, width, height)

                var w = width
                var h = height
                var m = Math.max(w, h)

                function drawOrb(centerX, centerY, radius, baseColor) {
                    var g = ctx.createRadialGradient(centerX, centerY, 0, centerX, centerY, radius)
                    g.addColorStop(0, root._rgbaWithAlpha(baseColor, 0.95))
                    g.addColorStop(1, root._rgbaWithAlpha(baseColor, 0.0))
                    ctx.fillStyle = g
                    ctx.beginPath()
                    ctx.arc(centerX, centerY, radius, 0, Math.PI * 2)
                    ctx.fill()
                }

                var p = phase

                var d1 = 0.60 * m
                var r1 = d1 * 0.5 * (1.0 + 0.10 * Math.sin(p * 0.9))
                var base1x = -0.10 * w + d1 * 0.5
                var base1y = -0.20 * h + d1 * 0.5
                var o1x = 30 * Math.sin(p * 1.0) + 8 * Math.sin(p * 0.33 + 0.7)
                var o1y = -50 * Math.sin(p * 0.7 + 0.5) + 10 * Math.cos(p * 0.45)
                drawOrb(base1x + o1x, base1y + o1y, r1, root.primaryContainerColor)

                var d2 = 0.50 * m
                var r2 = d2 * 0.5 * (1.0 + 0.10 * Math.cos(p * 0.8))
                var base2x = w - (-0.10 * w) - d2 * 0.5
                var base2y = h - (-0.10 * h) - d2 * 0.5
                var o2x = -28 * Math.sin(p * 0.95 + 0.4) + 6 * Math.cos(p * 0.28)
                var o2y = 26 * Math.cos(p * 0.72 + 1.2) - 10 * Math.sin(p * 0.38)
                drawOrb(base2x + o2x, base2y + o2y, r2, root.secondaryContainerColor)

                var d3 = 0.30 * m
                var r3 = d3 * 0.5 * (1.0 + 0.10 * Math.sin(p * 1.1 + 1.1))
                var base3x = 0.40 * w + d3 * 0.5
                var base3y = 0.40 * h + d3 * 0.5
                var o3x = 22 * Math.sin(p * 0.86 + 2.1) - 6 * Math.sin(p * 0.27)
                var o3y = -20 * Math.cos(p * 0.78 + 0.8) + 8 * Math.cos(p * 0.22)
                drawOrb(base3x + o3x, base3y + o3y, r3, root.tertiaryContainerColor)
            }
        }
    }

    Item {
        id: particlesLayer
        anchors.fill: parent
        visible: root.particlesEnabled
        opacity: root.particlesOpacity

        Canvas {
            id: particlesCanvas
            x: 0
            y: 0
            width: Math.max(1, Math.round(particlesLayer.width * Math.max(0.35, Math.min(1.0, root.particlesRenderScale))))
            height: Math.max(1, Math.round(particlesLayer.height * Math.max(0.35, Math.min(1.0, root.particlesRenderScale))))
            scale: 1 / Math.max(0.35, Math.min(1.0, root.particlesRenderScale))
            transformOrigin: Item.TopLeft
            antialiasing: true
            renderTarget: Canvas.FramebufferObject
            renderStrategy: Canvas.Threaded

            property var particles: []
            property real mouseX: NaN
            property real mouseY: NaN
            property int maxParticles: root.maxParticles
            property real repelDistance: root.repelDistance
            property real connectDistance: root.connectDistance

            function init() {
                var w = Math.max(1, width)
                var h = Math.max(1, height)
                particles = []
                var num = Math.min(maxParticles, (w * h) / 15000)
                for (var i = 0; i < num; i++) {
                    particles.push({
                        x: Math.random() * w,
                        y: Math.random() * h,
                        vx: (Math.random() - 0.5) * 0.5,
                        vy: (Math.random() - 0.5) * 0.5,
                        size: Math.random() * 2 + 1
                    })
                }
            }

            Timer {
                interval: Math.round(1000 / Math.max(1, root.targetFps))
                repeat: true
                running: root.running && root.visible && root.particlesEnabled
                onTriggered: particlesCanvas.requestPaint()
            }

            onWidthChanged: init()
            onHeightChanged: init()
            Component.onCompleted: init()

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.clearRect(0, 0, width, height)

                var w = width
                var h = height
                var mx = mouseX
                var my = mouseY
                var step = 60 / Math.max(1, root.targetFps)

                var fillC = root._rgbaWithAlpha(root.primaryColor, 0.15)
                ctx.fillStyle = fillC
                ctx.lineWidth = Math.max(0.6, Math.min(1.2, Math.max(0.35, Math.min(1.0, root.particlesRenderScale))))

                var repelDistSq = repelDistance * repelDistance
                var connectDistSq = connectDistance * connectDistance

                for (var i = 0; i < particles.length; i++) {
                    var p = particles[i]

                    p.x += p.vx * step
                    p.y += p.vy * step

                    if (p.x < 0 || p.x > w) p.vx *= -1
                    if (p.y < 0 || p.y > h) p.vy *= -1

                    if (!isNaN(mx) && !isNaN(my)) {
                        var dxm = mx - p.x
                        var dym = my - p.y
                        var distMSq = dxm * dxm + dym * dym
                        if (distMSq > 0.0001 && distMSq < repelDistSq) {
                            var distM = Math.sqrt(distMSq)
                            var fx = dxm / distM
                            var fy = dym / distM
                            var force = (repelDistance - distM) / repelDistance
                            p.vx -= fx * force * 0.5 * step
                            p.vy -= fy * force * 0.5 * step
                        }
                    }

                    ctx.beginPath()
                    ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2)
                    ctx.fill()
                }

                for (var a = 0; a < particles.length; a++) {
                    var pa = particles[a]
                    for (var b = a + 1; b < particles.length; b++) {
                        var pb = particles[b]
                        var dx = pa.x - pb.x
                        var dy = pa.y - pb.y
                        var distSq = dx * dx + dy * dy
                        if (distSq < connectDistSq) {
                            var dist = Math.sqrt(distSq)
                            var alpha = 0.12 * (1 - dist / connectDistance)
                            ctx.beginPath()
                            ctx.strokeStyle = root._rgbaWithAlpha(root.primaryColor, alpha)
                            ctx.moveTo(pa.x, pa.y)
                            ctx.lineTo(pb.x, pb.y)
                            ctx.stroke()
                        }
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        propagateComposedEvents: true
        enabled: root.mouseTrackingEnabled
        visible: root.mouseTrackingEnabled

        onPositionChanged: (mouse) => {
            var s = Math.max(0.35, Math.min(1.0, root.particlesRenderScale))
            particlesCanvas.mouseX = mouse.x * s
            particlesCanvas.mouseY = mouse.y * s
        }

        onExited: {
            particlesCanvas.mouseX = NaN
            particlesCanvas.mouseY = NaN
        }
    }

    Canvas {
        id: noiseCanvas
        anchors.fill: parent
        visible: root.noiseEnabled
        opacity: root.noiseOpacity
        antialiasing: false
        renderTarget: Canvas.Image
        renderStrategy: Canvas.Immediate

        property int seed: 1337

        function reseed() {
            seed = (seed * 1103515245 + 12345) & 0x7fffffff
        }

        function rand01() {
            seed = (seed * 1103515245 + 12345) & 0x7fffffff
            return (seed / 0x7fffffff)
        }

        function refresh() {
            reseed()
            requestPaint()
        }

        Component.onCompleted: refresh()
        onWidthChanged: refresh()
        onHeightChanged: refresh()
        onVisibleChanged: if (visible) refresh()

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.clearRect(0, 0, width, height)

            var w = width
            var h = height
            var count = Math.max(800, (w * h) / 600)

            for (var i = 0; i < count; i++) {
                var x = Math.floor(rand01() * w)
                var y = Math.floor(rand01() * h)
                var s = 1 + Math.floor(rand01() * 2)
                var a = 0.025 + rand01() * 0.04
                var c = (rand01() > 0.5) ? Qt.rgba(1, 1, 1, a) : Qt.rgba(0, 0, 0, a)
                ctx.fillStyle = c
                ctx.fillRect(x, y, s, s)
            }
        }
    }
}

