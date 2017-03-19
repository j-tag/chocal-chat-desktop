import QtQuick 2.5
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

Rectangle {
    id: rect

    property url avatar_path

    color: "#cc555555"

    // Avatar chooser dialog
    FileDialog {
          id: dlgAvatar

          title: qsTr("Please choose your Avatar")
          folder: shortcuts.pictures
          nameFilters: [ qsTr("Image files (*.jpg *.jpeg *.png)"), qsTr("All files (*)") ]

          onAccepted: {
              avatar_path = fileUrl
              avatar.source = fileUrl
          }

          onRejected: {
              avatar_path = ""
              avatar.source = "qrc:/img/img/no-avatar.png"
          }

    }

    // Inner rectangle
    Rectangle {
        id: rectInner

        radius: 10
        color: Material.background

        width: 512
        height: avatar.height + txtWelcome.height + txtError.height + colTitles.height

        anchors {
            centerIn: parent
        }

        // Avatar preview
        Avatar {
            id: avatar
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.top
                bottomMargin: -(avatar.height / 2)
            }
            source: main.getAvatar("")
            height: 185
            width: 185
        }
        // End Avatar preview

        // Welcome text
        Text {
            id: txtWelcome
            anchors {
                top: avatar.bottom
                horizontalCenter: parent.horizontalCenter
                margins: 20
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


    // Bottom buttons
    Row {
        spacing: 10
        anchors.top: rectInner.bottom
        anchors.left: rectInner.left

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
                joinChat(txtName.text, avatar_path)
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
                opacity: 1
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
