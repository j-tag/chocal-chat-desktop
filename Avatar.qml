import QtQuick 2.5
import QtGraphicalEffects 1.0

// Avatar item
Item {
    id: itmImage

    property string source

    height: 60
    width: 70

    // Avatar image
    Image {
        id: imgAvatar
        height: 60
        width: 60
        y: 5
        x: 10

        fillMode: Image.PreserveAspectCrop
        source: itmImage.source

        // Circle effect
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Item {
                width: imgAvatar.width
                height: imgAvatar.height
                Rectangle {
                    anchors.centerIn: parent
                    width: Math.min(imgAvatar.width, imgAvatar.height)
                    height: width
                    radius: Math.min(width, height)
                }
            }
        }
    }
    // End avatar image
}
// End avatar item
