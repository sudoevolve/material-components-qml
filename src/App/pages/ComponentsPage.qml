import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import md3.Core

Item {
    id: root
    width: parent.width
    height: parent.height

    Tabs {
        id: tabs
        anchors.fill: parent
        anchors.topMargin: 16
        type: "primary"
        model: [
            { text: "Basics", icon: "widgets" },
            { text: "Inputs", icon: "tune" },
            { text: "Dialogs", icon: "chat_bubble" },
            { text: "Display", icon: "view_carousel" }
        ]

        Loader {
            Layout.fillWidth: true
            Layout.fillHeight: true
            asynchronous: true
            active: tabs.currentIndex === 0
            sourceComponent: basicsPage
        }

        Loader {
            Layout.fillWidth: true
            Layout.fillHeight: true
            asynchronous: true
            active: tabs.currentIndex === 1
            sourceComponent: inputsPage
        }

        Loader {
            Layout.fillWidth: true
            Layout.fillHeight: true
            asynchronous: true
            active: tabs.currentIndex === 2
            sourceComponent: dialogsPage
        }

        Loader {
            Layout.fillWidth: true
            Layout.fillHeight: true
            asynchronous: true
            active: tabs.currentIndex === 3
            sourceComponent: displayPage
        }
    }

    Component {
        id: basicsPage

        Item {
            anchors.fill: parent

            Flickable {
                id: flickable
                anchors.fill: parent
                anchors.rightMargin: 48
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

                        Text { text: "Text Only"; color: Theme.color.onSurfaceColor; font.pixelSize: 14; horizontalAlignment: Text.AlignHCenter; Layout.alignment: Qt.AlignHCenter }
                        Text { text: "With Icon"; color: Theme.color.onSurfaceColor; font.pixelSize: 14; horizontalAlignment: Text.AlignHCenter; Layout.alignment: Qt.AlignHCenter }
                        Text { text: "Disabled"; color: Theme.color.onSurfaceColor; font.pixelSize: 14; horizontalAlignment: Text.AlignHCenter; Layout.alignment: Qt.AlignHCenter }

                        Button { text: "Elevated"; type: "elevated"; Layout.alignment: Qt.AlignHCenter }
                        Button { text: "Icon"; icon: "add"; type: "elevated"; Layout.alignment: Qt.AlignHCenter }
                        Button { text: "Elevated"; type: "elevated"; enabled: false; Layout.alignment: Qt.AlignHCenter }

                        Button { text: "Filled"; type: "filled"; Layout.alignment: Qt.AlignHCenter }
                        Button { text: "Icon"; icon: "add"; type: "filled"; Layout.alignment: Qt.AlignHCenter }
                        Button { text: "Filled"; type: "filled"; enabled: false; Layout.alignment: Qt.AlignHCenter }

                        Button { text: "Filled tonal"; type: "filledTonal"; Layout.alignment: Qt.AlignHCenter }
                        Button { text: "Icon"; icon: "add"; type: "filledTonal"; Layout.alignment: Qt.AlignHCenter }
                        Button { text: "Filled tonal"; type: "filledTonal"; enabled: false; Layout.alignment: Qt.AlignHCenter }

                        Button { text: "Outlined"; type: "outlined"; Layout.alignment: Qt.AlignHCenter }
                        Button { text: "Icon"; icon: "add"; type: "outlined"; Layout.alignment: Qt.AlignHCenter }
                        Button { text: "Outlined"; type: "outlined"; enabled: false; Layout.alignment: Qt.AlignHCenter }

                        Button { text: "Text"; type: "text"; Layout.alignment: Qt.AlignHCenter }
                        Button { text: "Icon"; icon: "add"; type: "text"; Layout.alignment: Qt.AlignHCenter }
                        Button { text: "Text"; type: "text"; enabled: false; Layout.alignment: Qt.AlignHCenter }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        height: 1
                        color: Theme.color.outlineVariant
                    }

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

                        ColumnLayout {
                            spacing: 12
                            Layout.alignment: Qt.AlignBottom
                            FAB { type: "small"; icon: "add"; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Small"; color: Theme.color.onSurfaceVariantColor; Layout.alignment: Qt.AlignHCenter }
                        }

                        ColumnLayout {
                            spacing: 12
                            Layout.alignment: Qt.AlignBottom
                            FAB { type: "standard"; icon: "add"; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Standard"; color: Theme.color.onSurfaceVariantColor; Layout.alignment: Qt.AlignHCenter }
                        }

                        ColumnLayout {
                            spacing: 12
                            Layout.alignment: Qt.AlignBottom
                            FAB { type: "large"; icon: "add"; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Large"; color: Theme.color.onSurfaceVariantColor; Layout.alignment: Qt.AlignHCenter }
                        }

                        ColumnLayout {
                            spacing: 12
                            Layout.alignment: Qt.AlignBottom
                            FAB { type: "extended"; icon: "add"; text: "Create"; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Extended"; color: Theme.color.onSurfaceVariantColor; Layout.alignment: Qt.AlignHCenter }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        height: 1
                        color: Theme.color.outlineVariant
                    }

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

                        ColumnLayout {
                            spacing: 12
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                            IconButton { type: "filled"; icon: "settings"; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Filled"; color: Theme.color.onSurfaceVariantColor; Layout.alignment: Qt.AlignHCenter }
                        }

                        ColumnLayout {
                            spacing: 12
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                            IconButton { type: "filledTonal"; icon: "settings"; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Filled Tonal"; color: Theme.color.onSurfaceVariantColor; Layout.alignment: Qt.AlignHCenter }
                        }

                        ColumnLayout {
                            spacing: 12
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                            IconButton { type: "outlined"; icon: "settings"; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Outlined"; color: Theme.color.onSurfaceVariantColor; Layout.alignment: Qt.AlignHCenter }
                        }

                        ColumnLayout {
                            spacing: 12
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                            IconButton { type: "standard"; icon: "settings"; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Standard"; color: Theme.color.onSurfaceVariantColor; Layout.alignment: Qt.AlignHCenter }
                        }

                        ColumnLayout {
                            spacing: 12
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                            IconButton { type: "filled"; icon: "settings"; enabled: false; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Disabled"; color: Theme.color.onSurfaceColor; opacity: 0.38; Layout.alignment: Qt.AlignHCenter }
                        }

                        ColumnLayout {
                            spacing: 12
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                            IconButton { type: "filledTonal"; icon: "settings"; enabled: false; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Disabled"; color: Theme.color.onSurfaceColor; opacity: 0.38; Layout.alignment: Qt.AlignHCenter }
                        }

                        ColumnLayout {
                            spacing: 12
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                            IconButton { type: "outlined"; icon: "settings"; enabled: false; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Disabled"; color: Theme.color.onSurfaceColor; opacity: 0.38; Layout.alignment: Qt.AlignHCenter }
                        }

                        ColumnLayout {
                            spacing: 12
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                            IconButton { type: "standard"; icon: "settings"; enabled: false; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Disabled"; color: Theme.color.onSurfaceColor; opacity: 0.38; Layout.alignment: Qt.AlignHCenter }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        height: 1
                        color: Theme.color.outlineVariant
                    }

                    Text {
                        text: "Segmented Buttons"
                        font.pixelSize: Theme.typography.headlineSmall.size
                        color: Theme.color.onSurfaceColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    ColumnLayout {
                        spacing: 24
                        Layout.alignment: Qt.AlignHCenter

                        ColumnLayout {
                            spacing: 12
                            Layout.alignment: Qt.AlignHCenter
                            SegmentedButton { Layout.alignment: Qt.AlignHCenter }
                            Text { text: "Single Select"; color: Theme.color.onSurfaceVariantColor; Layout.alignment: Qt.AlignHCenter }
                        }

                        ColumnLayout {
                            spacing: 12
                            Layout.alignment: Qt.AlignHCenter
                            SegmentedButton {
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

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        height: 1
                        color: Theme.color.outlineVariant
                    }

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

                        Chip { text: "Assist"; icon: "event" }
                        Chip { text: "Filter"; type: "filter"; selected: true }
                        Chip { text: "Input"; type: "input"; showCloseIcon: true; onCloseClicked: console.log("Close clicked") }
                        Chip { text: "Suggestion"; type: "suggestion" }

                        Chip { text: "Assist"; icon: "event"; enabled: false }
                        Chip { text: "Filter"; type: "filter"; selected: true; enabled: false }
                        Chip { text: "Input"; type: "input"; showCloseIcon: true; enabled: false }
                        Chip { text: "Suggestion"; type: "suggestion"; enabled: false }
                    }

                    Item { height: 32 }
                }
            }

            ScrollBar {
                target: flickable
                orientation: Qt.Vertical
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 14
                anchors.topMargin: 4
                anchors.bottomMargin: 4
            }
        }
    }

    Component {
        id: inputsPage

        Item {
            id: page
            anchors.fill: parent



            Flickable {
                id: flickable
                anchors.fill: parent
                anchors.rightMargin: 48
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
                        text: "Checkboxes"
                        font.pixelSize: Theme.typography.headlineMedium.size
                        color: Theme.color.onSurfaceColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    ColumnLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 0
                        Layout.fillWidth: true
                        Layout.maximumWidth: 300

                        Checkbox { text: "Option 1"; checked: true; Layout.fillWidth: true }
                        Checkbox { text: "Option 2"; indeterminate: true; Layout.fillWidth: true }
                        Checkbox { text: "Option 3"; checked: false; Layout.fillWidth: true }
                        Checkbox { text: "Option 4"; checked: true; enabled: false; Layout.fillWidth: true }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        height: 1
                        color: Theme.color.outlineVariant
                    }

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

                        RadioButton {
                            text: "Radio Option 1"
                            checked: true
                            Layout.fillWidth: true
                            onClicked: {
                                checked = true
                                radioOption2.checked = false
                                radioOption3.checked = false
                            }
                        }

                        RadioButton {
                            id: radioOption2
                            text: "Radio Option 2"
                            checked: false
                            Layout.fillWidth: true
                            onClicked: {
                                checked = true
                                parent.children[0].checked = false
                                radioOption3.checked = false
                            }
                        }

                        RadioButton {
                            id: radioOption3
                            text: "Radio Option 3"
                            checked: false
                            Layout.fillWidth: true
                            onClicked: {
                                checked = true
                                parent.children[0].checked = false
                                radioOption2.checked = false
                            }
                        }

                        RadioButton { text: "Radio Option 4 (Disabled)"; checked: true; enabled: false; Layout.fillWidth: true }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        height: 1
                        color: Theme.color.outlineVariant
                    }

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

                        ColumnLayout {
                            spacing: 16
                            Layout.alignment: Qt.AlignTop
                            Switch { text: "Off"; checked: false }
                            Switch { text: "On"; checked: true }
                        }

                        ColumnLayout {
                            spacing: 16
                            Layout.alignment: Qt.AlignTop
                            Switch { text: "Disabled Off"; checked: false; enabled: false }
                            Switch { text: "Disabled On"; checked: true; enabled: false }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        height: 1
                        color: Theme.color.outlineVariant
                    }

                    Text {
                        text: "Menus"
                        font.pixelSize: Theme.typography.headlineSmall.size
                        color: Theme.color.onSurfaceColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 24

                        Button {
                            id: menuButton
                            text: "Show Menu"
                            type: "filled"
                            onClicked: demoMenu.open(menuButton, 0, menuButton.height)
                        }

                        Menu {
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

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        height: 1
                        color: Theme.color.outlineVariant
                    }

                    Text {
                        text: "ComboBox"
                        font.pixelSize: Theme.typography.headlineSmall.size
                        color: Theme.color.onSurfaceColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 24

                        ComboBox {
                            label: "Color"
                            type: "filled"
                            model: ["Red", "Green", "Blue", "Yellow"]
                            currentIndex: 3
                        }

                        ComboBox {
                            label: "Icon"
                            type: "outlined"
                            leadingIcon: "search"
                            model: ["Brush", "Pen", "Eraser", "Bucket"]
                            currentIndex: 0
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        height: 1
                        color: Theme.color.outlineVariant
                    }

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

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 16
                            Text { text: "Continuous"; font.family: Theme.typography.labelLarge.family; font.pixelSize: Theme.typography.labelLarge.size; color: Theme.color.onSurfaceColor; Layout.preferredWidth: 120; horizontalAlignment: Text.AlignRight }
                            Slider { Layout.fillWidth: true; value: 0.5 }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 16
                            Text { text: "Discrete"; font.family: Theme.typography.labelLarge.family; font.pixelSize: Theme.typography.labelLarge.size; color: Theme.color.onSurfaceColor; Layout.preferredWidth: 120; horizontalAlignment: Text.AlignRight }
                            Slider { Layout.fillWidth: true; value: 0.2; stepSize: 0.2; snapMode: true; tickMarksEnabled: true }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 16
                            Text { text: "Labeled"; font.family: Theme.typography.labelLarge.family; font.pixelSize: Theme.typography.labelLarge.size; color: Theme.color.onSurfaceColor; Layout.preferredWidth: 120; horizontalAlignment: Text.AlignRight }
                            Slider { Layout.fillWidth: true; value: 0.5; valueLabelEnabled: true }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 16
                            Text { text: "Range"; font.family: Theme.typography.labelLarge.family; font.pixelSize: Theme.typography.labelLarge.size; color: Theme.color.onSurfaceColor; Layout.preferredWidth: 120; horizontalAlignment: Text.AlignRight }
                            Slider { Layout.fillWidth: true; rangeMode: true }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 16
                            Text { text: "Range Labels"; font.family: Theme.typography.labelLarge.family; font.pixelSize: Theme.typography.labelLarge.size; color: Theme.color.onSurfaceColor; Layout.preferredWidth: 120; horizontalAlignment: Text.AlignRight }
                            Slider { Layout.fillWidth: true; rangeMode: true; firstValue: 0.2; secondValue: 0.8; valueLabelEnabled: true }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 16
                            Text { text: "Range Ticks"; font.family: Theme.typography.labelLarge.family; font.pixelSize: Theme.typography.labelLarge.size; color: Theme.color.onSurfaceColor; Layout.preferredWidth: 120; horizontalAlignment: Text.AlignRight }
                            Slider { Layout.fillWidth: true; rangeMode: true; stepSize: 0.1; snapMode: true; tickMarksEnabled: true; firstValue: 0.3; secondValue: 0.7 }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 16
                            Text { text: "Disabled"; font.family: Theme.typography.labelLarge.family; font.pixelSize: Theme.typography.labelLarge.size; color: Theme.color.onSurfaceColor; Layout.preferredWidth: 120; horizontalAlignment: Text.AlignRight }
                            Slider { Layout.fillWidth: true; value: 0.3; enabled: false }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        height: 1
                        color: Theme.color.outlineVariant
                    }

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

                        TextField { type: "filled"; label: "Filled"; placeholderText: "Filled input"; Layout.fillWidth: true }
                        TextField { type: "outlined"; label: "Outlined"; placeholderText: "Outlined input"; Layout.fillWidth: true }
                        TextField { type: "filled"; label: "Search"; leadingIcon: "search"; trailingIcon: "close"; Layout.fillWidth: true; onTrailingIconClicked: text = "" }
                        TextField { type: "outlined"; label: "Password"; isPassword: true; Layout.fillWidth: true }
                        TextField { type: "filled"; label: "Error"; errorText: "Error message"; text: "Invalid input"; Layout.fillWidth: true }
                        TextField { type: "outlined"; label: "Disabled"; enabled: false; text: "Disabled"; Layout.fillWidth: true }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        height: 1
                        color: Theme.color.outlineVariant
                    }



                    Item { height: 32 }
                }
            }

            ScrollBar {
                target: flickable
                orientation: Qt.Vertical
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 14
                anchors.topMargin: 4
                anchors.bottomMargin: 4
            }
        }
    }

    Component {
        id: dialogsPage

        Item {
            anchors.fill: parent

            Item {
                id: overlay
                anchors.fill: parent
                z: 9999
            }

            ToolTip {
                id: hoverTip
                parent: overlay
            }

            Snackbar {
                id: snackbarTip
                parent: overlay
                onActionClicked: console.log("Snackbar action clicked")
            }

            Flickable {
                id: flickable
                anchors.fill: parent
                anchors.rightMargin: 48
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
                        text: "Dialogs"
                        font.pixelSize: Theme.typography.headlineMedium.size
                        color: Theme.color.onSurfaceColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 16

                        Button { text: "Show Dialog"; onClicked: basicDialog.open() }
                        Button { text: "Dialog with Icon"; type: "tonal"; onClicked: iconDialog.open() }
                    }

                    Dialog {
                        id: basicDialog
                        title: "Basic Dialog"
                        text: "This is a basic dialog with a title and supporting text. It asks for a decision."
                        onAccepted: console.log("Accepted")
                        onRejected: console.log("Rejected")
                    }

                    Dialog {
                        id: iconDialog
                        icon: "info"
                        title: "Dialog with Icon"
                        text: "This dialog features a hero icon at the top to reinforce the message."
                        acceptText: "Confirm"
                        showRejectButton: false
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        height: 1
                        color: Theme.color.outlineVariant
                    }

                    Text {
                        text: "Pickers"
                        font.pixelSize: Theme.typography.headlineSmall.size
                        color: Theme.color.onSurfaceColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 16

                        Button { text: "Date Picker"; onClicked: datePicker.open() }
                        Button { text: "Time Picker"; onClicked: timePicker.open() }
                    }

                    Text {
                        text: "Selected: " + Qt.formatDate(datePicker.selectedDate, "yyyy-MM-dd") + " " + timePicker.hour.toString().padStart(2, "0") + ":" + timePicker.minute.toString().padStart(2, "0")
                        color: Theme.color.onSurfaceVariantColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    DatePicker { id: datePicker; onAccepted: (date) => console.log("Date selected:", date) }
                    TimePicker { id: timePicker; onAccepted: (h, m) => console.log("Time selected:", h, m) }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        height: 1
                        color: Theme.color.outlineVariant
                    }
                    
                    Text {
                        text: "Tooltips"
                        font.pixelSize: Theme.typography.headlineSmall.size
                        color: Theme.color.onSurfaceColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 16

                        Item {
                            Layout.preferredWidth: hoverButton.implicitWidth
                            Layout.preferredHeight: hoverButton.implicitHeight

                            Button {
                                id: hoverButton
                                anchors.fill: parent
                                type: "outlined"
                                text: "Hover me"
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                acceptedButtons: Qt.NoButton

                                onEntered: {
                                    hoverTip.text = "Tooltip on hover"
                                    var p = hoverButton.mapToItem(overlay, hoverButton.width / 2, 0)
                                    hoverTip.x = p.x - hoverTip.implicitWidth / 2
                                    hoverTip.y = p.y - hoverTip.implicitHeight - 12
                                    hoverTip.open()
                                }

                                onExited: hoverTip.close()
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        height: 1
                        color: Theme.color.outlineVariant
                    }

                    Text {
                        text: "Snackbars"
                        font.pixelSize: Theme.typography.headlineSmall.size
                        color: Theme.color.onSurfaceColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 16

                        Button {
                            text: "Show Snackbar"
                            type: "filled"
                            onClicked: {
                                snackbarTip.text = "Message sent"
                                snackbarTip.actionText = ""
                                snackbarTip.open()
                            }
                        }
                        
                        Button {
                            text: "With Action"
                            type: "outlined"
                             onClicked: {
                                snackbarTip.text = "Photo deleted"
                                snackbarTip.actionText = "Undo"
                                snackbarTip.open()
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        height: 1
                        color: Theme.color.outlineVariant
                    }

                    Text {
                        text: "Selection Dialogs"
                        font.pixelSize: Theme.typography.headlineSmall.size
                        color: Theme.color.onSurfaceColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 16

                        Button { text: "Single Select"; onClicked: singleSelectDialog.open() }
                        Button { text: "Multi Select"; onClicked: multiSelectDialog.open() }
                    }

                    Dialog {
                        id: singleSelectDialog
                        title: "Select Ringtone"
                        
                        ColumnLayout {
                            spacing: 0
                            width: parent.width
                            
                            Repeater {
                                model: ["None", "Callisto", "Ganymede", "Luna"]
                                delegate: RadioButton {
                                    text: modelData
                                    checked: index === 1
                                    Layout.fillWidth: true
                                    onClicked: {
                                         // Simple exclusive logic for demo
                                         for(var i=0; i<parent.children.length; i++) {
                                             if(parent.children[i] !== this && parent.children[i].hasOwnProperty("checked")) {
                                                 parent.children[i].checked = false
                                             }
                                         }
                                    }
                                }
                            }
                        }
                    }

                    Dialog {
                        id: multiSelectDialog
                        title: "Select Toppings"
                        
                        ColumnLayout {
                            spacing: 0
                            width: parent.width
                            
                            Repeater {
                                model: ["Cheese", "Tomato", "Mushroom", "Onion"]
                                delegate: Checkbox {
                                    text: modelData
                                    checked: index === 0
                                    Layout.fillWidth: true
                                }
                            }
                        }
                    }

                    Item { height: 32 }
                }
            }

            ScrollBar {
                target: flickable
                orientation: Qt.Vertical
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 14
                anchors.topMargin: 4
                anchors.bottomMargin: 4
            }
        }
    }

    Component {
        id: displayPage

        Item {
            anchors.fill: parent

            Flickable {
                id: flickable
                anchors.fill: parent
                anchors.rightMargin: 48
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
                        text: "Progress Indicators"
                        font.pixelSize: Theme.typography.headlineMedium.size
                        color: Theme.color.onSurfaceColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    ColumnLayout {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        spacing: 24

                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 16

                            Text { text: "Play Animation"; color: Theme.color.onSurfaceColor; font.family: Theme.typography.labelLarge.family }
                            Switch { id: progressSwitch; checked: false }
                        }

                        LinearProgress { Layout.fillWidth: true; value: 0.7; indeterminate: progressSwitch.checked }
                        CircularProgress { Layout.alignment: Qt.AlignHCenter; value: 0.75; indeterminate: progressSwitch.checked }

                        Text { text: "Wavy Progress"; color: Theme.color.onSurfaceVariantColor; font.family: Theme.typography.labelLarge.family; Layout.topMargin: 16 }
                        LinearProgress { Layout.fillWidth: true; value: 0.5; wavy: true; indeterminate: progressSwitch.checked }
                        CircularProgress { Layout.alignment: Qt.AlignHCenter; value: 0.75; wavy: true; indeterminate: progressSwitch.checked }

                        Text { text: "Loading Indicator (MD3)"; color: Theme.color.onSurfaceVariantColor; font.family: Theme.typography.labelLarge.family; Layout.topMargin: 16 }

                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 32

                            LoadingIndicator { running: progressSwitch.checked }
                            LoadingIndicator { running: progressSwitch.checked; withContainer: true }
                            LoadingIndicator { running: progressSwitch.checked; color: Theme.color.tertiary }

                            Button {
                                type: "outlined"
                                contentItem: RowLayout {
                                    spacing: 8
                                    LoadingIndicator { Layout.preferredWidth: 18; Layout.preferredHeight: 18; running: progressSwitch.checked }
                                    Text { text: "Loading..."; color: Theme.color.primary; font.family: Theme.typography.labelLarge.family }
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        height: 1
                        color: Theme.color.outlineVariant
                    }

                    Text {
                        text: "Index Background"
                        font.pixelSize: Theme.typography.headlineSmall.size
                        color: Theme.color.onSurfaceColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 700
                        Layout.preferredHeight: 340
                        Layout.alignment: Qt.AlignHCenter
                        radius: 16
                        color: Theme.color.surfaceContainerLowest
                        border.width: 1
                        border.color: Theme.color.outlineVariant
                        clip: true

                        IndexBackground {
                            anchors.fill: parent
                            running: progressSwitch.checked
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        height: 1
                        color: Theme.color.outlineVariant
                    }

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

                            property int itemW: 200
                            property int sp: 24
                            property int cols: Math.max(1, Math.floor((parent.width + sp) / (itemW + sp)))
                            width: cols * itemW + (cols - 1) * sp

                            Card {
                                type: "elevated"
                                width: 200; height: 200

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 16
                                    Item { Layout.fillHeight: true }
                                    Text { text: "Elevated"; font.pixelSize: Theme.typography.titleMedium.size; font.family: Theme.typography.titleMedium.family; font.bold: true; color: Theme.color.onSurfaceColor }
                                }

                                Text { anchors.top: parent.top; anchors.right: parent.right; anchors.margins: 16; text: "more_vert"; font.family: Theme.iconFont.name; font.pixelSize: 24; color: Theme.color.onSurfaceColor }
                            }

                            Card {
                                type: "filled"
                                width: 200; height: 200

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 16
                                    Item { Layout.fillHeight: true }
                                    Text { text: "Filled"; font.pixelSize: Theme.typography.titleMedium.size; font.family: Theme.typography.titleMedium.family; font.bold: true; color: Theme.color.onSurfaceColor }
                                }

                                Text { anchors.top: parent.top; anchors.right: parent.right; anchors.margins: 16; text: "more_vert"; font.family: Theme.iconFont.name; font.pixelSize: 24; color: Theme.color.onSurfaceColor }
                            }

                            Card {
                                type: "outlined"
                                width: 200; height: 200

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 16
                                    Item { Layout.fillHeight: true }
                                    Text { text: "Outlined"; font.pixelSize: Theme.typography.titleMedium.size; font.family: Theme.typography.titleMedium.family; font.bold: true; color: Theme.color.onSurfaceColor }
                                }

                                Text { anchors.top: parent.top; anchors.right: parent.right; anchors.margins: 16; text: "more_vert"; font.family: Theme.iconFont.name; font.pixelSize: 24; color: Theme.color.onSurfaceColor }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        height: 1
                        color: Theme.color.outlineVariant
                    }

                    Text {
                        text: "Carousel"
                        font.pixelSize: Theme.typography.headlineSmall.size
                        color: Theme.color.onSurfaceColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text { text: "Multi-browse"; font.pixelSize: Theme.typography.titleMedium.size; color: Theme.color.onSurfaceVariantColor; Layout.alignment: Qt.AlignHCenter }

                    Carousel {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        itemWidth: 200
                        itemHeight: 120
                        spacing: 16
                        type: "multi-browse"

                        model: 10
                        delegate: Card {
                            width: 200
                            height: 120
                            type: "filled"
                            property int index: 0
                            color: index % 2 === 0 ? Theme.color.surfaceContainerHigh : Theme.color.surfaceContainer

                            Text { anchors.centerIn: parent; text: "Item " + (parent.index + 1); color: Theme.color.onSurfaceColor }
                        }
                    }

                    Text { text: "Hero & Parallax"; font.pixelSize: Theme.typography.titleMedium.size; color: Theme.color.onSurfaceVariantColor; Layout.alignment: Qt.AlignHCenter }

                    Carousel {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        itemWidth: 280
                        itemHeight: 200
                        spacing: 16
                        type: "hero"

                        model: 5
                        delegate: Card {
                            width: 280
                            height: 200
                            type: "elevated"
                            elevationLevel: 0
                            clip: true

                            property int index: 0
                            property real scrollProgress: 0

                            Rectangle { anchors.centerIn: parent; width: parent.width * 1.5; height: parent.height; color: Theme.color.primary; opacity: 0.1; x: -parent.width * 0.25 + (scrollProgress * 50) }
                            Text { anchors.centerIn: parent; text: "Hero Item " + (parent.index + 1); font.pixelSize: 24; color: Theme.color.onSurfaceColor; scale: 1.0 + Math.abs(scrollProgress) * 0.2 }
                        }
                    }

                    Text { text: "Uncontained"; font.pixelSize: Theme.typography.titleMedium.size; color: Theme.color.onSurfaceVariantColor; Layout.alignment: Qt.AlignHCenter }

                    Carousel {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        itemWidth: 120
                        itemHeight: 120
                        spacing: 16
                        type: "uncontained"

                        model: 15
                        delegate: Card {
                            width: 120
                            height: 120
                            type: "outlined"
                            property int index: 0
                            Text { anchors.centerIn: parent; text: "Item " + (parent.index + 1); color: Theme.color.onSurfaceColor }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        height: 1
                        color: Theme.color.outlineVariant
                    }

                    Text {
                        text: "Data Table"
                        font.pixelSize: Theme.typography.headlineSmall.size
                        color: Theme.color.onSurfaceColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredHeight: 300
                        Layout.margins: 20

                        DataTable {
                            id: dataTable
                            anchors.fill: parent
                            columns: [
                                {label: "ID", role: "id", width: 30},
                                {label: "Name", role: "name", width: 70},
                                {label: "Role", role: "role", width: 70},
                                {label: "Status", role: "status", width: 50}
                            ]

                            rowData: [
                                {id: 1, name: "Alice Johnson", role: "Engineer", status: "Active"},
                                {id: 2, name: "Bob Smith", role: "Designer", status: "Inactive"},
                                {id: 3, name: "Charlie Brown", role: "Manager", status: "Active"},
                                {id: 4, name: "Diana Prince", role: "Developer", status: "Active"},
                                {id: 5, name: "Evan Wright", role: "Tester", status: "Pending"},
                                {id: 6, name: "Frank Miller", role: "Analyst", status: "Active"},
                                {id: 7, name: "Grace Lee", role: "Director", status: "Active"},
                                {id: 8, name: "Henry Wilson", role: "Support", status: "Inactive"}
                            ]

                            showCheckBoxes: true
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        height: 1
                        color: Theme.color.outlineVariant
                    }

                    Text {
                        text: "Charts (Canvas)"
                        font.pixelSize: Theme.typography.headlineSmall.size
                        color: Theme.color.onSurfaceColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 700
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 24

                        Card {
                            type: "outlined"
                            Layout.fillWidth: true
                            Layout.preferredHeight: 240

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 12

                                Text { text: "Line"; font.pixelSize: Theme.typography.titleMedium.size; font.family: Theme.typography.titleMedium.family; color: Theme.color.onSurfaceColor }
                                CanvasLineChart {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    labels: ["1", "2", "3", "4", "5", "6", "7", "8"]
                                    series: [
                                        { name: "A", values: [4, 7, 6, 10, 8, 12, 11, 15], color: "primary", showArea: true, showPoints: true },
                                        { name: "B", values: [3, 6, 4, 8, 9, 10, 13, 12], color: "tertiary", showArea: false, showPoints: true }
                                    ]
                                }
                            }
                        }

                        Card {
                            type: "outlined"
                            Layout.fillWidth: true
                            Layout.preferredHeight: 240

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 12

                                Text { text: "Bar"; font.pixelSize: Theme.typography.titleMedium.size; font.family: Theme.typography.titleMedium.family; color: Theme.color.onSurfaceColor }
                                CanvasBarChart {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    labels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                                    series: [
                                        { name: "2025", values: [12, 6, 9, 3, 11, 7, 10], color: "primary" },
                                        { name: "2026", values: [10, 8, 7, 5, 9, 6, 12], color: "secondary" }
                                    ]
                                }
                            }
                        }

                        Card {
                            type: "outlined"
                            Layout.fillWidth: true
                            Layout.preferredHeight: 240

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 16

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    spacing: 12

                                    Text { text: "Pie"; font.pixelSize: Theme.typography.titleMedium.size; font.family: Theme.typography.titleMedium.family; color: Theme.color.onSurfaceColor }
                                    CanvasPieChart {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        values: [30, 20, 15, 10, 25]
                                        sliceColors: [Theme.color.primary, Theme.color.secondary, Theme.color.tertiary, Theme.color.error, Theme.color.outline]
                                        innerRadiusRatio: 0.55
                                        strokeWidth: 2
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        height: 1
                        color: Theme.color.outlineVariant
                    }

                    Text {
                        text: "Blur Card"
                        font.pixelSize: Theme.typography.headlineSmall.size
                        color: Theme.color.onSurfaceColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Item {
                        id: blurWrapper
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.preferredHeight: 300
                        Layout.alignment: Qt.AlignHCenter
                        clip: true
                        property bool ballAnimationEnabled: false

                        // Background Content (Sibling to BlurCard)
                        Item {
                            id: blurBackground
                            anchors.fill: parent
                            layer.enabled: true // Enable layer for ShaderEffectSource capture
                            layer.smooth: true

                            Rectangle {
                                anchors.fill: parent
                                color: Theme.color.surfaceContainerLowest
                                radius: 16
                            }

                            // Background Pattern
                            Repeater {
                                model: 15
                                Rectangle {
                                    id: blurBall
                                    width: Math.random() * 100 + 50
                                    height: width
                                    x: Math.random() * (parent.width - width)
                                    y: Math.random() * (parent.height - height)
                                    rotation: Math.random() * 360
                                    color: Qt.hsla(Math.random(), 0.7, 0.6, 0.5)
                                    radius: width / 2

                                    property int _moveDurationMs: 1800
                                    property int _moveIntervalMs: 1200

                                    Behavior on x {
                                        NumberAnimation { duration: blurBall._moveDurationMs; easing.type: Easing.InOutQuad }
                                    }
                                    Behavior on y {
                                        NumberAnimation { duration: blurBall._moveDurationMs; easing.type: Easing.InOutQuad }
                                    }
                                    Behavior on rotation {
                                        NumberAnimation { duration: blurBall._moveDurationMs; easing.type: Easing.InOutQuad }
                                    }

                                    Timer {
                                        id: blurBallTimer
                                        interval: blurBall._moveIntervalMs
                                        running: blurWrapper.ballAnimationEnabled
                                        repeat: true
                                        triggeredOnStart: true
                                        onTriggered: {
                                            blurBall._moveDurationMs = 1200 + Math.floor(Math.random() * 2200)
                                            blurBall._moveIntervalMs = 800 + Math.floor(Math.random() * 1600)
                                            interval = blurBall._moveIntervalMs
                                            blurBall.x = Math.random() * Math.max(0, blurBall.parent.width - blurBall.width)
                                            blurBall.y = Math.random() * Math.max(0, blurBall.parent.height - blurBall.height)
                                            blurBall.rotation = Math.random() * 360
                                        }
                                    }
                                }
                            }
                        }

                        BlurCard {
                            id: blurCard
                            x: (parent.width - width) / 2
                            y: (parent.height - height) / 2
                            width: 320
                            height: 200
                            blurSource: blurBackground
                            blurAmount: 40
                            borderRadius: 24
                            dragable: true

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 8
                                Text {
                                    text: "Glassmorphism"
                                    font.pixelSize: Theme.typography.headlineSmall.size
                                    font.family: Theme.typography.headlineSmall.family
                                    color: Theme.color.onSurfaceColor
                                    Layout.alignment: Qt.AlignHCenter
                                }
                                Text {
                                    text: "Drag me around!"
                                    font.pixelSize: Theme.typography.bodyLarge.size
                                    font.family: Theme.typography.bodyLarge.family
                                    color: Theme.color.onSurfaceVariantColor
                                    Layout.alignment: Qt.AlignHCenter
                                }
                                Button {
                                    text: blurWrapper.ballAnimationEnabled ? "stop" : "play"
                                    type: "filledTonal"
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.topMargin: 16
                                    onClicked: blurWrapper.ballAnimationEnabled = !blurWrapper.ballAnimationEnabled
                                }
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 600
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 12

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: "Blur Amount"
                                font.pixelSize: Theme.typography.bodyMedium.size
                                color: Theme.color.onSurfaceColor
                            }
                            Item { Layout.fillWidth: true }
                            Text {
                                text: Math.round(blurCard.blurAmount)
                                font.pixelSize: Theme.typography.bodyMedium.size
                                color: Theme.color.onSurfaceVariantColor
                            }
                        }

                        Slider {
                            id: blurAmountSlider
                            Layout.fillWidth: true
                            from: 0
                            to: Math.max(1, blurCard.blurMax)
                            stepSize: 1
                            snapMode: true
                            valueLabelEnabled: true
                            Component.onCompleted: value = blurCard.blurAmount
                            onMoved: blurCard.blurAmount = value
                        }
                    }

                    Item { height: 32 }
                }
            }

            ScrollBar {
                target: flickable
                orientation: Qt.Vertical
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 14
                anchors.topMargin: 4
                anchors.bottomMargin: 4
            }
        }
    }

    FabMenu {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 32
        
        model: [
            { text: "Document", icon: "description", color: Theme.color.surfaceContainerHigh, textColor: Theme.color.onSurfaceColor },
            { text: "Message", icon: "chat", color: Theme.color.secondaryContainer, textColor: Theme.color.onSecondaryContainerColor },
            { text: "Folder", icon: "folder", color: Theme.color.tertiaryContainer, textColor: Theme.color.onTertiaryContainerColor }
        ]
        
        onItemClicked: (index, itemData) => {
            console.log("FabMenu Clicked:", itemData.text)
        }
    }
}
