import QtQuick 2.5
import QtQuick.Controls 1.4

// Container rectangle
Rectangle {
    id: rect

    height: layout.height
    width: userView.width

    color: "#eee"


    Row {
        id: layout
        spacing: 20

        height: Math.max(itmText.height, avatar.height) + 20

        // Avatar item
        Avatar {
            id: avatar
            source: main.getAvatar(name)
        }
        // End Avatar item

        // Text item
        Item {
            id: itmText

            height: txtName.height + txtStatus.height + 20
            width: txtName.width

            // User name
            Text {
                id: txtName
                y: 15
                width: userView.width - 90
                text: name
                color: "#ea8627"
                font.bold: true
                wrapMode: Text.Wrap
                horizontalAlignment:  Text.AlignLeft
            }

            // Status text
            Text {
                id: txtStatus

                anchors {
                    top: txtName.bottom
                    topMargin: 10
                }

                color: "teal"
                text: qsTr("Online")
            }

        }
        // End text item

    }
    // End row
}
// End container rectangle
