import QtQuick
import QtQuick.Layouts
import md3.Core
import md3.Extras.NodeGraph 1.0

Item {
    id: root
    property string title: "Node Graph"
    signal backClicked()

    property int _spawnIndex: 0
    property bool benchmarkGraph: false
    property string statusMessage: ""

    property var nodes: []
    property var edges: []
    property var _contentTypes: ["text", "switch", "input", "single", "multi"]

    function _cloneMap(src) {
        var out = {}
        for (var k in src) out[k] = src[k]
        return out
    }

    function _splitCsv(text) {
        var raw = (text || "").split(",")
        var out = []
        for (var i = 0; i < raw.length; ++i) {
            var t = raw[i].trim()
            if (t.length > 0) out.push(t)
        }
        return out
    }

    function _toBool(text) {
        var t = ("" + (text || "")).trim().toLowerCase()
        return t === "1" || t === "true" || t === "yes" || t === "on"
    }

    function _colorOr(value, fallback) {
        return (value !== undefined && value !== null) ? value : fallback
    }

    function _themeColor(key, fallback, altKey) {
        if (Theme && Theme.color) {
            var c = Theme.color[key]
            if (c !== undefined && c !== null) return c
            if (altKey !== undefined && altKey !== null) {
                var c2 = Theme.color[altKey]
                if (c2 !== undefined && c2 !== null) return c2
            }
        }
        return fallback
    }

    function _nodeCardColor(node) {
        if (node && node.fillColor !== undefined && node.fillColor !== null) return node.fillColor
        if (graph && graph.nodeFillColor !== undefined && graph.nodeFillColor !== null) return graph.nodeFillColor
        return _themeColor("surfaceContainerHigh", "#ECE6F0", "surfaceContainer")
    }

    function _normalizePort(port, idx, inputSide) {
        var p = {}
        if (typeof port === "string") {
            var token = port.trim()
            if (inputSide && token.endsWith("*")) {
                p.allowMultiple = true
                token = token.slice(0, token.length - 1).trim()
            }
            var sep = token.indexOf(":")
            p.name = sep >= 0 ? token.slice(0, sep).trim() : token
            p.type = sep >= 0 ? token.slice(sep + 1).trim() : ""
        } else if (port) {
            p.name = (port.name !== undefined) ? ("" + port.name).trim() : ""
            p.type = (port.type !== undefined) ? ("" + port.type).trim() : ""
            p.allowMultiple = !!port.allowMultiple
        }
        if (!p.name || p.name.length === 0) p.name = (inputSide ? "In " : "Out ") + (idx + 1)
        if (p.type === undefined) p.type = ""
        if (p.allowMultiple === undefined) p.allowMultiple = false
        return p
    }

    function _portsFromText(text, inputSide) {
        var parts = _splitCsv(text)
        var ports = []
        for (var i = 0; i < parts.length; ++i) ports.push(_normalizePort(parts[i], i, inputSide))
        return ports
    }

    function _portsToText(ports, inputSide) {
        if (!ports || ports.length === 0) return ""
        var out = []
        for (var i = 0; i < ports.length; ++i) {
            var p = _normalizePort(ports[i], i, inputSide)
            var s = p.name + (p.type.length > 0 ? ":" + p.type : "")
            if (inputSide && p.allowMultiple) s += "*"
            out.push(s)
        }
        return out.join(", ")
    }

    function _normalizeSpec(spec, fallback) {
        var s = spec ? _cloneMap(spec) : {}
        var t = (s.type !== undefined) ? ("" + s.type) : "text"
        if (_contentTypes.indexOf(t) < 0) t = "text"
        s.type = t

        if (t === "text") {
            s.value = (s.value !== undefined) ? ("" + s.value) : (fallback || "")
        } else if (t === "switch") {
            if (!s.label) s.label = "Enabled"
            s.value = !!s.value
        } else if (t === "input") {
            if (!s.label) s.label = "Input"
            if (s.placeholder === undefined) s.placeholder = ""
            if (s.value === undefined) s.value = ""
        } else if (t === "single") {
            s.options = (s.options && s.options.length > 0) ? s.options.slice() : ["Option A", "Option B"]
            if (s.options.indexOf(s.value) < 0) s.value = s.options[0]
        } else if (t === "multi") {
            s.options = (s.options && s.options.length > 0) ? s.options.slice() : ["Option A", "Option B", "Option C"]
            var values = (s.values && s.values.length > 0) ? s.values.slice() : []
            var kept = []
            for (var i = 0; i < values.length; ++i) {
                if (s.options.indexOf(values[i]) >= 0) kept.push(values[i])
            }
            s.values = kept
        }
        return s
    }

    function _normalizeNode(node0) {
        var n = node0 ? JSON.parse(JSON.stringify(node0)) : {}
        n.id = (n.id !== undefined) ? n.id : ("n" + Date.now() + "_" + Math.floor(Math.random() * 10000))
        n.title = (n.title !== undefined) ? ("" + n.title) : "Node"
        n.x = (n.x !== undefined) ? n.x : 0
        n.y = (n.y !== undefined) ? n.y : 0
        n.w = Math.max(140, (n.w !== undefined) ? n.w : 240)
        n.h = Math.max(100, (n.h !== undefined) ? n.h : 170)

        var inCount = Math.max(0, parseInt(n.inPorts) || 0)
        var outCount = Math.max(0, parseInt(n.outPorts) || 0)
        var ins = []
        var outs = []

        if (n.inputPorts && n.inputPorts.length !== undefined) {
            for (var i = 0; i < n.inputPorts.length; ++i) ins.push(_normalizePort(n.inputPorts[i], i, true))
        } else {
            for (var ii = 0; ii < inCount; ++ii) ins.push(_normalizePort(undefined, ii, true))
        }

        if (n.outputPorts && n.outputPorts.length !== undefined) {
            for (var j = 0; j < n.outputPorts.length; ++j) outs.push(_normalizePort(n.outputPorts[j], j, false))
        } else {
            for (var jj = 0; jj < outCount; ++jj) outs.push(_normalizePort(undefined, jj, false))
        }

        n.inputPorts = ins
        n.outputPorts = outs
        n.inPorts = ins.length
        n.outPorts = outs.length
        n.contentSpec = _normalizeSpec(n.contentSpec, n.content || "")
        n.content = n.contentSpec.type === "text" ? (n.contentSpec.value || "") : ""
        return n
    }

    function _centerFor(w, h) {
        var c = graph.viewToScenePoint(Qt.point(graph.width * 0.5, graph.height * 0.5))
        return { x: c.x - w * 0.5, y: c.y - h * 0.5 }
    }

    function _nextSpawnFor(w, h) {
        var base = _centerFor(w, h)
        var i = _spawnIndex
        _spawnIndex = i + 1
        var step = 36
        var gx = (i % 7) - 3
        var gy = (Math.floor(i / 7) % 7) - 3
        return { x: base.x + gx * step, y: base.y + gy * step * 0.7 }
    }

    function _contentTypeIndex(typeValue) {
        for (var i = 0; i < _contentTypes.length; ++i) {
            if (_contentTypes[i] === typeValue) return i
        }
        return 0
    }

    function _contentTypeAt(index) {
        if (index < 0 || index >= _contentTypes.length) return "text"
        return _contentTypes[index]
    }

    function _showStatus(msg) {
        statusMessage = msg
        statusTimer.restart()
    }

    function _rejectReasonText(reason) {
        if (reason === "duplicate_edge") return "Duplicate edge"
        if (reason === "port_type_mismatch") return "Port type mismatch"
        if (reason === "input_port_occupied") return "Input occupied (use * for multi-link)"
        if (reason === "same_node") return "Cannot connect same node"
        return "Connection validation failed"
    }

    function _makeEdgeStyleButtons(styleIndex) {
        return [
            { text: "Cubic", selected: styleIndex === 0 },
            { text: "Linear", selected: styleIndex === 1 },
            { text: "Step", selected: styleIndex === 2 }
        ]
    }

    function _updateNodeById(id, updater) {
        var arr = graph.nodes ? graph.nodes.slice() : []
        for (var i = 0; i < arr.length; ++i) {
            if (arr[i] && arr[i].id === id) {
                var n = _normalizeNode(arr[i])
                updater(n)
                arr[i] = _normalizeNode(n)
                break
            }
        }
        graph.nodes = arr
    }

    function _buildSampleGraph() {
        return {
            nodes: [
                _normalizeNode({ id: "input", title: "Image Input", x: 80, y: 90, w: 240, h: 170,
                                 inputPorts: [], outputPorts: [ { name: "Image", type: "image" }, { name: "Mask", type: "mask" } ],
                                 contentSpec: { type: "text", value: "dataset: camera_01" } }),
                _normalizeNode({ id: "blur", title: "Gaussian Blur", x: 430, y: 70, w: 260, h: 220,
                                 inputPorts: [ { name: "Image", type: "image" }, { name: "Mask", type: "mask" }, { name: "Sigma", type: "number" } ],
                                 outputPorts: [ { name: "Result", type: "image" } ],
                                 contentSpec: { type: "switch", label: "Enabled", value: true } }),
                _normalizeNode({ id: "param", title: "Blur Params", x: 80, y: 320, w: 240, h: 170,
                                 inputPorts: [], outputPorts: [ { name: "Sigma", type: "number" } ],
                                 contentSpec: { type: "input", label: "Sigma", placeholder: "0.1 - 30", value: "4.0" } }),
                _normalizeNode({ id: "mix", title: "Mix", x: 430, y: 335, w: 260, h: 190,
                                 inputPorts: [ { name: "A", type: "image" }, { name: "B", type: "image" } ],
                                 outputPorts: [ { name: "Out", type: "image" } ],
                                 contentSpec: { type: "single", options: ["Normal", "Screen", "Overlay"], value: "Screen" } }),
                _normalizeNode({ id: "out", title: "Output", x: 800, y: 190, w: 240, h: 190,
                                 inputPorts: [ { name: "Final", type: "image", allowMultiple: false } ], outputPorts: [],
                                 contentSpec: { type: "multi", options: ["Preview", "Save PNG", "Histogram"], values: ["Preview"] } })
            ],
            edges: [
                { from: "input", fromPort: 0, to: "blur", toPort: 0 },
                { from: "input", fromPort: 1, to: "blur", toPort: 1 },
                { from: "param", fromPort: 0, to: "blur", toPort: 2 },
                { from: "input", fromPort: 0, to: "mix", toPort: 0 },
                { from: "blur", fromPort: 0, to: "mix", toPort: 1 },
                { from: "mix", fromPort: 0, to: "out", toPort: 0 }
            ]
        }
    }

    function _buildBenchmarkGraph(cols, rows) {
        cols = Math.max(2, cols | 0)
        rows = Math.max(2, rows | 0)
        var nodesArr = []
        var edgesArr = []
        for (var r = 0; r < rows; ++r) {
            for (var c = 0; c < cols; ++c) {
                var id = "n_" + r + "_" + c
                var inPorts = (c === 0) ? [] : [ { name: "In", type: "sig" + ((r + c) % 3) } ]
                var outPorts = (c === cols - 1) ? [] : [ { name: "Out", type: "sig" + ((r + c * 2) % 3) } ]
                nodesArr.push(_normalizeNode({
                    id: id,
                    title: "Node " + r + "," + c,
                    x: 80 + c * 260,
                    y: 80 + r * 170 + ((c % 3) * 10),
                    w: 220,
                    h: 140,
                    inputPorts: inPorts,
                    outputPorts: outPorts,
                    contentSpec: { type: "text", value: "bench" }
                }))
            }
        }
        for (var rr = 0; rr < rows; ++rr) {
            for (var cc = 0; cc < cols - 1; ++cc) {
                edgesArr.push({ from: "n_" + rr + "_" + cc, fromPort: 0, to: "n_" + rr + "_" + (cc + 1), toPort: 0 })
                if (rr + 1 < rows && (cc % 2) === 0) {
                    edgesArr.push({ from: "n_" + rr + "_" + cc, fromPort: 0, to: "n_" + (rr + 1) + "_" + (cc + 1), toPort: 0 })
                }
            }
        }
        return { nodes: nodesArr, edges: edgesArr }
    }

    function _ensureGraph() {
        var g = benchmarkGraph ? _buildBenchmarkGraph(14, 10) : _buildSampleGraph()
        nodes = g.nodes
        edges = g.edges
        graph.nodes = nodes
        graph.edges = edges
    }

    function _addTemplateNode(kind) {
        var p = _nextSpawnFor(240, 170)
        var n = {
            id: "n" + Date.now() + "_" + Math.floor(Math.random() * 10000),
            x: p.x,
            y: p.y,
            w: 240,
            h: 170,
            title: "Process",
            inputPorts: [ { name: "In 1", type: "any" } ],
            outputPorts: [ { name: "Out 1", type: "any" } ],
            contentSpec: { type: "text", value: "Node" }
        }
        if (kind === "switch") n.contentSpec = { type: "switch", label: "Enabled", value: true }
        else if (kind === "input") n.contentSpec = { type: "input", label: "Input", placeholder: "", value: "" }
        else if (kind === "single") n.contentSpec = { type: "single", options: ["A", "B"], value: "A" }
        else if (kind === "multi") n.contentSpec = { type: "multi", options: ["A", "B", "C"], values: ["A"] }
        var arr = graph.nodes ? graph.nodes.slice() : []
        arr.push(_normalizeNode(n))
        graph.nodes = arr
    }

    Timer {
        id: statusTimer
        interval: 2200
        repeat: false
        onTriggered: root.statusMessage = ""
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        GridLayout {
            Layout.fillWidth: true
            rowSpacing: 16
            columnSpacing: 16
            columns: 3

            Item {
                width: 40
                height: 40
                Layout.alignment: Qt.AlignVCenter
                Rectangle {
                    anchors.fill: parent
                    radius: 20
                    color: backMouse.containsMouse ? Theme.color.surfaceContainerHigh : "transparent"
                    Text {
                        anchors.centerIn: parent
                        text: "arrow_back"
                        font.family: Theme.iconFont.name
                        font.pixelSize: 24
                        color: Theme.color.onSurfaceColor
                    }
                    MouseArea { id: backMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.backClicked() }
                }
            }

            Text {
                text: "Node Graph"
                font.family: Theme.typography.headlineSmall.family
                font.pixelSize: Theme.typography.headlineSmall.size
                font.weight: Theme.typography.headlineSmall.weight
                color: Theme.color.onSurfaceColor
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }

            RowLayout {
                spacing: 12
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                SegmentedButton {
                    id: edgeStyleSeg
                    buttons: root._makeEdgeStyleButtons(0)
                    onClicked: function(index) {
                        if (index === 0) graph.edgeStyle = NodeGraphView.Cubic
                        else if (index === 1) graph.edgeStyle = NodeGraphView.Linear
                        else graph.edgeStyle = NodeGraphView.Step
                    }
                }
                Button { text: "Reset"; icon: "restart_alt"; type: "filledTonal"; height: 32; onClicked: graph.resetView() }
                Button { id: addButton; text: "Add"; icon: "add"; type: "filled"; height: 32; onClicked: addMenu.open(addButton, 0, addButton.height + 6) }
                Switch { text: "Grid"; checked: graph.showGrid; onClicked: graph.showGrid = !graph.showGrid }
                Switch {
                    text: "Benchmark"
                    checked: root.benchmarkGraph
                    onClicked: {
                        root.benchmarkGraph = !root.benchmarkGraph
                        root._ensureGraph()
                        graph.resetView()
                    }
                }
            }
        }

        Card {
            Layout.fillWidth: true
            Layout.fillHeight: true
            type: "filled"
            color: Theme.color.surfaceContainerLowest
            radius: 16
            padding: 0
            clip: true

            NodeGraph {
                id: graph
                anchors.fill: parent
                liveUpdateNodes: true
                liveUpdateEdges: true
                edgeStyle: NodeGraphView.Cubic
                edgeColor: root._themeColor("primary", "#6750A4", "primaryColor")
                nodeFillColor: root._themeColor("surfaceContainerHigh", "#ECE6F0", "surfaceContainer")
                nodeStrokeColor: root._themeColor("onSurfaceVariantColor", "#49454F", "onSurfaceVariant")
                portColor: root._themeColor("secondary", "#625B71", "secondaryColor")
                backgroundColor: root._themeColor("surface", "#FFFBFE", "background")

                Component.onCompleted: {
                    root._ensureGraph()
                    if (graph.hasOwnProperty("ghostEdgeEnabled")) graph["ghostEdgeEnabled"] = true
                    if (graph.hasOwnProperty("ghostEdgeColor")) {
                        graph["ghostEdgeColor"] = root._themeColor("primary", "#7A52FF", "primaryColor")
                    }
                }

                onNodesChanged: root.nodes = graph.nodes
                onEdgesChanged: root.edges = graph.edges
                onNodeRightClicked: function(id, x, y) { editor.openEdit(id) }
            }

            Connections {
                target: graph
                ignoreUnknownSignals: true
                function onEdgeCreateRejected(edge, reason) {
                    root._showStatus(root._rejectReasonText(reason))
                }
            }

            Item {
                anchors.fill: parent
                z: 12
                clip: true
                Repeater {
                    model: graph.nodes
                    delegate: Item {
                        id: nodeUi
                        property var node: modelData
                        property var spec: root._normalizeSpec(node ? node.contentSpec : undefined, node ? node.content : "")
                        property real nodeX: (node && node.x !== undefined) ? node.x : 0
                        property real nodeY: (node && node.y !== undefined) ? node.y : 0
                        property real nodeW: (node && node.w !== undefined ? node.w : 220)
                        property real nodeH: (node && node.h !== undefined ? node.h : 140)
                        property real contentW: Math.max(84, nodeW - 48)
                        property real contentH: Math.max(44, nodeH - 58)
                        property color nodeCardColor: root._themeColor("surfaceContainerHigh", "#ECE6F0", "surfaceContainer")

                        x: graph.sceneToViewX(nodeX + 24)
                        y: graph.sceneToViewY(nodeY + 40)
                        width: contentW
                        height: contentH
                        scale: graph.zoom
                        transformOrigin: Item.TopLeft
                        visible: node && spec.type !== "text" && graph.zoom > 0.45

                        function patchSpec(mutator) {
                            root._updateNodeById(node.id, function(n) {
                                var s = root._normalizeSpec(n.contentSpec, n.content || "")
                                mutator(s)
                                n.contentSpec = s
                                n.content = s.type === "text" ? (s.value || "") : ""
                            })
                        }

                        Flickable {
                            id: scroll
                            anchors.fill: parent
                            clip: true
                            boundsBehavior: Flickable.StopAtBounds
                            flickableDirection: Flickable.VerticalFlick
                            contentWidth: width
                            property real formHeight: {
                                if (!loader.item) return height
                                var h = loader.item.implicitHeight
                                if (h === undefined || h <= 0) h = loader.item.height
                                return Math.max(1, h)
                            }
                            contentHeight: Math.max(height, formHeight)
                            interactive: contentHeight > height + 1

                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.NoButton
                                hoverEnabled: true
                                onWheel: function(wheel) {
                                    if (scroll.interactive) {
                                        var dy = 0
                                        if (wheel.pixelDelta && wheel.pixelDelta.y !== 0) dy = wheel.pixelDelta.y
                                        else if (wheel.angleDelta) dy = wheel.angleDelta.y * 0.5
                                        var maxY = Math.max(0, scroll.contentHeight - scroll.height)
                                        scroll.contentY = Math.max(0, Math.min(maxY, scroll.contentY - dy))
                                    }
                                    wheel.accepted = true
                                }
                            }

                            Loader {
                                id: loader
                                width: {
                                    if (!item) return 0
                                    var w = item.implicitWidth
                                    if (w === undefined || w <= 0) w = item.width
                                    return Math.max(0, Math.min(scroll.width, w))
                                }
                                height: {
                                    if (!item) return 0
                                    var h = item.implicitHeight
                                    if (h === undefined || h <= 0) h = item.height
                                    return Math.max(0, h)
                                }
                                x: Math.round((scroll.width - width) * 0.5)
                                y: scroll.interactive ? 0 : Math.max(0, Math.round((scroll.height - height) * 0.5))
                                sourceComponent: {
                                    if (nodeUi.spec.type === "switch") return switchComp
                                    if (nodeUi.spec.type === "input") return inputComp
                                    if (nodeUi.spec.type === "single") return singleComp
                                    if (nodeUi.spec.type === "multi") return multiComp
                                    return undefined
                                }
                            }
                        }

                        Component {
                            id: switchComp
                            Switch {
                                width: Math.min(nodeUi.width, Math.max(120, implicitWidth + 24))
                                text: nodeUi.spec.label || "Enabled"
                                checked: !!nodeUi.spec.value
                                onClicked: {
                                    var v = checked
                                    nodeUi.patchSpec(function(s) { s.type = "switch"; s.label = text; s.value = v })
                                }
                            }
                        }

                        Component {
                            id: inputComp
                            TextField {
                                id: field
                                width: Math.min(nodeUi.width, 220)
                                type: "outlined"
                                label: nodeUi.spec.label || "Input"
                                placeholderText: nodeUi.spec.placeholder || ""
                                text: nodeUi.spec.value || ""
                                labelBackgroundColor: nodeUi.nodeCardColor
                                onAccepted: {
                                    nodeUi.patchSpec(function(s) {
                                        s.type = "input"
                                        s.label = field.label
                                        s.placeholder = field.placeholderText
                                        s.value = field.text
                                    })
                                }
                                onEditingFinished: {
                                    nodeUi.patchSpec(function(s) {
                                        s.type = "input"
                                        s.label = field.label
                                        s.placeholder = field.placeholderText
                                        s.value = field.text
                                    })
                                }
                            }
                        }

                        Component {
                            id: singleComp
                            ComboBox {
                                width: Math.min(nodeUi.width, 220)
                                type: "outlined"
                                label: "Select"
                                labelBackgroundColor: nodeUi.nodeCardColor
                                property var optionsModel: (nodeUi.spec.options && nodeUi.spec.options.length > 0) ? nodeUi.spec.options : ["Option A", "Option B"]
                                model: optionsModel
                                currentIndex: {
                                    var i = optionsModel.indexOf(nodeUi.spec.value)
                                    return i >= 0 ? i : 0
                                }
                                onActivated: function(index) {
                                    var v = optionsModel[index]
                                    nodeUi.patchSpec(function(s) { s.type = "single"; s.options = optionsModel.slice(); s.value = v })
                                }
                            }
                        }

                        Component {
                            id: multiComp
                            Column {
                                width: Math.min(nodeUi.width, 220)
                                spacing: 1
                                property var optionsModel: (nodeUi.spec.options && nodeUi.spec.options.length > 0) ? nodeUi.spec.options : ["Option A", "Option B", "Option C"]
                                Repeater {
                                    model: parent.optionsModel
                                    delegate: Checkbox {
                                        width: parent.width
                                        text: modelData
                                        checked: (nodeUi.spec.values || []).indexOf(modelData) >= 0
                                        onClicked: {
                                            var on = checked
                                            nodeUi.patchSpec(function(s) {
                                                s.type = "multi"
                                                s.options = parent.optionsModel.slice()
                                                var values = s.values ? s.values.slice() : []
                                                var idx = values.indexOf(modelData)
                                                if (on && idx < 0) values.push(modelData)
                                                if (!on && idx >= 0) values.splice(idx, 1)
                                                s.values = values
                                            })
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Item {
                id: portTooltipLayer
                anchors.fill: parent
                z: 26
                enabled: false
                property var hoverPort: (graph.hasOwnProperty("hoveredPort") && graph.hoveredPort) ? graph.hoveredPort : ({})
                property bool hasHoverPort: hoverPort && hoverPort.portIndex !== undefined && hoverPort.sceneX !== undefined && hoverPort.sceneY !== undefined
                property real viewX: hasHoverPort ? graph.sceneToViewX(hoverPort.sceneX) : 0
                property real viewY: hasHoverPort ? graph.sceneToViewY(hoverPort.sceneY) : 0
                property string tipText: {
                    if (!hasHoverPort) return ""
                    var name = (hoverPort.name !== undefined && ("" + hoverPort.name).length > 0)
                            ? ("" + hoverPort.name)
                            : ((hoverPort.isInput ? "In " : "Out ") + (hoverPort.portIndex + 1))
                    var text = name
                    if (hoverPort.type !== undefined && ("" + hoverPort.type).length > 0) text += "\nType: " + hoverPort.type
                    if (hoverPort.isInput && hoverPort.allowMultiple) text += "\nMulti-link"
                    return text
                }

                Rectangle {
                    id: portTooltipBubble
                    visible: portTooltipLayer.hasHoverPort
                    radius: 10
                    color: root._colorOr(Theme.color.inverseSurfaceColor, "#303030")
                    opacity: visible ? 0.96 : 0
                    width: Math.min(parent.width - 12, tipLabel.implicitWidth + 18)
                    height: tipLabel.implicitHeight + 10
                    x: {
                        var rightSide = portTooltipLayer.viewX + 12
                        var leftSide = portTooltipLayer.viewX - width - 12
                        var raw = portTooltipLayer.hoverPort.isInput ? rightSide : leftSide
                        return Math.max(6, Math.min(parent.width - width - 6, raw))
                    }
                    y: Math.max(6, Math.min(parent.height - height - 6, portTooltipLayer.viewY - height * 0.5))
                    Behavior on opacity { NumberAnimation { duration: 100 } }
                    Text {
                        id: tipLabel
                        anchors.centerIn: parent
                        text: portTooltipLayer.tipText
                        color: root._colorOr(Theme.color.inverseOnSurfaceColor, "#FFFFFF")
                        font.pixelSize: 11
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            Item {
                anchors.fill: parent
                z: 30
                enabled: false
                Text {
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 12
                    anchors.bottomMargin: 10
                    color: Theme.color.onSurfaceVariantColor
                    opacity: 0.85
                    font.pixelSize: 12
                    text: "Selected: " + (graph.selectedNodeIds ? graph.selectedNodeIds.length : 0)
                          + "   Ctrl/Shift multi-select   Drag box-select   Ctrl+C copy   Ctrl+V paste   Del delete"
                }
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 14
                radius: 14
                color: root._colorOr(Theme.color.inverseSurfaceColor, "#303030")
                opacity: statusMessage.length > 0 ? 0.92 : 0
                visible: opacity > 0
                z: 40
                width: Math.min(parent.width - 40, statusLabel.implicitWidth + 26)
                height: statusLabel.implicitHeight + 12
                Behavior on opacity { NumberAnimation { duration: 140 } }
                Text {
                    id: statusLabel
                    anchors.centerIn: parent
                    text: statusMessage
                    color: root._colorOr(Theme.color.inverseOnSurfaceColor, "#FFFFFF")
                    font.pixelSize: 12
                }
            }

            Menu {
                id: addMenu
                model: [
                    { text: "Switch Node", action: function() { root._addTemplateNode("switch") } },
                    { text: "Input Node", action: function() { root._addTemplateNode("input") } },
                    { text: "Single Select Node", action: function() { root._addTemplateNode("single") } },
                    { text: "Multi Select Node", action: function() { root._addTemplateNode("multi") } },
                    { type: "separator" },
                    { text: "Custom...", action: function() { editor.openAdd() } }
                ]
            }

            Item {
                id: editor
                anchors.fill: parent
                z: 60
                visible: false
                property var editingId: undefined

                function openAdd() {
                    editingId = undefined
                    titleField.text = "Custom"
                    inputsField.text = "In 1:any"
                    outputsField.text = "Out 1:any"
                    contentTypeBox.currentIndex = 0
                    labelField.text = ""
                    valueField.text = ""
                    optionsField.text = ""
                    visible = true
                }

                function openEdit(id) {
                    var found = undefined
                    for (var i = 0; i < graph.nodes.length; ++i) {
                        var n = graph.nodes[i]
                        if (n && n.id === id) { found = root._normalizeNode(n); break }
                    }
                    if (!found) return
                    editingId = id
                    titleField.text = found.title
                    inputsField.text = root._portsToText(found.inputPorts, true)
                    outputsField.text = root._portsToText(found.outputPorts, false)
                    contentTypeBox.currentIndex = root._contentTypeIndex(found.contentSpec.type)
                    labelField.text = found.contentSpec.label || ""
                    if (found.contentSpec.type === "multi") valueField.text = (found.contentSpec.values || []).join(", ")
                    else valueField.text = found.contentSpec.value || ""
                    optionsField.text = found.contentSpec.options ? found.contentSpec.options.join(", ") : (found.contentSpec.placeholder || "")
                    visible = true
                }

                function close() { visible = false }

                function _collectSpec() {
                    var t = root._contentTypeAt(contentTypeBox.currentIndex)
                    var spec = { type: t }
                    if (t === "text") spec.value = valueField.text
                    else if (t === "switch") spec = { type: "switch", label: labelField.text || "Enabled", value: root._toBool(valueField.text) }
                    else if (t === "input") spec = { type: "input", label: labelField.text || "Input", placeholder: optionsField.text, value: valueField.text }
                    else if (t === "single") {
                        var opts = root._splitCsv(optionsField.text)
                        if (opts.length === 0) opts = ["Option A", "Option B"]
                        spec = { type: "single", options: opts, value: valueField.text || opts[0] }
                    } else {
                        var optsM = root._splitCsv(optionsField.text)
                        if (optsM.length === 0) optsM = ["Option A", "Option B", "Option C"]
                        spec = { type: "multi", options: optsM, values: root._splitCsv(valueField.text) }
                    }
                    return root._normalizeSpec(spec, "")
                }

                function save() {
                    if (editingId !== undefined) {
                        root._updateNodeById(editingId, function(n) {
                            n.title = titleField.text
                            n.inputPorts = root._portsFromText(inputsField.text, true)
                            n.outputPorts = root._portsFromText(outputsField.text, false)
                            n.inPorts = n.inputPorts.length
                            n.outPorts = n.outputPorts.length
                            n.contentSpec = _collectSpec()
                            n.content = n.contentSpec.type === "text" ? (n.contentSpec.value || "") : ""
                        })
                    } else {
                        var p = root._nextSpawnFor(240, 170)
                        var n = root._normalizeNode({
                            id: "n" + Date.now() + "_" + Math.floor(Math.random() * 10000),
                            x: p.x,
                            y: p.y,
                            w: 240,
                            h: 170,
                            title: titleField.text,
                            inputPorts: root._portsFromText(inputsField.text, true),
                            outputPorts: root._portsFromText(outputsField.text, false),
                            contentSpec: _collectSpec()
                        })
                        var arr = graph.nodes ? graph.nodes.slice() : []
                        arr.push(n)
                        graph.nodes = arr
                    }
                    close()
                }

                Rectangle { anchors.fill: parent; color: Qt.rgba(0, 0, 0, 0.35) }

                MouseArea {
                    anchors.fill: parent
                    onPressed: function(mouse) {
                        var p = panel.mapFromItem(editor, mouse.x, mouse.y)
                        if (p.x < 0 || p.y < 0 || p.x > panel.width || p.y > panel.height) editor.close()
                        else mouse.accepted = false
                    }
                }

                Rectangle {
                    id: panel
                    anchors.centerIn: parent
                    width: Math.min(700, root.width - 32)
                    height: form.implicitHeight + 32
                    radius: 16
                    color: Theme.color.surfaceContainerHigh

                    ColumnLayout {
                        id: form
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 10

                        Text { text: editor.editingId !== undefined ? "Edit Node" : "Custom Node"; color: Theme.color.onSurfaceColor }
                        TextField { id: titleField; Layout.fillWidth: true; type: "outlined"; label: "Title"; labelBackgroundColor: Theme.color.surfaceContainerHigh }
                        TextField { id: inputsField; Layout.fillWidth: true; type: "outlined"; label: "Inputs (name:type*)"; labelBackgroundColor: Theme.color.surfaceContainerHigh }
                        TextField { id: outputsField; Layout.fillWidth: true; type: "outlined"; label: "Outputs (name:type)"; labelBackgroundColor: Theme.color.surfaceContainerHigh }

                        ComboBox { id: contentTypeBox; Layout.preferredWidth: 220; type: "outlined"; label: "Content Type"; labelBackgroundColor: Theme.color.surfaceContainerHigh; model: ["text", "switch", "input", "single", "multi"] }
                        TextField { id: labelField; Layout.fillWidth: true; type: "outlined"; label: "Control Label"; labelBackgroundColor: Theme.color.surfaceContainerHigh }
                        TextField { id: valueField; Layout.fillWidth: true; type: "outlined"; label: "Value / multi values(csv)"; labelBackgroundColor: Theme.color.surfaceContainerHigh }
                        TextField { id: optionsField; Layout.fillWidth: true; type: "outlined"; label: "Options(csv) / placeholder"; labelBackgroundColor: Theme.color.surfaceContainerHigh }

                        RowLayout {
                            Layout.fillWidth: true
                            Item { Layout.fillWidth: true }
                            Button { text: "Cancel"; type: "text"; onClicked: editor.close() }
                            Button { text: editor.editingId !== undefined ? "Save" : "Add"; type: "filled"; onClicked: editor.save() }
                        }
                    }
                }
            }
        }
    }
}
