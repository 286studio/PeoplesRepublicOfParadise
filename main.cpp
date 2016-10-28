#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>

#include "b2file.h"
#include "b2imageutil.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterSingletonType<B2File>("B2.File", 1, 0, "File", &B2File::qmlSingleton);
    qmlRegisterSingletonType<B2ImageUtil>("B2.ImageUtil", 1, 0, "ImageUtil", &B2ImageUtil::qmlSingleton);

    qmlRegisterSingletonType(QUrl(QStringLiteral("qrc:/B2Notification.qml")), "B2.Notification", 1, 0, "Notification" );
    qmlRegisterSingletonType(QUrl(QStringLiteral("qrc:/B2Sound.qml")), "B2.Sound", 1, 0, "Sound" );
    qmlRegisterSingletonType(QUrl(QStringLiteral("qrc:/B2TextFont.qml")), "B2.TextFont", 1, 0, "TextFont" );

    B2ImageUtil::singleton()->setup(QSize(960,640),QSize(960,640));

    // start with a viewer
    QQuickView viewer;
    QSize winSize(960,640);
    viewer.setSource(QUrl(QStringLiteral("qrc:/main.qml")));
    // common settings
    viewer.setResizeMode(QQuickView::SizeRootObjectToView);
    viewer.setTitle(QObject::tr("~People's Republic of Paradise~"));
    //
    viewer.setMaximumSize(winSize);
    viewer.setMinimumSize(winSize);
    viewer.show();

    return app.exec();
}
