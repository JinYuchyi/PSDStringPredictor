        var psdPath = "/Users/ipdesign/Downloads/1TA_Screen_Light.psd"
        var contentList = ["Hello"]
        var colorList = [[0.2, 1.0, 0.2]]
        var fontSizeList = [50]
        var fontNameList= [""]
        var positionList = [[100, 100]]

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