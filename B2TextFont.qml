pragma Singleton

import QtQuick 2.7

Item {
    visible: false

    // fonts
    FontLoader{id:fontHei; source:'qrc:/font/PingFangM.ttf'}
    FontLoader{id:fontKai; source:'qrc:/font/STKaiTi.ttf'}

    // fonts: please use TextFont['advlFont'] to index them!
    // fontHei.name may vary across differenct systems, e.g. PingFang SC or PingFang SC Medium
    // color is in #AARRGGBB
    property var advl: ({fontInfo:{name:fontHei.name,pixelSize:50,color:'#FFFFFFFF',lineGap:0},
                            colorInfo:{c1:'#ffeef8FF',c2:'#FFFFFFFF',c3:'#FF6070FF',pos:0.5},
                            shadowInfo:{offset:{x:2,y:2},opacity:0.7}})

    property var advlLarge: ({fontInfo:{name:fontHei.name,pixelSize:60,color:'#FFFFFFFF',lineGap:0},
                            colorInfo:{c1:'#FFFFFFFF',c2:'#FFFFFFFF',c3:'#FF5060FF',pos:0.5},
                            shadowInfo:{offset:{x:2,y:2},opacity:0.7}})

    property var advlHuge: ({fontInfo:{name:fontHei.name,pixelSize:70,color:'#FFFFFFFF',lineGap:0},
                            colorInfo:{c1:'#FFFFFFFF',c2:'#FFFFFFFF',c3:'#FF5060FF',pos:0.5},
                            shadowInfo:{offset:{x:2,y:2},opacity:0.7}})

    property var advlSmall: ({fontInfo:{name:fontHei.name,pixelSize:38,color:'#FFFFFFFF',lineGap:0},
                            colorInfo:{c1:'#FFFFFFFF',c2:'#FFFFFFFF',c3:'#FF5060FF',pos:0.5},
                            shadowInfo:{offset:{x:2,y:2},opacity:0.7}})

    property var advlOrange: ({fontInfo:{name:fontHei.name,pixelSize:50,color:'#ffffffff',lineGap:0},
                              colorInfo:{c1:'#e7b434',c2:'#f5ba42',c3:'#e7b434',pos:0.5},
                              shadowInfo:{offset:{x:2,y:2},opacity:0.5}})

    property var advlOrangeSmall: ({fontInfo:{name:fontHei.name,pixelSize:38,color:'#ffffffff',lineGap:0},
                              colorInfo:{c1:'#e7b434',c2:'#f5ba42',c3:'#e7b434',pos:0.5},
                              shadowInfo:{offset:{x:2,y:2},opacity:0.5}})

    property var branch: ({fontInfo:{name:fontHei.name,pixelSize:60,color:'#FFFFFFFF',lineGap:0},
                            colorInfo:{c1:'#ffeef8FF',c2:'#FFFFFFFF',c3:'#FF6070FF',pos:0.5},
                            shadowInfo:{offset:{x:2,y:2},opacity:0.7}})

    property var bbs: ({fontInfo:{name:fontHei.name,pixelSize:40,color:'#FFFFFFFF',lineGap:0},
                           colorInfo:{c1:'#FFFFFFFF',c2:'#FFFFFFFF',c3:'#FF5060FF',pos:0.5},
                           shadowInfo:{offset:{x:2,y:2},opacity:0.7}})

    property var sub: ({fontInfo:{name:fontKai.name,pixelSize:55,color:'#FFFFFFFF',lineGap:0.2},
                           colorInfo:{c1:'#FFFFFFFF',c2:'#FFFFFFFF',c3:'#FF5060FF',pos:0.5},
                           shadowInfo:{offset:{x:2,y:2},opacity:0.7}})

    property var mingmei: ({fontInfo:{name:fontKai.name,pixelSize:54,color:'#FFFFFFFF',lineGap:0},
                           colorInfo:{c1:'#FFFFFFFF',c2:'#FFFFFFFF',c3:'#FFFF6050',pos:0.58},
                           shadowInfo:{offset:{x:2,y:2},opacity:0.7}})

    property var history: ({fontInfo:{name:fontHei.name,pixelSize:40,color:'#FF000000',lineGap:0},
                            colorInfo:{c1:'#ffeef8FF',c2:'#FFFFFFFF',c3:'#FF6070FF',pos:0.5},
                            shadowInfo:{offset:{x:2,y:2},opacity:0.7}})

    property string fontNameKai: fontKai.name
    property string fontNameHei: fontHei.name
}
