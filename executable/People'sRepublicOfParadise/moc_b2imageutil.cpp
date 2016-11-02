/****************************************************************************
** Meta object code from reading C++ file 'b2imageutil.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.7.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../Fear/b2imageutil.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'b2imageutil.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.7.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
struct qt_meta_stringdata_B2ImageUtil_t {
    QByteArrayData data[12];
    char stringdata0[108];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_B2ImageUtil_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_B2ImageUtil_t qt_meta_stringdata_B2ImageUtil = {
    {
QT_MOC_LITERAL(0, 0, 11), // "B2ImageUtil"
QT_MOC_LITERAL(1, 12, 9), // "fileExist"
QT_MOC_LITERAL(2, 22, 0), // ""
QT_MOC_LITERAL(3, 23, 4), // "path"
QT_MOC_LITERAL(4, 28, 9), // "imageSize"
QT_MOC_LITERAL(5, 38, 7), // "warning"
QT_MOC_LITERAL(6, 46, 12), // "isWideDevice"
QT_MOC_LITERAL(7, 59, 12), // "isTallDevice"
QT_MOC_LITERAL(8, 72, 7), // "devSize"
QT_MOC_LITERAL(9, 80, 10), // "clientRect"
QT_MOC_LITERAL(10, 91, 10), // "designSize"
QT_MOC_LITERAL(11, 102, 5) // "scale"

    },
    "B2ImageUtil\0fileExist\0\0path\0imageSize\0"
    "warning\0isWideDevice\0isTallDevice\0"
    "devSize\0clientRect\0designSize\0scale"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_B2ImageUtil[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       5,   14, // methods
       4,   52, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // methods: name, argc, parameters, tag, flags
       1,    1,   39,    2, 0x02 /* Public */,
       4,    2,   42,    2, 0x02 /* Public */,
       4,    1,   47,    2, 0x22 /* Public | MethodCloned */,
       6,    0,   50,    2, 0x02 /* Public */,
       7,    0,   51,    2, 0x02 /* Public */,

 // methods: parameters
    QMetaType::Bool, QMetaType::QString,    3,
    QMetaType::QSize, QMetaType::QString, QMetaType::Bool,    3,    5,
    QMetaType::QSize, QMetaType::QString,    3,
    QMetaType::Bool,
    QMetaType::Bool,

 // properties: name, type, flags
       8, QMetaType::QSizeF, 0x00095401,
       9, QMetaType::QRectF, 0x00095401,
      10, QMetaType::QSizeF, 0x00095401,
      11, QMetaType::QReal, 0x00095401,

       0        // eod
};

void B2ImageUtil::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        B2ImageUtil *_t = static_cast<B2ImageUtil *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: { bool _r = _t->fileExist((*reinterpret_cast< QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        case 1: { QSize _r = _t->imageSize((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< bool(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< QSize*>(_a[0]) = _r; }  break;
        case 2: { QSize _r = _t->imageSize((*reinterpret_cast< QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QSize*>(_a[0]) = _r; }  break;
        case 3: { bool _r = _t->isWideDevice();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        case 4: { bool _r = _t->isTallDevice();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        default: ;
        }
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        B2ImageUtil *_t = static_cast<B2ImageUtil *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QSizeF*>(_v) = _t->devSize(); break;
        case 1: *reinterpret_cast< QRectF*>(_v) = _t->clientRect(); break;
        case 2: *reinterpret_cast< QSizeF*>(_v) = _t->designSize(); break;
        case 3: *reinterpret_cast< qreal*>(_v) = _t->scale(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
}

const QMetaObject B2ImageUtil::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_B2ImageUtil.data,
      qt_meta_data_B2ImageUtil,  qt_static_metacall, Q_NULLPTR, Q_NULLPTR}
};


const QMetaObject *B2ImageUtil::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *B2ImageUtil::qt_metacast(const char *_clname)
{
    if (!_clname) return Q_NULLPTR;
    if (!strcmp(_clname, qt_meta_stringdata_B2ImageUtil.stringdata0))
        return static_cast<void*>(const_cast< B2ImageUtil*>(this));
    return QObject::qt_metacast(_clname);
}

int B2ImageUtil::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 5)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 5;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 5)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 5;
    }
#ifndef QT_NO_PROPERTIES
   else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 4;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 4;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 4;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 4;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 4;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}
QT_END_MOC_NAMESPACE
