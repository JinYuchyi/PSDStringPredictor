        var psdPath = "/Users/ipdesign/Documents/Development/PSDStringPredictor/PSDStringPredictor/Resources/TestImages/LocSample.png"
        var contentList = ["9:41", "Beaches", "Cancel", "See All", "Moments", "See All", "25 >", "Lisboa", "11 >", "Search", "/olu Photos", "Essaouira"]
        var colorList = [[0, 0, 0], [107, 107, 116], [0, 69, 250], [0, 76, 246], [0, 0, 0], [0, 76, 246], [123, 123, 134], [0, 0, 0], [126, 126, 136], [0, 78, 245], [0, 0, 0], [0, 0, 0]]
        var fontSizeList = [45, 51, 49, 51, 67, 51, 53, 51, 52, 28, 66, 49]
        var fontNameList= ["SFProText-Semibold", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProDisplay-Semibold", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProDisplay-Semibold", "SFProText-Regular"]
        var positionList = [[96, 86], [173, 230], [911, 227], [911, 429], [64, 1737], [911, 1737], [928, 1916], [280, 2126], [942, 2154], [934, 2323], [74, 430], [280, 1886]]
        var trackingList = [0, -1, 0, -1, 0, -1, 0, -1, -1, 0, 0, 0]
        var offsetList = [[2, 6], [4, 7], [3, 7], [2, 7], [4, 10], [2, 7], [4, 7], [4, 6], [3, 6], [1, 4], [0, 0], [4, 6]]
        var names = ["0.941", "1.Beaches", "2.Cancel", "3.SeeAll", "4.Moments", "5.SeeAll", "6.25", "7.Lisboa", "8.11", "9.Search", "10.oluPhotos", "11.Essaouira"]

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
        var layerSetRef = app.activeDocument.layerSets.add()
        layerSetRef.name = "StringLayerGroup"


        //Add Text layer
        const num = contentList.length

        //for (var i = 0; i < num; i++){
            //var artLayerRef = layerSetRef.artLayers.add()
            //artLayerRef.kind = LayerKind.TEXT
            //var textItemRef = artLayerRef.textItem
        //}

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
            textItemRef.position = Array(positionList[i][0] - offsetList[i][0], positionList[i][1]  - offsetList[i][1] / 4)
            textItemRef.tracking = trackingList[i]
        }