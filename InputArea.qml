import QtQuick 2.5
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4

Rectangle {
    id: rect

    color: "#eee"

    // Avatar chooser dialog
    FileDialog {
          id: dlgAttachment

          title: qsTr("Please choose the attachment photo")
          folder: shortcuts.pictures
    }

    Row {
        anchors.fill: parent
        spacing: 20

        // Avatar item
        Avatar {
            id: avatar
            y: 5
            source: main.getAvatar(my_name)
        }
        // End avatar item

        // Text area
        TextArea {
            id: txtMessage
            width: parent.width / 2
            height: parent.height - 20
            anchors.verticalCenter: parent.verticalCenter
        }
        // End text area

        // Send button
        Button {
            id: btnSend
            anchors.verticalCenter: parent.verticalCenter
            height: 40
            text: qsTr("Send")

            onClicked: {
                // Find out message has image or not
                if(dlgAttachment.fileUrl.toString() === "") {
                    // Text message
                    if(txtMessage.text.trim() === "") {
                        return
                    }
                    sendTextMessage(txtMessage.text)
                } else {
                    // Image message
                    sendImageMessage(txtMessage.text, dlgAttachment.fileUrl.toString())
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
            height: 40
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
