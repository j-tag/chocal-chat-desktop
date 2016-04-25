import QtQuick 2.5
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4

Rectangle {
    id: rect

    color: "#555"

    // Avatar chooser dialog
    FileDialog {
          id: dlgAvatar

          title: qsTr("Please choose your Avatar")
          folder: shortcuts.pictures

          onAccepted: {
              avatar.source = dlgAvatar.fileUrl
          }
    }

    // Inner rectangle
    Rectangle {
        id: rectInner

        radius: 10
        color: "#eee"

        width: 512
        height: 392

        anchors {
            centerIn: parent
        }

        // Welcome text
        Text {
            id: txtWelcome
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
                margins: 40
            }

            text: qsTr("Join Chocal Chat to commiunicate with your friends!")
            wrapMode: Text.WordWrap
        }

        // Error area
        Text {
            id: txtError

            anchors {
                top: txtWelcome.bottom
                horizontalCenter: parent.horizontalCenter
                margins: 20
            }

            visible: false
            wrapMode: Text.WordWrap
            color: "red"
        }

        // End error area

        // Main Layout
        Column {
            id: colTitles
            anchors {
                top: txtError.bottom
                bottom: parent.bottom
                right: parent.right
                left: parent.left
                topMargin: 10
                leftMargin: 10
                rightMargin: 10
            }
            spacing: 20

            // Name field
            Row {
                width: parent.width

                // Description text
                Text{
                    text:qsTr("Your name:")
                    width: parent.width / 2
                    wrapMode: Text.WordWrap
                }

                // Input field
                TextField {
                    id: txtName
                    width: parent.width / 2
                    placeholderText: qsTr("e.g. John, Ali, Alex Doe")
                    text: settings.getString("name")
                }
            }
            // End name field

            // Server IP field
            Row {
                width: parent.width

                // Description text
                Text{
                    text:qsTr("Chocal Server IP address:")
                    width: parent.width / 2
                    wrapMode: Text.WordWrap
                }

                // Input field
                TextField {
                    id: txtIp
                    width: parent.width / 2
                    placeholderText: qsTr("i.e. 192.168.1.2")
                    text: settings.getString("ip")
                }
            }
            // End server IP field

            // Port number field
            Row {
                width: parent.width

                // Description text
                Text{
                    text:qsTr("Port number:")
                    width: parent.width / 2
                    wrapMode: Text.WordWrap
                }

                // Input field
                TextField{
                    id: txtPort
                    width: parent.width / 2
                    validator: IntValidator {
                        top: 65534
                        bottom: 1
                    }
                    placeholderText: qsTr("i.e. 36911")
                    text: settings.getInt("port", "36911")
                }
            }
            // End port number field

            // Avatar field
            Row {
                width: parent.width

                // Description text
                Text{
                    text:qsTr("Your Avatar:")
                    width: parent.width / 2
                    wrapMode: Text.WordWrap
                }

                // Input button
                Button {
                    id: btnAvatar
                    text: qsTr("Select Avatar...")

                    onClicked: {
                        dlgAvatar.open()
                    }

                }

            }
            // End Avatar field

            // Avatar preview
            Avatar {
                id: avatar
                anchors.horizontalCenter: parent.horizontalCenter
                source: main.getAvatar("")
            }
            // End Avatar preview

            // Bottom buttons
            Row {
                spacing: 10

                // Login button
                Button {
                    text: qsTr("Join Chat")

                    onClicked: {
                        // Check name
                        if(txtName.text.trim() == "") {

                            showError(qsTr("Name is invalid"))
                            return
                        }

                        // Check server IP
                        if(txtIp.text.trim() == "") {

                            showError(qsTr("Server IP is invalid"))
                            return
                        }

                        // Check port number
                        if(!txtPort.acceptableInput) {

                            showError(qsTr("Please enter a port number between 1 and 65534"))
                            return
                        }

                        settings.setValue("name", txtName.text)
                        settings.setValue("ip", txtIp.text)
                        settings.setValue("port", txtPort.text)

                        rect.state = "hide"
                        flipable.flipped = true
                        joinChat(txtName.text, dlgAvatar.fileUrl)
                    }
                }

                // Close button
                Button {
                    text: qsTr("Exit")
                    onClicked: {
                        // Quit app
                        Qt.quit()
                    }
                }

            }
            // End bottom buttons


        }
        // End main layout

        Behavior on scale {

            NumberAnimation {
                target: rectInner
                property: "scale"
                duration: 1000
                easing.type: Easing.InOutBack
            }
        }

    }
    // End inner rectangle



    // Transitions
    transitions: Transition {
        // smoothly fade
        PropertyAnimation{
            property: "opacity"
            easing.type: Easing.OutExpo
            duration: 1000
        }
    }

    // States
    states: [
        // For showing about box
        State {
            name: "show"
            PropertyChanges {
                target: rect
                opacity: .8
                enabled: true
            }
            PropertyChanges {
                target: rectInner
                scale: 1
            }
        },
        // For hiding about box
        State {
            name: "hide"
            PropertyChanges {
                target: rect
                opacity: 0
                enabled: false
            }
            PropertyChanges {
                target: rectInner
                scale: 0
            }
        }
    ]



    // Functions

    // Show an error message on login form
    function showError(message) {
        txtError.text = message
        txtError.visible = true
    }

    // Clears the error area
    function clearErrors() {
        txtError.visible = false
        txtError.text = "";
    }
}
