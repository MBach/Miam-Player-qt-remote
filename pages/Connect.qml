import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

Pane {
    id: connectPane

    ColumnLayout {
        id: column
        transformOrigin: Item.Center
        spacing: 20
        anchors.fill: parent
        anchors.topMargin: 0

        Label {
            id: connectLabel
            Layout.fillWidth: true
            width: parent.width
            wrapMode: Label.Wrap
            horizontalAlignment: Qt.AlignHCenter
            text: "Connect to Miam-Player:"
        }

        Image {
            id: logo
            anchors.top: connectLabel.bottom

            Layout.fillWidth: true
            //width: connectPane.availableWidth / 6
            //height: connectPane.availableHeight / 6
            Layout.preferredHeight: 100
            //Layout.preferredHeight: 100
            horizontalAlignment: Image.AlignHCenter
            fillMode: Image.PreserveAspectFit
            source: "qrc:/images/miam-player_logo.png"
        }

        BusyIndicator {
            id: busy
            running: remoteClient.isConnecting
            //running: true
            anchors.top: logo.bottom
        }

        TextField {
            id: ipHostAddress
            anchors.top: logo.bottom
            anchors.left: busy.right
            anchors.right: parent.right
            placeholderText: "Type an IP address"
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            onAccepted: remoteClient.establishConnectionToServer(text)
        }

        Label {
            id: lastSuccessfulConnectionsLabel
            anchors.top: busy.bottom
            Layout.fillWidth: true
            width: parent.width
            wrapMode: Label.Wrap
            horizontalAlignment: Qt.AlignHCenter
            text: "Last successful connections:"
        }

        ButtonGroup {
            id: radioButtonGroup
        }

        Component {
            id: radioDelegateComponent

            RadioDelegate {
                text: ipText
                width: parent.width
                ButtonGroup.group: radioButtonGroup
                onClicked: {
                    console.log(text)
                    remoteClient.establishConnectionToServer(text)
                }
            }
        }

        ListView {
            id: listView
            anchors.top: lastSuccessfulConnectionsLabel.bottom
            anchors.bottom: parent.bottom
            model: lastConnectionsModel
            Layout.fillWidth: true
            Layout.fillHeight: true
            width: parent.width
            clip: true
            delegate: Loader {
                id: delegateLoader
                width: listView.width
                sourceComponent: radioDelegateComponent
                property string ipText: ip
                property ListView view: listView
            }
            focus: true
        }
    }

    Popup {
        id: connectDialog
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: window.height / 6
        width: Math.min(window.width, window.height) / 3 * 2
        contentHeight: aboutColumn.height

        Column {
            id: connectedColumn
            spacing: 20

            Label {
                id: headerConnect
                text: "You are connected"
                font.bold: true
            }

            Label {
                id: bodyConnect
                width: aboutDialog.availableWidth
                wrapMode: Label.Wrap
                font.pixelSize: 12
            }
        }
    }

    Connections {
        target: remoteClient
        onAboutToDisplayGreetings: {
            bodyConnect.text = greetings
            connectDialog.open()
        }
    }
}
