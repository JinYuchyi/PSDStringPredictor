        var psdPath = "/Users/ipdesign/Documents/Development/PSDStringPredictor/PSDStringPredictor/Resources/TestImages/LocSample.png"
        var contentList = ["9:41", "Beaches", "Cancel", "See All", "Moments", "See All", "25 >", "Lisboa", "11 >", "Search", "/olu Photos", "Essaouira"]
        var colorList = [[0, 0, 0], [255, 255, 255], [0, 69, 250], [0, 76, 246], [0, 0, 0], [0, 76, 246], [123, 123, 134], [0, 0, 0], [126, 126, 136], [0, 78, 245], [0, 0, 0], [0, 0, 0]]
        var fontSizeList = [45.0, 49.0, 47.0, 47.0, 66.0, 50.0, 53.0, 48.0, 52.0, 29.0, 66.0, 48.0]
        var fontNameList= ["SFProText-Semibold", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProDisplay-Semibold", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProDisplay-Semibold", "SFProText-Regular"]
        var positionList = [[96, 86], [173, 230], [911, 227], [911, 429], [64, 1737], [911, 1737], [928, 1916], [280, 2126], [942, 2154], [934, 2323], [74, 430], [280, 1886]]
        var trackingList = [-5.111111, -6.3265305, -6.5957446, -6.5957446, -3.9393938, -26.52, -8.301887, -6.4583335, -25.5, 4.137931, -3.9393938, -6.4583335]
        var offsetList = [[2, 6], [4, 7], [3, 7], [2, 6], [4, 10], [2, 7], [4, 7], [4, 6], [3, 6], [1, 4], [0, 0], [4, 6]]
        var alignmentList = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        var rectList = [[96.0, 2350.0, 86.0, 34.0], [173.0, 2206.0, 192.0, 39.0], [911.0, 2209.0, 149.0, 39.0], [911.0, 2007.0, 149.0, 39.0], [64.0, 699.0, 276.0, 48.0], [911.0, 699.0, 149.0, 39.0], [928.0, 520.0, 147.0, 39.0], [280.0, 310.0, 144.0, 39.0], [942.0, 282.0, 133.0, 37.0], [934.0, 113.0, 98.0, 23.0], [74.0, 2006.0, 329.0, 50.0], [280.0, 550.0, 214.0, 39.0]]
        var names = ["0.941", "1.Beaches", "2.Cancel", "3.SeeAll", "4.Moments", "5.SeeAll", "6.25", "7.Lisboa", "8.11", "9.Search", "10.oluPhotos", "11.Essaouira"]
        var bgColorList = [[251.0, 251.0, 252.0], [142.0, 142.0, 147.0], [251.0, 251.0, 252.0], [242.0, 242.0, 247.0], [242.0, 242.0, 247.0], [242.0, 242.0, 247.0], [254.0, 255.0, 254.0], [254.0, 255.0, 254.0], [254.0, 255.0, 254.0], [247.0, 247.0, 246.0], [242.0, 242.0, 247.0], [254.0, 255.0, 254.0]]
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

    textItemRef.position = Array(positionList[i][0] - offsetList[i][0] + alignmentOffset, positionList[i][1]  - offsetList[i][1] / 4)
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
   //var y = arguments.length;
//    var i = 0;

//    var lineArray = [];
//    lineArray[0] = new PathPointInfo;
//    lineArray[0].kind = PointKind.CORNERPOINT;
//    lineArray[0].anchor = [posX, posY];
//    lineArray[0].leftDirection = lineArray[0].anchor;
//    lineArray[0].rightDirection = lineArray[0].anchor;

//    lineArray[1] = new PathPointInfo;
//    lineArray[1].kind = PointKind.CORNERPOINT;
//    lineArray[1].anchor = [posX + width, posY];
//    lineArray[1].leftDirection = lineArray[1].anchor;
//    lineArray[1].rightDirection = lineArray[1].anchor;

//    lineArray[2] = new PathPointInfo;
//    lineArray[2].kind = PointKind.CORNERPOINT;
//    lineArray[2].anchor = [posX + width, posY + height];
//    lineArray[2].leftDirection = lineArray[2].anchor;
//    lineArray[2].rightDirection = lineArray[2].anchor;

//    lineArray[3] = new PathPointInfo;
//    lineArray[3].kind = PointKind.CORNERPOINT;
//    lineArray[3].anchor = [posX, posY + height];
//    lineArray[3].leftDirection = lineArray[3].anchor;
//    lineArray[3].rightDirection = lineArray[3].anchor;

//    var lineSubPathArray = new SubPathInfo();
//    lineSubPathArray.closed = true;
//    lineSubPathArray.operation = ShapeOperation.SHAPEADD;
//    lineSubPathArray.entireSubPath = lineArray;
//    var myPathItem = docRef.pathItems.add(layerName, [lineSubPathArray]);

//    var desc88 = new ActionDescriptor();
//    var ref60 = new ActionReference();
//    ref60.putClass(stringIDToTypeID("contentLayer"));
//    desc88.putReference(charIDToTypeID("null"), ref60);
//    var desc89 = new ActionDescriptor();
//    var desc90 = new ActionDescriptor();
//    var desc91 = new ActionDescriptor();
//    desc91.putDouble(charIDToTypeID("Rd  "), color1[0]); // R
//    desc91.putDouble(charIDToTypeID("Grn "), color1[1]); // G
//    desc91.putDouble(charIDToTypeID("Bl  "), color1[2]); // B
//    var id481 = charIDToTypeID("RGBC");
//    desc90.putObject(charIDToTypeID("Clr "), id481, desc91);
//    desc89.putObject(charIDToTypeID("Type"), stringIDToTypeID("solidColorLayer"), desc90);
//    desc88.putObject(charIDToTypeID("Usng"), stringIDToTypeID("contentLayer"), desc89);
//    executeAction(charIDToTypeID("Mk  "), desc88, DialogModes.NO);
//    //rename(layerName)
//    myPathItem.remove();
// }

// function rename(name){
//     var idset = stringIDToTypeID( "set" );
//     var desc920 = new ActionDescriptor();
//     var idnull = stringIDToTypeID( "null" );
//         var ref264 = new ActionReference();
//         var idlayer = stringIDToTypeID( "layer" );
//         var idordinal = stringIDToTypeID( "ordinal" );
//         var idtargetEnum = stringIDToTypeID( "targetEnum" );
//         ref264.putEnumerated( idlayer, idordinal, idtargetEnum );
//     desc920.putReference( idnull, ref264 );
//     var idto = stringIDToTypeID( "to" );
//         var desc921 = new ActionDescriptor();
//         var idname = stringIDToTypeID( "name" );
//         desc921.putString( idname, name );
//     var idlayer = stringIDToTypeID( "layer" );
//     desc920.putObject( idto, idlayer, desc921 );
// executeAction( idset, desc920, DialogModes.NO );
}

// =======================================================
