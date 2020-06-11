import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
Page {
    title: "About"
    ListView {
        anchors.fill: parent
        header:Column {
            id:aboutColumn
            topPadding: 10
            width: parent.width
            Image {
                id: logo
                anchors.horizontalCenter: parent.horizontalCenter
                source: "../Icons/quickddit.svg"
                layer.enabled: true
                width: 120
                height: 120
                sourceSize.height:120
                sourceSize.width:120

                layer.effect:
                    OpacityMask {
                    maskSource: Rectangle {
                        width: logo.width
                        height: logo.height
                        radius: logo.width/5
                    }
                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 1
                        verticalOffset: 1
                        color: "#A0000000"

                    }
                }
            }


            Label {
                text: "Quickddit"
                padding: 10
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 18
            }
            Label {
                text: "A free and open source Reddit client for mobile phones" +
                          "\nv" + APP_VERSION
                horizontalAlignment: "AlignHCenter"
                padding: 5
                width: parent.width
                wrapMode: "WordWrap"
            }
        }
        model: [
            { name: "Get the source", url: QMLUtils.SOURCE_REPO_URL },
            { name: "Report issues",  url: "https://github.com/accumulator/Quickddit/issues" },
            { name: "Translations", url: QMLUtils.TRANSLATIONS_URL },
            { name: "Licence", url: QMLUtils.GPL3_LICENSE_URL },
            { name: "Donate", url: "" }
        ]

        delegate: ItemDelegate {
            width: parent.width
            text: modelData.name
            contentItem.anchors.horizontalCenter: horizontalCenter
            onClicked: Qt.openUrlExternally(modelData.url)
        }
    }
}
