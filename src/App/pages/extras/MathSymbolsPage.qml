import QtQuick
import QtQuick.Layouts
import QtQuick.Dialogs
import QtCore
import md3.Core
import md3.Extras.MathSymbols 1.0

Item {
    id: root
    property string title: "Math Symbols"
    signal backClicked()

    property string formulaText: "E = mc^2\n\\frac{1}{2}mv^2\n\\alpha_1 + \\beta^{2} \\le \\gamma\n\\sqrt{a^2 + b^2}"
    property bool _symbolPanelExpanded: false
    readonly property int _symbolPanelCollapsedHeight: 52
    property int _categoryIndex: 0
    property string _symbolSearch: ""
    property bool _symbolHoverReady: false

    property var _symbolCategories: [
        {
            key: "common",
            name: "Common",
            symbols: [
                { label: "+", insert: "+", keywords: "plus add" },
                { label: "−", insert: "-", keywords: "minus subtract" },
                { label: "=", insert: "=", keywords: "equal" },
                { label: "×", insert: "\\times", keywords: "times multiply" },
                { label: "÷", insert: "\\div", keywords: "divide div" },
                { label: "·", insert: "\\cdot", keywords: "dot cdot" },
                { label: "±", insert: "\\pm", keywords: "plusminus pm" },
                { label: "∓", insert: "\\mp", keywords: "minusplus mp" },
                { label: "≠", insert: "\\neq", keywords: "neq notequal" },
                { label: "≈", insert: "\\approx", keywords: "approx" },
                { label: "≤", insert: "\\le", keywords: "le lessequal" },
                { label: "≥", insert: "\\ge", keywords: "ge greaterequal" },
                { label: "≡", insert: "\\equiv", keywords: "equiv" },
                { label: "∝", insert: "\\propto", keywords: "propto" },
                { label: "∞", insert: "\\infty", keywords: "infty infinity" },
                { label: "∈", insert: "\\in", keywords: "in element" },
                { label: "∉", insert: "\\notin", keywords: "notin" },
                { label: "⊂", insert: "\\subset", keywords: "subset" },
                { label: "⊆", insert: "\\subseteq", keywords: "subseteq" },
                { label: "⊃", insert: "\\supset", keywords: "supset" },
                { label: "⊇", insert: "\\supseteq", keywords: "supseteq" },
                { label: "∪", insert: "\\cup", keywords: "cup union" },
                { label: "∩", insert: "\\cap", keywords: "cap intersection" },
                { label: "∅", insert: "\\emptyset", keywords: "emptyset" },
                { label: "∀", insert: "\\forall", keywords: "forall" },
                { label: "∃", insert: "\\exists", keywords: "exists" },
                { label: "¬", insert: "\\neg", keywords: "neg not" },
                { label: "∧", insert: "\\wedge", keywords: "wedge and" },
                { label: "∨", insert: "\\vee", keywords: "vee or" },
                { label: "→", insert: "\\rightarrow", keywords: "rightarrow" },
                { label: "←", insert: "\\leftarrow", keywords: "leftarrow" },
                { label: "↔", insert: "\\leftrightarrow", keywords: "leftrightarrow" },
                { label: "⇒", insert: "\\Rightarrow", keywords: "Rightarrow implies" },
                { label: "⇐", insert: "\\Leftarrow", keywords: "Leftarrow" },
                { label: "⇔", insert: "\\Leftrightarrow", keywords: "Leftrightarrow iff" },
                { label: "↦", insert: "\\mapsto", keywords: "mapsto" },
                { label: "∠", insert: "\\angle", keywords: "angle" },
                { label: "°", insert: "\\deg", keywords: "deg degree" },
                { label: "ℝ", insert: "\\mathbb{R}", keywords: "mathbb R reals" },
                { label: "ℕ", insert: "\\mathbb{N}", keywords: "mathbb N naturals" },
                { label: "ℤ", insert: "\\mathbb{Z}", keywords: "mathbb Z integers" },
                { label: "ℚ", insert: "\\mathbb{Q}", keywords: "mathbb Q rationals" },
                { label: "ℂ", insert: "\\mathbb{C}", keywords: "mathbb C complex" }
            ]
        },
        {
            key: "greek",
            name: "Greek",
            symbols: [
                { label: "α", insert: "\\alpha", keywords: "alpha" },
                { label: "β", insert: "\\beta", keywords: "beta" },
                { label: "γ", insert: "\\gamma", keywords: "gamma" },
                { label: "δ", insert: "\\delta", keywords: "delta" },
                { label: "ε", insert: "\\epsilon", keywords: "epsilon" },
                { label: "ϵ", insert: "\\varepsilon", keywords: "varepsilon" },
                { label: "ζ", insert: "\\zeta", keywords: "zeta" },
                { label: "η", insert: "\\eta", keywords: "eta" },
                { label: "θ", insert: "\\theta", keywords: "theta" },
                { label: "ϑ", insert: "\\vartheta", keywords: "vartheta" },
                { label: "ι", insert: "\\iota", keywords: "iota" },
                { label: "κ", insert: "\\kappa", keywords: "kappa" },
                { label: "λ", insert: "\\lambda", keywords: "lambda" },
                { label: "μ", insert: "\\mu", keywords: "mu" },
                { label: "ν", insert: "\\nu", keywords: "nu" },
                { label: "ξ", insert: "\\xi", keywords: "xi" },
                { label: "π", insert: "\\pi", keywords: "pi" },
                { label: "ϖ", insert: "\\varpi", keywords: "varpi" },
                { label: "ρ", insert: "\\rho", keywords: "rho" },
                { label: "ϱ", insert: "\\varrho", keywords: "varrho" },
                { label: "σ", insert: "\\sigma", keywords: "sigma" },
                { label: "ς", insert: "\\varsigma", keywords: "varsigma" },
                { label: "τ", insert: "\\tau", keywords: "tau" },
                { label: "φ", insert: "\\phi", keywords: "phi" },
                { label: "ϕ", insert: "\\varphi", keywords: "varphi" },
                { label: "χ", insert: "\\chi", keywords: "chi" },
                { label: "ψ", insert: "\\psi", keywords: "psi" },
                { label: "ω", insert: "\\omega", keywords: "omega" },
                { label: "Γ", insert: "\\Gamma", keywords: "Gamma" },
                { label: "Δ", insert: "\\Delta", keywords: "Delta" },
                { label: "Θ", insert: "\\Theta", keywords: "Theta" },
                { label: "Λ", insert: "\\Lambda", keywords: "Lambda" },
                { label: "Ξ", insert: "\\Xi", keywords: "Xi" },
                { label: "Π", insert: "\\Pi", keywords: "Pi" },
                { label: "Σ", insert: "\\Sigma", keywords: "Sigma" },
                { label: "Φ", insert: "\\Phi", keywords: "Phi" },
                { label: "Ψ", insert: "\\Psi", keywords: "Psi" },
                { label: "Ω", insert: "\\Omega", keywords: "Omega" }
            ]
        },
        {
            key: "frac_diff",
            name: "Fractions & Derivatives",
            symbols: [
                { label: "a⁄b", insert: "\\frac{}{}", keywords: "frac fraction" },
                { label: "d", insert: "\\mathrm{d}", keywords: "mathrm d differential" },
                { label: "∂", insert: "\\partial", keywords: "partial" },
                { label: "∇", insert: "\\nabla", keywords: "nabla" },
                { label: "∇·", insert: "\\nabla \\cdot", keywords: "divergence div" },
                { label: "∇×", insert: "\\nabla \\times", keywords: "curl" }
            ]
        },
        {
            key: "radical_script",
            name: "Radicals & Scripts",
            symbols: [
                { label: "√x", insert: "\\sqrt{}", keywords: "sqrt" },
                { label: "ⁿ√x", insert: "\\sqrt[]{}", keywords: "sqrt nthroot" },
                { label: "x^n", insert: "^{}", keywords: "power superscript" },
                { label: "x_n", insert: "_{}", keywords: "subscript" },
                { label: "x̄", insert: "\\bar{}", keywords: "bar overline" },
                { label: "x⃗", insert: "\\vec{}", keywords: "vec vector" },
                { label: "x̂", insert: "\\hat{}", keywords: "hat" },
                { label: "x̃", insert: "\\tilde{}", keywords: "tilde" }
            ]
        },
        {
            key: "limit_log",
            name: "Limits & Logs",
            symbols: [
                { label: "lim", insert: "\\lim_{} ", keywords: "lim limit" },
                { label: "log", insert: "\\log_{} ", keywords: "log" },
                { label: "ln", insert: "\\ln ", keywords: "ln" },
                { label: "exp", insert: "\\exp ", keywords: "exp" },
                { label: "max", insert: "\\max ", keywords: "max" },
                { label: "min", insert: "\\min ", keywords: "min" },
                { label: "sup", insert: "\\sup ", keywords: "sup" },
                { label: "inf", insert: "\\inf ", keywords: "inf" }
            ]
        },
        {
            key: "trig",
            name: "Trigonometry",
            symbols: [
                { label: "sin", insert: "\\sin ", keywords: "sin" },
                { label: "cos", insert: "\\cos ", keywords: "cos" },
                { label: "tan", insert: "\\tan ", keywords: "tan" },
                { label: "cot", insert: "\\cot ", keywords: "cot" },
                { label: "sec", insert: "\\sec ", keywords: "sec" },
                { label: "csc", insert: "\\csc ", keywords: "csc" },
                { label: "arcsin", insert: "\\arcsin ", keywords: "arcsin" },
                { label: "arccos", insert: "\\arccos ", keywords: "arccos" },
                { label: "arctan", insert: "\\arctan ", keywords: "arctan" },
                { label: "sinh", insert: "\\sinh ", keywords: "sinh" },
                { label: "cosh", insert: "\\cosh ", keywords: "cosh" },
                { label: "tanh", insert: "\\tanh ", keywords: "tanh" }
            ]
        },
        {
            key: "integral",
            name: "Integrals",
            symbols: [
                { label: "∫", insert: "\\int_{}^{} ", keywords: "int integral" },
                { label: "∬", insert: "\\iint_{}^{} ", keywords: "iint doubleintegral" },
                { label: "∭", insert: "\\iiint_{}^{} ", keywords: "iiint tripleintegral" },
                { label: "∮", insert: "\\oint_{}^{} ", keywords: "oint contourintegral" },
                { label: "d x", insert: "\\,\\mathrm{d}x", keywords: "dx differential" }
            ]
        },
        {
            key: "bigop",
            name: "Big Operators",
            symbols: [
                { label: "∑", insert: "\\sum_{}^{} ", keywords: "sum" },
                { label: "∏", insert: "\\prod_{}^{} ", keywords: "prod" },
                { label: "∐", insert: "\\coprod_{}^{} ", keywords: "coprod" },
                { label: "⋃", insert: "\\bigcup_{}^{} ", keywords: "bigcup" },
                { label: "⋂", insert: "\\bigcap_{}^{} ", keywords: "bigcap" },
                { label: "⋁", insert: "\\bigvee_{}^{} ", keywords: "bigvee" },
                { label: "⋀", insert: "\\bigwedge_{}^{} ", keywords: "bigwedge" }
            ]
        },
        {
            key: "bracket",
            name: "Brackets",
            symbols: [
                { label: "( )", insert: "\\left(\\right)", keywords: "parentheses" },
                { label: "[ ]", insert: "\\left[\\right]", keywords: "brackets" },
                { label: "{ }", insert: "\\left\\{\\right\\}", keywords: "braces" },
                { label: "⟨ ⟩", insert: "\\langle\\rangle", keywords: "angle brackets" },
                { label: "| |", insert: "\\left|\\right|", keywords: "abs absolute" },
                { label: "‖ ‖", insert: "\\|\\|", keywords: "norm" },
                { label: "⌊ ⌋", insert: "\\lfloor\\rfloor", keywords: "floor" },
                { label: "⌈ ⌉", insert: "\\lceil\\rceil", keywords: "ceil" }
            ]
        },
        {
            key: "matrix",
            name: "Matrices",
            symbols: [
                { label: "matrix", insert: "\\begin{matrix}  &  \\\\  &  \\end{matrix}", keywords: "matrix" },
                { label: "pmatrix", insert: "\\begin{pmatrix}  &  \\\\  &  \\end{pmatrix}", keywords: "pmatrix" },
                { label: "bmatrix", insert: "\\begin{bmatrix}  &  \\\\  &  \\end{bmatrix}", keywords: "bmatrix" },
                { label: "vmatrix", insert: "\\begin{vmatrix}  &  \\\\  &  \\end{vmatrix}", keywords: "vmatrix determinant" }
            ]
        }
    ]

    property var _activeSymbols: []

    function _normSearch(s) {
        return ("" + (s === undefined || s === null ? "" : s)).toLowerCase().trim()
    }

    function _symbolMatches(sym, q) {
        if (!q || q.length === 0) return true
        var label = (sym.label || "").toLowerCase()
        var insert = (sym.insert || "").toLowerCase()
        var keywords = (sym.keywords || "").toLowerCase()
        return label.indexOf(q) !== -1 || insert.indexOf(q) !== -1 || keywords.indexOf(q) !== -1
    }

    function _rebuildActiveSymbols() {
        var q = _normSearch(root._symbolSearch)
        var list = []
        if (q.length > 0) {
            for (var ci = 0; ci < root._symbolCategories.length; ++ci) {
                var cat = root._symbolCategories[ci]
                for (var si = 0; si < cat.symbols.length; ++si) {
                    var sym = cat.symbols[si]
                    if (_symbolMatches(sym, q)) list.push(sym)
                }
            }
        } else {
            var active = root._symbolCategories[root._categoryIndex]
            list = active ? active.symbols : []
        }
        root._activeSymbols = list
        if (symbolPanelFlick) symbolPanelFlick.contentX = 0
    }

    on_CategoryIndexChanged: _rebuildActiveSymbols()
    on_SymbolSearchChanged: _rebuildActiveSymbols()
    Component.onCompleted: {
        root._symbolPanelExpanded = false
        root._symbolHoverReady = false
        _rebuildActiveSymbols()
        hoverReadyTimer.restart()
    }

    function _insertIntoEditor(s) {
        if (!formulaEdit) return
        var pos = formulaEdit.cursorPosition
        formulaEdit.insert(pos, s)
        formulaEdit.forceActiveFocus()
        formulaEdit.cursorPosition = pos + s.length
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 36
        anchors.rightMargin: 36
        anchors.topMargin: 20
        anchors.bottomMargin: 16 + root._symbolPanelCollapsedHeight
        spacing: 14

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Item {
                width: 44
                height: 44

                Rectangle {
                    anchors.fill: parent
                    radius: 22
                    color: backMouse.containsMouse ? Theme.color.surfaceContainerHigh : Theme.color.surfaceContainerLow

                    Text {
                        anchors.centerIn: parent
                        text: "arrow_back"
                        font.family: Theme.iconFont.name
                        font.pixelSize: 24
                        color: Theme.color.onSurfaceColor
                    }

                    MouseArea {
                        id: backMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.backClicked()
                    }
                }
            }

            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                Layout.minimumWidth: 0

                Text {
                    text: "Math Symbols"
                    font.family: Theme.typography.titleLarge.family
                    font.pixelSize: Theme.typography.titleLarge.size
                    font.weight: Theme.typography.titleLarge.weight
                    color: Theme.color.onSurfaceColor
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                Text {
                    text: "Type formulas on the left, preview on the right."
                    font.family: Theme.typography.bodySmall.family
                    font.pixelSize: Theme.typography.bodySmall.size
                    font.weight: Theme.typography.bodySmall.weight
                    color: Theme.color.onSurfaceVariantColor
                    elide: Text.ElideRight
                    opacity: 0.9
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                spacing: 8

                Button {
                    text: "Basic"
                    icon: "functions"
                    type: "filledTonal"
                    height: 32
                    horizontalPadding: 16
                    onClicked: root.formulaText = "x_1 + x_2 = x_3\n\\pi r^2\n\\alpha + \\beta = \\gamma"
                }

                Button {
                    text: "Physics"
                    icon: "bolt"
                    type: "filledTonal"
                    height: 32
                    horizontalPadding: 16
                    onClicked: root.formulaText = "E = mc^2\n\\frac{1}{2}mv^2\n\\Delta E \\approx \\hbar \\omega"
                }

                Button {
                    text: "Calculus"
                    icon: "show_chart"
                    type: "filledTonal"
                    height: 32
                    horizontalPadding: 16
                    onClicked: root.formulaText = "\\int_a^b f(x) dx\n\\sum_{i=1}^{n} i = \\frac{n(n+1)}{2}\n\\nabla \\cdot \\vec{F} = 0"
                }

                Button {
                    text: "Advanced"
                    icon: "auto_awesome"
                    type: "filledTonal"
                    height: 32
                    horizontalPadding: 16
                    onClicked: root.formulaText =
                               "\\displaystyle \\left( \\sum_{i=1}^{n} i \\right) = \\frac{n(n+1)}{2}\n"
                               + "\\textstyle \\int_{0}^{\\pi} \\sin(x)\\,dx = 2\n"
                               + "\\begin{cases}\n"
                               + "x^2 & x \\ge 0 \\\\\n"
                               + "-x & x < 0\n"
                               + "\\end{cases}\n"
                               + "\\begin{align}\n"
                               + "f(x) &= \\overline{x^2+1} \\\\\n"
                               + "g(x) &= \\underline{\\binom{n}{k}}\n"
                               + "\\end{align}\n"
                               + "100\\%\\,\\_\\,\\#\\,\\$\\,\\&\n"
                               + "a \\overset{def}{=} b \\underset{n\\to\\infty}{\\lim}\n"
                               + "A \\xrightarrow[below]{above} B"
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 14

            Card {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 1
                type: "filled"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 10

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 32
                        spacing: 10

                        Text {
                            text: "Input"
                            color: Theme.color.onSurfaceVariantColor
                            font.family: Theme.typography.titleSmall.family
                            font.pixelSize: Theme.typography.titleSmall.size
                            font.weight: Theme.typography.titleSmall.weight
                            Layout.preferredHeight: 32
                            Layout.minimumHeight: 32
                            Layout.maximumHeight: 32
                            verticalAlignment: Text.AlignVCenter
                        }

                        Item { Layout.fillWidth: true }

                        Button {
                            text: "Clear"
                            icon: "backspace"
                            type: "text"
                            height: 32
                            Layout.preferredHeight: 32
                            Layout.minimumHeight: 32
                            Layout.maximumHeight: 32
                            Layout.alignment: Qt.AlignVCenter
                            horizontalPadding: 12
                            onClicked: root.formulaText = ""
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Theme.color.surfaceContainer
                        radius: 12
                        clip: true
                        border.width: 1
                        border.color: Theme.color.outlineVariant

                        TextEdit {
                            id: formulaEdit
                            anchors.fill: parent
                            anchors.margins: 14
                            text: root.formulaText
                            wrapMode: TextEdit.Wrap
                            color: Theme.color.onSurfaceColor
                            font.family: Theme.typography.bodyLarge.family
                            font.pixelSize: Theme.typography.bodyLarge.size
                            selectByMouse: true
                            onTextChanged: root.formulaText = text
                        }
                    }
                }
            }

            Card {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 1
                type: "filled"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 10

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 32
                        spacing: 10

                        Text {
                            text: "Preview"
                            color: Theme.color.onSurfaceVariantColor
                            font.family: Theme.typography.titleSmall.family
                            font.pixelSize: Theme.typography.titleSmall.size
                            font.weight: Theme.typography.titleSmall.weight
                            Layout.preferredHeight: 32
                            Layout.minimumHeight: 32
                            Layout.maximumHeight: 32
                            verticalAlignment: Text.AlignVCenter
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: root._symbolPanelExpanded ? "Symbols expanded" : "Hover for symbols"
                            color: Theme.color.onSurfaceVariantColor
                            font.family: Theme.typography.bodySmall.family
                            font.pixelSize: Theme.typography.bodySmall.size
                            font.weight: Theme.typography.bodySmall.weight
                            opacity: 0.85
                            Layout.preferredHeight: 32
                            Layout.minimumHeight: 32
                            Layout.maximumHeight: 32
                            verticalAlignment: Text.AlignVCenter
                        }

                        Button {
                            text: "Export SVG"
                            icon: "download"
                            type: "text"
                            height: 32
                            Layout.preferredHeight: 32
                            Layout.minimumHeight: 32
                            Layout.maximumHeight: 32
                            Layout.alignment: Qt.AlignVCenter
                            horizontalPadding: 12
                            onClicked: {
                                exportSvgDialog.selectedFile = exportSvgDialog.currentFolder + "/formula.svg"
                                exportSvgDialog.open()
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Theme.color.surfaceContainer
                        radius: 12
                        clip: true
                        border.width: 1
                        border.color: Theme.color.outlineVariant

                        Flickable {
                            anchors.fill: parent
                            contentWidth: width
                            contentHeight: previewText.implicitHeight + 28
                            clip: true

                            MathText {
                                id: previewText
                                x: 14
                                y: 14
                                width: parent.width - 28
                                formula: root.formulaText
                            }
                        }
                    }
                }
            }
        }
    }

    FileDialog {
        id: exportSvgDialog
        title: "Export SVG"
        nameFilters: ["SVG files (*.svg)"]
        fileMode: FileDialog.SaveFile
        defaultSuffix: "svg"
        currentFolder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        onAccepted: {
            previewText.saveSvg(selectedFile, 2.0)
        }
    }

    Rectangle {
        id: symbolPanel
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 36
        anchors.rightMargin: 36
        anchors.bottomMargin: 12
        height: root._symbolPanelExpanded ? (symbolPanelContent.implicitHeight + 32) : root._symbolPanelCollapsedHeight
        color: Theme.color.surfaceContainerHighest
        radius: 18
        border.width: 1
        border.color: Theme.color.outlineVariant
        clip: true

        Behavior on height { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }

        Timer {
            id: collapseTimer
            interval: 220
            onTriggered: root._symbolPanelExpanded = false
        }

        Timer {
            id: hoverReadyTimer
            interval: 250
            repeat: false
            onTriggered: root._symbolHoverReady = true
        }

        HoverHandler {
            id: symbolPanelHover
            acceptedDevices: PointerDevice.Mouse
            onHoveredChanged: {
                if (!root._symbolHoverReady) return
                if (hovered) {
                    collapseTimer.stop()
                    root._symbolPanelExpanded = true
                } else {
                    collapseTimer.restart()
                }
            }
        }

        ColumnLayout {
            id: symbolPanelContent
            anchors.fill: parent
            anchors.margins: 16
            spacing: 10

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Text {
                    text: "Symbols"
                    color: Theme.color.onSurfaceVariantColor
                    font.family: Theme.typography.titleSmall.family
                    font.pixelSize: Theme.typography.titleSmall.size
                    font.weight: Theme.typography.titleSmall.weight
                }

                Text {
                    visible: root._symbolPanelExpanded
                    text: root._normSearch(root._symbolSearch).length > 0 ? ("Search: " + root._symbolSearch) : (root._symbolCategories[root._categoryIndex] ? root._symbolCategories[root._categoryIndex].name : "")
                    color: Theme.color.onSurfaceVariantColor
                    font.family: Theme.typography.bodySmall.family
                    font.pixelSize: Theme.typography.bodySmall.size
                    font.weight: Theme.typography.bodySmall.weight
                    opacity: 0.8
                    elide: Text.ElideRight
                }

                Item { Layout.fillWidth: true }

                Text {
                    visible: !root._symbolPanelExpanded
                    text: "Hover to expand"
                    color: Theme.color.onSurfaceVariantColor
                    opacity: 0.8
                    font.family: Theme.typography.bodySmall.family
                    font.pixelSize: Theme.typography.bodySmall.size
                    font.weight: Theme.typography.bodySmall.weight
                }
            }

            Rectangle {
                id: searchBox
                visible: root._symbolPanelExpanded
                Layout.fillWidth: true
                Layout.preferredHeight: 36
                radius: 18
                color: Theme.color.surfaceContainerHigh
                border.width: 1
                border.color: Theme.color.outlineVariant

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 10
                    spacing: 8

                    Text {
                        text: "search"
                        font.family: Theme.iconFont.name
                        font.pixelSize: 18
                        color: Theme.color.onSurfaceVariantColor
                    }

                    TextInput {
                        id: symbolSearchInput
                        Layout.fillWidth: true
                        text: root._symbolSearch
                        color: Theme.color.onSurfaceColor
                        font.family: Theme.typography.bodyMedium.family
                        font.pixelSize: Theme.typography.bodyMedium.size
                        verticalAlignment: TextInput.AlignVCenter
                        clip: true
                        selectByMouse: true
                        onTextChanged: root._symbolSearch = text
                    }

                    Item {
                        width: 18
                        height: 18
                        visible: root._symbolSearch.length > 0

                        Text {
                            anchors.centerIn: parent
                            text: "close"
                            font.family: Theme.iconFont.name
                            font.pixelSize: 18
                            color: Theme.color.onSurfaceVariantColor
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root._symbolSearch = ""
                                symbolSearchInput.forceActiveFocus()
                            }
                        }
                    }
                }
            }

            Flickable {
                id: categoryFlick
                visible: root._symbolPanelExpanded
                Layout.fillWidth: true
                Layout.preferredHeight: 34
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                contentHeight: 34
                contentWidth: categoryRow.implicitWidth

                Row {
                    id: categoryRow
                    height: 34
                    spacing: 8

                    Repeater {
                        model: root._symbolCategories
                        delegate: Rectangle {
                            required property var modelData
                            required property int index

                            height: 34
                            radius: 17
                            color: root._categoryIndex === index ? Theme.color.secondaryContainer : Theme.color.surfaceContainer
                            border.width: 1
                            border.color: root._categoryIndex === index ? "transparent" : Theme.color.outlineVariant
                            opacity: root._normSearch(root._symbolSearch).length > 0 ? 0.55 : 1

                            implicitWidth: Math.max(64, labelText.implicitWidth + 22)

                            Text {
                                id: labelText
                                anchors.centerIn: parent
                                text: modelData.name
                                color: Theme.color.onSurfaceColor
                                font.family: Theme.typography.bodyMedium.family
                                font.pixelSize: Theme.typography.bodyMedium.size
                                font.weight: Theme.typography.bodyMedium.weight
                                elide: Text.ElideRight
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                enabled: root._normSearch(root._symbolSearch).length === 0
                                onClicked: {
                                    root._categoryIndex = index
                                }
                            }
                        }
                    }
                }
            }

            Flickable {
                id: symbolPanelFlick
                Layout.fillWidth: true
                Layout.preferredHeight: contentHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                interactive: true

                property int rows: {
                    var n = root._activeSymbols.length
                    if (n <= 10) return 1
                    if (n <= 20) return 2
                    return 3
                }
                property int cellW: 58
                property int cellH: 44
                property int spacing: 8
                property int cols: Math.ceil(root._activeSymbols.length / rows)

                contentWidth: Math.max(width, cols * (cellW + spacing) - spacing)
                contentHeight: rows * (cellH + spacing) - spacing

                Repeater {
                    model: root._activeSymbols
                    delegate: Rectangle {
                        required property var modelData
                        required property int index

                        readonly property int row: index % symbolPanelFlick.rows
                        readonly property int col: Math.floor(index / symbolPanelFlick.rows)

                        x: col * (symbolPanelFlick.cellW + symbolPanelFlick.spacing)
                        y: row * (symbolPanelFlick.cellH + symbolPanelFlick.spacing)
                        width: symbolPanelFlick.cellW
                        height: symbolPanelFlick.cellH
                        radius: 14
                        color: chipMouse.containsMouse ? Theme.color.secondaryContainer : Theme.color.surfaceContainer
                        border.width: 1
                        border.color: chipMouse.containsMouse ? "transparent" : Theme.color.outlineVariant

                        Text {
                            anchors.centerIn: parent
                            text: modelData.label
                            color: Theme.color.onSurfaceColor
                            font.family: Theme.typography.titleMedium.family
                            font.pixelSize: Theme.typography.titleMedium.size
                            font.weight: Theme.typography.titleMedium.weight
                        }

                        MouseArea {
                            id: chipMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                var ins = modelData.insert
                                root._insertIntoEditor(ins)
                            }
                        }
                    }
                }
            }
        }
    }
}
