import QtQuick 2.0

Image{
    id: you
    source: 'qrc:/images/one.png'
    x: 414
    y: 256
    property int speed: 4
    property var vel: []
    property bool dead: false
    Timer{
        id: youMove
        interval: 33
        repeat: true
        running: true
        onTriggered: {
            if(dead) return
            x+=vel[0]
            y+=vel[1]
            confineInBound()
        }
    }
    function confineInBound(){
        x=Math.max(100,Math.min(x,760))
        y=Math.max(200,Math.min(y,500))
    }

    function setVel(vx,vy){
        if(dead) return
        if(vx===0 && vy===0){
            vel[0]=0
            vel[1]=0
            return
        }
        var theta=Math.atan2(vy,vx)
        vel[0]=speed*Math.cos(theta)
        vel[1]=speed*Math.sin(theta)
    }
    function die(){
        source='qrc:/images/blood1.png'
        dead=true
    }
}

