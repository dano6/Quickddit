import QtQuick 2.9
import QtQuick.Controls 2.2
import quickddit.Core 1.0
import QtQuick.Controls.Suru 2.2

Drawer {
    id:subredditsDrawer
    height: window.height
    width: 250
    dragMargin: 0
    property bool loaded: false
    property bool signedIn: false
    function showSubreddit(subreddit) {
        var mainPage = globalUtils.getMainPage();
        mainPage.refresh(subreddit);
    }

    function refresh(dk) {
        loaded=true
        subredditModel.section= signedIn ? SubredditModel.PopularSection : SubredditModel.UserAsSubscriberSection
        subredditModel.submit({"displayName":"All"})
        subredditModel.refresh(true);
    }

    ListView{
        anchors.fill: parent
        id:subredditsView
        model: subredditModel
        header:Column{
            width: parent.width
            ItemDelegate{
            text: "Subscribded"
            width: parent.width
            implicitHeight: Suru.units.gu(6)
            visible: quickdditManager.isSignedIn
            onClicked: {
                showSubreddit(text);
                subredditsDrawer.close();
            }
        }
            ItemDelegate{
            text: "All"
            width: parent.width
            implicitHeight: Suru.units.gu(6)
            onClicked: {
                showSubreddit(text);
                subredditsDrawer.close();
            }
        }
            ItemDelegate{
            text: "Popular"
            width: parent.width
            implicitHeight: Suru.units.gu(6)
            onClicked: {
                showSubreddit(text);
                subredditsDrawer.close();
            }
        }
        }

        delegate: ItemDelegate{
            id:subredditDelegate
            width: parent.width
            text: model.displayName
            implicitHeight: Suru.units.gu(6)
            //highlighted: ListView.isCurrentItem
            onClicked: {
                showSubreddit(subredditDelegate.text);
                subredditsDrawer.close();
            }
        }

        Component.onCompleted: {
        }

        onAtYEndChanged: {
            if (atYEnd && count > 0 && !subredditModel.busy && subredditModel.canLoadMore)
                subredditModel.refresh(true);
        }
    }
    SubredditModel {
        id: subredditModel
        manager: quickdditManager
        section: SubredditModel.UserAsSubscriberSection
        onError: console.warn(errorString);
        onBusyChanged: {
            //if(!subredditModel.busy&& subredditModel.)
        }

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
            signedIn=quickdditManager.isSignedIn;
        }
    }
    Component.onCompleted: {
        //subredditModel.refresh(true)
    }
}
