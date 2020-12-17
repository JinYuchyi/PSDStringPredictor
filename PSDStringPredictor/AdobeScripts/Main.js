
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
        textItemRef.leading = fontSizeList[i]/(600/72)
        textItemRef.width = rectList[i][2]
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

