////Variables
var psdPath = "/Users/ipdesign/Documents/Development/PSDStringPredictor/PSDStringPredictor/Resources/TestImages/textTest.png"
var contentList = ["abc,", "abc,", "abcpp abc, abcj", "abcpp", "abcj", "abcpp", "abcj"]
var colorList = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]]
var fontSizeList = [28.0, 59.0, 93.0, 28.0, 28.0, 59.0, 58.0]
var fontNameList= ["SFProText-Regular", "SFProText-Semibold", "SFProDisplay-Semibold", "SFProText-Regular", "SFProText-Regular", "SFProText-Semibold", "SFProText-Semibold"]
var positionList = [[375, 160], [469, 247], [79, 437], [184, 159], [564, 160], [186, 247], [782, 248]]
var trackingList = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
var offsetList = [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]
var alignmentList = [0, 0, 0, 0, 0, 0, 0]
var rectList = [[375.0, 840.05237, 58.0, 23.947657], [469.0, 752.5389, 115.0, 46.461132], [79.0, 563.4596, 877.0, 73.54043], [184.0, 841.05237, 87.0, 22.947657], [564.0, 840.05237, 57.0, 24.947657], [186.0, 752.5389, 173.0, 46.461132], [782.0, 752.39417, 113.0, 48.605858]]
var names = ["0.abc", "1.abc", "2.abcppabcabcj", "3.abcpp", "4.abcj", "5.abcpp", "6.abcj"]
var bgColorList = [[255.0, 255.0, 255.0], [255.0, 255.0, 255.0], [255.0, 255.0, 255.0], [255.0, 255.0, 255.0], [255.0, 255.0, 255.0], [255.0, 255.0, 255.0], [255.0, 255.0, 255.0]]
var isParagraphList = [false, false, false, false, false, false, false]
var widthExtend = 5
// ========================= Load from Main.js ==============================

//PS Preferance Setting

var originalUnit = preferences.rulerUnits
preferences.rulerUnits = Units.PIXELS

var fileRef = File(psdPath)
var docRef = app.open(fileRef)

//Create Folder
var len = docRef.layerSets.length

//Remove the previous folder
var listToRemove=[]
var i = 0
var console = new ConsoleLog();

//if(len >= 1){
    while ( i < docRef.layerSets.length ){
        //console.log(docRef.layerSets.length+"-"+docRef.layerSets[i].name)
        if (docRef.layerSets[i].name == "StringLayersGroup" || docRef.layerSets[i].name == "MaskLayersGroup"){
            //listToRemove.push(i)
                console.log(i)
                docRef.layerSets[i].remove()
            }else{
                i++
            }

    }


//Add new folder
var layerSetRef1 = app.activeDocument.layerSets.add()
layerSetRef1.name = "MaskLayersGroup"
var layerSetRef = app.activeDocument.layerSets.add()
layerSetRef.name = "StringLayersGroup"

//Add Text layer
const num = contentList.length
for (var i = 0; i < num; i++){
    var artLayerRef = layerSetRef.artLayers.add()
    
    artLayerRef.kind = LayerKind.TEXT
    var textItemRef = artLayerRef.textItem
    if (isParagraphList[i] == true) {
        textItemRef.kind = TextType.PARAGRAPHTEXT
        textItemRef.useAutoLeading = false
        textItemRef.leading = fontSizeList[i] * 10 /(600/72)
        textItemRef.width = rectList[i][2] + widthExtend
        textItemRef.height = rectList[i][3]
        
    }else{
        textItemRef.kind = TextType.POINTTEXT 
    }
    textItemRef.contents = contentList[i]
    textColor = new SolidColor
    textColor.rgb.red = colorList[i][0]
    textColor.rgb.green = colorList[i][1]
    textColor.rgb.blue = colorList[i][2]
    textItemRef.color = textColor
    textItemRef.font = fontNameList[i]
    textItemRef.size = new UnitValue(fontSizeList[i], "pt")
    
    var alignmentOffset = 0
    var alignName = "left"
    if (alignmentList[i] == 1) {
        alignmentOffset = rectList[i][2] / 2
        alignName = "center"
    }
    if (alignmentList[i] == 2) {
        alignmentOffset = rectList[i][2]
        alignName = "right"
    }
    if (isParagraphList[i] == true) {
        textItemRef.position = Array(positionList[i][0] - offsetList[i][0] + alignmentOffset, positionList[i][1] - rectList[i][3]  - offsetList[i][1] / 4)
    }else{
        textItemRef.position = Array(positionList[i][0] - offsetList[i][0] + alignmentOffset, positionList[i][1]  - offsetList[i][1] / 4)
    }
    textItemRef.tracking = trackingList[i]
    artLayerRef.name = names[i]
    selectLayer(artLayerRef.name)
    setTextAlignment(alignName)

    //Create Mask Layers
    offset = 5
    fillColor = bgColorList[i]
    createRectangle(layerSetRef1, "L_" + names[i], positionList[i][0] - offset,positionList[i][1] - rectList[i][3] - offset, rectList[i][2] + offset, rectList[i][3] + offset, fillColor)
}


