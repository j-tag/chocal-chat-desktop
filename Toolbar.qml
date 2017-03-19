import QtQuick 2.5
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

ToolBar {
    Material.primary: "white"
    Row {
        anchors.fill: parent

        // Leave button
        ToolButton {
            text: qsTr("Leave")
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Leave chat")
            contentItem: Image {
                source: "qrc:/img/img/toolbar-leave.png"
            }


            onClicked: {
                disconnect()
                flipable.flipped = false
                login.state = "show"
            }
        }

        // Settings button
        ToolButton {
            text: qsTr("Settings")
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Chat settings")
            contentItem: Image {
                source: "qrc:/img/img/toolbar-settings.png"
            }

            onClicked: {
                settingView.state = settingView.state === "show" ? "hide" : "show"
            }
        }

        ToolSeparator {}

        // About button
        ToolButton {
            text: qsTr("About")
            ToolTip.visible: hovered
            ToolTip.text: qsTr("About application")
            contentItem: Image {
                source: "qrc:/img/img/toolbar-about.png"
            }

            onClicked: {
                if(about.state === "show") {
                    flipable.flipped = true
                    about.state = "hide"
                } else {
                    flipable.flipped = false
                    about.state = "show"
                }
            }
        }

    }
    // End toolbar row
}

