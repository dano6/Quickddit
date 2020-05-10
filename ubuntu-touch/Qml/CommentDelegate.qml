import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import QtQuick.Controls.Suru 2.2
import quickddit.Core 1.0

Item {
    id: commentDelegate
    property alias listItem: mainItem
    signal  move
    height: mainItem.height
    Row {
        id:lineRow
        anchors{left: parent.left; top: parent.top; bottom: parent.bottom}
        Repeater {
            model: depth

            Item {
                anchors{top:parent.top; bottom: parent.bottom }
                width: 10
                Rectangle {
                    anchors { top: parent.top; bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }
                    width: 3
                    color:{
                        var dk = ["#ed3146", "#ef9928", "#3eb34f", "#19b6ee", "#762572", "#e95420", "#cdcdcd", "#f99b0f", "#111111" ]
                        switch (index) {
                        case 0: case 1: case 2: case 3: case 4:
                                                        case 5: case 6: case 7: case 8:
                                                                                    return dk[index];
                                                                                default: return dk[9];
                        }
                    }
                }
            }
        }
    }

    SwipeDelegate{
        id:mainItem
        height: info.height+comment.height
        anchors {left: lineRow.right; right: parent.right}
        swipe {enabled: true}
        onClicked: {
            if(model.isCollapsed)
                commentModel.expand(model.fullname)
            else
                commentModel.collapse(model.index)
        }
        Connections {
            target: commentsList

            onMovementStarted: mainItem.swipe.close()

        }

        leftPadding: 0
        topPadding: 0
        swipe.left:ToolButton {
            anchors {verticalCenter: parent.verticalCenter;bottom: parent.bottom}
            down: model.likes===-1||pressed
            Image {
                anchors.centerIn: parent
                source: "../Icons/down.svg"
                width: 24
                height: 24
            }
            onClicked: commentVoteManager.vote(model.fullname,model.likes===-1 ? VoteManager.Unvote : VoteManager.Downvote);
        }
        swipe.right: Row {
            anchors { top: parent.top;bottom: parent.bottom; right: parent.right }

            ToolButton {
                height: parent.height
                Image {
                    anchors.centerIn: parent
                    source: "../Icons/mail-reply.svg"
                    width: 24
                    height: 24
                }
            }

            ToolButton {
                height: parent.height
                Image {
                    anchors.centerIn: parent
                    source: model.saved ? "../Icons/starred.svg" : "../Icons/non-starred.svg"
                    width: 24
                    height: 24
                }
                onClicked: commentSaveManager.save(model.fullname,!model.saved)
            }

            ToolButton {
                height: parent.height
                Image {
                    anchors.centerIn: parent
                    source: "../Icons/up.svg"
                    width: 24
                    height: 24
                }
                down: model.likes===1||pressed
                onClicked: commentVoteManager.vote(model.fullname,model.likes===1 ? VoteManager.Unvote : VoteManager.Upvote);
            }
        }
        contentItem:Item{
            width: parent.width
            height: info.height+comment.height

            Label {
                id:info
                text: "/u/"+model.author+ " ~ " + (model.score < 0 ? "-" : "") +  qsTr("%n points", "", Math.abs(model.score)) + " ~ "+ model.created
            }

            Label {
                id:comment
                anchors {top: info.bottom;left: parent.left;right: parent.right}
                text: model.body

                wrapMode: "Wrap"
            }
        }
    }
}
