import QtQuick 2.9
import QtQuick.Controls 2.2
import quickddit.Core 1.0
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
                    text: "Picture layout"
                }
                ComboBox {
                    anchors { right: parent.right; verticalCenter: parent.verticalCenter; margins:10 }
                    model: ["Compact","Previews","Full sized"]
                    onAccepted: {
                        persistantSettings.layout = currentText
                    }

                }
            }
            ItemDelegate {
                width: parent.width
                Label {
                    id:sliderLabel
                    anchors {left: parent.left;verticalCenter: parent.verticalCenter; margins: 10}
                    text: "Thumbnail scale: ["+Math.floor(slider.value*100)+"%]"
                }
                Slider {
                    id:slider
                    anchors { right: parent.right; left:sliderLabel.right;  verticalCenter: parent.verticalCenter; margins:10 }
                    from: 0.5
                    to: 2.5
                    stepSize: 0.1
                    snapMode: "SnapAlways"
                    value: persistantSettings.scale
                    live: true
                    onMoved: persistantSettings.scale = value
                }
            }
            ItemDelegate {
                width: parent.width
                Label {
                    anchors {left: parent.left;verticalCenter: parent.verticalCenter; margins: 10}
                    text: "Preferred Video Size"
                }
                ComboBox {
                    anchors { right: parent.right;  verticalCenter: parent.verticalCenter; margins:10 }
                    model: ["360p","720p"]
                    onCurrentIndexChanged: {
                        switch (currentIndex) {
                        case 0: appSettings.preferredVideoSize = AppSettings.VS360; break;
                        case 1: appSettings.preferredVideoSize = AppSettings.VS720; break;
                        }
                    }
                }

            }
            SwitchDelegate {
                width: parent.width
                text: "Open links internaly"
                checked: persistantSettings.linksInternaly
                onCheckedChanged: persistantSettings.linksInternaly = checked
            }
            ItemDelegate {
                width: parent.width
            }
        }
    }
}
