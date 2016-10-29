import QtGraphicalEffects 1.0
import QtQuick 2.7
import B2.ImageUtil 1.0
import B2.TextFont 1.0

/** Image Module
  Every item has a property var param:[], which will be nullified right before calling destroy(),
  showing that this item is no longer available.
*/

Item {
    id: self
    x: ImageUtil.clientRect.x
    y: ImageUtil.clientRect.y
    width: ImageUtil.clientRect.width
    height: ImageUtil.clientRect.height

    // we use 'myScale' to tell the nodes their scale factor
    property real myScale: ImageUtil.scale

    // set image to 'group'
    property string type: 'group'
    property var param: []

    // stores all camera animations
    property var cameraList: []
    property var anchoredCameraTrans: ({})

    // private
    property var searchPath: ['qrc:/images/']

    function save(){
        var data=[]
        for(var i=1;i<200;i++){
            var node=find(i)
            if(!node) continue
            data.push({type:node.type, param:node.param,
                          x:node.x/self.width, y:node.y/self.height, z:node.z,
                          width:node.width/self.width, height:node.height/self.height,
                          scale:node.scale, rotation:node.rotation, opacity:node.opacity, visible:node.visible,
                          transformOrigin:node.transformOrigin,
                          parentZ:node.parent===self?0:node.parent.z})
        }
        var json=JSON.stringify(data)
        return json
    }
    function load(json){
        self.removeAll()
        var data=JSON.parse(json)
        assert(data, 'load(): can NOT load json data:'+json)
        // create nodes
        for(var i=0;i<data.length;i++){
            var nodeType=data[i].type
            var nodeParam=data[i].param
            var item=null
            // create node
            if(nodeType==='group')
                item=self.group(nodeParam[0])
            else if(nodeType==='color')
                item=self.color(nodeParam[0],nodeParam[1],nodeParam[2])
            else if(nodeType==='text')
                item=self.plainText(nodeParam[0],nodeParam[1],nodeParam[2])
            else if(nodeType==='image'){
                item=self.image(nodeParam[0],nodeParam[1],nodeParam[2])
            }else if(nodeType==='blink'){
                console.log('load() blink:',nodeParam[0],nodeParam[1])
                item=self.blink(nodeParam[0],nodeParam[1])
            }else if(nodeType==='particle')
                item=self.particle(nodeParam[0],nodeParam[1])
            else if(nodeType==='stencil')
                item=self.stencil(nodeParam[0],nodeParam[1],nodeParam[2])
            else
                assert(false, 'load(): unknown type:'+nodeType)
            // load common props
            if(nodeType==='group'){
                item.width=data[i].width*self.width
                item.height=data[i].height*self.height
            }
            item.x=data[i].x*self.width
            item.y=data[i].y*self.height
            item.z=data[i].z
            if(nodeType==='group'){
                item.width=data[i].width
                item.height=data[i].height
            }
            item.scale=data[i].scale
            item.rotation=data[i].rotation
            item.opacity=data[i].opacity
            item.transformOrigin=data[i].transformOrigin
            item.visible=data[i].visible
        }
        // add to parrent
        for(i=0;i<data.length;i++){
            if(data[i].parentZ>0)
                add(data[i].parentZ, data[i].z)
        }
    }

    // returns wheter the node will exist, or it has been called destory() on it.
    function willExist(node){
        return node.param!==null
    }

    // node hierachy functions
    function find(z,errMsg){
        assert(typeof z==='number' && z>=1,'find(): z MUST>=1')
        function find_r(z, from){
            if(z===from.z && willExist(from)) return from
            if(from.type==='group'){
                for(var i=0;i<from.children.length;i++){
                    var result=find_r(z,from.children[i])
                    if(result && willExist(result)) return result
                }
            }
            return null
        }
        var result=find_r(z, self)
        if(!result && errMsg)
            console.log('*** image.'+errMsg)
        return result
    }
    function add(parent,child){
        assert(parent && child, 'add(): parent and child must be non-null!')
        if(parent===0) parent=image
        if(typeof parent==='number') parent=find(parent,'add(): can NOT find parent:'+parent)
        if(typeof child==='number') child=find(child,'add(): can NOT find child:'+child)
        assert(parent.type==='group', 'add(): parent must be a group!')
        assert(willExist(parent) && willExist(child), 'add(): parent and child must be existing!')
        console.log('add:',parent.width,child)
        child.parent=parent
    }
    function remove(zOrNode,warning){
        if(typeof zOrNode==='number') zOrNode=find(zOrNode,'remove(): can NOT find z:'+zOrNode)
        if(!zOrNode){
            if(warning)
                console.log('*image.remove(): can NOT find the node.')
            return
        }
        if(zOrNode.type==='group')
            for(var i=0;i<zOrNode.children.length;i++)
                remove(zOrNode.children[i])
        // set its param to null, so that willExist(node) will return false before node is destroyed
        zOrNode.param=null
        if(anchoredCameraTrans[zOrNode.z]){
            anchoredCameraTrans[zOrNode.z].destroy()
            anchoredCameraTrans[zOrNode.z]=null
        }
        zOrNode.destroy()
    }
    function removeAll(){
        for(var i=0;i<self.children.length;i++)
            remove(self.children[i])
    }

    // file functions
    function findFile(file){
        if(ImageUtil.fileExist(file))
            return file
        var path=null
        for(var i=0;i<searchPath.length;i++){
            path=searchPath[i]+file
            if(ImageUtil.fileExist(path))
                return path;
        }
        return false
    }

    // --------------------------------- Nodes ------------------------------------
    // creates a group node--ONLY group node can have children
    Component{
        id: compGroup;
        Item{
            property string type:'group'
            property var param: []
        }
    }
    function group(z){
        assert(z>=1,'image.group(): z MUST>=1')
        // remove same z
        remove(find(z))
        // create item
        var item=compGroup.createObject(self, {'param':[z]})
        item.z=z
        // add item & remove same z
        add(self,item)
        return item
    }

    // creates a color node
    Component{
        id: compColor
        Rectangle{
            property string type:'color'
            property var param: []
        }
    }
    function color(z,color,size){
        assert(z>=1,'image.color(): z MUST>=1')
        if(color==='black') color=[0,0,0,1]
        if(typeof color !== 'object') color=[1,1,1,1]
        if(typeof size !== 'object') size=[1,1]
        // remove same z
        remove(find(z))
        // create item
        var item=compColor.createObject(self, {'param':[z,color,size]})
        item.z=z
        item.color=Qt.rgba(color[0],color[1],color[2],color[3])
        item.width=size[0]*ImageUtil.clientRect.width; item.height=size[1]*ImageUtil.clientRect.height
        // add
        add(self,item)
        return item
    }

    // create a plain text
    Component{
        id: compText
        Text{
            property string type: 'text'
            property var param: []
            width: contentWidth
            height: contentHeight
        }
    }
    function plainText(z,t,fontStyle){
        assert(z>=1,'image.plainText(): z MUST>=1')
        // remove same z
        remove(find(z))
        // create item
        var item=compText.createObject(self, {'param':[z,t,fontStyle]})
        var fontInfo=TextFont[fontStyle].fontInfo
        console.log('plainText'+JSON.stringify(fontInfo))
        item.z=z
        item.text=t
        item.font.family=fontInfo.name
        item.font.pixelSize=fontInfo.pixelSize*ImageUtil.scale
        item.color=fontInfo.color
        // add
        add(self,item)
        return item
    }

    // create an image node
    Component{
        id: compImage
        Item{
            property string type: 'image'
            property var param: []
            function setImageSource(f){
                basicImage.source='qrc:/images/'+f
            }
            function setDx(dx){
                basicImage.x=dx
            }
            function setDs(ds){
                basicImage.scale=1+ds
            }
            function setDa(da){
                basicImage.opacity=1-da
            }
            Image{id: basicImage}
            ColorOverlay{}
        }
    }
    function image(z,file,cc){
        assert(z>=1,'image.image(): z MUST>=1')
        // remove same z
        remove(find(z))
        // check file
        var path=findFile(file)
        if(!path) path=findFile('_noimage_.jpg')
        var size=ImageUtil.imageSize(path);
        assert(size.width>0,'image(): can NOT read file:'+file)
        // create item
        var item=compImage.createObject(self, {'param':[z,file,cc]})
        item.z=z
        item.width=size.width*myScale
        item.height=size.height*myScale
        var img=item.children[0]
        img.source=path
        img.width=item.width
        img.height=item.height
        if(cc){
            console.log('image(): cc to add!!')
            if(cc.length>=4 && cc[3]>0){
                var ccFx=item.children[1]
                ccFx.source=img
                ccFx.color=Qt.rgba(cc[0],cc[1],cc[2],cc[3])
                ccFx.width=item.width
                ccFx.height=item.height
            }else
                assert(false,'image(): cc must have 4 numbers! The last number must>0!')
        }
        // add
        add(self,item)
        return item
    }

    // create a blink animation
    Component{
        id: compBlink
        Item{
            // set by user
            property string file: ''
            property size frameSize: Qt.size(286,286)
            property string type: 'blink'
            property var param: []
            Image{
                id: frameImgae
                source: file
                anchors.fill: parent
                scale: ImageUtil.scale
                fillMode: Image.Pad
                horizontalAlignment: Image.Left
                verticalAlignment: Image.Top
                transformOrigin: Item.TopLeft
            }
            Timer{id:frameTimer; running:true; onTriggered: {frameImgae.visible=false}}
            SpriteSequence{
                id: frameAnim
                interpolate: true
                anchors.fill: parent
                // sprites
                Sprite{
                    name: 'still0'
                    source: file
                    frameCount: 1
                    frameWidth: frameSize.width
                    frameHeight: frameSize.height
                    frameDuration: 3000
                    frameDurationVariation: 1500
                    to: {'blink': 1}
                }
                Sprite{
                    name: 'blink'
                    source: file
                    frameCount: 4
                    frameWidth: frameSize.width
                    frameHeight: frameSize.height
                    frameDuration: 60
                    to: {'still1': 0.75, 'blink': 0.25}
                }
                Sprite{
                    name: 'still1'
                    source: file
                    frameCount: 1
                    frameWidth: frameSize.width
                    frameHeight: frameSize.height
                    frameDuration: 5000
                    frameDurationVariation: 3000
                    to: {'blink': 1}
                }
            }
        }
    }
    function blink(z,file){
        assert(typeof z==='number' && z>=1, 'blink(): z MUST >=1.')
        // remove same z
        remove(find(z))
        // create item
        var item=compBlink.createObject(self,{'param':[z,file]})
        item.z=z
        var path=findFile(file)
        item.file=path
        var size=ImageUtil.imageSize(path)
        item.frameSize=Qt.size(size.width/2,size.height/2)
        item.width=item.frameSize.width*myScale
        item.height=item.frameSize.height*myScale
        // add item & remove same z
        add(self,item)
        return item
    }

    // creates a particle node
    function particle(z,qml){
        assert(z>=1,'particle(): z MUST>=1')
        // remove same z
        remove(find(z))
        // create item
        var path=findFile(qml)
        assert(path, 'particle(): can NOT find file:'+qml)
        // create item & set info
        var comp=Qt.createComponent(path)
        var par=comp.createObject(self, {'myScale':myScale,'param':[z,qml]})
        assert(par.param, 'particle(): the QML file should have a param property.')
        par.z=z
        // add
        add(self, par)
        return par
    }

    // creates a stencil node
    Component{
        id: compStencil
        OpacityMask{
            property string type: 'stencil'
            property var param: []
        }
    }

    function stencil(z,sourceZ,maskZ){
        assert(z>sourceZ,'stencil(): z must > sourceZ!')
        assert(z>maskZ,'stencil(): z must > maskZ!')
        // remove same z
        remove(find(z))
        var source=find(sourceZ, 'stencil(): can NOT find source z:'+sourceZ)
        var mask=find(maskZ, 'stencl(): can NOT find mask z:'+maskZ)
        // create item
        var item=compStencil.createObject(self, {'param':[z,sourceZ,maskZ]})
        item.anchors.fill=source
        item.source=source
        item.maskSource=mask
        item.z=z
        // add
        add(self, item)
        return item
    }

    // run a camera animation
    Component{
        id: compCamera
        ParallelAnimation{
            id: pa
            property var target
            property var prop
            property int duration
            property var easing
            property real to
            PropertyAnimation{target:pa.target; property:pa.prop;
                duration:pa.duration; easing.type:pa.easing; to:pa.to}
        }
    }
    function camera(zOrNode,tag,params,onComplete){
        assert(zOrNode && typeof zOrNode !== 'number' || zOrNode>=1, 'camera(): zOrNode must be non-null or >=1')
        var node=zOrNode
        if(typeof node === 'number') node=find(node)
        // create animation
        var anim=compCamera.createObject(node, {'target':node,
                                             'prop':params[0], 'duration':params[1], 'easing':params[2], 'to':params[3]})
        anim.stopped.connect(function(){
            // remove tag
            if(tag){
                var cameraIndex=cameraList.indexOf(tag)
                if(cameraIndex>=0) cameraList.splice(cameraIndex,1)
            }
            // destroy anim
            anim.destroy()
            // call completing func
            if(onComplete) onComplete()
        })
        // insert tag
        if(tag)
            cameraList.push(tag)
        anim.start()
    }
    Component{
        id: compTremble
        Timer{
            id: ti
            property var target: null
            property real dx: 0
            property real ds: 0
            property real da: 0
            interval: 60
            repeat: true
            // count of it
            property int count: 0
            onTriggered: {
                count++
                target.setDx(count%2===0?dx:-dx)
                target.setDs(count%2===0?ds:-ds)
                target.setDa(count%2===0?da:2*da)
            }
        }
    }
    function tremble(zOrNode, dx, ds, da){
        assert(zOrNode && typeof zOrNode !== 'number' || zOrNode>=1, 'camera(): zOrNode must be non-null or >=1')
        var node=zOrNode
        if(typeof node === 'number') node=find(node)
        // create animation
        var trem=compTremble.createObject(node, {'target':node,'dx':dx,'ds':ds, 'da':da})
        trem.restart()
    }
    function stopTremble(zOrNode){
        assert(zOrNode && typeof zOrNode !== 'number' || zOrNode>=1, 'camera(): zOrNode must be non-null or >=1')
        var node=zOrNode
        if(typeof node === 'number') node=find(node, '***stopTremble: can NOT find '+zOrNode)
        // stop trembling
        if(node.ti)
            node.ti.stop()
    }

    Component{
        id: compAnchoredScale
        Scale{
            property bool isCustom: true
            property var anchor: [0,0]
            property real toValue: 1
            origin.x: anchor[0]
            origin.y: anchor[1]
            xScale: toValue
            yScale: toValue
        }
    }
    Component{
        id: compAnchoredRotation
        Rotation{
            property bool isCustom: true
            property var anchor: [0,0]
            property real toValue: 0
            origin.x: anchor[0]
            origin.y: anchor[1]
            angle: toValue
        }
    }
    function anchoredCamera(zOrNode,tag,anchor,params,onComplete){
        assert(zOrNode && typeof zOrNode !== 'number' || zOrNode>=1, 'camera(): zOrNode must be non-null or >=1')
        var node=zOrNode
        if(typeof node === 'number') node=find(node)
        // create animation
        var trans=null
        if(params[0]==='scale')
            trans=compAnchoredScale.createObject(node, {'anchor':[anchor[0]*node.width, anchor[1]*node.height] })
        else
            trans=compAnchoredRotation.createObject(node, {'anchor':[anchor[0]*node.width, anchor[1]*node.height] })
        node.transform=trans
        anchoredCameraTrans[node.z]=trans
        // create animation
        var anim=compCamera.createObject(trans, {'target':trans,
                                             'prop':'toValue', 'duration':params[1], 'easing':params[2], 'to':params[3]})
        anim.stopped.connect(function(){
            // remove tag
            if(tag){
                var cameraIndex=cameraList.indexOf(tag)
                if(cameraIndex>=0) cameraList.splice(cameraIndex,1)
            }
            // destroy anim
            anim.destroy()
            // don't destroy trans
            // call completing func
            if(onComplete) onComplete()
        })
        // insert tag
        if(tag)
            cameraList.push(tag)
        anim.start()
    }
    function hasCamera(tag){
        return cameraList.indexOf(tag)>=0
    }

    // property functions
    function setZ(zOrNode,newZ){
        if(typeof zOrNode==='number') zOrNode=find(zOrNode,'setZ(): can NOT find z:'+zOrNode)
        zOrNode.z=newZ
    }
    function setAnchorClock(zOrNode,clock){
        if(typeof zOrNode==='number') zOrNode=find(zOrNode,'setAnchorClock(): can NOT find z:'+zOrNode)
        var table=[Item.Top, Item.TopRight, Item.TopRight, Item.Right, Item.BottomRight, Item.BottomRight, Item.Bottom,
                   Item.BottomLeft, Item.BottomLeft, Item.Left, Item.TopLeft, Item.TopLeft, Item.Top]
        if(clock>24)
            zOrNode.transformOrigin=Item.Center
        else
            zOrNode.transformOrigin=table[clock]
    }

    function setPos(zOrNode,xN,yN){
        if(typeof zOrNode==='number') zOrNode=find(zOrNode,'setPos(): can NOT find z:'+zOrNode)
        zOrNode.x=xN*ImageUtil.clientRect.width
        zOrNode.y=yN*ImageUtil.clientRect.height
    }

    function setOpacity(zOrNode,opa){
        if(typeof zOrNode==='number') zOrNode=find(zOrNode,'setOpacity(): can NOT find z:'+zOrNode)
        zOrNode.opacity=opa
    }

    function assert(cond, msg){
        if(!cond) console.log('***Image.'+msg)
    }
}
