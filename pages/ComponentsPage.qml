import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import md3
import "../components" as Md3

Item {
    anchors.fill: parent



    Flickable {
        id: flickable
        anchors.fill: parent
        anchors.rightMargin: 48 // Make room for scrollbar
        contentWidth: width
        contentHeight: contentLayout.implicitHeight + 64
        clip: true

        ColumnLayout {
            id: contentLayout
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 32
            spacing: 32

            Text {
                text: "Buttons"
                font.pixelSize: Theme.typography.headlineMedium.size
                color: Theme.color.onSurfaceColor
                Layout.alignment: Qt.AlignHCenter
            }

            GridLayout {
                columns: 3
                rowSpacing: 24
                columnSpacing: 24
                Layout.alignment: Qt.AlignHCenter

                // Headers (Optional, but helps clarify)
                Text { text: "Text Only"; color: Theme.color.onSurfaceColor; font.pixelSize: 14; horizontalAlignment: Text.AlignHCenter; Layout.alignment: Qt.AlignHCenter }
                Text { text: "With Icon"; color: Theme.color.onSurfaceColor; font.pixelSize: 14; horizontalAlignment: Text.AlignHCenter; Layout.alignment: Qt.AlignHCenter }
                Text { text: "Disabled"; color: Theme.color.onSurfaceColor; font.pixelSize: 14; horizontalAlignment: Text.AlignHCenter; Layout.alignment: Qt.AlignHCenter }

                // Row 1: Elevated
                Md3.Button { text: "Elevated"; type: "elevated"; Layout.alignment: Qt.AlignHCenter }
                Md3.Button { text: "Icon"; icon: "add"; type: "elevated"; Layout.alignment: Qt.AlignHCenter }
                Md3.Button { text: "Elevated"; type: "elevated"; enabled: false; Layout.alignment: Qt.AlignHCenter }

                // Row 2: Filled
                Md3.Button { text: "Filled"; type: "filled"; Layout.alignment: Qt.AlignHCenter }
                Md3.Button { text: "Icon"; icon: "add"; type: "filled"; Layout.alignment: Qt.AlignHCenter }
                Md3.Button { text: "Filled"; type: "filled"; enabled: false; Layout.alignment: Qt.AlignHCenter }

                // Row 3: Filled Tonal
                Md3.Button { text: "Filled tonal"; type: "filledTonal"; Layout.alignment: Qt.AlignHCenter }
                Md3.Button { text: "Icon"; icon: "add"; type: "filledTonal"; Layout.alignment: Qt.AlignHCenter }
                Md3.Button { text: "Filled tonal"; type: "filledTonal"; enabled: false; Layout.alignment: Qt.AlignHCenter }

                // Row 4: Outlined
                Md3.Button { text: "Outlined"; type: "outlined"; Layout.alignment: Qt.AlignHCenter }
                Md3.Button { text: "Icon"; icon: "add"; type: "outlined"; Layout.alignment: Qt.AlignHCenter }
                Md3.Button { text: "Outlined"; type: "outlined"; enabled: false; Layout.alignment: Qt.AlignHCenter }

                // Row 5: Text
                Md3.Button { text: "Text"; type: "text"; Layout.alignment: Qt.AlignHCenter }
                Md3.Button { text: "Icon"; icon: "add"; type: "text"; Layout.alignment: Qt.AlignHCenter }
                Md3.Button { text: "Text"; type: "text"; enabled: false; Layout.alignment: Qt.AlignHCenter }
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                Layout.alignment: Qt.AlignHCenter
                height: 1
                color: Theme.color.outlineVariant
            }


            // FAB Section
            Text {
                text: "Floating Action Buttons"
                font.pixelSize: Theme.typography.headlineSmall.size
                color: Theme.color.onSurfaceColor
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                spacing: 48
                
                // Small
                ColumnLayout {
                    spacing: 12
                    Layout.alignment: Qt.AlignBottom
                    Md3.FAB { type: "small"; icon: "add"; Layout.alignment: Qt.AlignHCenter }
                    Text { text: "Small"; color: Theme.color.onSurfaceVariantColor; Layout.alignment: Qt.AlignHCenter }
                }

                // Standard
                ColumnLayout {
                    spacing: 12
                    Layout.alignment: Qt.AlignBottom
                    Md3.FAB { type: "standard"; icon: "add"; Layout.alignment: Qt.AlignHCenter }
                    Text { text: "Standard"; color: Theme.color.onSurfaceVariantColor; Layout.alignment: Qt.AlignHCenter }
                }

                // Large
                ColumnLayout {
                    spacing: 12
                    Layout.alignment: Qt.AlignBottom
                    Md3.FAB { type: "large"; icon: "add"; Layout.alignment: Qt.AlignHCenter }
                    Text { text: "Large"; color: Theme.color.onSurfaceVariantColor; Layout.alignment: Qt.AlignHCenter }
                }

                // Extended
                ColumnLayout {
                    spacing: 12
                    Layout.alignment: Qt.AlignBottom
                    Md3.FAB { type: "extended"; icon: "add"; text: "Create"; Layout.alignment: Qt.AlignHCenter }
                    Text { text: "Extended"; color: Theme.color.onSurfaceVariantColor; Layout.alignment: Qt.AlignHCenter }
                }
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                Layout.alignment: Qt.AlignHCenter
                height: 1
                color: Theme.color.outlineVariant
            }

            // Icon Buttons Section
            Text {
                text: "Icon Buttons"
                font.pixelSize: Theme.typography.headlineSmall.size
                color: Theme.color.onSurfaceColor
                Layout.alignment: Qt.AlignHCenter
            }

            GridLayout {
                columns: 4
                rowSpacing: 24
                columnSpacing: 48
                Layout.alignment: Qt.AlignHCenter

                // Row 1: Enabled
                ColumnLayout {
                    spacing: 12
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    Md3.IconButton { type: "filled"; icon: "settings"; Layout.alignment: Qt.AlignHCenter }
                    Text { text: "Filled"; color: Theme.color.onSurfaceVariantColor; Layout.alignment: Qt.AlignHCenter }
                }

                ColumnLayout {
                    spacing: 12
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    Md3.IconButton { type: "filledTonal"; icon: "settings"; Layout.alignment: Qt.AlignHCenter }
                    Text { text: "Filled Tonal"; color: Theme.color.onSurfaceVariantColor; Layout.alignment: Qt.AlignHCenter }
                }

                ColumnLayout {
                    spacing: 12
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    Md3.IconButton { type: "outlined"; icon: "settings"; Layout.alignment: Qt.AlignHCenter }
                    Text { text: "Outlined"; color: Theme.color.onSurfaceVariantColor; Layout.alignment: Qt.AlignHCenter }
                }

                ColumnLayout {
                    spacing: 12
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    Md3.IconButton { type: "standard"; icon: "settings"; Layout.alignment: Qt.AlignHCenter }
                    Text { text: "Standard"; color: Theme.color.onSurfaceVariantColor; Layout.alignment: Qt.AlignHCenter }
                }

                // Row 2: Disabled
                ColumnLayout {
                    spacing: 12
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    Md3.IconButton { type: "filled"; icon: "settings"; enabled: false; Layout.alignment: Qt.AlignHCenter }
                    Text { text: "Disabled"; color: Theme.color.onSurfaceColor; opacity: 0.38; Layout.alignment: Qt.AlignHCenter }
                }

                ColumnLayout {
                    spacing: 12
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    Md3.IconButton { type: "filledTonal"; icon: "settings"; enabled: false; Layout.alignment: Qt.AlignHCenter }
                    Text { text: "Disabled"; color: Theme.color.onSurfaceColor; opacity: 0.38; Layout.alignment: Qt.AlignHCenter }
                }

                ColumnLayout {
                    spacing: 12
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    Md3.IconButton { type: "outlined"; icon: "settings"; enabled: false; Layout.alignment: Qt.AlignHCenter }
                    Text { text: "Disabled"; color: Theme.color.onSurfaceColor; opacity: 0.38; Layout.alignment: Qt.AlignHCenter }
                }

                ColumnLayout {
                    spacing: 12
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    Md3.IconButton { type: "standard"; icon: "settings"; enabled: false; Layout.alignment: Qt.AlignHCenter }
                    Text { text: "Disabled"; color: Theme.color.onSurfaceColor; opacity: 0.38; Layout.alignment: Qt.AlignHCenter }
                }
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                Layout.alignment: Qt.AlignHCenter
                height: 1
                color: Theme.color.outlineVariant
            }

            // Segmented Buttons Section
            Text {
                text: "Segmented Buttons"
                font.pixelSize: Theme.typography.headlineSmall.size
                color: Theme.color.onSurfaceColor
                Layout.alignment: Qt.AlignHCenter
            }

            ColumnLayout {
                spacing: 24
                Layout.alignment: Qt.AlignHCenter

                // Single Select
                ColumnLayout {
                    spacing: 12
                    Layout.alignment: Qt.AlignHCenter
                    Md3.SegmentedButton {
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text { text: "Single Select"; color: Theme.color.onSurfaceVariantColor; Layout.alignment: Qt.AlignHCenter }
                }

                // Multi Select
                ColumnLayout {
                    spacing: 12
                    Layout.alignment: Qt.AlignHCenter
                    Md3.SegmentedButton {
                        multiSelect: true
                        buttons: [
                            { text: "XS", selected: false },
                            { text: "S", selected: true },
                            { text: "M", selected: true },
                            { text: "L", selected: true },
                            { text: "XL", selected: false }
                        ]
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text { text: "Multi Select"; color: Theme.color.onSurfaceVariantColor; Layout.alignment: Qt.AlignHCenter }
                }
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                Layout.alignment: Qt.AlignHCenter
                height: 1
                color: Theme.color.outlineVariant
            }

            // Chips Section
            Text {
                text: "Chips"
                font.pixelSize: Theme.typography.headlineSmall.size
                color: Theme.color.onSurfaceColor
                Layout.alignment: Qt.AlignHCenter
            }

            Flow {
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                Layout.alignment: Qt.AlignHCenter
                spacing: 8
                
                Md3.Chip { text: "Assist"; icon: "event" }
                Md3.Chip { text: "Filter"; type: "filter"; selected: true }
                Md3.Chip { text: "Input"; type: "input"; showCloseIcon: true; onCloseClicked: console.log("Close clicked") }
                Md3.Chip { text: "Suggestion"; type: "suggestion" }
                
                Md3.Chip { text: "Assist"; icon: "event"; enabled: false }
                Md3.Chip { text: "Filter"; type: "filter"; selected: true; enabled: false }
                Md3.Chip { text: "Input"; type: "input"; showCloseIcon: true; enabled: false }
                Md3.Chip { text: "Suggestion"; type: "suggestion"; enabled: false }
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                Layout.alignment: Qt.AlignHCenter
                height: 1
                color: Theme.color.outlineVariant
            }

            // Checkboxes Section
            Text {
                text: "Checkboxes"
                font.pixelSize: Theme.typography.headlineSmall.size
                color: Theme.color.onSurfaceColor
                Layout.alignment: Qt.AlignHCenter
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 0
                Layout.fillWidth: true
                Layout.maximumWidth: 300

                Md3.Checkbox {
                    text: "Option 1"
                    checked: true
                    Layout.fillWidth: true
                }

                Md3.Checkbox {
                    text: "Option 2"
                    indeterminate: true
                    Layout.fillWidth: true
                }

                Md3.Checkbox {
                    text: "Option 3"
                    checked: false
                    Layout.fillWidth: true
                }

                Md3.Checkbox {
                    text: "Option 4"
                    checked: true
                    enabled: false
                    Layout.fillWidth: true
                }
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                Layout.alignment: Qt.AlignHCenter
                height: 1
                color: Theme.color.outlineVariant
            }

            // Radio Buttons Section
            Text {
                text: "Radio Buttons"
                font.pixelSize: Theme.typography.headlineSmall.size
                color: Theme.color.onSurfaceColor
                Layout.alignment: Qt.AlignHCenter
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 0
                Layout.fillWidth: true
                Layout.maximumWidth: 300

                Md3.RadioButton {
                    text: "Radio Option 1"
                    checked: true
                    Layout.fillWidth: true
                    onClicked: {
                        // Manual exclusive logic for demo
                        checked = true
                        radioOption2.checked = false
                        radioOption3.checked = false
                    }
                }

                Md3.RadioButton {
                    id: radioOption2
                    text: "Radio Option 2"
                    checked: false
                    Layout.fillWidth: true
                    onClicked: {
                        checked = true
                        parent.children[0].checked = false // option 1
                        radioOption3.checked = false
                    }
                }

                Md3.RadioButton {
                    id: radioOption3
                    text: "Radio Option 3"
                    checked: false
                    Layout.fillWidth: true
                    onClicked: {
                        checked = true
                        parent.children[0].checked = false // option 1
                        radioOption2.checked = false
                    }
                }

                Md3.RadioButton {
                    text: "Radio Option 4 (Disabled)"
                    checked: true
                    enabled: false
                    Layout.fillWidth: true
                }
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                Layout.alignment: Qt.AlignHCenter
                height: 1
                color: Theme.color.outlineVariant
            }

            // Switches Section
            Text {
                text: "Switches"
                font.pixelSize: Theme.typography.headlineSmall.size
                color: Theme.color.onSurfaceColor
                Layout.alignment: Qt.AlignHCenter
            }

            GridLayout {
                columns: 2
                columnSpacing: 48
                rowSpacing: 24
                Layout.alignment: Qt.AlignHCenter
                
                // Column 1: Enabled
                ColumnLayout {
                    spacing: 16
                    Layout.alignment: Qt.AlignTop
                    
                    Md3.Switch {
                        text: "Off"
                        checked: false
                    }
                    
                    Md3.Switch {
                        text: "On"
                        checked: true
                    }
                }
                
                // Column 2: Disabled
                ColumnLayout {
                    spacing: 16
                    Layout.alignment: Qt.AlignTop
                    
                    Md3.Switch {
                        text: "Disabled Off"
                        checked: false
                        enabled: false
                    }
                    
                    Md3.Switch {
                        text: "Disabled On"
                        checked: true
                        enabled: false
                    }
                }
            }
            
            // Divider
            Rectangle {
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                Layout.alignment: Qt.AlignHCenter
                height: 1
                color: Theme.color.outlineVariant
            }

            // Menus Section
            Text {
                text: "Menus"
                font.pixelSize: Theme.typography.headlineSmall.size
                color: Theme.color.onSurfaceColor
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 24
                
                Md3.Button {
                    id: menuButton
                    text: "Show Menu"
                    type: "filled"
                    onClicked: demoMenu.open(menuButton, 0, menuButton.height)
                }
                
                Md3.Menu {
                    id: demoMenu
                    model: [
                        { text: "Item 1", icon: "settings", action: function() { console.log("Item 1 clicked") } },
                        { 
                             text: "Sub Menu", 
                             icon: "folder",
                             subItems: [
                                 { text: "Sub Item 1" },
                                 { text: "Sub Item 2" }
                             ]
                        },
                        { type: "separator" },
                        { text: "Item 2", trailingText: "Ctrl+C", enabled: false },
                        { text: "Item 3", trailingIcon: "chevron_right" }
                    ]
                }
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                Layout.alignment: Qt.AlignHCenter
                height: 1
                color: Theme.color.outlineVariant
            }

            // ComboBox Section
            Text {
                text: "ComboBox"
                font.pixelSize: Theme.typography.headlineSmall.size
                color: Theme.color.onSurfaceColor
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 24
                
                Md3.ComboBox {
                    label: "Color"
                    type: "filled"
                    model: ["Red", "Green", "Blue", "Yellow"]
                    currentIndex: 3
                }
                
                Md3.ComboBox {
                    label: "Icon"
                    type: "outlined"
                    leadingIcon: "search"
                    model: ["Brush", "Pen", "Eraser", "Bucket"]
                    currentIndex: 0
                }
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                Layout.alignment: Qt.AlignHCenter
                height: 1
                color: Theme.color.outlineVariant
            }

            // Sliders Section
            Text {
                text: "Sliders"
                font.pixelSize: Theme.typography.headlineSmall.size
                color: Theme.color.onSurfaceColor
                Layout.alignment: Qt.AlignHCenter
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 24
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                
                // Continuous
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16
                    Text {
                        text: "Continuous"
                        font.family: Theme.typography.labelLarge.family
                        font.pixelSize: Theme.typography.labelLarge.size
                        color: Theme.color.onSurfaceColor
                        Layout.preferredWidth: 120
                        horizontalAlignment: Text.AlignRight
                    }
                    Md3.Slider {
                        Layout.fillWidth: true
                        value: 0.5
                    }
                }
                
                // Discrete (Steps)
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16
                    Text {
                        text: "Discrete"
                        font.family: Theme.typography.labelLarge.family
                        font.pixelSize: Theme.typography.labelLarge.size
                        color: Theme.color.onSurfaceColor
                        Layout.preferredWidth: 120
                        horizontalAlignment: Text.AlignRight
                    }
                    Md3.Slider {
                        Layout.fillWidth: true
                        value: 0.2
                        stepSize: 0.2
                        snapMode: true
                        tickMarksEnabled: true
                    }
                }
                
                // Labeled
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16
                    Text {
                        text: "Labeled"
                        font.family: Theme.typography.labelLarge.family
                        font.pixelSize: Theme.typography.labelLarge.size
                        color: Theme.color.onSurfaceColor
                        Layout.preferredWidth: 120
                        horizontalAlignment: Text.AlignRight
                    }
                    Md3.Slider {
                        Layout.fillWidth: true
                        value: 0.5
                        valueLabelEnabled: true
                    }
                }
                
                // Range Slider
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16
                    Text {
                        text: "Range"
                        font.family: Theme.typography.labelLarge.family
                        font.pixelSize: Theme.typography.labelLarge.size
                        color: Theme.color.onSurfaceColor
                        Layout.preferredWidth: 120
                        horizontalAlignment: Text.AlignRight
                    }
                    Md3.RangeSlider {
                        Layout.fillWidth: true
                    }
                }
                
                // Range with Labels
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16
                    Text {
                        text: "Range Labels"
                        font.family: Theme.typography.labelLarge.family
                        font.pixelSize: Theme.typography.labelLarge.size
                        color: Theme.color.onSurfaceColor
                        Layout.preferredWidth: 120
                        horizontalAlignment: Text.AlignRight
                    }
                    Md3.RangeSlider {
                        Layout.fillWidth: true
                        firstValue: 0.2
                        secondValue: 0.8
                        valueLabelEnabled: true
                    }
                }
                
                // Range with Ticks
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16
                    Text {
                        text: "Range Ticks"
                        font.family: Theme.typography.labelLarge.family
                        font.pixelSize: Theme.typography.labelLarge.size
                        color: Theme.color.onSurfaceColor
                        Layout.preferredWidth: 120
                        horizontalAlignment: Text.AlignRight
                    }
                    Md3.RangeSlider {
                        Layout.fillWidth: true
                        stepSize: 0.1
                        snapMode: true
                        tickMarksEnabled: true
                        firstValue: 0.3
                        secondValue: 0.7
                    }
                }
                
                // Disabled
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16
                    Text {
                        text: "Disabled"
                        font.family: Theme.typography.labelLarge.family
                        font.pixelSize: Theme.typography.labelLarge.size
                        color: Theme.color.onSurfaceColor
                        Layout.preferredWidth: 120
                        horizontalAlignment: Text.AlignRight
                    }
                    Md3.Slider {
                        Layout.fillWidth: true
                        value: 0.3
                        enabled: false
                    }
                }
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                Layout.alignment: Qt.AlignHCenter
                height: 1
                color: Theme.color.outlineVariant
            }

            // Text Fields Section
            Text {
                text: "Text Fields"
                font.pixelSize: Theme.typography.headlineSmall.size
                color: Theme.color.onSurfaceColor
                Layout.alignment: Qt.AlignHCenter
            }

            GridLayout {
                columns: 2
                rowSpacing: 24
                columnSpacing: 24
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                Layout.maximumWidth: 600

                // Filled
                Md3.TextField {
                    type: "filled"
                    label: "Filled"
                    placeholderText: "Filled input"
                    Layout.fillWidth: true
                }

                // Outlined
                Md3.TextField {
                    type: "outlined"
                    label: "Outlined"
                    placeholderText: "Outlined input"
                    Layout.fillWidth: true
                }

                // With Icon
                Md3.TextField {
                    type: "filled"
                    label: "Search"
                    leadingIcon: "search"
                    trailingIcon: "close"
                    Layout.fillWidth: true
                    onTrailingIconClicked: text = ""
                }

                // Password
                Md3.TextField {
                    type: "outlined"
                    label: "Password"
                    isPassword: true
                    Layout.fillWidth: true
                }

                // Error
                Md3.TextField {
                    type: "filled"
                    label: "Error"
                    errorText: "Error message"
                    text: "Invalid input"
                    Layout.fillWidth: true
                }

                // Disabled
                Md3.TextField {
                    type: "outlined"
                    label: "Disabled"
                    enabled: false
                    text: "Disabled"
                    Layout.fillWidth: true
                }
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                Layout.alignment: Qt.AlignHCenter
                height: 1
                color: Theme.color.outlineVariant
            }

            // Dialogs Section
            Text {
                text: "Dialogs"
                font.pixelSize: Theme.typography.headlineSmall.size
                color: Theme.color.onSurfaceColor
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 16

                Md3.Button {
                    text: "Show Dialog"
                    onClicked: basicDialog.open()
                }

                Md3.Button {
                    text: "Dialog with Icon"
                    type: "tonal"
                    onClicked: iconDialog.open()
                }
            }
            
            // Dialog Instances
            Md3.Dialog {
                id: basicDialog
                title: "Basic Dialog"
                text: "This is a basic dialog with a title and supporting text. It asks for a decision."
                onAccepted: console.log("Accepted")
                onRejected: console.log("Rejected")
            }
            
            // Picker Instances
            Md3.Dialog {
                id: iconDialog
                icon: "info"
                title: "Dialog with Icon"
                text: "This dialog features a hero icon at the top to reinforce the message."
                acceptText: "Confirm"
                showRejectButton: false
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                Layout.alignment: Qt.AlignHCenter
                height: 1
                color: Theme.color.outlineVariant
            }

            // Pickers Section
            Text {
                text: "Pickers"
                font.pixelSize: Theme.typography.headlineSmall.size
                color: Theme.color.onSurfaceColor
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 16

                Md3.Button {
                    text: "Date Picker"
                    onClicked: datePicker.open()
                }

                Md3.Button {
                    text: "Time Picker"
                    onClicked: timePicker.open()
                }
            }
            
            Text {
                text: "Selected: " + Qt.formatDate(datePicker.selectedDate, "yyyy-MM-dd") + " " + 
                      timePicker.hour.toString().padStart(2, '0') + ":" + timePicker.minute.toString().padStart(2, '0')
                color: Theme.color.onSurfaceVariantColor
                Layout.alignment: Qt.AlignHCenter
            }

            // Picker Instances
            Md3.DatePicker {
                id: datePicker
                onAccepted: (date) => console.log("Date selected:", date)
            }

            Md3.TimePicker {
                id: timePicker
                onAccepted: (h, m) => console.log("Time selected:", h, m)
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                Layout.alignment: Qt.AlignHCenter
                height: 1
                color: Theme.color.outlineVariant
            }

            // Progress Section
            Text {
                text: "Progress Indicators"
                font.pixelSize: Theme.typography.headlineSmall.size
                color: Theme.color.onSurfaceColor
                Layout.alignment: Qt.AlignHCenter
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                spacing: 24
                
                // Controls
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 16
                    
                    Text {
                        text: "Play Animation"
                        color: Theme.color.onSurfaceColor
                        font.family: Theme.typography.labelLarge.family
                    }
                    
                    Md3.Switch {
                        id: progressSwitch
                        checked: false
                    }
                }
                
                // Linear
                Md3.LinearProgress {
                    Layout.fillWidth: true
                    value: 0.7
                    indeterminate: progressSwitch.checked
                }
                
                // Circular
                Md3.CircularProgress {
                    Layout.alignment: Qt.AlignHCenter
                    value: 0.75
                    indeterminate: progressSwitch.checked
                }

                // Wavy Progress
                Text { 
                    text: "Wavy Progress" 
                    color: Theme.color.onSurfaceVariantColor 
                    font.family: Theme.typography.labelLarge.family
                    Layout.topMargin: 16
                }

                // Wavy Linear
                Md3.LinearProgress {
                    Layout.fillWidth: true
                    value: 0.5
                    wavy: true
                    indeterminate: progressSwitch.checked
                }
                
                // Wavy Circular
                Md3.CircularProgress {
                    Layout.alignment: Qt.AlignHCenter
                    value: 0.75
                    wavy: true
                    indeterminate: progressSwitch.checked
                }
                
                // Loading Indicator (New)
                Text { 
                    text: "Loading Indicator (MD3)" 
                    color: Theme.color.onSurfaceVariantColor 
                    font.family: Theme.typography.labelLarge.family
                    Layout.topMargin: 16
                }
                
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 32
                    
                    // Standard
                    Md3.LoadingIndicator {
                        running: progressSwitch.checked
                    }
                    
                    // With Container
                    Md3.LoadingIndicator {
                        running: progressSwitch.checked
                        withContainer: true
                    }
                    
                    // Custom Color
                    Md3.LoadingIndicator {
                        running: progressSwitch.checked
                        color: Theme.color.tertiary
                    }
                    
                    // In Button
                    Md3.Button {
                        type: "outlined"
                        contentItem: RowLayout {
                            spacing: 8
                            Md3.LoadingIndicator {
                                Layout.preferredWidth: 18
                                Layout.preferredHeight: 18
                                running: progressSwitch.checked
                            }
                            Text {
                                text: "Loading..."
                                color: Theme.color.primary
                                font.family: Theme.typography.labelLarge.family
                            }
                        }
                    }
                }
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                Layout.alignment: Qt.AlignHCenter
                height: 1
                color: Theme.color.outlineVariant
            }

            // Cards Section
            Text {
                text: "Cards"
                font.pixelSize: Theme.typography.headlineSmall.size
                color: Theme.color.onSurfaceColor
                Layout.alignment: Qt.AlignHCenter
            }

            Item {
                Layout.fillWidth: true
                Layout.maximumWidth: 700
                Layout.alignment: Qt.AlignHCenter
                implicitHeight: cardFlow.implicitHeight

                Flow {
                    id: cardFlow
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 24
                    
                    // Dynamic width calculation for centering
                    property int itemW: 200
                    property int sp: 24
                    property int cols: Math.max(1, Math.floor((parent.width + sp) / (itemW + sp)))
                    width: cols * itemW + (cols - 1) * sp

                    // Elevated Card
                    Md3.Card {
                    type: "elevated"
                    width: 200; height: 200
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        
                        Item { Layout.fillHeight: true } // Spacer
                        
                        Text { 
                            text: "Elevated"
                            font.pixelSize: Theme.typography.titleMedium.size
                            font.family: Theme.typography.titleMedium.family
                            font.bold: true
                            color: Theme.color.onSurfaceColor 
                        }
                    }
                    
                    // Menu Icon (Visual only)
                    Text {
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.margins: 16
                        text: "more_vert" // Material Icon
                        font.family: Theme.iconFont.name
                        font.pixelSize: 24
                        color: Theme.color.onSurfaceColor
                    }
                }

                // Filled Card
                Md3.Card {
                    type: "filled"
                    width: 200; height: 200

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        
                        Item { Layout.fillHeight: true } // Spacer
                        
                        Text { 
                            text: "Filled"
                            font.pixelSize: Theme.typography.titleMedium.size
                            font.family: Theme.typography.titleMedium.family
                            font.bold: true
                            color: Theme.color.onSurfaceColor 
                        }
                    }
                    
                    Text {
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.margins: 16
                        text: "more_vert"
                        font.family: Theme.iconFont.name
                        font.pixelSize: 24
                        color: Theme.color.onSurfaceColor
                    }
                }

                // Outlined Card
                Md3.Card {
                    type: "outlined"
                    width: 200; height: 200

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        
                        Item { Layout.fillHeight: true } // Spacer
                        
                        Text { 
                            text: "Outlined"
                            font.pixelSize: Theme.typography.titleMedium.size
                            font.family: Theme.typography.titleMedium.family
                            font.bold: true
                            color: Theme.color.onSurfaceColor 
                        }
                    }
                    
                    Text {
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.margins: 16
                        text: "more_vert"
                        font.family: Theme.iconFont.name
                        font.pixelSize: 24
                        color: Theme.color.onSurfaceColor
                    }
                }
            }
        }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                Layout.alignment: Qt.AlignHCenter
                height: 1
                color: Theme.color.outlineVariant
            }

            // Carousel Section
            Text {
                text: "Carousel"
                font.pixelSize: Theme.typography.headlineSmall.size
                color: Theme.color.onSurfaceColor
                Layout.alignment: Qt.AlignHCenter
            }

            // Multi-browse Carousel
            Text {
                text: "Multi-browse"
                font.pixelSize: Theme.typography.titleMedium.size
                color: Theme.color.onSurfaceVariantColor
                Layout.alignment: Qt.AlignHCenter
            }
            
            Md3.Carousel {
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                Layout.alignment: Qt.AlignHCenter
                itemWidth: 200
                itemHeight: 120
                spacing: 16
                type: "multi-browse"
                
                model: 10
                delegate: Md3.Card {
                    width: 200
                    height: 120
                    type: "filled"
                    property int index: 0
                    color: index % 2 === 0 ? Theme.color.surfaceContainerHigh : Theme.color.surfaceContainer
                    
                    Text {
                        anchors.centerIn: parent
                        text: "Item " + (parent.index + 1)
                        color: Theme.color.onSurfaceColor
                    }
                }
            }

            // Hero Carousel (With Parallax)
            Text {
                text: "Hero & Parallax"
                font.pixelSize: Theme.typography.titleMedium.size
                color: Theme.color.onSurfaceVariantColor
                Layout.alignment: Qt.AlignHCenter
            }

            Md3.Carousel {
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                Layout.alignment: Qt.AlignHCenter
                itemWidth: 280
                itemHeight: 200
                spacing: 16
                type: "hero"
                
                model: 5
                delegate: Md3.Card {
                    width: 280
                    height: 200
                    type: "elevated"
                    elevationLevel: 0 // Remove shadow for Hero style
                    clip: true
                    
                    property int index: 0
                    
                    // Receive scroll progress from Carousel
                    property real scrollProgress: 0
                    
                    // Parallax Background
                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.width * 1.5
                        height: parent.height
                        color: Theme.color.primary
                        opacity: 0.1
                        // Move background opposite to scroll direction
                        x: -parent.width * 0.25 + (scrollProgress * 50) 
                    }
                    
                    Text {
                        anchors.centerIn: parent
                        text: "Hero Item " + (parent.index + 1)
                        font.pixelSize: 24
                        color: Theme.color.onSurfaceColor
                        // Subtle scale parallax on text
                        scale: 1.0 + Math.abs(scrollProgress) * 0.2
                    }
                }
            }
            
            // Uncontained Carousel
            Text {
                text: "Uncontained"
                font.pixelSize: Theme.typography.titleMedium.size
                color: Theme.color.onSurfaceVariantColor
                Layout.alignment: Qt.AlignHCenter
            }

            Md3.Carousel {
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                Layout.alignment: Qt.AlignHCenter
                itemWidth: 120
                itemHeight: 120
                spacing: 16
                type: "uncontained"
                
                model: 15
                delegate: Md3.Card {
                    width: 120
                    height: 120
                    type: "outlined"
                    property int index: 0
                    
                    Text {
                        anchors.centerIn: parent
                        text: "Item " + (parent.index + 1)
                        color: Theme.color.onSurfaceColor
                    }
                }
            }

            Item { height: 32 } // Bottom spacer
        }
    }

    // Vertical Scrollbar using Slider
    Item {
        id: scrollbarContainer
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 48
        
        // Hover detection area
        MouseArea {
            id: scrollbarHoverArea
            anchors.fill: parent
            hoverEnabled: true
            onPressed: (mouse) => mouse.accepted = false // Pass clicks through to slider
        }
        
        Md3.Slider {
            id: scrollbar
            anchors.centerIn: parent
            // Rotate 90 degrees to make it vertical
            rotation: 90
            
            // Width becomes the visual height when rotated
            width: parent.height - 64
            
            from: 0
            to: Math.max(0, flickable.contentHeight - flickable.height)
            value: flickable.contentY
            
            // Fade in when hovering the container or dragging the slider
            opacity: (scrollbarHoverArea.containsMouse || hovered || pressed) ? 1.0 : 0.0
            Behavior on opacity { NumberAnimation { duration: 200 } }
            
            onMoved: {
                flickable.contentY = value
            }
        }
    }
}
