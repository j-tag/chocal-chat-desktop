import QtQuick 2.5
import QtQuick.Controls 1.4

ToolBar {
    Row {
        anchors.fill: parent

        // Leave button
        ToolButton {
            text: qsTr("Leave")
            tooltip: qsTr("Leave chat")
            iconSource: "qrc:/img/img/toolbar-leave.png"

            onClicked: {
                disconnect()
                flipable.flipped = false
                login.state = "show"
            }
        }

        // Settings button
        ToolButton {
            text: qsTr("Settings")
            tooltip: qsTr("Chat settings")
            iconSource: "qrc:/img/img/toolbar-settings.png"

            onClicked: {
                settingView.state = settingView.state === "show" ? "hide" : "show"
            }
        }

        // About button
        ToolButton {
            text: qsTr("About")
            tooltip: qsTr("About application")
            iconSource: "qrc:/img/img/toolbar-about.png"

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

