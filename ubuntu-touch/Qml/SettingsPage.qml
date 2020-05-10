import QtQuick 2.9
import QtQuick.Controls 2.2

Page {
    title: "Settings"
    ScrollView {
        contentWidth: width
        anchors.fill: parent
        Column{
            anchors {left: parent.left;right: parent.right}
            ItemDelegate {
                width: parent.width
                Label {
                    anchors {left: parent.left;verticalCenter: parent.verticalCenter; margins: 10}
                    text: "Feed layout"
                }
                ComboBox {
                    anchors { right: parent.right; verticalCenter: parent.verticalCenter; margins:10 }
                    model: ["Compact","previews","full sized"]
                }
            }
            ItemDelegate {
                width: parent.width
            }
            ItemDelegate {
                width: parent.width
            }
            ItemDelegate {
                width: parent.width
            }
            ItemDelegate {
                width: parent.width
            }
        }
    }
}
