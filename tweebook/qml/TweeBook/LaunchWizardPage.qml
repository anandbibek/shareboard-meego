import QtQuick 1.1
import com.nokia.meego 1.1
import SocialConnect 1.0

Page {
    id: launchWizardPage

    property PageStack pageStack

    property FacebookConnection facebook
    property TwitterConnection twitter
    property WebInterface webIf

    Label {
        id: titleText

        anchors {
            top: parent.top
            topMargin: 30
            horizontalCenter: parent.horizontalCenter
        }
        width: parent.width * 0.8
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 26
        text: qsTr("ShareBoard 1.0.0")
    }

    Label {
        id: descriptionText

        anchors {
            top: titleText.bottom
            topMargin: 30
            horizontalCenter: parent.horizontalCenter
        }
        width: parent.width * 0.8
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        text: qsTr("You may log in to Facebook and/or Twitter and post updates with or without an image to both networks simultaneously"
                   + "\n\nReport problems and feedbacks to @Anand_Bibek on Twitter" +
                   "\nTap the input field in landscape mode if keyboard doesn't open normally.")
    }

    Button {
        id: facebookButton
        visible: !facebook.authenticated

        anchors {
            top: descriptionText.bottom
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("Connect to Facebook")

        onClicked: {
            busyIndicatorLoader.loading = true;
            // TODO! Check the authenticate return value!
            facebook.authenticate();
        }
    }

    SocialMediaItem {
        id: facebookConnected

        anchors {
            top: descriptionText.bottom
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        visible: facebook.authenticated  // Shown only, if connected.
        text: "Logout " + facebook.name
        imageSource: "gfx/thumb1.png"
        onClicked: {
            facebook.removeCredentials()
            facebookConnected.visible = false
            facebookButton.visible = true
        }
    }

    Button {
        id: twitterButton
        visible: !twitter.authenticated

        anchors {
            top: facebookButton.bottom
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("Connect to Twitter")

        onClicked: {
            busyIndicatorLoader.loading = true;
            // TODO! Check the authenticate return value!
            twitter.authenticate();
        }
    }

    SocialMediaItem {
        id: twitterConnected

        anchors {
            top: facebookButton.bottom
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        visible: twitter.authenticated  // Shown only, if connected.
        text: "Logout " + twitter.name
        imageSource: "gfx/thumb2.png"
        onClicked: {
            twitter.removeCredentials()
            twitterConnected.visible = false
            twitterButton.visible = true
        }
    }

    Loader {
        id: busyIndicatorLoader

        property bool loading: false

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 50
        }
        sourceComponent: loading ? busyIndicator : undefined

        Component {
            id: busyIndicator

            BusyIndicator {
                running: true
                width: 300
                height: 300
            }
        }
    }

    WebViewLoader {
        id: webViewLoader

        webIf: launchWizardPage.webIf
        anchors.fill: parent
    }

    Connections {
        target: twitter

        onAuthenticateCompleted: {
            busyIndicatorLoader.loading = false;

            if (success) {
                // Save the access token etc.
                twitter.storeCredentials();
                // Let the user continue!
                twitterButton.visible = false;
                twitterConnected.visible = true;
                continueButton.enabled = true;
            }
        }
    }

    Connections {
        target: facebook

        onAuthenticateCompleted: {
            busyIndicatorLoader.loading = false;

            if (success) {
                facebook.storeCredentials();
                facebookButton.visible = false;
                facebookConnected.visible = true;
                continueButton.enabled = true;
            }
        }
    }

    tools: ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back"

            onClicked: {
                if (webViewLoader.active) {
                    busyIndicatorLoader.loading = false;
                    twitter.cancel();
                    facebook.cancel();
                } else {
                    pageStack.pop()
                }
            }
        }

        ToolButton {
            id: continueButton

            enabled: true
            text: qsTr("Continue")

            onClicked: {
                pageStack.replace(Qt.resolvedUrl("MainPage.qml"),
                                  {pageStack: pageStack,
                                      webIf: webInterface,
                                      twitter: twitterConnection,
                                      facebook: facebookConnection});
            }
        }
    }
}
