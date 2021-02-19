
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
    alignName = alignmentList[i]
    if (alignName == "center") {
        alignmentOffset = rectList[i][2] / 2
    }
    if (alignName == "right") {
        alignmentOffset = rectList[i][2]
    }

//    alignName = alignmentList[i]
    
    padding = 5

    if (isParagraphList[i] == true) {
        textItemRef.position = Array(positionList[i][0] - offsetList[i][0] + alignmentOffset , positionList[i][1] - rectList[i][3]  - offsetList[i][1] / 4)
    }else{
        textItemRef.position = Array(positionList[i][0] - offsetList[i][0] + alignmentOffset, positionList[i][1]  - offsetList[i][1] / 4)
    }
    textItemRef.tracking = trackingList[i]
    artLayerRef.name = names[i]
    selectLayer(artLayerRef.name)
    setTextAlignment(alignName)

    //Create Mask Layers
    fillColor = bgColorList[i]
    createRectangle(layerSetRef1, "L_" + names[i], positionList[i][0] - padding, positionList[i][1] - rectList[i][3] - padding , rectList[i][2] + padding * 2, rectList[i][3] + padding*2 + descentOffset[i], fillColor)
}
                                     
 if (saveToPath != "") {
        const file = File(saveToPath)
        docRef.saveAs(file, PhotoshopSaveOptions)
        docRef.close(SaveOptions.DONOTSAVECHANGES)
        //newDoc.close(SaveOptions.DONOTSAVECHANGES)
}

