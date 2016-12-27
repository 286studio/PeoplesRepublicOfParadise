#ifndef B2IMAGEUTIL_H
#define B2IMAGEUTIL_H

#include <QObject>
#include <QQmlEngine>
#include <QJSEngine>
#include <QtCore>

class QQuickView;
class B2ImageUtil : public QObject
{
    Q_OBJECT
    // ------------------ Singleton Func -----------------------
    Q_DISABLE_COPY(B2ImageUtil)
    B2ImageUtil() {}
public:
    static QObject* qmlSingleton(QQmlEngine *engine, QJSEngine *scriptEngine);
    static B2ImageUtil* singleton();

    // ------------------ QML Property -----------------------
    Q_PROPERTY(QSizeF devSize READ devSize CONSTANT)
    Q_PROPERTY(QRectF clientRect READ clientRect CONSTANT)
    Q_PROPERTY(QSizeF designSize READ designSize CONSTANT)
    Q_PROPERTY(qreal scale READ scale CONSTANT)

    // ------------------- QML Func ---------------------------
    Q_INVOKABLE bool fileExist(QString path);
    Q_INVOKABLE QSize imageSize(QString path, bool warning=false);
    Q_INVOKABLE bool isWideDevice();
    Q_INVOKABLE bool isTallDevice();
    Q_INVOKABLE void changeTitle(QString s);

    // ------------------- C++ Func ---------------------------
    void setup(QSize designSize, QSize devSize);
    QRectF clientRect(){return _clientRect;}
    QSizeF designSize(){return _designSize;}
    QSizeF devSize(){return _devSize;}
    qreal  scale(){return _scale;}
    void setView(QQuickView* view) {_view=view;}

    // ------------------- Private Func ---------------------------
private:
    QRectF _clientRect;
    QSizeF _designSize;
    QSizeF _devSize;
    qreal  _scale;
    QQuickView* _view;
};

#endif // B2IMAGEUTIL_H
