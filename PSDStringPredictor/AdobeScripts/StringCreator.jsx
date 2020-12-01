        var psdPath = "/Users/ipdesign/Documents/Development/PSDStringPredictor/PSDStringPredictor/Resources/TestImages/LocSample.png"
        var contentList = ["9:41", "Beaches", "Cancel", "See All", "Moments", "See All", "Jul 22, 2019", "25 >", "Lisboa", "11 >", "Photos", "For You", "Albums", "Search", "/olu Photos", "Essaouira"]
        var colorList = [[0, 0, 0], [255, 255, 255], [255, 255, 255], [255, 255, 255], [255, 255, 255], [0, 80, 246], [123, 123, 134], [255, 255, 255], [255, 255, 255], [126, 126, 136], [237, 236, 235], [255, 255, 255], [255, 255, 255], [255, 255, 255], [255, 255, 255], [255, 255, 255]]
        var fontSizeList = [46, 49, 49, 51, 67, 51, 39, 50, 51, 50, 29, 29, 29, 30, 67, 51]
        var fontNameList= ["SFProText-Semibold", "SFProText-Semibold", "SFProText-Semibold", "SFProText-Regular", "SFProDisplay-Semibold", "SFProText-Regular", "SFProText-Semibold", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Semibold", "SFProText-Semibold", "SFProText-Semibold", "SFProText-Semibold", "SFProDisplay-Semibold", "SFProText-Regular"]
        var positionList = [[97, 85], [174, 229], [912, 226], [911, 428], [64, 1736], [911, 1736], [279, 1945], [930, 1915], [281, 2125], [944, 2153], [92, 2322], [370, 2322], [649, 2322], [934, 2322], [75, 429], [281, 1885]]
        var trackingList = [-16, -20, -20, -26, -4, -26, -6, -26, -26, -26, 12, 12, 12, 12, -4, -26]
        var offsetList = [[3, 6], [4, 7], [3, 7], [2, 7], [4, 10], [2, 7], [1, 5], [3, 6], [4, 6], [3, 5], [2, 4], [2, 4], [1, 4], [1, 4], [4, 6]]

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
            textItemRef.name = ["0.941", "1.Beaches", "2.Cancel", "3.SeeAll", "4.Moments", "5.SeeAll", "6.Jul222019", "7.25", "8.Lisboa", "9.11", "10.Photos", "11.ForYou", "12.Albums", "13.Search", "14.oluPhotos", "15.Essaouira"][i]
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