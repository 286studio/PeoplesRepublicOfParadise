pragma Singleton

import QtQuick 2.0
import QtMultimedia 5.6

Item {
    MediaPlayer {id: bgm; volume: 1; loops: Audio.Infinite; autoPlay:true}
    MediaPlayer {id: se; volume: 1; loops: 1; autoPlay:true}
    MediaPlayer {id: se2; volume: 1; loops: 1; autoPlay:true}
    MediaPlayer {id: se3; volume: 1; loops: 1; autoPlay:true}
    MediaPlayer {id: vo; volume: 1; loops: 1; autoPlay:true}

    function playBgm(f){
        bgm.source='qrc:/sounds/'+f
        bgm.play()
    }
    function stopBgm(){
        bgm.stop()
    }

    function playSe(f){
        se.source='qrc:/sounds/'+f
        se.play()
    }

    function playSe2(f){
        se2.source='qrc:/sounds/'+f
        se2.play()
    }

    function playSe3(f){
        se3.source='qrc:/sounds/'+f
        se3.play()
    }
    function playVo(f){
        vo.source='qrc:/sounds/'+f
        vo.play()
    }
}
