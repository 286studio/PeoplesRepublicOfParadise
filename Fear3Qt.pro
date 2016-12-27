TEMPLATE = app

# must be current macOS version!
QMAKE_MAC_SDK = macosx10.12

QT += qml quick multimedia
CONFIG += c++11 resources_big

SOURCES += main.cpp b2file.cpp b2imageutil.cpp

HEADERS += b2file.h b2imageutil.h

RESOURCES += qml.qrc \
    res.qrc \
    scr.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)
