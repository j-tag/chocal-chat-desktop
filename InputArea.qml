import QtQuick 2.5
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

Rectangle {
    id: rect

    property url attachment_path

    color: Material.background

    onAttachment_pathChanged: {
        // Find out message has attachment or not and show an indicator on top of input area for that
        if(attachment_path.toString() === "") {
            // No attachment is provided
            rectAttachIndicator.state = "hide"
        } else {
            /// Message has attachment
            rectAttachIndicator.state = "show"
        }
    }

    // Avatar chooser dialog
    FileDialog {
          id: dlgAttachment

          title: qsTr("Please choose the attachment photo")
          folder: shortcuts.pictures
          nameFilters: [ qsTr("Image files (*.jpg *.jpeg *.png)"), qsTr("All files (*)") ]

          onAccepted: {
              attachment_path = fileUrl
          }

          onRejected: {
              attachment_path = ""
          }
    }

    Rectangle {
        id: rectAttachIndicator
        color: "green"

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.top
            margins: 0
        }
        state: "hide"

        height: txtAttachmentIndicator.height + 10

        Text {
            id: txtAttachmentIndicator
            anchors.centerIn: parent
            text: qsTr("Attachment file added.")
            color: "white"
            font.bold: true
            wrapMode: Text.WordWrap
        }

        // Transitions
        transitions: Transition {
            // Smoothly resize
            PropertyAnimation {
                property: "height"
                easing.type: Easing.InOutQuad
                duration: 500
            }
        }

        // States
        states: [
            // For showing attachment indicator
            State {
                name: "show"
                PropertyChanges {
                    target: rectAttachIndicator
                    height: txtAttachmentIndicator.height + 10
                }
                PropertyChanges {
                    target: txtAttachmentIndicator
                    visible: true
                }
            },
            // For hiding about box
            State {
                name: "hide"
                PropertyChanges {
                    target: rectAttachIndicator
                    height: 0
                }
                PropertyChanges {
                    target: txtAttachmentIndicator
                    visible: false
                }
            }
        ]
    }

    Row {
        id: rowMain
        anchors.fill: parent
        spacing: 20

        // Avatar item
        Avatar {
            id: avatar
            source: main.getAvatar(my_name)
        }
        // End avatar item

        // Text area
        TextArea {
            id: txtMessage
            width: parent.width / 2
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter

            Keys.onReleased: {
                // Here we customize behavior of Ctrl+Enter key event to send message
                if(event.modifiers && Qt.ControlModifier) {
                    if(event.key === Qt.Key_Return) {
                        btnSend.clicked()
                        event.accepted = true
                    }
                }
            }
        }
        // End text area

        // Send button
        Button {
            id: btnSend
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Send")

            onClicked: {
                // Find out message has image or not
                if(attachment_path.toString() === "") {
                    // Text message
                    if(txtMessage.text.trim() === "") {
                        return
                    }
                    sendTextMessage(txtMessage.text)
                } else {
                    // Image message
                    sendImageMessage(txtMessage.text, attachment_path)
                    attachment_path = ""
                }

                txtMessage.text = ""
                txtMessage.forceActiveFocus()
            }
        }
        // End send button

        // Attachment button
        Button {
            id: btnAttachment
            anchors.verticalCenter: parent.verticalCenter
            Image {
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: "qrc:/img/img/inputbar-attachment.png"
            }
            onClicked: {
                dlgAttachment.open()
            }
        }
        // End attachment button
    }
}
