import QtQuick 2.0

Image{
    id: you
    source: 'qrc:/images/one.png'
    x: 414
    y: 256
    property int speed: 4
    property var vel: []
    function setVel(vx,vy){
        if(vx===0 && vy===0){
            vel[0]=0
            vel[1]=0
            return
        }
        var theta=Math.atan2(vy,vx)
        vel[0]=speed*Math.cos(theta)
        vel[1]=speed*Math.sin(theta)
    }
    Timer{
        id: youMove
        interval: 33
        repeat: true
        running: true
        onTriggered: {
            x+=vel[0]
            y+=vel[1]
        }
    }
}

