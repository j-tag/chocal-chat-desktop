import QtQuick 2.5
import QtQuick.Controls 1.4

Rectangle {
    id: rect

    // Main Layout
    Column {
        id: colTitles
        anchors {
            fill: parent
            topMargin: 10
            leftMargin: 10
            rightMargin: 10
        }
        spacing: 20

        // Title label
        Label {
            text: qsTr("Settings")
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // New message notification field
        Row {
            width: parent.width

            // Description text
            Text{
                text:qsTr("Play new message sounds:")
                width: parent.width / 2
                wrapMode: Text.WordWrap
            }

            // Input switch
            Switch {
                id: switchMessageNotification
                checked: settings.getBool("newMessageSound", true)
            }
        }
        // End message notification field

        // Info notification field
        Row {
            width: parent.width

            // Description text
            Text{
                text:qsTr("Play info sounds:")
                width: parent.width / 2
                wrapMode: Text.WordWrap
            }

            // Input switch
            Switch {
                id: switchInfoNotification
                checked: settings.getBool("infoSound", true)
            }
        }
        // End info notification field


        // Language field
        Row {
            width: parent.width

            // Description text
            Text{
                text:qsTr("Language:")
                width: parent.width / 2
                wrapMode: Text.WordWrap
            }

            // Input combo
            ComboBox {
                id: comboLanguage
                currentIndex: settings.getInt("localeIndex")
                model: ListModel {
                    id: languageItems
                    ListElement { text: "English (United States)"; locale: "en_US" }
                    ListElement { text: "پارسی"; locale: "fa_IR" }
                }
                width: parent.width / 2
            }
        }
        // End language field

        // Bottom buttons
        Row {
            spacing: 10

            // Save button
            Button {
                text: qsTr("Save")

                onClicked: {
                    settings.setValue("newMessageSound", switchMessageNotification.checked)
                    settings.setValue("infoSound", switchInfoNotification.checked)
                    settings.setValue("locale", languageItems.get(comboLanguage.currentIndex).locale)
                    settings.setValue("localeIndex", comboLanguage.currentIndex)
                    appendInfoMessage(qsTr("Settings are successfuly saved. You must restart Chocal Chat for settings to take effect"))
                    rect.state = "hide"
                }
            }

            // Cancel button
            Button {
                text: qsTr("Cancel")

                onClicked: {
                    rect.state = "hide"
                }
            }

        }
        // End bottom buttons


    }
    // End main layout


    // Transitions
    transitions: Transition {
        // smoothly reanchor settings panel and move into new position
        AnchorAnimation {
            easing.type: Easing.OutExpo
            duration: 600
        }
    }

    // States
    states: [
        // For showing panel
        State {
            name: "show"
            AnchorChanges {
                target: rect
                anchors.right: rect.parent.right
                anchors.left: undefined
            }
        },
        // For hiding panel
        State {
            name: "hide"
            AnchorChanges {
                target: rect
                anchors.right: undefined
                anchors.left: rect.parent.right
            }
        }
    ]

}
