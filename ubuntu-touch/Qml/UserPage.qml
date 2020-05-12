import QtQuick 2.9
import QtQuick.Controls 2.2
import quickddit.Core 1.0

Page {
    title: username;

    property string username;

    ListView {
        anchors.fill: parent
        header: Row {
            Label {
                text: userManager.user.name
            }
        }
    }

    Component.onCompleted: {
        userManager.request(username);
    }

    UserManager {
        id: userManager
        manager: quickdditManager
        onError: console.log(errorString);
    }

    UserThingModel {
        id: userThingModel
        manager: quickdditManager
        section: myself ? UserThingModel.SavedSection : UserThingModel.OverviewSection
        onError: console.log(errorString);
    }

    LinkManager {
        id: linkManager
        manager: quickdditManager
        userThingModel: userThingModel
        onSuccess: console.log(message);
        onError: console.log(errorString);
    }

    MessageManager {
        id: messageManager
        manager: quickdditManager
        onSendSuccess: {
            console.log(qsTr("Message sent"));
            pageStack.pop();
        }
        onError: console.log(errorString);
    }

    SaveManager {
        id: linkSaveManager
        manager: quickdditManager
        onSuccess: console.log("TODO: update userpage model");
        onError: console.log(errorString);
    }
}
