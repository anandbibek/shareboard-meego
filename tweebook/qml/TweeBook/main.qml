import QtQuick 1.1
import com.nokia.meego 1.1
import SocialConnect 1.0

PageStackWindow {


    property bool cp_inPortrait: appWindow.inPortrait
    property string imgUrl : ""
    property int initial : 0


    id: appWindow

    //initialPage: mainPage


    Component.onCompleted: {
        theme.inverted = true;
        // Try to restore the saved credentials
        twitterConnection.restoreCredentials();
        facebookConnection.restoreCredentials();

        // If none of the supported SoMe services proves to be authenticated,
        // present the LaunchWizardPage to the user.
        if (!facebookConnection.authenticated && !twitterConnection.authenticated) {
            pageStack.push(Qt.resolvedUrl("LaunchWizardPage.qml"),
                          {pageStack: pageStack,
                           facebook: facebookConnection,
                           twitter: twitterConnection,
                           webIf: webInterface});
        } else {
            pageStack.push(Qt.resolvedUrl("MainPage.qml"),
                          {pageStack: pageStack,
                           facebook: facebookConnection,
                           twitter: twitterConnection,
                           webIf: webInterface});
        }
    }

    WebInterface {
        id: webInterface
    }

    TwitterConnection {
        id: twitterConnection

        webInterface: webInterface
        consumerKey: "O8tvcleqSxvCYKiafbcARQ"
        consumerSecret: "onovRXcssvdAYPRD2c1M9ib3SMQFaMMZlLYBGh22Zk"
        callbackUrl: "http://theweekendcoder.blogspot.com"
        //callbackUrl: "http://projects.developer.nokia.com/statusshout"

        onAuthenticateCompleted: console.debug("TWITTER onAuthenticateCompleted! Success: " + success)
    }

//    TwitterConnection {
//        id: twitterConnection

//        webInterface: webInterface
//        consumerKey: "8X8HXL5PuNIPpuieYICVQ"
//        consumerSecret: "GCJgN1mh4rtBjB8ZjDaOEoZ83hqbOyjufJThw50I"
//        callbackUrl: "http://projects.developer.nokia.com/statusshout"

//        onAuthenticateCompleted: console.debug("TWITTER onAuthenticateCompleted! Success: " + success)
//    }

    FacebookConnection {
        id: facebookConnection

        webInterface: webInterface
        permissions: ["publish_stream", "read_stream", "friends_status"]
        clientId: "	506835416004535" //"399096860123557"

        onAuthenticateCompleted: console.debug("FACEBOOK onAuthenticateCompleted! Success: " + success)
    }

}
