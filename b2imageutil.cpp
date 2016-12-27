#include <QImageReader>
#include <QJsonObject>
#include <QQuickView>
#include "b2imageutil.h"

static B2ImageUtil* _singleton=nullptr;

QObject* B2ImageUtil::qmlSingleton(QQmlEngine *engine, QJSEngine *scriptEngine){
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    if(!_singleton)
        _singleton=new B2ImageUtil;
    return _singleton;
}
B2ImageUtil* B2ImageUtil::singleton(){
    return qobject_cast<B2ImageUtil*>(qmlSingleton(nullptr,nullptr));
}

bool B2ImageUtil::fileExist(QString path){
    if(path.startsWith("qrc:/"))
        path=path.replace(0,3,"");
    else if(!path.startsWith(":/"))
        path=":/"+path;
    QFile file(path);
    return file.exists();
}

QSize B2ImageUtil::imageSize(QString path, bool warning){
    if(path.startsWith("qrc:/"))
        path=path.replace(0,3,"");
    else if(!path.startsWith(":/"))
        path=":/"+path;
    QImageReader reader(path);
    if(!reader.canRead()){
        if(warning)
            qDebug()<<"***ImageUtil.imageSize(): can NOT find file at path:"+path;
        return QSize(-1,-1);
    }
    QSize size=reader.size();
    if(size.width()<=0 || size.height()<=0){
        if(warning)
            qDebug()<<"***ImageUtil.imageSize(): can NOT find file at path:"+path;
        return QSize(-1,-1);
    }
    return size;
}

bool B2ImageUtil::isWideDevice(){
    qreal ratio=_designSize.width()/_designSize.height();
    return _devSize.width()/_devSize.height()>ratio+0.005;
}

bool B2ImageUtil::isTallDevice(){
    qreal ratio=_designSize.width()/_designSize.height();
    return _devSize.width()/_devSize.height()<ratio-0.005;
}

void B2ImageUtil::setup(QSize designSize, QSize devSize){
    _designSize=designSize;
    _devSize=devSize;
    qreal ratio=_designSize.width()/_designSize.height();
    if(isWideDevice()){
        qreal w=_devSize.height()*ratio;
        qreal x=(_devSize.width()-w)/2;
        _clientRect=QRectF(x,0,w,_devSize.height());
    }else if(isTallDevice()){
        qreal h=_devSize.width()/ratio;
        qreal y=(_devSize.height()-h)/2;
        _clientRect=QRectF(0,y,_devSize.width(),h);
    }else
        _clientRect=QRectF(0,0,_devSize.width(),_devSize.height());
    _scale=_clientRect.width()/_designSize.width();
}

void B2ImageUtil::changeTitle(QString s){
    _view->setTitle(s);
}
