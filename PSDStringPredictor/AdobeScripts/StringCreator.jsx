        var psdPath = "/Users/ipdesign/Desktop/SO_ObjectSearch-1FC~L_F.psd"
        var contentList = ["9:41", "Beaches", "Cancel", "See All", "Moments", "See All", "Jul 22, 2019", "25", "Lisboa", "11", "Search", "/.lu Photos", "Essaouira"]
        var colorList = [[255, 0, 0], [255, 0, 0], [255, 0, 0], [255, 0, 0], [255, 0, 0], [255, 0, 0], [255, 0, 0], [255, 0, 0], [255, 0, 0], [255, 0, 0], [255, 0, 0], [255, 0, 0], [255, 0, 0]]
        var fontSizeList = [46, 51, 47, 49, 67, 49, 38, 50, 49, 50, 28, 69, 49]
        var fontNameList= ["SFProText-Semibold", "SFProText-Regular", "SFProText-Semibold", "SFProText-Semibold", "SFProDisplay-Semibold", "SFProText-Semibold", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Semibold", "SFProDisplay-Regular", "SFProText-Regular"]
        var positionList = [[96, 86], [173, 230], [911, 227], [911, 429], [64, 1737], [911, 1737], [278, 1946], [929, 1916], [280, 2126], [943, 2154], [934, 2323], [70, 430], [280, 1886]]
        var trackingList = [-16, -26, -20, -20, -4, -20, -6, -26, -20, -26, 19, -4, -20]
        var offsetList = [[3, 6], [4, 7], [3, 7], [2, 7], [4, 10], [2, 7], [1, 4], [3, 6], [4, 6], [3, 5], [1, 4], [4, 6]]

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
            textItemRef.name = ["0.941", "1.Beaches", "2.Cancel", "3.SeeAll", "4.Moments", "5.SeeAll", "6.Jul222019", "7.25", "8.Lisboa", "9.11", "10.Search", "11.luPhotos", "12.Essaouira"][i]
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