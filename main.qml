import QtQuick 2.5
import QtQuick.Controls 2.1
import QtMultimedia 5.5
import QtQuick.Controls.Material 2.1

ApplicationWindow {
    id: main
    visible: true
    width: 1024
    height: 768
    title: qsTr("Chocal Chat")

    // Material colors
    Material.primary: "teal"

    property var user_local_ids_index: []
    property string my_user_key
    property string my_name
    property string register_request

    // Timer for login screen
    Timer {
        interval:2000; running: true; repeat: false
        onTriggered: login.state = "show"
    }

    SoundEffect {
        id: soundNewMsg
        source: "qrc:/raw/raw/new-message.wav"
    }

    SoundEffect {
        id: soundInfo
        source: "qrc:/raw/raw/info.wav"
    }

    // User model
    ListModel {
        id: userModel
    }
    // End user model

    // Message model
    ListModel {
        id: messageModel
    }
    // End message model

    // Application toolbar
    header: Toolbar { id: toolbar }
    // End toolbar

    // Background tile picture
    Image {
        id: imgBackTile
        anchors.fill: parent
        fillMode: Image.Tile
        source: "qrc:/img/img/back-tile.jpg"
    }

    // Web socket client
    Socket { id: socket }
    // End web socket client

    // Flipable
    Flipable {
        id: flipable

        property bool flipped: false

        anchors.fill: parent

        // Main item
        back: Item {
            id: front
            anchors.fill: parent

            // Background picture
            Image {
                id: imgBackground
                source: "qrc:/img/img/background.jpg"
            }

            // Users area
            ListView {
                id: userView

                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                }
                z: 2
                width: main.width / 4

                model: userModel

                delegate: UserDelegate{}

                // Add transitions
                add: Transition {
                    // Fade in animation
                    NumberAnimation {
                        property: "opacity";
                        from: 0; to: 1.0;
                        duration: 400
                    }
                    // Coming animation
                    NumberAnimation {
                        property: "scale";
                        easing.amplitude: 0.3;
                        easing.type: Easing.OutExpo
                        from:0; to:1;
                        duration: 600
                    }
                }
                // End add transitions

                // remove transitions
                remove: Transition {
                    // Fade in animation
                    NumberAnimation {
                        property: "opacity";
                        from: 1.0; to: 0;
                        duration: 400
                    }
                    // Coming animation
                    NumberAnimation {
                        property: "scale";
                        easing.amplitude: 0.3;
                        easing.type: Easing.OutExpo
                        from:1; to:0;
                        duration: 600
                    }
                }
                // End remove transitions

                // Displaced transitions
                displaced: Transition {
                    // Fade in animation
                    NumberAnimation {
                        property: "y";
                        easing.type: Easing.InOutBack
                        duration: 600
                    }
                }
                // End displaced transitions

            }
            // End users area



            // Chat area
            ListView {
                id: messageView

                anchors {
                    top: parent.top
                    bottom: inputArea.top
                    left: userView.right
                    right: settingView.left
                    topMargin: 40
                }
                z: 2

                spacing: 40

                model: messageModel

                delegate: MessageDelegate{}

            }
            // End chat area

            // Input message area
            InputArea {
                id: inputArea

                anchors {
                    bottom: parent.bottom
                    left: messageView.left
                    right: messageView.right
                }
                z: 3
                height: 80
            }
            // End input message area

            // Settings area
            Settings {
                id: settingView

                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                }
                z: 4
                width: main.width / 4

                state: "hide"
            }
            // End settings area
        }
        // End main item

        // Splash item
        front: Splash {id: back}
        // End splash item

        // Transforms
        transform: Rotation {
            id: rotation
            origin.x: flipable.width/2
            origin.y: flipable.height/2
            // set axis.x to 1 to rotate around x-axis
            axis.x: 1; axis.y: 0; axis.z: 0
            angle: 0    // the default angle
        }

        // States
        states: State {
            name: "back"
            PropertyChanges { target: rotation; angle: -180 }
            when: flipable.flipped
        }

        // Transitions
        transitions: Transition {
            NumberAnimation {
                target: rotation
                property: "angle"
                easing.type: Easing.OutQuint
                duration: 2000
            }
        }
    }
    // End flipabel

    // Login box
    Login {
        id: login

        anchors.fill: parent

        state: "hide"
    }

    // About box
    About {
        id: about

        anchors.fill: parent

        state: "hide"
    }

    // Functions

    // Goes to last message on the list
    function gotoLast() {
        messageView.currentIndex = messageModel.count - 1
    }

    // Show a plain text message in the message list
    function appendTextMessage(json) {
        newMessageSound()
        messageModel.append(json)
        gotoLast()
    }

    // Show an info message in the message list
    function appendInfoMessage(message) {
        infoSound()
        messageModel.append({
                                type: "info",
                                name: "",
                                message: message,
                                image: ""
                            })
        gotoLast()
    }

    // Show an image message in the message list
    function appendImageMessage(json) {
        newMessageSound()
        messageModel.append(json)
        gotoLast()
    }

    // Initialize login time, online users
    function initOnlineUsers(json) {
        var user = null;

        for (var index = 0; index < json.length; index++) {
            user = json[index];
            newUser(user);
        }
    }

    // Add new user to list
    function newUser(json) {
        var user_local_id = fileio.getNewUserLocalId()

        // Set user Avatar
        if(typeof json.image !== "undefined") {
            fileio.setUserAvatar(user_local_id, json.image);
        }

        // Everything is ok, so add user
        userModel.append({
                             name: json.name,
                             user_local_id: user_local_id,
                             image: json.image,
                             image_type: json.image_type
                         })

        updateUserLocalIdsIndex()

        // Navigate to newly added user
        userView.currentIndex = user_local_ids_index[user_local_id]

        return user_local_id
    }

    // Remove an existing user from list
    function removeUser(user_local_id) {
        if(isValidUserLocalId(user_local_id)) {

            userModel.remove(user_local_ids_index[user_local_id])
            updateUserLocalIdsIndex()

            return true
        }

        return false
    }

    // Sync user_local_ids_index array
    function updateUserLocalIdsIndex() {
        // Map user keys to their indices in user model
        for(var i = 0; i < userModel.count; ++i) {
            user_local_ids_index[userModel.get(i).user_local_id] = i;
        }
    }

    // Returns user object of requested user local id
    function getUserByLocalId(user_local_id) {
        return userModel.get(user_local_ids_index[user_local_id])
    }

    // Returns user local id by his name
    function getUserLocalIdByName(name) {
        for(var i = 0; i < userModel.count; ++i) {
            var user = userModel.get(i)

            if(user.name === name) {
                // Name found
                return user.user_local_id
            }
        }
        // Not found
        return -1
    }

    // Sends a plain text message
    function generalSend(string) {
        socket.sendTextMessage(string)
    }

    // Sends a text message
    function sendTextMessage(string) {
        var json = {
            type: "plain",
            message: string
        }
        addMyUserKey(json)

        var json_string = JSON.stringify(json)
        generalSend(json_string)
    }

    // Sends an image message
    function sendImageMessage(string, image) {
        var json = {
            type: "image",
            message: string,
            image: fileio.encodeImage(image),
            image_type: fileio.getFileType(image)
        }
        addMyUserKey(json)

        var json_string = JSON.stringify(json)
        generalSend(json_string)
    }

    // Add user name to json object
    function addMyUserKey(json) {
        json.user_key = my_user_key;
    }

    // Get avatar path by name
    function getAvatar(name) {
        var user_local_id = getUserLocalIdByName(name)

        if(user_local_id === -1 || user_local_id === undefined || user_local_id === null
                || user_local_id === "" || !fileio.hasAvatar(user_local_id)) {
            return "qrc:/img/img/no-avatar.png"
        }

        return fileio.getAvatarUrl(user_local_id);
    }

    // Check to see if user local id is valid or not
    function isValidUserLocalId(user_local_id) {
        return typeof user_local_ids_index[user_local_id] !== 'undefined'
    }

    // Try to join chat
    function joinChat(name, avatar_path) {
        var json = null

        if(avatar_path.toString() === "") {
            json = {
                type: "register",
                name: name
            }
        } else {
            json = {
                type: "register",
                name: name,
                image: fileio.cropEncodeImage(avatar_path),
                image_type: "jpg" // In fileio.cropEncodeImage() method we convert image format to JPG
            }
        }

        register_request = JSON.stringify(json)
        my_name = name
        connect()
    }

    // Connect to Chocal Server
    function connect() {
        socket.active = true
        socket.url = "ws://" + settings.getString("ip") + ":" + settings.getString("port")
    }

    // Disconnect from chat
    function disconnect() {
        socket.active = false;
        userModel.clear()
        messageModel.clear()
        my_user_key = ""
        register_request = ""
        updateUserLocalIdsIndex()
    }

    // Plays a sound that indicate new message is arrived
    function newMessageSound() {
        if(!settings.getBool("newMessageSound", true)) {
            return
        }

        if(soundNewMsg.playing) {
            soundNewMsg.stop()
        }
        soundNewMsg.play()
    }

    // Plays a sound that indicate some info message is shown
    function infoSound() {
        if(!settings.getBool("infoSound", true)) {
            return
        }

        if(soundInfo.playing) {
            soundInfo.stop()
        }
        soundInfo.play()
    }

}
