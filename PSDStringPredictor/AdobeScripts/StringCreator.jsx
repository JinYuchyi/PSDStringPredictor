////Variables
var psdPath = "/Users/ipdesign/Documents/Development/PSDStringPredictor/PSDStringPredictor/Resources/TestImages/IMG_0019.PNG"
var contentList = ["4:12", "WED", "10", "31", "Wednesday, December 31", "Camera", "280", "Find My", "No content available", "tv", "WEDNESDAY", "31", "No more events", "today", "No Recently", "100%", "ol", "Plaved Music"]
var colorList = [[255, 255, 255], [255, 255, 255], [255, 255, 255], [28, 28, 30], [255, 255, 255], [255, 255, 255], [255, 255, 255], [255, 255, 255], [255, 255, 255], [255, 255, 255], [255, 255, 255], [28, 28, 30], [99, 99, 102], [28, 28, 30], [255, 255, 255], [142, 142, 147], [255, 255, 255], [255, 255, 255]]
var fontSizeList = [109.0, 23.0, 14.0, 75.0, 40.19414, 23.0, 15.0, 23.0, 25.386328, 54.0, 25.0, 66.0, 32.12617, 32.0, 27.281641, 23.0, 55.0, 28.041016]
var fontNameList= ["SFProDisplay-Regular", "SFProText-Regular", "SFProText-Regular", "SFProDisplay-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Semibold", "SFProText-Regular", "SFProText-Regular", "SFProText-Semibold", "SFProText-Regular", "SFProDisplay-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular"]
var positionList = [[139, 236], [1193, 174], [1423, 187], [1185, 243], [140, 294], [2158, 297], [1974, 505], [2158, 557], [163, 663], [1708, 742], [162, 789], [164, 855], [164, 936], [162, 976], [511, 1302], [2236, 33], [2187, 478], [511, 1335]]
var trackingList = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
var offsetList = [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]
var alignmentList = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var rectList = [[139.0, 1432.0, 195.0, 79.0], [1193.0, 1494.0, 53.0, 17.0], [1423.0, 1481.0, 13.0, 10.0], [1185.0, 1425.0, 64.0, 55.0], [140.0, 1373.9117, 490.0, 32.08828], [2158.0, 1371.0, 87.0, 19.0], [1974.0, 1163.0, 27.0, 11.0], [2158.0, 1111.4382, 88.0, 18.561718], [163.0, 1005.0, 237.0, 18.0], [1708.0, 926.0, 47.0, 38.0], [162.0, 879.0, 163.0, 20.0], [164.0, 813.0, 57.0, 50.0], [164.0, 732.0, 235.0, 24.0], [162.0, 691.78906, 83.0, 25.210938], [511.0, 365.82422, 153.0, 21.175781], [2236.0, 1635.0, 63.0, 18.0], [2187.0, 1190.0, 47.0, 43.0], [511.0, 333.0, 167.0, 20.0]]
var names = ["0.412", "1.WED", "2.10", "3.31", "4.WednesdayDecember31", "5.Camera", "6.280", "7.FindMy", "8.Nocontentavailable", "9.tv", "10.WEDNESDAY", "11.31", "12.Nomoreevents", "13.today", "14.NoRecently", "15.100", "16.ol", "17.PlavedMusic"]
var bgColorList = [[219.0, 104.0, 69.0], [254.0, 255.0, 254.0], [246.0, 247.0, 247.0], [254.0, 255.0, 254.0], [217.0, 100.0, 67.0], [166.0, 175.0, 191.0], [0.0, 116.0, 218.0], [155.0, 164.0, 182.0], [121.0, 121.0, 125.0], [29.0, 29.0, 29.0], [254.0, 255.0, 254.0], [254.0, 255.0, 254.0], [254.0, 255.0, 254.0], [254.0, 255.0, 254.0], [250.0, 51.0, 74.0], [171.0, 181.0, 196.0], [67.0, 210.0, 92.0], [213.0, 63.0, 75.0]]
var isParagraphList = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
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
var i
if(len >= 1){
    for (i = 0; i < len; i++){
        if (docRef.layerSets[i].name == "StringLayerGroup"){
            docRef.layerSets[i].remove()
        }
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

// =======================================================
