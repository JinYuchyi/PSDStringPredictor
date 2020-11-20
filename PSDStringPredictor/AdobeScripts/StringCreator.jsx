//(Open PSD from terminal script, not here)
//PS Preferance Setting
//Create Folder
//Add Text layer into folder
//Save
//Close

//Variables
var psdPath = "/Users/ipdesign/Documents/Development/PSDStringPredictor/PSDStringPredictor/Resources/TestImages/test.psd"
var contentList = ["Hello","12345"]
var colorList = []
var fontSizeList = []
var fontNameList= []
var positionList = []

//PS Preferance Setting
var originalUnit = preferences.rulerUnits
preferences.rulerUnits = Units.INCHES

var fileRef = File(psdPath) 
var docRef = app.open(fileRef)

//Create Folder
var len = docRef.layerSets.length
//Remove the previous folder
var i
for (i = 0; i < len; i++){
    if (docRef.layerSets[i].name == "StringLayerGroup"){
        docRef.layerSets[i].remove()
    }
}
//Add new folder
var layerSetRef = app.activeDocument.layerSets.add()
layerSetRef.name = "StringLayerGroup"

//Add Text layer
var artLayerRef = layerSetRef.artLayers.add()
artLayerRef.kind = LayerKind.TEXT
var textItemRef = artLayerRef.textItem
textItemRef.contents = "Hello, World"


