import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import quickddit.Core 1.0
import Qt.labs.settings 1.0
import QtQuick.Controls.Suru 2.2

import "Qml"
ApplicationWindow {
    visible: true
    width: 376
    height: 644
    title: "quickddit"
    id:window

    SubredditsDrawer{
        id:subredditsDrawer
    }

    header: ToolBar{
        background: Rectangle {
            color: Suru.secondaryBackgroundColor
        }

        RowLayout {
            anchors.fill: parent

            ToolButton {
                width: height
                //icon.source: "Icons/back.svg"
                onClicked: {
                    pageStack.pop()
                }
                Image {
                    anchors.centerIn: parent
                    source: "Icons/back.svg"
                    width: 24
                    height: 24
                }
                visible: pageStack.depth>1
            }

            ToolButton {
                width: height
                visible: pageStack.depth<=1
                //icon.source: "Icons/navigation-menu.svg"
                onClicked: subredditsDrawer.open()
                onPressed: if(!subredditsDrawer.loaded)
                               subredditsDrawer.refresh(false)
                Image {
                    anchors.centerIn: parent
                    source: "Icons/navigation-menu.svg"
                    width: 24
                    height: 24
                }
            }

            Label{
                id:titleLabel
                font.pointSize: 14
                elide: "ElideRight"
                Layout.fillWidth: true
                horizontalAlignment: "AlignLeft"
                verticalAlignment: "AlignVCenter"
                text: pageStack.currentItem.title
            }

            ToolButton {
                width: height
                // icon.source: "Icons/contextual-menu.svg"
                Image {
                    anchors.centerIn: parent
                    source: "Icons/contextual-menu.svg"
                    width: 24
                    height: 24
                }
                onClicked: optionsMenu.open()
                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    y:parent.y+parent.height
                    transformOrigin: Menu.TopRight
                    width: 200

                    MenuItem {
                        text: "My Subreddits"
                        padding: Suru.units.gu(1)
                        onTriggered: {pageStack.push(Qt.resolvedUrl("Qml/SubredditsPage.qml"))
                        }
                    }

                    MenuSeparator {topPadding: 0; bottomPadding:0}

                    MenuItem {
                        text: quickdditManager.isSignedIn ? "Log out ("+quickdditManager.settings.accountNames[0]+")": "Log in"
                        onTriggered:{
                            !quickdditManager.isSignedIn ? pageStack.push(Qt.resolvedUrl("Qml/LoginPage.qml")) : logOutDialog.open();
                        }
                        Dialog{
                            id:logOutDialog
                            //parent: Overlay.overlay
                            title: "Log out"
                            modal: true
                            standardButtons: Dialog.Yes | Dialog.No
                            Label{
                                text: "Do you want to log out?"
                            }
                            onAccepted: {
                                quickdditManager.signOut();
                                globalUtils.getMainPage().refresh();
                            }
                        }
                    }

                    MenuSeparator{topPadding: 0; bottomPadding:0}

                    MenuItem {
                        text: "Settings"
                        onTriggered: pageStack.push(Qt.resolvedUrl("Qml/SettingsPage.qml"))
                    }

                    MenuSeparator{topPadding: 0; bottomPadding:0}

                    MenuItem {
                        text: "About"
                        onTriggered: pageStack.push(Qt.resolvedUrl("Qml/AboutPage.qml"))
                    }
                }
            }
        }
    }

    StackView{
        id:pageStack
        anchors.fill: parent
        initialItem: Component{MainPage{}}
    }

    AppSettings { id: appSettings }

    Settings {
        id: settings
        property string style: "Suru"
        property string layout: "Compact"
    }
    QuickdditManager {
        id: quickdditManager
        settings: appSettings
        onAccessTokenFailure: {
            if (code == 299 /* QNetworkReply::UnknownContentError */) {
                console.warn(qsTr("Please log in again"));
                pageStack.push(Qt.resolvedUrl("Qml/AppSettingsPage.qml"));
            } else {
                console.warn(errorString);
            }
        }
        onAccessTokenSuccess: {
            console.log("Logged in succesfully");
        }
        onBusyChanged: {
            if(pageStack.depth==0&& !quickdditManager.isBusy)
                pageStack.push(Qt.resolvedUrl("Qml/MainPage.qml"));

        }
    }
    // A collections of global utility functions
    //ToDo: try to use unmodified version from sailfish
    QtObject {
        id: globalUtils

        property Component __openLinkDialogComponent: null

        function getMainPage() {
            return pageStack.find(function(page) { return page.objectName === "mainPage"; });
        }

        function getWebViewPage() {
            if (webViewPage === null) {
                webViewPage = __webViewPage.createObject(appWindow);
            }
            return webViewPage;
        }

        function getNavPage() {
            if (subredditsPage == undefined) {
                subredditsPage = __subredditsPage.createObject(appWindow);
            }
            return subredditsPage;
        }

        function getMultiredditModel() {
            return getNavPage().getMultiredditModel()
        }

        function previewableVideo(url) {
            if (python.isUrlSupported(url)) {
                return true;
            } else if (/^https?:\/\/\S+\.(mp4|avi|mkv|webm)/i.test(url)) {
                return true
            } else {
                return false
            }
        }

        function previewableImage(url) {
            // imgur url
            if (/^https?:\/\/((i|m|www)\.)?imgur\.com\//.test(url))
                return !(/^.*\.gifv$/.test(url));
            // reddituploads
            else if (/^https?:\/\/i.reddituploads.com\//.test(url))
                return true;
            // direct image url with image format extension
            else if (/^https?:\/\/\S+\.(jpe?g|png|gif)/i.test(url)){
                return true;
            }
            else{
                return false;
            }
        }

        function redditLink(url) {
            var redditLink = parseRedditLink(url);
            if (redditLink === null)
                return false;

            if (/\.rss$/.test(redditLink.path)) // don't handle RSS links in-app
                return false;
            if (/^\/r\/\w+\/wiki(\/\w+)?/.test(redditLink.path)) // don't handle /r/sub/wiki links in-app
                return false;

            if (/^(\/r\/\w+)?\/comments\/\w+/.test(redditLink.path))
                return true;
            if (/^\/r\/(\w+)/.test(redditLink.path))
                return true;
            if (/^\/u(ser)?\/([A-Za-z0-9_-]+)/.test(redditLink.path))
                return true;
            if (/^\/message\/compose/.test(redditLink.path))
                return true;
            if (/^\/search/.test(redditLink.path))
                return true;

            return false
        }

        function openRedditLink(url) {
            var redditLink = parseRedditLink(url);
            if (redditLink === null) {
                console.log("Not a reddit link: " + url);
                return;
            }

            var params = {}

            if (/^(\/r\/\w+)?\/comments\/\w+/.test(redditLink.path))
                pushOrReplace(Qt.resolvedUrl("Qml/CommentPage.qml"), {linkPermalink: url});
            else if (/^\/r\/(\w+)/.test(redditLink.path)) {
                var path = redditLink.path.split("/");
                params["subreddit"] = path[2];
                if (path[3] === "search") {
                    if (redditLink.queryMap["q"] !== undefined)
                        params["query"] = redditLink.queryMap["q"]
                    pushOrReplace(Qt.resolvedUrl("Qml/SearchDialog.qml"), params);
                    return;
                }

                if (path[3] !== "")
                    params["section"] = path[3];
                pushOrReplace(Qt.resolvedUrl("Qml/MainPage.qml"), params);
            } else if (/^\/u(ser)?\/([A-Za-z0-9_-]+)/.test(redditLink.path)) {
                var username = redditLink.path.split("/")[2];
                pushOrReplace(Qt.resolvedUrl("Qml/UserPage.qml"), {username: username});
            } else if (/^\/message\/compose/.test(redditLink.path)) {
                params["recipient"] = redditLink.queryMap["to"]
                if (redditLink.queryMap["message"] !== null)
                    params["message"] = redditLink.queryMap["message"]
                if (redditLink.queryMap["subject"] !== null)
                    params["subject"] = redditLink.queryMap["subject"]
                pushOrReplace(Qt.resolvedUrl("Qml/SendMessagePage.qml"), params);
            } else if (/^\/search/.test(redditLink.path)) {
                if (redditLink.queryMap["q"] !== undefined)
                    params["query"] = redditLink.queryMap["q"]
                pushOrReplace(Qt.resolvedUrl("Qml/SearchDialog.qml"), params);
            } else
                infoBanner.alert(qsTr("Unsupported reddit url"));
        }

        function pushOrReplace(page, params) {
            if (pageStack.currentPage.objectName === "subredditsPage") {
                var mainPage = globalUtils.getMainPage();
                mainPage.__pushedAttached = false;
                pageStack.replaceAbove(mainPage, page, params);
            } else {
                pageStack.push(page, params)
            }
        }

        function parseRedditLink(url) {
            var shortLinkRe = /^https?:\/\/redd.it\/([^/]+)\/?/.exec(url);
            var linkRe = /^(https?:\/\/(\w+\.)?reddit.com)?(\/[^?]*)(\?.*)?/.exec(url);
            if (linkRe === null && shortLinkRe === null) {
                return null;
            }

            var link = {}
            if (shortLinkRe !== null) {
                link = {
                    path: "/comments/" + shortLinkRe[1],
                    query: ""
                }
            } else {
                link = {
                    path: linkRe[3].charAt(linkRe[3].length-1) === "/" ? linkRe[3].substring(0,linkRe[3].length-1) : linkRe[3],
                    query: linkRe[4] === undefined ? "" : linkRe[4].substring(1)
                }
            }
            link.queryMap = {}
            if (link.query !== "") {
                var urlparams = link.query.split("&")
                for (var i=0; i < urlparams.length; i++) {
                    var kvp = urlparams[i].split("=");
                    link.queryMap[kvp[0]] = decodeURIComponent(kvp[1]);
                }
            }
            return link
        }

        function openImageViewPage(url) {
            if (/^https?:\/\/((i|m|www)\.)?imgur\.com/.test(url))
                pageStack.push(Qt.resolvedUrl("Qml/ImageViewPage.qml"), {imgurUrl: url});
            else if (/^https?:\/\/\S+\.(jpe?g|png|gif)/i.test(url))
                pageStack.push(Qt.resolvedUrl("Qml/ImageViewPage.qml"), {imageUrl: url});
            else if (/^https?:\/\/i.reddituploads.com\//.test(url))
                pageStack.push(Qt.resolvedUrl("Qml/ImageViewPage.qml"), {imageUrl: url});
            else
                infoBanner.alert(qsTr("Unsupported image url"));
        }

        function openVideoViewPage(url) {
            if (python.isUrlSupported(url)) {
                pageStack.push(Qt.resolvedUrl("VideoViewPage.qml"), { origUrl: url });
            } else if ((/^https?:\/\/\S+\.(mp4|avi|mkv|webm)/i.test(url))) {
                pageStack.push(Qt.resolvedUrl("VideoViewPage.qml"), { videoUrl: url });
            } else
                infoBanner.alert(qsTr("Unsupported video url"));
        }

        function toAbsoluteUrl(url)
        {

            if (String(url).charAt(0)==='/')
                return "https://www.reddit.com" + url;
            else
                return url;
        }
        function openLink(url) {
            url = toAbsoluteUrl(url);
            if (!url)
                return;

            //if (previewableVideo(url))
            //    openVideoViewPage(url);
            if (previewableImage(url))
                openImageViewPage(url);
            else if (redditLink(url))
                openRedditLink(url);
            else
                createOpenLinkDialog(url);
        }


        function openNonPreviewLink(url, source) {
            url = toAbsoluteUrl(source)
            if (url) {
                source = toAbsoluteUrl(source);
                if (source === url) {
                    source = undefined
                }

                createOpenLinkDialog(url,source);
            }
        }

        /*function toAbsoluteUrl(QMLUtils.toAbsoluteUrl() url)
        {
            if (!QUrl(url).isRelative())
                return url;

            if (url.startsWith('/'))
                return "https://www.reddit.com" + url;
            else
                return "";
        }*/

        function createOpenLinkDialog(url, source) {
            pageStack.push(Qt.resolvedUrl("Qml/WebViewer.qml"), {url: url, source: source});
        }

        function createSelectionDialog(title, model, selectedIndex, onAccepted) {
            var p = {title: title, model: model, selectedIndex: selectedIndex}
            var dialog = pageStack.push(Qt.resolvedUrl("SelectionDialog.qml"), p);
            dialog.accepted.connect(function() { onAccepted(dialog.selectedIndex); })
        }

        function formatDuration(seconds) {
            var date = new Date(null);
            if (seconds < 0)
                seconds = 0
            date.setSeconds(seconds);
            var durationString = date.toISOString().substr(11, 8);
            if (durationString.indexOf("00") === 0)
                durationString = durationString.substr(3)
            return durationString
        }

        // StyledText has severe limitations, but can be elided unlike RichText
        // we pick off a few <p> paragraphs and return a simplified, cropped representation
        function formatForStyledText(text) {
            var result = ""
            var re = /(<p>(.*?)<\/p>)/g
            re.lastIndex = 0 // QT bug, lastIndex not always initialized to 0
            var match = re.exec(text)
            while (result.length < 1000 && match !== null) {
                if (result.length != 0)
                    result += "<br/><br/>"
                result += match[2]
                console.log(result);
                match = re.exec(text)
            }
            if (result.length == 0)
                result = text
            result = result.replace(/&#39;/g,"'") // $#39 not shown when using StyledText?
            return result
        }
    }

}
