////Variables
var psdPath = "/Users/ipdesign/Documents/Development/PSDStringPredictor/PSDStringPredictor/Resources/TestImages/LocSample.png"
var contentList = ["9:41", "Beaches", "Cancel", "See All", "Moments", "See All", "25 >", "Lisboa", "11 >", "Search", "/olu Photos", "Essaouira"]
var colorList = [[0, 0, 0], [254, 255, 254], [0, 122, 251], [0, 122, 247], [0, 0, 0], [0, 122, 247], [152, 152, 159], [0, 0, 0], [152, 152, 159], [0, 122, 246], [0, 0, 0], [0, 0, 0]]
var fontSizeList = [45.0, 50.0, 47.0, 50.0, 66.0, 50.0, 53.0, 48.0, 52.0, 29.0, 66.0, 48.0]
var fontNameList= ["SFProText-Semibold", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProDisplay-Semibold", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProDisplay-Semibold", "SFProText-Regular"]
var positionList = [[96, 86], [173, 230], [911, 227], [911, 429], [64, 1737], [911, 1737], [928, 1916], [280, 2126], [942, 2154], [934, 2323], [74, 430], [280, 1886]]
var trackingList = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
var offsetList = [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]
var alignmentList = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var rectList = [[96.0, 2350.0, 86.0, 34.0], [173.0, 2206.0, 192.0, 39.0], [911.0, 2209.0, 149.0, 39.0], [911.0, 2007.0, 149.0, 39.0], [64.0, 699.0, 276.0, 48.0], [911.0, 699.0, 149.0, 39.0], [928.0, 520.0, 147.0, 39.0], [280.0, 310.0, 144.0, 39.0], [942.0, 282.0, 133.0, 37.0], [934.0, 113.0, 98.0, 23.0], [74.0, 2006.0, 329.0, 50.0], [280.0, 550.0, 214.0, 39.0]]
var names = ["0.941", "1.Beaches", "2.Cancel", "3.SeeAll", "4.Moments", "5.SeeAll", "6.25", "7.Lisboa", "8.11", "9.Search", "10.oluPhotos", "11.Essaouira"]
var bgColorList = [[251.0, 251.0, 252.0], [142.0, 142.0, 147.0], [251.0, 251.0, 252.0], [242.0, 242.0, 247.0], [242.0, 242.0, 247.0], [242.0, 242.0, 247.0], [254.0, 255.0, 254.0], [254.0, 255.0, 254.0], [254.0, 255.0, 254.0], [247.0, 247.0, 246.0], [242.0, 242.0, 247.0], [254.0, 255.0, 254.0]]
var isParagraphList = [false, false, false, false, false, false, false, false, false, false, false, false]
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
