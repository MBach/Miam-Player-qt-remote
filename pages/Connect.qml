import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

Pane {
    id: connectPane

    Popup {
        id: connectDialog
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: window.height / 6
        width: Math.min(window.width, window.height) / 5 * 4
        contentHeight: aboutColumn.height

        ColumnLayout {
            id: connectColumn
            spacing: 20

            Label {
                id: headerConnect
                font.bold: true
            }

            Column {
                id: bodyConnect
                Label {
                    text: qsTr("Miam-Player Remote was unable to reach the server")
                    width: connectDialog.availableWidth
                    wrapMode: Text.Wrap
                    font.pixelSize: 12
                }
            }

            BusyIndicator {
                id: busy
                running: true
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

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
            text: qsTr("Connect to Miam-Player:")
        }

        Image {
            id: logo
            anchors.top: connectLabel.bottom
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            horizontalAlignment: Image.AlignHCenter
            fillMode: Image.PreserveAspectFit
            source: "qrc:/images/miam-player_logo.png"
        }

        TextField {
            id: ipHostAddress
            anchors.top: logo.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            placeholderText: qsTr("Type an IP address")
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            onAccepted: {
                headerConnect.text = qsTr("Connecting...")
                bodyConnect.visible = false
                busy.visible = true
                connectDialog.open()
                remoteClient.establishConnectionToServer(text)
            }
        }

        Label {
            id: lastSuccessfulConnectionsLabel
            anchors.top: ipHostAddress.bottom
            Layout.fillWidth: true
            width: parent.width
            wrapMode: Label.Wrap
            horizontalAlignment: Qt.AlignHCenter
            text: qsTr("Last successful connections:")
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
                    headerConnect.text = qsTr("Connecting...")
                    bodyConnect.visible = false
                    busy.visible = true
                    connectDialog.open()
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

    Connections {
        target: remoteClient
        onConnectionSucceded: {
            connectDialog.close()
            drawer.loadPage("Remote", "qrc:/pages/remote")
        }

        onConnectionFailed: {
            headerConnect.text = qsTr("Not connected")
            bodyConnect.visible = true
            busy.visible = false
            connectDialog.open()
        }
    }
}
