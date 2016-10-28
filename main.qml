import QtQuick 2.5
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
import B2.Sound 1.0

Item {
    id: mainWindow
    visible: true
    width: 960
    height: 640
    focus: true

    // root bg
    Rectangle{
        id: root
        anchors.fill: parent
        color: 'gray'
    }

    // start button
    Button{
        text: 'Reset'
        z: 100
    }
    Component.onCompleted: {
        startStage()
    }

    // key events
    property var directions: [0,0,0,0]
    Keys.onPressed: function(e){
        console.log(e.key)
        e.accepted=true
        if(e.key===Qt.Key_W)
            directions[0]=1
        else if(e.key===Qt.Key_S)
            directions[1]=1
        else if(e.key===Qt.Key_A)
            directions[2]=1
        else if(e.key===Qt.Key_D)
            directions[3]=1
        you.setVel(directions[3]-directions[2], directions[1]-directions[0])
    }
    Keys.onReleased: function(e){
        e.accepted=true
        if(e.key===Qt.Key_W)
            directions[0]=0
        else if(e.key===Qt.Key_S)
            directions[1]=0
        else if(e.key===Qt.Key_A)
            directions[2]=0
        else if(e.key===Qt.Key_D)
            directions[3]=0
        you.setVel(directions[3]-directions[2], directions[1]-directions[0])
    }

    // instructor
    Text{
        id: inst
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Fear III "
        x: 100
        y: 200
        color: 'white'
        font.pixelSize: 40
        z: 10
    }

    // You
    You{id: you}


    // image mod
    B2Image{id: image}
    // parser mod
    B2Parser{ id: parser }
    // function mod
    B2Func{ id:func }


    // start
    function startStage(){
        parser.reset('stage1.script')
        parser.run()
    }
}
