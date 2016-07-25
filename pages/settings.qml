import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

import QtQuick.Controls.Material 2.0

Pane {
    id: settingsPane
    width: parent.width
    height: parent.height

    ColumnLayout {
        id: column
        spacing: 0
        anchors.fill: parent

        Label {
            id: connectionsLabel
            text: qsTr("Manage connections")
            textFormat: Text.PlainText
            wrapMode: Text.WordWrap
            verticalAlignment: Text.AlignVCenter
            color: Material.color(Material.Grey)
        }

        RowLayout {
            spacing: 10
            Label {
                id: labelPort
                text: qsTr("Port:")
                Layout.preferredWidth: 150
                Layout.fillWidth: true
            }
            TextField {
                Layout.preferredWidth: 60
                id: portTextField
                text: "5600"
                horizontalAlignment: Text.AlignRight
                Layout.fillHeight: false
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                inputMethodHints: Qt.ImhDigitsOnly
                property int port: 5600

            }
        }

        SwitchDelegate {
            id: switchDelegate
            text: qsTr("On startup, auto-connect to last server")
            spacing: 0
            bottomPadding: 0
            topPadding: 0
            rightPadding: 0
            leftPadding: 0
            anchors.left: parent.left
            anchors.right: parent.right
            clip: false
            checked: true
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.fillWidth: true
        }

        Label {
            id: lastConnectionsLabel
            text: qsTr("Swipe to remove last successful connections")
            topPadding: 12
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            color: Material.color(Material.Grey)
            Layout.fillWidth: true
        }

        Component {
            id: swipeDelegateComponent

            SwipeDelegate {
                id: swipeDelegate
                text: ipText
                width: parent.width

                onClicked: if (swipe.complete) {
                               lastConnectionsModel.removeConnection(ipText)
                           }

                Component {
                    id: removeConnection

                    Rectangle {
                        color: swipeDelegate.swipe.complete && swipeDelegate.pressed ? "#333" : "#444"
                        width: parent.width
                        height: parent.height
                        clip: true

                        Label {
                            font.pixelSize: swipeDelegate.font.pixelSize
                            text: qsTr("Remove")
                            anchors.centerIn: parent
                        }
                    }
                }

                swipe.left: removeConnection
                swipe.right: removeConnection
            }
        }

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: lastConnectionsModel

            delegate: Loader {
                id: delegateLoader
                width: listView.width

                sourceComponent: swipeDelegateComponent

                property string ipText: ip

                // Can't find a way to do this in the SwipeDelegate component itself,
                // so do it here instead.
                ListView.onRemove: SequentialAnimation {
                    PropertyAction {
                        target: delegateLoader
                        property: "ListView.delayRemove"
                        value: true
                    }
                    NumberAnimation {
                        target: item
                        property: "height"
                        to: 0
                        easing.type: Easing.InOutQuad
                    }
                    PropertyAction {
                        target: delegateLoader
                        property: "ListView.delayRemove"
                        value: false
                    }
                }
            }
            focus: true
        }
    }
}
