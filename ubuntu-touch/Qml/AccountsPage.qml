/*
    Quickddit - Reddit client for mobile phones
    Copyright (C) 2020  Daniel Kutka

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see [http://www.gnu.org/licenses/].
*/

import QtQuick 2.9
import QtQuick.Controls 2.2
import quickddit.Core 1.0

Page {
    title: "Accounts"

    ListView {
        id:accountsView
        anchors.fill: parent

        model:appSettings.accountNames

        delegate: ItemDelegate {
            width: parent.width
            text: modelData
            highlighted: modelData === appSettings.redditUsername

            ToolButton {
                anchors.right: parent.right
                anchors.rightMargin: 12
                height: parent.height
                hoverEnabled: false

                Image {
                    height: 24
                    width: 24
                    anchors.centerIn: parent
                    source: "../Icons/delete.svg"
                }
                onClicked: {
                    if(modelData === appSettings.redditUsername )
                        quickdditManager.signOut();
                    appSettings.removeAccount(modelData);
                }
            }
            onClicked: {
                quickdditManager.selectAccount(modelData);
                pageStack.pop(globalUtils.getMainPage(),StackView.ReplaceTransition)
            }
        }

        footer: ItemDelegate {
            width: parent.width
            text: "Add new account"

            onClicked: {
                pageStack.push(Qt.resolvedUrl("LoginPage.qml"));
            }
        }
    }

}
