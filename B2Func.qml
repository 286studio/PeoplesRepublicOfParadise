import QtQuick 2.0
import QtGraphicalEffects 1.0
import B2.Notification 1.0
import B2.Sound 1.0

Item {
    id: self
    anchors.fill: parent

    // the center pos
    property int cx: self.width/2
    property int cy: self.height/2


    function adjustBg(des, opa){
        bgAdjust.desaturation=des
        bgAdjust.opacity=opa
    }
    function changeBg(file){
        bgParadise.source='qrc:/images/'+file
    }

    function maskIn(){
        mask.opacity=1
    }
    function maskOut(){
        mask.opacity=0
    }

    function showInst(msg,t){
        inst.text=msg
        if(t)
            return t;
    }
    function showCmd(cmd){
        inst.color='red'
        inst.text=cmd
    }

    Rectangle{
        id: circle
        border.color: "green"
        border.width: 3
        color: 'transparent'
        visible: false
    }
    Timer {
        id: areaTimer
        interval: 100
        repeat: true
        property int xx: 0
        property int yy: 0
        property int rr: 0
        property int elapsed: 0
        property int limit: 99999
        property var timeUp: null
        onTriggered: {
            elapsed+=interval
            // game over
            if(elapsed>=limit && timeUp){
                areaTimer.stop()
                timeUp()
            }
            var dist=Math.sqrt((you.x-xx)*(you.x-xx)+(you.y-yy)*(you.y-yy))
            if(dist<rr){
                areaTimer.stop()
                circle.visible=false
                Notification.notify("testArea")
            }
        }
    }
    function showArea(x,y,r){
        circle.x=cx+x
        circle.y=cy+y
        circle.height=circle.width=2*r
        circle.radius=r
        circle.visible=true
    }
    function testArea(x,y,r,t){
        areaTimer.xx=cx+x
        areaTimer.yy=cy+y
        areaTimer.rr=r
        areaTimer.elapsed=0
        areaTimer.limit=t
        areaTimer.timeUp=function(){
            gameOver()
        }
        areaTimer.restart()
        return "testArea"
    }
    function friend(z,shape,color,x,y){
        var img=image.image(z, shape+'.png')
        img.x=cx+x
        img.y=cy+y
    }
    function friendAll(){
        var shapes=["one","cir","tri"]
        var colors=["yellow","gray","green","blue","black"]
        var pos=[[999,999],[-100,0],[100,0],[-100,-100],[0,-100],[100,-100],[-100,100],[0,100],[100,100]]
        for(var z=1;z<9;z++){
            var i1=Math.floor(Math.random()*shapes.length)
            var i2=Math.floor(Math.random()*colors.length)
            friend(z, shapes[i1], colors[i2], pos[z][0], pos[z][1])
        }
    }

    // move all series
    property bool isMovingAll: false
    function move(z,tag,x,y,time){
        image.camera(z,tag+'x',['x', time, Easing.InOutQuad, cx+x])
        image.camera(z,tag+'y',['y', time, Easing.InOutQuad, cy+y])
    }
    function moveAll(dx,dy,time){
        if(!time)
            time=1500
        var firstOne=true
        for(var z=1;z<20;z++){
            var node=image.find(z)
            if(!node)
                continue
            // notify on the first one!
            if(firstOne){
                firstOne=false
                self.isMovingAll=true
                image.camera(z,'all',['x', time, Easing.InOutQuad, node.x+dx])
                image.camera(z,'moveAll',['y', time, Easing.InOutQuad, node.y+dy], function(){
                    self.isMovingAll=false
                    Notification.notify('moveAll')
                })
            }else{
                image.camera(z,'all',['x', time, Easing.InOutQuad, node.x+dx])
                image.camera(z,'all',['y', time, Easing.InOutQuad, node.y+dy])
            }
        }
    }
    function moveAllMis(dx,dy,time,miss,dmiss){
        if(!time)
            time=1500
        var firstOne=true
        for(var z=1;z<20;z++){
            var node=image.find(z)
            if(!node)
                continue
            // calc miss
            var missx=0
            var missy=0
            var misst=1.0
            var isMiss=false
            for(var mm=0;mm<miss.length;mm++){
                if(z===miss[mm]){
                    isMiss=true
                    missx=dmiss[mm][0]
                    missy=dmiss[mm][1]
                    misst=0.9+Math.random()*0.3
                }
            }
            if(!isMiss){
                // must reset for JS-like things
                missx=0
                missy=0
                misst=1.0
            }

            // notify on the first one!
            if(firstOne){
                firstOne=false
                self.isMovingAll=true
                image.camera(z,'all',['x', time*misst, Easing.InOutQuad, node.x+dx+missx])
                image.camera(z,'moveAll',['y', time*misst, Easing.InOutQuad, node.y+dy+missy], function(){
                    self.isMovingAll=false
                    Notification.notify('moveAll')
                })
            }else{
                image.camera(z,'all',['x', time*misst, Easing.InOutQuad, node.x+dx+missx])
                image.camera(z,'all',['y', time*misst, Easing.InOutQuad, node.y+dy+missy])
            }
        }
    }

    function waitMoveAll(){
        if(self.isMovingAll)
            return "moveAll"
    }

    Image{
        id: aimMask
        source: 'qrc:/images/aimMask.png'
        visible: false
    }
    function aim(z){
        var node=image.find(z, "*** aim: can NOT find "+z)
        var nx=node.x
        var ny=node.y
        // TODO
    }
    function stopAim(){
        aimMask.visible=false
        // TODO
    }

    function shoot(z, n, keepBgm){
        se('gun1.wav', n)
        if(!keepBgm)
            Sound.playBgm()
        var x=image.find(z).x
        var y=image.find(z).y
        image.remove(z)
        var filename='blood'+ (1+Math.floor(Math.random()*2.9)) +'.png'
        var blood=image.image(-z,'blood2.png')
        blood.x=x
        blood.y=y
    }

    function tremble(z, dx, ds, da){
        if(!dx) dx=1
        if(!ds) ds=0.01
        if(!da) da=0
        image.tremble(z,dx,ds,da)
    }
    function trembleAll(dx,ds,da){
        for(var i=1;i<20;i++)
            if(image.find(i))
                tremble(i,dx,ds,da)
    }

    // sound funcs
    function bgm(f){
        if(f)
            Sound.playBgm(f)
        else
            Sound.stopBgm(f)
    }
    function se(f, n){
        if(!n)
            n=1
        if(n===1)
            Sound.playSe(f)
        else if(n===2)
            Sound.playSe2(f)
        else if(n===3)
            Sound.playSe3(f)
    }


    function jump(file,scene){
        if(!file) file=''
        parser.jump(file,scene)
    }

    function gameOver(){
        Sound.playBgm()
        Sound.playSe('gun1.wav')
        you.die()
        showInst("Game Over",9999999);
    }
}
