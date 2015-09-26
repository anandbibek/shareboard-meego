#include <QtGui/QApplication>
#include <QtDeclarative>
#include "qmlapplicationviewer.h"

// socialconnect additions begin

#include "socialconnectplugin.h"

// socialconnect additions end

Q_DECL_EXPORT int main(int argc, char *argv[])
{

    // socialconnect additions begin

    SocialConnectPlugin plugin;
    plugin.registerTypes("SocialConnect");

    // socialconnect additions end


    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QString nexus4UA = "Mozilla/5.0 (Linux; U; Android 4.2; en-us; LT18i Build/4.1.B.0.431) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30";
    app->setApplicationName(nexus4UA);

    QmlApplicationViewer viewer;

    QString data1 = "";
    QString data2 = "";
    if (argc>1) {
        data1 = QCoreApplication::arguments().at(1);
        data2 = QCoreApplication::arguments().at(2);
    }
    viewer.rootContext()->setContextProperty("data1", data1);
    viewer.rootContext()->setContextProperty("data2", data2);

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/TweeBook/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
