import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import quickddit.Core 1.0
import QtQuick.Controls.Suru 2.2

Page {
    title: section

    property string  section

    header:Item {
        width: parent.width
        height: tabBar.height+(search.visible?search.height:0)
        TabBar{
            id: tabBar
            width: parent.width
            currentIndex: swipeView.currentIndex
            contentHeight: undefined
            contentWidth: implicitWidth
            TabButton{
                text: "Subscribed"
                padding: Suru.units.gu(1)
                width: implicitWidth
            }
            TabButton{
                text: "Popular"
                padding: Suru.units.gu(1)
                width: implicitWidth
            }
            TabButton{
                text: "New"
                padding: Suru.units.gu(1)
                width: implicitWidth
            }
            TabButton{
                text: "Search"
                padding: Suru.units.gu(1)
                width: implicitWidth
            }
            onCurrentIndexChanged: {
                console.log(currentIndex)
                swipeView.setCurrentIndex(currentIndex)

                switch(currentItem.text){
                case "Subscribed":
                    subredditModel.section=SubredditModel.UserAsSubscriberSection;
                    break;
                case "Popular":
                    subredditModel.section=SubredditModel.PopularSection
                    break;
                case "New":
                    subredditModel.section=SubredditModel.NewSection
                    break;
                case "Search":
                    subredditModel.section=SubredditModel.SearchSection
                    subredditModel.query=" "
                    subredditModel.clear()
                    search.forceActiveFocus()
                    break;
                }
                section=currentItem.text
                subredditsView.parent=swipeView.currentItem
                subredditModel.refresh(false)
            }
        }

        TextField {
            id:search
            visible: section==="Search"
            anchors.top: tabBar.bottom
            width: parent.width
            text: ""
            onTextEdited: {
                subredditModel.query=" "+text
                subredditModel.refresh(false)
            }
        }
    }

    SwipeView{
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Item{
            ListView{

                anchors.fill: parent
                id:subredditsView
                model: subredditModel
                delegate: SubredditDelegate{
                    id:subredditDelegate
                    manager:subredditManager
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("SubredditPage.qml"),{subreddit:model.displayName})
                    }
                }
                onAtYEndChanged: {
                    if (atYEnd && count > 0 && !subredditModel.busy && subredditModel.canLoadMore)
                        subredditModel.refresh(true);
                }
            }
        }
        Item{}
        Item{}
        Item{}
    }


    SubredditModel {
        id: subredditModel
        manager: quickdditManager
        section: SubredditModel.UserAsSubscriberSection
        onError: console.warn(errorString);
    }

    SubredditManager {
        id: subredditManager
        manager: quickdditManager
        //onSuccess: linkModel.changeSaved(fullname, saved);
        onError: console.log(errorString);
    }

    MultiredditModel {
        id: multiredditModel
        manager: quickdditManager
        onError: console.warn(errorString);
    }

    Connections {
        target: quickdditManager

        onSignedInChanged: {
            if (quickdditManager.isSignedIn) {
                // only load the list if there is an existing list (otherwise wait for page to activate, see above)
                if (subredditModel.rowCount() === 0)
                    return;
                subredditModel.refresh(false)
                multiredditModel.refresh(false)
            } else {
                subredditModel.clear();
                multiredditModel.clear();
            }
        }
    }
    Component.onCompleted:
    {
        subredditModel.section=SubredditModel.UserAsSubscriberSection
        subredditModel.refresh(false)
        console.log(quickdditManager.isSignedIn)
    }

    function showSubreddit(subreddit) {
        var mainPage = globalUtils.getMainPage();
        mainPage.refresh(subreddit);
        pageStack.navigateBack();
    }

    function replacePage(newpage, parms) {
        var mainPage = globalUtils.getMainPage();
        mainPage.__pushedAttached = false;
        pageStack.replaceAbove(mainPage, newpage, parms);
    }

    function getMultiredditModel() {
        return multiredditModel
    }

    function tabButtonClick(s) {
        if(s!==section)
            switch(s){
            case "Subscribed":
                subredditModel.section=SubredditModel.UserAsSubscriberSection;
                break;
            case "Popular":
                subredditModel.section=SubredditModel.PopularSection
                break;
            case "Moderated":
                subredditModel.section=SubredditModel.UserAsModeratorSection
                break;
            case "Contributed":
                subredditModel.section=SubredditModel.UserAsContributorSection
                break;
            case "Search":
                subredditModel.section=SubredditModel.SearchSection
                subredditModel.query=" "
                subredditModel.clear()
                search.forceActiveFocus()
                break;
            }
        section=s;
        subredditModel.refresh(false)
    }
}
