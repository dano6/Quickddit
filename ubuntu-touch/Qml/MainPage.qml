import QtQuick 2.9
import QtQuick.Layouts 1.2
import quickddit.Core 1.0
import QtQuick.Controls 2.2
import Qt.labs.settings 1.0
import QtQuick.Controls.Suru 2.2

Page {

    id:mainPage
    objectName: "mainPage"
    title: subreddit

    property string subreddit
    property string section

    function refresh(sr) {
        if(sr===undefined|| sr===""){
            if(quickdditManager.isSignedIn){
                sr="Subscribed"
            }
            else
                sr="All"
        }

        if ( String(sr).toLowerCase() === "subscribed") {
            linkModel.location = LinkModel.FrontPage;
        } else if (String(sr).toLowerCase() === "all") {
            linkModel.location = LinkModel.All;
        } else if (String(sr).toLowerCase() === "popular") {
            linkModel.location = LinkModel.Popular;
        } else {
            linkModel.location = LinkModel.Subreddit;
            linkModel.subreddit = sr;
        }
        subreddit=sr;
        linkModel.refresh(false);
    }

    function refreshMR(multireddit) {
        linkModel.location = LinkModel.Multireddit;
        linkModel.multireddit = multireddit
        linkModel.refresh(false);
    }


    header: TabBar{
        id: tabBar
        contentHeight: undefined
            //padding: 0
        TabButton{
            id:h
            text: "Hot"
            width: implicitWidth
            padding: Suru.units.gu(1)

        }
        TabButton{
            text: "New"
            width: implicitWidth
            padding: Suru.units.gu(1)
        }
        TabButton{
            text: "Top"
            width: implicitWidth
            padding: Suru.units.gu(1)
        }
        TabButton{
            text: "Controversial"
            width: implicitWidth
            padding: Suru.units.gu(1)
        }
        TabButton{
            text: "Rising"
            width: implicitWidth
            padding: Suru.units.gu(1)
        }
        onCurrentIndexChanged: {
            linkModel.section=currentIndex
            refresh(subreddit)
            swipeView.setCurrentIndex(tabBar.currentIndex)
            linkListView.parent=swipeView.currentItem
            comeon.start();

        }
        PropertyAnimation{id:comeon; target: linkListView; property: "opacity";from:0;to: 1;duration: 1500}
    }

    SwipeView{
        id: swipeView
        anchors.fill: parent

        Item{id:item0

            ListView{
                id: linkListView
                anchors.fill: parent
                model: linkModel
                cacheBuffer: height*3

                delegate: LinkDelegate{
                    linkSaveManager: saveManager
                    linkVoteManager: voteManager
                    id:linkDelegate
                    link:model
                    onClicked: {
                        var p = { link: model };
                        pageStack.push(Qt.resolvedUrl("CommentsPage.qml"), p);
                    }
                }
                onAtYEndChanged: {
                    if (atYEnd && count > 0 && !linkModel.busy && linkModel.canLoadMore)
                        linkModel.refresh(true);
                }
            }
        }
        Item{id:item1}
        Item{id:item2}
        Item{id:item3}
        Item{id:item4}
        onCurrentIndexChanged: {
            tabBar.setCurrentIndex(currentIndex)
        }
    }

    LinkModel {
        id: linkModel
        manager: quickdditManager
        onError: console.log(errorString)
    }

    LinkManager {
        id: linkManager
        manager: quickdditManager
        linkModel: linkModel
        onSuccess: {
            console.log(message);
            pageStack.pop();
        }
        onError: console.log(errorString);
    }

    VoteManager {
        id: voteManager
        manager: quickdditManager
        onVoteSuccess: linkModel.changeLikes(fullname, likes);
        onError: console.warn(errorString);
    }

    SaveManager {
        id: saveManager
        manager: quickdditManager
        onSuccess: linkModel.changeSaved(fullname, saved);
        onError: infoBanner.warning(errorString);
    }

    Component.onCompleted: {
        linkModel.section=0
        refresh("Subscribed")
    }
}
