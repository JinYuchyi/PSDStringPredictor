        var psdPath = "/Users/ipdesign/Documents/Development/PSDStringPredictor/PSDStringPredictor/Resources/TestImages/LocSample.png"
        var contentList = ["9:41", "Beaches", "lu Photos", "See All", "Moments", "See All", "Jul 22, 2019", "25", "Lisboa", "11", "Photos", "For You", "Albums", "Search", "ancel", "Essaouira", "olc"]
        var colorList = [[0, 0, 0], [142, 142, 147], [0, 0, 0], [0, 122, 247], [0, 0, 0], [0, 122, 247], [152, 152, 159], [152, 152, 159], [0, 0, 0], [152, 152, 159], [138, 134, 133], [147, 147, 147], [148, 148, 148], [0, 122, 245], [0, 122, 251], [0, 0, 0], [0, 122, 147]]
        var fontSizeList = [48, 47, 69, 50, 68, 51, 38, 50, 52, 47, 30, 30, 29, 30, 47, 49, 91]
        var fontNameList= ["SFProText-Semibold", "SFProText-Semibold", "SFProDisplay-Semibold", "SFProText-Regular", "SFProDisplay-Semibold", "SFProText-Semibold", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Semibold", "SFProText-Semibold", "SFProText-Regular", "SFProDisplay-Semibold"]
        var positionList = [[96, 86], [173, 230], [128, 430], [910, 429], [63, 1737], [910, 1737], [278, 1947], [929, 1916], [280, 2126], [943, 2154], [91, 2323], [369, 2323], [648, 2323], [933, 2323], [945, 227], [280, 1886], [801, 256]]
        var trackingList = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        var offsetList = []

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
        for (var i = 0; i < contentList.length; i++){
            var artLayerRef = layerSetRef.artLayers.add()
            artLayerRef.kind = LayerKind.TEXT
            var textItemRef = artLayerRef.textItem
            textItemRef.name = ["0.941", "1.Beaches", "2.luPhotos", "3.SeeAll", "4.Moments", "5.SeeAll", "6.Jul222019", "7.25", "8.Lisboa", "9.11", "10.Photos", "11.ForYou", "12.Albums", "13.Search", "14.ancel", "15.Essaouira", "16.olc"][i]
            textItemRef.contents = contentList[i]
            textColor = new SolidColor
            textColor.rgb.red = colorList[i][0]
            textColor.rgb.green = colorList[i][1]
            textColor.rgb.blue = colorList[i][2]
            textItemRef.color = textColor
            textItemRef.font = fontNameList[i]
            textItemRef.size = new UnitValue(fontSizeList[i], "pt")
            //textItemRef.position = Array(positionList[i][0] - offsetList[i][0], positionList[i][1] - offsetList[i][1])
            textItemRef.position = Array(positionList[i][0] - offsetList[i][0], positionList[i][1]  - offsetList[i][1] / 4)
            textItemRef.tracking = trackingList[i]
        }