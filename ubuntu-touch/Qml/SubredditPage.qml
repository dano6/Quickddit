import QtQuick 2.9
import QtQuick.Controls 2.2
import quickddit.Core 1.0
import QtGraphicalEffects 1.0

Page {
    id:subredditPage
    title: subreddit

    property string subreddit
    ScrollView{
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: logoRect.height + Math.max(headerImage.height,30) + subButton.height + showButton.height + about.height + wiki.height
        ScrollBar.vertical.interactive: false

        Image {
            id:headerImage
            anchors{left: parent.left;right: parent.right;top:parent.top}
            fillMode: Image.PreserveAspectFit
            source: aboutSubredditManager.bannerBackgroundUrl
            Component.onCompleted: console.log(aboutSubredditManager.bannerBackgroundUrl)
        }

        Rectangle {
            id: logoRect
            anchors{left: parent.left;top:headerImage.bottom; leftMargin: 20; topMargin: -Math.min(50,headerImage.height)}
            width: Math.min(150,parent.width/3)
            height: width;
            radius: width;
            color:"white"
            clip: true
            Image{
                anchors.centerIn: parent
                id:logoImage
                source: aboutSubredditManager.iconUrl
                width: logoRect.width-20
                height: width
                fillMode: Image.PreserveAspectFit
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: logoRect.width-20
                        height: width
                        radius: width
                    }
                }
            }
        }
        Label {
            id:fullName
            text: subreddit
            font.pointSize: 18
            anchors{ left: logoRect.right;bottom: name.top;leftMargin: 20}
        }
        Label {
            id:name
            text: "r/"+aboutSubredditManager.subreddit
            anchors{left: logoRect.right;bottom: logoRect.bottom;leftMargin: 20}
        }
        Button {
            anchors{top: logoRect.bottom;right: parent.right;margins: 5}
            id:subButton
            text: aboutSubredditManager.isSubscribed?"Unsubscribe":"Subscribe"
            onClicked: {
                if(aboutSubredditManager.isSubscribed)
                    aboutSubredditManager.subscribeOrUnsubscribe()
                else
                    aboutSubredditManager.subscribeOrUnsubscribe()
            }
        }

        Label {
            id:subCount
            anchors{right: subButton.left;verticalCenter:  subButton.verticalCenter; margins: 5}
            text: aboutSubredditManager.activeUsers + " active / " + aboutSubredditManager.subscribers + " subs"
        }

        Label {
            id:about
            anchors {left: parent.left;right: parent.right;top: subButton.bottom; margins:10}
            text: aboutSubredditManager.shortDescription
            wrapMode: "WordWrap"
        }

        Button {
            id:showButton
            text: "Show posts in r/"+subreddit
            anchors { horizontalCenter: parent.horizontalCenter; top: about.bottom; margins: 10}
            onClicked: {
                globalUtils.getMainPage().refresh(subreddit)
                pageStack.pop(globalUtils.getMainPage(),StackView.ReplaceTransition)
            }
        }

        Label {
            id:wiki
            text: aboutSubredditManager.longDescription
            anchors{ left: parent.left;top:showButton.bottom;right: parent.right;margins: 10}
            wrapMode: "WordWrap"
        }
    }


    AboutSubredditManager{
        id:aboutSubredditManager
        manager: quickdditManager
        subreddit: subredditPage.subreddit
    }

    Component.onCompleted: {
        console.log(subreddit)
    }
}
