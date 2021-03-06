import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import Qt.labs.settings 1.0

import org.miamplayer.remote 1.0

Pane {
    id: connectPane

    NetworkScannerModel {
        id: networkScannerModel
    }

    Popup {
        id: startupDialog
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: window.height / 6
        width: Math.min(window.width, window.height) / 5 * 4
        closePolicy: Popup.NoAutoClose

        height: startupColumn.height + topPadding + bottomPadding
        contentItem: ColumnLayout {

            id: startupColumn
            spacing: 20

            Label {
                id: noWifiLabel
                text: qsTr("No WiFi detected")
                font.bold: true
            }

            Label {
                wrapMode: Label.WordWrap
                text: qsTr("Please enable Wifi to use this App.")
            }
            Label {
                wrapMode: Label.WordWrap
                text: qsTr("Would you like to turn on Wifi?")
            }
            BusyIndicator {
                id: wifiBusyIndicator
                running: true
                visible: false
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                id: wifiRowLayout
                spacing: 10
                Button {
                    id: exitButton
                    text: "Exit"
                    onClicked: Qt.quit()
                    Material.background: "transparent"
                    Material.elevation: 0
                    Layout.preferredWidth: 0
                    Layout.fillWidth: true
                }
                Button {
                    id: activateWifiButton
                    text: "Ok"
                    onClicked: {
                        wifiRowLayout.visible = false
                        wifiBusyIndicator.visible = true
                        wifiChecker.enableWifi()
                    }

                    Material.foreground: Material.color(Material.Indigo)
                    Material.background: "transparent"
                    Material.elevation: 0
                    Layout.preferredWidth: 0
                    Layout.fillWidth: true
                }
            }
        }
    }

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

    Popup {
        id: scanNetworkPopup
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: window.height / 6
        width: Math.min(window.width, window.height) / 5 * 4
        contentHeight: scanColumn.height
        contentWidth: scanColumn.width
        ColumnLayout {
            id: scanColumn
            spacing: 20

            Label {
                text: qsTr("Scanning...")
                font.bold: true
            }

            ProgressBar {
                indeterminate: true
            }

            ListView {
                id: scanNetworkListView
                model: networkScannerModel
                Layout.fillWidth: true
                Layout.fillHeight: true
                width: parent.width
                clip: true
                /*delegate: Loader {
                    id: delegateNetworkLoader
                    width: listView.width
                    sourceComponent: radioDelegateComponent
                    property string ipText: ip
                    property ListView view: listView
                }*/
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
            horizontalAlignment: Qt.AlignLeft
            text: qsTr("Scan network to find Miam-Player")
            color: Material.color(Material.Grey)
        }

        Button {
            id: scanNetworkButton
            text: qsTr("Scan network")
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            onClicked: {
                scanNetworkPopup.open()
                networkScannerModel.scanNetwork()
            }
        }

        Label {
            id: directConnectLabel
            Layout.fillWidth: true
            width: parent.width
            wrapMode: Label.Wrap
            horizontalAlignment: Qt.AlignLeft
            text: qsTr("Connect manually")
            topPadding: 0
            bottomPadding: 8
            verticalAlignment: Text.AlignVCenter
            color: Material.color(Material.Grey)
        }

        TextField {
            id: ipHostAddress
            anchors.top: directConnectLabel.bottom
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
            topPadding: 12
            id: lastSuccessfulConnectionsLabel
            anchors.top: ipHostAddress.bottom
            Layout.fillWidth: true
            width: parent.width
            wrapMode: Label.Wrap
            horizontalAlignment: Qt.AlignLeft
            text: qsTr("Last successful connections")
            color: Material.color(Material.Grey)
        }

        ButtonGroup {
            id: radioButtonGroup
        }

        Component {
            id: radioDelegateComponent

            RadioDelegate {
                id: control
                text: hostName
                width: parent.width
                height: 90
                ButtonGroup.group: radioButtonGroup

                contentItem: Label {
                    rightPadding: control.indicator.width + control.spacing
                    text: hostName + "<br>" + dateText
                    font: control.font
                    color: Material.foreground
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    textFormat: Text.RichText
                }

                onClicked: {
                    headerConnect.text = qsTr("Connecting...")
                    bodyConnect.visible = false
                    busy.visible = true
                    connectDialog.open()
                    remoteClient.establishConnectionToServer(ipText)
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
                property string hostName: host
                property string ipText: ip
                property string dateText: date
                property ListView view: listView
            }
            focus: true
        }
    }

    Settings {
        id: settings
        property bool autoConnect: true
    }

    Connections {
        target: wifiChecker
        onCloseStartupPopup: {
            startupDialog.close()
            if (settings.autoConnect && listView.count > 0) {
                remoteClient.establishConnectionToServer(lastConnectionsModel.lastConnectionIP())
            }
        }
    }

    Connections {
        target: remoteClient
        onConnectionSucceded: {
            lastConnectionsModel.addConnection(hostName, ip)
            connectDialog.close()
            drawer.loadPage(qsTr("Remote"), "qrc:/pages/remote")
        }

        onConnectionFailed: {
            headerConnect.text = qsTr("Not connected")
            bodyConnect.visible = true
            busy.visible = false
            connectDialog.open()
        }
    }

    Component.onCompleted: {
        if (wifiChecker.isOk()) {
            if (!remoteClient.isConnected() && settings.autoConnect && listView.count > 0) {
                remoteClient.establishConnectionToServer(lastConnectionsModel.lastConnectionIP())
            }
        } else {
            startupDialog.open()
        }
    }
}
