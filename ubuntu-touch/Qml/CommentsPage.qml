import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import quickddit.Core 1.0

Page {
    id:commentPage
    title:commentModel.link.title

    property alias link: commentModel.link
    property alias linkPermalink: commentModel.permalink
    property VoteManager linkVoteManager
    property SaveManager linkSaveManager

    function refresh(refreshOlder) {
        commentModel.refresh(refreshOlder);
    }

    readonly property variant commentSortModel: [qsTr("Best"), qsTr("Top"), qsTr("New"), qsTr("Hot"), qsTr("Controversial"), qsTr("Old")]

    function loadMoreChildren(index, children) {
        commentModel.moreComments(index, children);
    }

    ListView{
        id:commentsList
        anchors.fill: parent
        header: LinkDelegate{
            width: parent.width
            link: commentModel.link
            compact: false
        }

        model: commentModel
        delegate: CommentDelegate {
            id:commentDelegate
            width: parent.width

        }
    }
    CommentModel {
        id: commentModel
        manager: quickdditManager
        permalink: link.permalink
        onError: infoBanner.warning(errorString)
        onCommentLoaded: {
            var rlink = globalUtils.parseRedditLink(permalink)
            var post = rlink.path.split("/").pop()
            var postIndex = commentModel.getCommentIndex("t1_" + post);
            if (postIndex !== -1) {
                commentListView.model = commentModel
                commentListView.positionViewAtIndex(postIndex, ListView.Contain);
                commentListView.currentIndex = postIndex;
                commentListView.currentItem.highlight();
            } else {
                //viewHack.start();
            }
        }
    }

    CommentManager {
        id: commentManager
        manager: quickdditManager
        model: commentModel
        linkAuthor: link ? link.author : ""
        onSuccess: infoBanner.alert(message);
        onError: infoBanner.warning(errorString);
    }

    LinkManager {
        id: linkManager
        manager: quickdditManager
        commentModel: commentModel
        onSuccess: {
            infoBanner.alert(message);
            pageStack.pop();
        }
        onError: infoBanner.warning(errorString);
    }

    VoteManager {
        id: commentVoteManager
        manager: quickdditManager
        onVoteSuccess: {
            if (fullname.indexOf("t1") === 0) // comment
                commentModel.changeLikes(fullname, likes);
            else if (fullname.indexOf("t3") === 0) // link
                commentModel.changeLinkLikes(fullname, likes);
        }
        onError: infoBanner.warning(errorString);
    }

    SaveManager {
        id: commentSaveManager
        manager: quickdditManager
        onSuccess: {
            if (fullname.indexOf("t1") === 0) // comment
                commentModel.changeSaved(fullname, saved);
            else if (fullname.indexOf("t3") === 0) // link
                commentModel.changeLinkSaved(fullname, saved);
        }
        onError: infoBanner.warning(errorString);
    }

    Connections {
        target: linkVoteManager
        onVoteSuccess: if (linkVoteManager != commentVoteManager) { commentModel.changeLinkLikes(fullname, likes); }
    }

    Connections {
        target: linkSaveManager
        onSuccess: if (linkSaveManager != commentSaveManager) { commentModel.changeLinkSaved(fullname, saved); }
    }

    Component.onCompleted: {
        // if we didn't get vote and save managers passed (for updating models in the calling page),
        // we use the local managers
        if (!linkVoteManager)
            linkVoteManager = commentVoteManager;
        if (!linkSaveManager)
            linkSaveManager = commentSaveManager;
    }
}
