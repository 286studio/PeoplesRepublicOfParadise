pragma Singleton

import QtQuick 2.7

// must be an Item since we have a Timer
Item {
    id: self
    opacity: 0
    visible: false

    // properties
    property var entries: ([ ])
    property var result: null

    // functions
    function recent(){
        if(entries.length===0)
            return null
        else
            return entries[entries.length-1]
    }
    function indexOf(waitFor){
        for(var i=0;i<entries.length;i++)
            if(entries[i].waitFor===waitFor)
                return i
        return -1
    }
    // waitFor can be null, undefined, number>=0 or string
    function wait(waitFor,callbackFunc){
        console.log("Notification.wait():"+waitFor)
        if(waitFor===null || waitFor===undefined){
            callbackFunc()
        }else if(typeof waitFor==='number' && waitFor>=0){
            console.log('Notification.wait(): will wait time:'+waitFor)
            _performWithDelay(waitFor, callbackFunc)
        }else if(typeof waitFor==='string'){
            entries.push({waitFor:waitFor, callbackFunc:callbackFunc})
        }else
            console.log('***Notification.wait(): waitFor must be null,undefined,number>=0 or string.')
    }
    // notify what is being waited for
    function notify(waitFor,noWarning){
        console.log("Notification.notify():"+waitFor)
        console.assert(typeof waitFor==='string')
        var i=indexOf(waitFor)
        if(i>=0){
            var notified=entries.splice(i,1)    // remove waitFor from entries
            result=notified[0].callbackFunc()          // call the callback function
        }else if(!noWarning)
            console.log('***Notification.notify(): can NOT find waitFor:'+waitFor)
    }
    // remove all entries
    function removeAll(){
        entries=[]
        result=null
    }
    // report entries
    function report(){
        console.log(JSON.stringify(entries))
    }

    // public func: perform with delay
    property var delayNames: ({})
    function performWithDelay(name,delay,callbackFunc){
        var timer=comp.createObject(self)
        delayNames[name]=timer
        timer.interval=delay
        timer.triggered.connect(function(){
            timer.destroy()
            delete delayNames[name]
            callbackFunc()
        })
        timer.restart()
    }
    function hasPerformNamed(name){
        return delayNames.hasOwnProperty(name)
    }
    function cancelPerformNamed(name){
        if(delayNames.hasOwnProperty(name)){
            var timer=delayNames[name]
            timer.stop()
            timer.destroy()
            delete delayNames[name]
        }else
            console.log('***Notification.cancelPerformNamed(): can NOT find:'+name)
    }

    // private func
    Component{
        id: comp
        Timer{}
    }
    function _performWithDelay(delay, callbackFunc){
        var timer=comp.createObject(self)
        timer.interval=delay
        timer.triggered.connect(function(){
            timer.destroy()
            callbackFunc()
        })
        timer.restart()
    }
}
