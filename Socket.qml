import QtQuick 2.5
import QtWebSockets 1.0

WebSocket {

    onStatusChanged: {
        // When socket connection initialized, send register request immediately
        if(status === WebSocket.Open) {
            console.warn("Sending register request message", register_request)
            generalSend(register_request)
        }
    }

    onTextMessageReceived: {
        var json = JSON.parse(message)

        // Normal message
        if(json.type === "plain") {
            appendTextMessage(json)
        }

        // Image message
        if(json.type === "image") {
            appendImageMessage(json)
        }

        // Info message
        if(json.type === "info") {
            appendInfoMessage(json.message)
        }

        // Update message
        if(json.type === "update") {
            // Chekc update type
            switch(json.update) {
            case "userJoined":
                newUser(json)
                break
            case "userLeft":
                removeUser(getUserLocalIdByName(json.name))
                break
            default:
                break
            }
        }

        // Accept message
        if(json.type === "accepted") {
            // Our register request is accepted, so keep user_key
            my_user_key = json.user_key
            // And initialize online users
            initOnlineUsers(json.online_users)
        }
    }

    onErrorStringChanged: {
        if(errorString !== "") {
            appendInfoMessage(qsTr("Error: %1").arg(errorString))
        }
    }
}