// ========================= Load from Functions.js ==============================

function selectLayer(name){
    var idselect = stringIDToTypeID( "select" );
        var desc25 = new ActionDescriptor();
        var idnull = stringIDToTypeID( "null" );
            var ref3 = new ActionReference();
            var idlayer = stringIDToTypeID( "layer" );
            ref3.putName( idlayer, name );
        desc25.putReference( idnull, ref3 );
        var idmakeVisible = stringIDToTypeID( "makeVisible" );
        desc25.putBoolean( idmakeVisible, false );
        var idlayerID = stringIDToTypeID( "layerID" );
            var list7 = new ActionList();
            list7.putInteger( 2 );
        desc25.putList( idlayerID, list7 );
    executeAction( idselect, desc25, DialogModes.NO );
}

function setTextAlignment(alignment){
    var idset = stringIDToTypeID( "set" );
        var desc26 = new ActionDescriptor();
        var idnull = stringIDToTypeID( "null" );
            var ref4 = new ActionReference();
            var idproperty = stringIDToTypeID( "property" );
            var idparagraphStyle = stringIDToTypeID( "paragraphStyle" );
            ref4.putProperty( idproperty, idparagraphStyle );
            var idtextLayer = stringIDToTypeID( "textLayer" );
            var idordinal = stringIDToTypeID( "ordinal" );
            var idtargetEnum = stringIDToTypeID( "targetEnum" );
            ref4.putEnumerated( idtextLayer, idordinal, idtargetEnum );
        desc26.putReference( idnull, ref4 );
        var idto = stringIDToTypeID( "to" );
            var desc27 = new ActionDescriptor();
            var idtextOverrideFeatureName = stringIDToTypeID( "textOverrideFeatureName" );
            desc27.putInteger( idtextOverrideFeatureName, 808464433 );
            var idalign = stringIDToTypeID( "align" );
            var idalignmentType = stringIDToTypeID( "alignmentType" );
            var idcenter = stringIDToTypeID( alignment ); //"center"
            desc27.putEnumerated( idalign, idalignmentType, idcenter );
        var idparagraphStyle = stringIDToTypeID( "paragraphStyle" );
        desc26.putObject( idto, idparagraphStyle, desc27 );
    executeAction( idset, desc26, DialogModes.NO );
}

function createRectangle(layerSet, layerName, posX, posY, width, height, color1){
    var artLayerRef = layerSet.artLayers.add()
    artLayerRef.name = layerName
    var selRegion = Array(Array(posX, posY),
                    Array(posX + width, posY), 
                    Array(posX + width, posY + height), 
                    Array(posX, posY + height),
                    Array(posX, posY))

    app.activeDocument.selection.select(selRegion)
    fillColor = new SolidColor
    fillColor.rgb.red = color1[0]
    fillColor.rgb.green = color1[1]
    fillColor.rgb.blue = color1[2]
    app.activeDocument.selection.fill(fillColor)

}

function ConsoleLog() {
    //To view log from OSX terminal, execute:
    //$ nc -lvk <port> (listens on localhost:<port>)
    this.socket = new Socket();
    this.estkIsRunning = BridgeTalk.isRunning ('estoolkit');
    this.hostPort = "127.0.0.1:8000";
    this.log = function(logMessage){
            if (this.estkIsRunning){
               $.writeln(logMessage);
            }
            else{
                if (this.socket.open(this.hostPort)){
                  this.socket.write (logMessage + "\n");
                  this.socket.close();
                }
            }
         }
    }

// =======================================================
