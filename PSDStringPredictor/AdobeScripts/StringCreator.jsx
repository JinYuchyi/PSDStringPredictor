        var psdPath = "/Users/ipdesign/Documents/Development/PSDStringPredictor/PSDStringPredictor/Resources/TestImages/LocSample.png"
        var contentList = ["Beaches", "lu Photos", "Moments", "Jul 22, 2019", "Search", "Cancel", "11", "See All", "For You", "Lisboa", "Essaouira", "Albums", "25", "Photos", "See All", "9:41"]
        var colorList = [[255, 255, 255], [0, 0, 0], [0, 0, 0], [123, 123, 134], [0, 78, 245], [0, 69, 250], [135, 135, 144], [0, 76, 246], [122, 122, 122], [0, 0, 0], [0, 0, 0], [123, 123, 124], [123, 123, 134], [116, 113, 111], [0, 76, 246], [0, 0, 0]]
        var fontSizeList = [50.0, 67.0, 68.0, 38.55703, 28.0, 49.0, 50.0, 51.0, 30.0, 49.0, 49.0, 29.0, 51.0, 30.0, 51.0, 45.0]
        var fontNameList= ["SFProText-Regular", "SFProDisplay-Semibold", "SFProDisplay-Semibold", "SFProText-Regular", "SFProText-Semibold", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Semibold"]
        var positionList = [[173, 230], [128, 430], [63, 1737], [278, 1946], [933, 2323], [911, 227], [943, 2154], [911, 429], [369, 2322], [280, 2126], [280, 1886], [648, 2322], [929, 1916], [91, 2323], [911, 1737], [96, 86]]
        var trackingList = [-26.52, -3.8805969, -1.4705882, -2.0748484, 53.197544, -6.3265305, -26.52, -26.0, 4.0, -6.3265305, -6.3265305, 54.20528, -26.0, 4.0, -26.0, -5.111111]
        var offsetList = [[4, 7], [4, 6], [4, 10], [1, 5], [1, 4], [3, 7], [3, 5], [2, 7], [2, 4], [4, 6], [4, 6], [1, 4], [3, 7], [2, 4], [2, 7], [2, 6]]
        var names = ["0.Beaches", "1.luPhotos", "2.Moments", "3.Jul222019", "4.Search", "5.Cancel", "6.11", "7.SeeAll", "8.ForYou", "9.Lisboa", "10.Essaouira", "11.Albums", "12.25", "13.Photos", "14.SeeAll", "15.941"]

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