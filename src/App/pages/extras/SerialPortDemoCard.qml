import QtQuick
import QtQuick.Layouts
import md3.Core
import md3.Extras.Charts 1.0

Item {
    id: root

    implicitHeight: card.implicitHeight

    readonly property int backendMock: 0
    readonly property int backendSerial: 1
    readonly property int backendTcp: 2
    readonly property int backendWebSocket: 3

    property int backendType: backendMock
    property var portOptions: []
    property int selectedPortIndex: -1
    property string logText: ""
    property int maxLogLines: 120
    property var rxDeltaSamples: [0]
    property int maxSampleCount: 120
    property real trendYMax: 16
    property bool scrollWhenNoData: false

    function isMockBackend() { return root.backendType === root.backendMock }
    function isSerialBackend() { return root.backendType === root.backendSerial }
    function isSerialLikeBackend() { return root.isMockBackend() || root.isSerialBackend() }
    function isTcpBackend() { return root.backendType === root.backendTcp }
    function isWebSocketBackend() { return root.backendType === root.backendWebSocket }

    function activeBackend() {
        if (root.isMockBackend()) return mockBackend
        if (root.isSerialBackend()) return serialBackend
        if (root.isTcpBackend()) return tcpBackend
        return wsBackend
    }

    function backendName() {
        if (root.isMockBackend()) return "MockSerialPortBackend"
        if (root.isSerialBackend()) return "SerialPortBackend"
        if (root.isTcpBackend()) return "TcpSocketBackend"
        return "WebSocketBackend"
    }

    function endpointSummary() {
        if (root.isMockBackend()) return mockBackend.portName + " (mock)"
        if (root.isSerialBackend()) return serialBackend.portName
        if (root.isTcpBackend()) return tcpBackend.host + ":" + tcpBackend.port
        return wsBackend.url
    }

    function makeBackendButtons() {
        return [
            { text: "Mock", selected: root.backendType === root.backendMock },
            { text: "Serial", selected: root.backendType === root.backendSerial },
            { text: "TCP", selected: root.backendType === root.backendTcp },
            { text: "WebSocket", selected: root.backendType === root.backendWebSocket }
        ]
    }

    function nowTag() {
        const d = new Date()
        function pad2(v) { return v < 10 ? "0" + v : "" + v }
        return pad2(d.getHours()) + ":" + pad2(d.getMinutes()) + ":" + pad2(d.getSeconds())
    }

    function appendLog(tag, message) {
        const line = "[" + nowTag() + "][" + tag + "] " + message
        let lines = root.logText.length > 0 ? root.logText.split("\n") : []
        lines.push(line)
        if (lines.length > root.maxLogLines) {
            lines = lines.slice(lines.length - root.maxLogLines)
        }
        root.logText = lines.join("\n")
    }

    function clearLog() {
        root.logText = ""
    }

    function resetTrend() {
        root.rxDeltaSamples = [0]
        root.trendYMax = 16
        trendTimer.lastBytes = activeBackend().bytesReceived
    }

    function pushTrend(deltaRx) {
        const next = root.rxDeltaSamples.slice(0)
        next.push(Math.max(0, deltaRx))
        if (next.length > root.maxSampleCount) {
            next.splice(0, next.length - root.maxSampleCount)
        }
        root.rxDeltaSamples = next

        let peak = 0
        for (let i = 0; i < next.length; ++i) {
            if (next[i] > peak) peak = next[i]
        }
        const growTarget = Math.max(16, Math.ceil(peak * 1.25))
        if (growTarget > root.trendYMax) {
            root.trendYMax = growTarget
        } else {
            const shrinkTarget = Math.max(16, Math.ceil(peak * 1.5))
            if (shrinkTarget < root.trendYMax * 0.7) {
                root.trendYMax = shrinkTarget
            }
        }
    }

    function closeAllBackends() {
        serialBackend.closePort()
        mockBackend.closePort()
        tcpBackend.closePort()
        wsBackend.closePort()
    }

    function refreshPorts() {
        if (!root.isSerialLikeBackend()) return

        const backend = root.isMockBackend() ? mockBackend : serialBackend
        const raw = backend.availablePorts()
        const options = []

        for (let i = 0; i < raw.length; ++i) {
            const p = raw[i]
            const name = p.portName ? p.portName : ""
            const desc = p.description ? p.description : (p.systemLocation ? p.systemLocation : "")
            options.push({
                text: desc.length > 0 ? (name + " - " + desc) : name,
                value: name
            })
        }

        if (options.length === 0) {
            options.push({ text: "No serial ports found", value: "" })
        }

        root.portOptions = options

        let picked = -1
        for (let j = 0; j < options.length; ++j) {
            if (options[j].value === backend.portName) {
                picked = j
                break
            }
        }
        if (picked < 0) picked = 0

        root.selectedPortIndex = picked
        applyPortSelection()
    }

    function applyPortSelection() {
        if (!root.isSerialLikeBackend()) return
        if (root.selectedPortIndex < 0 || root.selectedPortIndex >= root.portOptions.length) return

        const value = root.portOptions[root.selectedPortIndex].value
        if (root.isMockBackend()) mockBackend.portName = value
        if (root.isSerialBackend()) serialBackend.portName = value
    }

    function syncBaudEditor() {
        if (root.isMockBackend()) baudField.text = mockBackend.baudRate.toString()
        if (root.isSerialBackend()) baudField.text = serialBackend.baudRate.toString()
    }

    function syncConnectionEditors() {
        tcpHostField.text = tcpBackend.host
        tcpPortField.text = tcpBackend.port.toString()
        wsUrlField.text = wsBackend.url
        if (root.isSerialLikeBackend()) syncBaudEditor()
    }

    function applyConnectionConfig() {
        if (root.isSerialLikeBackend()) {
            applyPortSelection()
            const baud = parseInt(baudField.text)
            if (!isNaN(baud) && baud > 0) {
                if (root.isMockBackend()) mockBackend.baudRate = baud
                if (root.isSerialBackend()) serialBackend.baudRate = baud
            }
            syncBaudEditor()
            return
        }

        if (root.isTcpBackend()) {
            const host = tcpHostField.text.trim()
            const p = parseInt(tcpPortField.text)
            if (host.length > 0) tcpBackend.host = host
            if (!isNaN(p) && p > 0 && p <= 65535) tcpBackend.port = p
            tcpHostField.text = tcpBackend.host
            tcpPortField.text = tcpBackend.port.toString()
            return
        }

        if (root.isWebSocketBackend()) {
            const u = wsUrlField.text.trim()
            if (u.length > 0) wsBackend.url = u
            wsUrlField.text = wsBackend.url
        }
    }

    function openActiveBackend() {
        applyConnectionConfig()
        const ok = activeBackend().openPort()
        if (!ok) {
            appendLog("ERR", "Open failed: " + activeBackend().errorString)
            return
        }
        if (root.isWebSocketBackend()) {
            appendLog("SYS", "WebSocket connecting: " + wsBackend.url)
        }
    }

    function sendTextFrame() {
        const backend = activeBackend()
        const payload = textFrameField.text
        const n = backend.sendText(payload, true)
        if (n >= 0) appendLog("TX", "TEXT(" + n + "B): " + payload)
    }

    function sendHexFrame() {
        const backend = activeBackend()
        const payload = hexFrameField.text
        const n = backend.sendHex(payload)
        if (n >= 0) appendLog("TX", "HEX(" + n + "B): " + payload)
    }

    function handleTextRx(prefix, text) {
        let cleaned = text
        if (cleaned.length > 220) cleaned = cleaned.slice(0, 220) + "..."
        appendLog(prefix, cleaned)
    }

    function handleError(prefix, code, message) {
        appendLog(prefix, "code=" + code + ", " + message)
    }

    onBackendTypeChanged: {
        closeAllBackends()
        backendToggle.buttons = makeBackendButtons()
        if (root.isSerialLikeBackend()) refreshPorts()
        syncConnectionEditors()
        resetTrend()
        appendLog("SYS", "Switched backend to " + backendName())
    }

    Component.onCompleted: {
        backendToggle.buttons = makeBackendButtons()
        refreshPorts()
        syncConnectionEditors()
        resetTrend()
        appendLog("SYS", "Transport demo ready. Default backend: " + backendName())
    }

    SerialPortBackend {
        id: serialBackend
        lineEnding: SerialPortBackend.CRLF
    }

    MockSerialPortBackend {
        id: mockBackend
        lineEnding: MockSerialPortBackend.CRLF
        autoEcho: true
        simulateTraffic: false
        trafficIntervalMs: 1000
    }

    TcpSocketBackend {
        id: tcpBackend
        host: "127.0.0.1"
        port: 9000
        lineEnding: TcpSocketBackend.CRLF
        connectTimeoutMs: 3000
    }

    WebSocketBackend {
        id: wsBackend
        url: "ws://127.0.0.1:9001"
        lineEnding: WebSocketBackend.CRLF
        connectTimeoutMs: 4000
    }

    Timer {
        id: trendTimer
        property real lastBytes: 0
        interval: 400
        repeat: true
        running: true
        onTriggered: {
            const backend = activeBackend()
            const current = backend.bytesReceived
            const delta = current - trendTimer.lastBytes
            if (delta > 0 || root.scrollWhenNoData) root.pushTrend(delta)
            trendTimer.lastBytes = current
        }
    }

    Connections {
        target: serialBackend
        function onOpened() { if (root.backendType === root.backendSerial) root.appendLog("SYS", "Serial opened: " + serialBackend.portName) }
        function onClosed() { if (root.backendType === root.backendSerial) root.appendLog("SYS", "Serial closed") }
        function onTextReceived(text) { if (root.backendType === root.backendSerial) root.handleTextRx("RX", text) }
        function onSerialErrorOccurred(code, message) { if (root.backendType === root.backendSerial) root.handleError("ERR", code, message) }
    }

    Connections {
        target: mockBackend
        function onOpened() { if (root.backendType === root.backendMock) root.appendLog("SYS", "Mock opened: " + mockBackend.portName) }
        function onClosed() { if (root.backendType === root.backendMock) root.appendLog("SYS", "Mock closed") }
        function onTextReceived(text) { if (root.backendType === root.backendMock) root.handleTextRx("RX", text) }
        function onSerialErrorOccurred(code, message) { if (root.backendType === root.backendMock) root.handleError("ERR", code, message) }
    }

    Connections {
        target: tcpBackend
        function onOpened() { if (root.backendType === root.backendTcp) root.appendLog("SYS", "TCP connected: " + tcpBackend.host + ":" + tcpBackend.port) }
        function onClosed() { if (root.backendType === root.backendTcp) root.appendLog("SYS", "TCP disconnected") }
        function onTextReceived(text) { if (root.backendType === root.backendTcp) root.handleTextRx("RX", text) }
        function onSerialErrorOccurred(code, message) { if (root.backendType === root.backendTcp) root.handleError("ERR", code, message) }
    }

    Connections {
        target: wsBackend
        function onOpened() { if (root.backendType === root.backendWebSocket) root.appendLog("SYS", "WebSocket connected: " + wsBackend.url) }
        function onClosed() { if (root.backendType === root.backendWebSocket) root.appendLog("SYS", "WebSocket disconnected") }
        function onTextReceived(text) { if (root.backendType === root.backendWebSocket) root.handleTextRx("RX", text) }
        function onSerialErrorOccurred(code, message) { if (root.backendType === root.backendWebSocket) root.handleError("ERR", code, message) }
    }

    Rectangle {
        id: card
        width: parent ? parent.width : 0
        implicitHeight: contentCol.implicitHeight + 24
        color: Theme.color.surfaceContainerHighest
        radius: 12

        ColumnLayout {
            id: contentCol
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 12
            spacing: 10

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Text {
                    text: "Transport Backend Demo (Mock / Serial / TCP / WebSocket)"
                    font.bold: true
                    color: Theme.color.onSurfaceColor
                }

                Item { Layout.fillWidth: true }

                SegmentedButton {
                    id: backendToggle
                    buttons: []
                    onClicked: function(index) { root.backendType = index }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                ComboBox {
                    id: portCombo
                    visible: root.isSerialLikeBackend()
                    Layout.preferredWidth: 320
                    label: "Port"
                    model: root.portOptions
                    currentIndex: root.selectedPortIndex
                    enabled: root.isSerialLikeBackend() && (activeBackend().isOpen === false)
                    onActivated: function(index) {
                        root.selectedPortIndex = index
                        root.applyPortSelection()
                    }
                }

                TextField {
                    id: baudField
                    visible: root.isSerialLikeBackend()
                    Layout.preferredWidth: 140
                    type: "outlined"
                    labelBackgroundColor: Theme.color.surfaceContainerHighest
                    label: "Baud"
                    text: "115200"
                    enabled: root.isSerialLikeBackend() && (activeBackend().isOpen === false)
                    onEditingFinished: {
                        root.applyConnectionConfig()
                    }
                }

                Button {
                    visible: root.isSerialLikeBackend()
                    text: "Refresh"
                    type: "outlined"
                    height: 36
                    onClicked: root.refreshPorts()
                }

                TextField {
                    id: tcpHostField
                    visible: root.isTcpBackend()
                    Layout.preferredWidth: 260
                    type: "outlined"
                    labelBackgroundColor: Theme.color.surfaceContainerHighest
                    label: "TCP Host"
                    text: "127.0.0.1"
                    enabled: !activeBackend().isOpen
                    onEditingFinished: root.applyConnectionConfig()
                }

                TextField {
                    id: tcpPortField
                    visible: root.isTcpBackend()
                    Layout.preferredWidth: 140
                    type: "outlined"
                    labelBackgroundColor: Theme.color.surfaceContainerHighest
                    label: "TCP Port"
                    text: "9000"
                    enabled: !activeBackend().isOpen
                    onEditingFinished: root.applyConnectionConfig()
                }

                TextField {
                    id: wsUrlField
                    visible: root.isWebSocketBackend()
                    Layout.fillWidth: true
                    type: "outlined"
                    labelBackgroundColor: Theme.color.surfaceContainerHighest
                    label: "WebSocket URL"
                    text: "ws://127.0.0.1:9001"
                    enabled: !activeBackend().isOpen
                    onEditingFinished: root.applyConnectionConfig()
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: activeBackend().isOpen ? "Close" : (root.isWebSocketBackend() ? "Connect" : "Open")
                    type: "filled"
                    height: 36
                    onClicked: {
                        if (activeBackend().isOpen) activeBackend().closePort()
                        else root.openActiveBackend()
                    }
                }

                Button {
                    text: "Reopen"
                    type: "outlined"
                    height: 36
                    enabled: activeBackend().isOpen
                    onClicked: activeBackend().reopenPort()
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                TextField {
                    id: textFrameField
                    Layout.fillWidth: true
                    type: "outlined"
                    labelBackgroundColor: Theme.color.surfaceContainerHighest
                    label: "Text Frame"
                    text: "PING"
                    enabled: activeBackend().isOpen
                }

                Button {
                    text: "Send Text"
                    type: "filledTonal"
                    height: 36
                    enabled: activeBackend().isOpen
                    onClicked: root.sendTextFrame()
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                TextField {
                    id: hexFrameField
                    Layout.fillWidth: true
                    type: "outlined"
                    labelBackgroundColor: Theme.color.surfaceContainerHighest
                    label: "HEX Frame"
                    text: "AA 55 01 02"
                    enabled: activeBackend().isOpen
                }

                Button {
                    text: "Send HEX"
                    type: "filledTonal"
                    height: 36
                    enabled: activeBackend().isOpen
                    onClicked: root.sendHexFrame()
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Switch {
                    visible: root.isMockBackend()
                    text: "Mock Auto Echo"
                    checked: mockBackend.autoEcho
                    enabled: root.isMockBackend()
                    onClicked: mockBackend.autoEcho = !mockBackend.autoEcho
                }

                Switch {
                    visible: root.isMockBackend()
                    text: "Mock Traffic"
                    checked: mockBackend.simulateTraffic
                    enabled: root.isMockBackend() && activeBackend().isOpen
                    onClicked: mockBackend.simulateTraffic = !mockBackend.simulateTraffic
                }

                Switch {
                    text: "Idle Scroll"
                    checked: root.scrollWhenNoData
                    onClicked: root.scrollWhenNoData = !root.scrollWhenNoData
                }

                Button {
                    visible: root.isMockBackend()
                    text: "Inject MOCK frame"
                    type: "text"
                    height: 34
                    enabled: root.isMockBackend() && activeBackend().isOpen
                    onClicked: mockBackend.injectIncomingText("MOCK,manual,123\n")
                }

                Item { Layout.fillWidth: true }
            }

            Text {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                color: activeBackend().lastErrorCode === 0 ? Theme.color.onSurfaceVariantColor : Theme.color.error
                text: "Backend: " + root.backendName()
                      + " | endpoint=" + root.endpointSummary()
                      + " | open=" + activeBackend().isOpen
                      + " | sent=" + activeBackend().bytesSent + "B"
                      + " | recv=" + activeBackend().bytesReceived + "B"
                      + (activeBackend().errorString.length > 0 ? (" | err=" + activeBackend().errorString) : "")
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 170
                color: Theme.color.surface
                border.color: Theme.color.outlineVariant
                border.width: 1
                radius: 10
                clip: true

                ChartView {
                    anchors.fill: parent
                    anchors.margins: 10
                    legendEnabled: false
                    tooltipEnabled: false
                    crosshairEnabled: false
                    axesEnabled: true
                    gridEnabled: true
                    yLabelFormatter: function(v) { return Number(v).toFixed(0) }

                    LineChart {
                        lineWidth: 2
                        lineStyle: LineChart.Linear
                        includeZeroInRange: true
                        animationDuration: 0
                        yMin: 0
                        yMax: root.trendYMax
                        series: [
                            ChartSeries {
                                name: "RX delta"
                                color: Theme.color.primary
                                data: root.rxDeltaSamples
                                visible: true
                            }
                        ]
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 160
                color: Theme.color.surface
                border.color: Theme.color.outlineVariant
                border.width: 1
                radius: 10
                clip: true

                Flickable {
                    anchors.fill: parent
                    anchors.margins: 10
                    contentWidth: width
                    contentHeight: logLabel.implicitHeight
                    clip: true

                    Text {
                        id: logLabel
                        width: parent.width
                        text: root.logText.length > 0 ? root.logText : "No logs yet."
                        font.family: Theme.typography.bodySmall.family
                        font.pixelSize: Theme.typography.bodySmall.size
                        color: Theme.color.onSurfaceColor
                        wrapMode: Text.WrapAnywhere
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Button {
                    text: "Clear Log"
                    type: "text"
                    height: 32
                    onClicked: root.clearLog()
                }

                Button {
                    text: "Reset Stats"
                    type: "text"
                    height: 32
                    onClicked: {
                        activeBackend().resetStatistics()
                        root.resetTrend()
                    }
                }

                Item { Layout.fillWidth: true }
            }
        }
    }
}
