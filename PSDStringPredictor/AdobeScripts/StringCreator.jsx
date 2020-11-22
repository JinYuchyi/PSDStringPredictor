        var psdPath = "/Users/ipdesign/Downloads/1TA_Screen_Light.psd"
        var contentList = ["9:41 AM", "Done", "Columbus Ave & Pacific Ave", "Chinatown, San Francisco", "Tl", "i•niffjiiffli•", "inimnniiiii Xi", "•nimiininii Mnii", "Irl"]
        var colorList = [[], [], [], [], [], [], [], [], []]
        var fontSizeList = [38, 55, 69, 44, 41, 17, 17, 19, 19]
        var fontNameList= ["SF Pro Text Regular", "SF Pro Text Semibold", "SF Pro Display Semibold", "SF Pro Text Regular", "SF Pro Text Regular", "SF Pro Text Regular", "SF Pro Text Regular", "SF Pro Text Regular", "SF Pro Text Regular"]
        var positionList = [[492, 1956], [919, 1815], [47, 124], [47, 62], [921, 956], [455, 837], [484, 818], [466, 593], [1092, 409]]

        //PS Preferance Setting

        var originalUnit = preferences.rulerUnits
        preferences.rulerUnits = Units.PIXELS

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
        for (var i = 0; i < contentList.length; i++){
            var artLayerRef = layerSetRef.artLayers.add()
            artLayerRef.kind = LayerKind.TEXT
            var textItemRef = artLayerRef.textItem
            textItemRef.name = ["0.", "941AM", "1.", "Done", "2.", "ColumbusAvePacificAve", "3.", "ChinatownSanFrancisco", "4.", "Tl", "5.", "iniffjiiffli", "6.", "inimnniiiiiXi", "7.", "nimiininiiMnii", "8.", "Irl"][i]
            textItemRef.contents = contentList[i]
            textColor = new SolidColor
            textColor.rgb.red = colorList[i][0]
            textColor.rgb.green = colorList[i][1]
            textColor.rgb.blue = colorList[i][2]
            textItemRef.color = textColor
            textItemRef.font = fontNameList[i]
            textItemRef.size = new UnitValue(fontSizeList[i], "pt")
            textItemRef.position = Array(positionList[i][0], positionList[i][1])
        }