import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import quickddit.Core 1.0
import QtQuick.Controls.Suru 2.2

//ToDo: rework this page, implement commpact image view
ItemDelegate {
    id:linkDelegate
    width: parent.width
    property bool compact: true
    property variant link
    property VoteManager linkVoteManager
    property SaveManager linkSaveManager
    property bool previewableImage: globalUtils.previewableImage(link.url)
    height: Math.max(titulok.height+pic.height,txt.height+titulok.height,thumb.height)+bottomRow.height+info.height
    onClicked: {
        if(!compact)globalUtils.openLink(link.url)
    }

    //info
    Label {
        padding: 2
        id: info
        anchors.top: parent.top
        anchors.left : parent.left
        anchors.right:  parent.right
        elide: Text.ElideRight
        text: "<a href='r/"+link.subreddit+"'>"+"r/"+link.subreddit+"</a>"+" ~ <a href='u/"+link.author+"'>"+"u/"+link.author+"</a>"+" ~ "+link.created+" ~ "+link.domain
        onLinkActivated: {
            if(link.charAt(0)=='r')
                pageStack.push(Qt.resolvedUrl("SubredditPage.qml"),{subreddit:link.slice(2)})
            if(link.charAt(0)=='u'){}
        }
    }
    //title
    Label {
        padding: 10
        anchors.top: info.bottom
        anchors.right: parent.right
        anchors.left: thumb.visible ? thumb.right : parent.left //thumb.right
        anchors.rightMargin: 10
        id: titulok
        text: link.title
        elide: Text.ElideRight
        maximumLineCount: compact ? 3 : 9999
        font.pointSize: 12
        font.weight: Font.DemiBold

        wrapMode: Text.Wrap
    }
    //text
    Label{
        padding: 10
        anchors.right: parent.right
        anchors.top: titulok.bottom
        anchors.left: thumb.visible ? thumb.right : parent.left
        id:txt
        text:(compact? link.rawText : link.text)
        elide: Text.ElideRight
        maximumLineCount: compact ? 3:9999
        font.pointSize: 10
        wrapMode: Text.WordWrap
        textFormat: Text.StyledText
        clip: true
        visible: !previewableImage
        onLinkActivated: globalUtils.openLink(link)
    }
    //preview
    Image {
        //asynchronous: true
        anchors.left: parent.left
        anchors.top: info.bottom
        width: 140
        height:visible? 140 : 0// String(link.thumbnailUrl).length>3 ? 140 : 0
        id: thumb
        source: String(link.thumbnailUrl).length<3? "http://www.google.com/s2/favicons?domain=" + link.domain : link.thumbnailUrl
        //enabled: !globalUtils.previewableImage(link.url)
        visible:  !previewableImage&&!globalUtils.redditLink(link.url) //;globalUtils.previewableImage(link.url)
        enabled: visible
        fillMode: Image.PreserveAspectFit
        MouseArea{
            anchors.fill: parent
            onClicked: {
                globalUtils.openLink(link.url)
            }
            enabled: thumb.enabled
            Rectangle{
                enabled: thumb.enabled
                id:rect
                anchors.fill: parent
                color: "black"
                opacity: 0.20
                visible: false
            }
            Rectangle{
                color: "black"
                opacity: 0.6
                anchors{left: parent.left ; right: parent.right; bottom: parent.bottom}
                height: 40
                Label {
                    text: link.domain
                    color: "white"
                    font.weight: Font.DemiBold
                    width: parent.width
                    anchors.centerIn: parent
                    horizontalAlignment: "AlignHCenter"
                    elide: "ElideRight"
                    wrapMode: "WrapAnywhere"
                    maximumLineCount: 1
                }
            }

            onPressedChanged: {
                if(pressed){
                    rect.visible=true

                }
                else
                    rect.visible=false
            }

        }
    }
    //image
    Image {
        asynchronous: true
        width: parent.width
        height: previewableImage?parent.width/link.previewWidth*previewHeight:0
        anchors.top: titulok.bottom
        id:pic
        fillMode: Image.PreserveAspectFit
        enabled: previewableImage
        source: (previewableImage)? link.previewUrl : ""
        //BusyIndicator is stealing too much frames
        Image {
            id: busy
            source: "../Icons/spinner.svg"
            anchors.centerIn: parent
            visible: parent.status===Image.Loading
            width: 48
            height: width
            Timer{
                interval: 150
                onTriggered: busy.rotation+=35
                running: parent.visible
                repeat: true
            }
        }
    }

    RowLayout{
        id:bottomRow
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right


        ToolButton{
            id:up
            flat: true
            Layout.fillWidth: true
            Layout.minimumWidth: bottomRow.width/7
            //icon.source: "Icons/up.svg"
            down: (link.likes ===1 || pressed)

            onClicked: {
                if (down)
                    linkVoteManager.vote(link.fullname, VoteManager.Unvote)
                else
                    linkVoteManager.vote(link.fullname, VoteManager.Upvote)
                console.log(link.likes)
            }

            Image{
                source: "../Icons/up.svg"
                width: 24
                height: 24
                anchors.centerIn: parent
            }
        }
        Label{
            id:score
            Layout.fillWidth: true
            Layout.minimumWidth: bottomRow.width/7
            horizontalAlignment: "AlignHCenter"
            text: link.score
            color:  link.score>0 ? "green" : "red"
        }
        ToolButton{
            id:downn
            flat: true
            Layout.fillWidth: true
            Layout.minimumWidth: bottomRow.width/7
            //icon.source: "Icons/down.svg"
            down: (link.likes ===-1 || pressed)

            onClicked: {
                if (down)
                    linkVoteManager.vote(link.fullname, VoteManager.Unvote)
                else
                    linkVoteManager.vote(link.fullname, VoteManager.Downvote)
            }
            Image{
                source: "../Icons/down.svg"
                width: 24
                height: 24
                anchors.centerIn: parent
            }
        }
        ToolButton{
            id:comment
            flat: true
            Layout.fillWidth: true
            Layout.minimumWidth: bottomRow.width/7
            //icon.source: "../Icons/message.svg"
            onClicked: {
                if (compact){
                    var p = { link: link };
                    pageStack.push(Qt.resolvedUrl("CommentsPage.qml"), p);
                }
                //console.log(icon.width)
            }
            Row {
                anchors.centerIn: parent

                Image{
                    id:dk
                    anchors.verticalCenter: parent.verticalCenter
                    source: "../Icons/message.svg"
                    width: 24
                    height: 24
                }
                Label{
                    //anchors.left: dk.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: " "+link.commentsCount
                }
            }

        }
        ToolButton{
            id:share
            Layout.fillWidth: true
            Layout.minimumWidth: bottomRow.width/7
            flat: true
            //icon.source: "Icons/share.svg"
            Image{
                source: "../Icons/share.svg"
                width: 24
                height: 24
                anchors.centerIn: parent
            }
        }
        ToolButton {
            id:save
            Layout.fillWidth: true
            Layout.minimumWidth: bottomRow.width/7
            flat:true
            Image {
                source: link.saved ? "../Icons/starred.svg" : "../Icons/non-starred.svg"
                width: 24
                height: 24
                anchors.centerIn: parent
            }
            onClicked: {
                linkSaveManager.save(link.fullname,!link.saved)
            }
        }
    }
}

