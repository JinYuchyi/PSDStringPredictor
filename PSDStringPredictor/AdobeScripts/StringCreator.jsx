        var psdPath = "/Users/ipdesign/Documents/Development/PSDStringPredictor/PSDStringPredictor/Resources/TestImages/IMG_0012.PNG"
        var contentList = ["General", "English", "1,234.56", "1000/0", "Apps and websites will use the first language in this list that they support.", "Language & Region", "Mail", "Privacy", "Wallpaper", "Calendar", "Home Screen & Dock", "Accessibility", "Control Center", "Chinese, Simplified", "Face ID & Passcode", "Display & Brightness", "Battery", "PREFERRED LANGUAGE ORDER", "iPad Language", "Gregorian", "App Store", "Region", "China mainland", "Passwords", "Siri & Search", "Edit", "English", "Apple Pencil", "Add Language...", "Friday, August 29, 1969", "General", "12:34 AM", "4,567.89", "4:09 PM Wed Dec 31", "Temperature Unit", "Region Format Example", "Wallet & Apple Pay", "General", "Settings", "AA"]
        var colorList = [[0, 81, 245], [102, 102, 108], [0, 0, 0], [0, 0, 0], [43, 43, 52], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [95, 95, 102], [0, 0, 0], [0, 0, 0], [0, 0, 0], [42, 42, 52], [0, 0, 0], [102, 102, 108], [0, 0, 0], [0, 0, 0], [100, 100, 107], [0, 0, 0], [0, 0, 0], [0, 81, 245], [0, 0, 0], [0, 0, 0], [0, 68, 254], [0, 0, 0], [0, 138, 254], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [255, 255, 255], [0, 0, 0], [255, 255, 255]]
        var fontSizeList = [31, 33, 32, 14, 23, 33, 33, 33, 32, 33, 32, 33, 33, 24, 29, 31, 33, 25, 30, 31, 33, 33, 32, 31, 33, 32, 33, 32, 32, 31, 32, 31, 31, 21, 32, 31, 31, 30, 33, 25]
        var fontNameList= ["SFProText-Semibold", "SFProText-Regular", "SFProText-Regular", "SFProText-Semibold", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Semibold", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Regular", "SFProText-Semibold", "SFProText-Semibold", "SFProText-Semibold"]
        var positionList = [[894, 111], [2096, 274], [1453, 1330], [2236, 33], [977, 764], [1458, 110], [163, 1611], [163, 1119], [161, 679], [976, 964], [163, 504], [161, 591], [162, 328], [976, 608], [163, 944], [163, 415], [163, 1031], [978, 413], [976, 274], [2054, 963], [161, 1277], [977, 875], [1971, 876], [163, 1523], [162, 768], [2292, 110], [977, 488], [161, 855], [975, 692], [1441, 1287], [162, 240], [1542, 1244], [1658, 1330], [33, 33], [975, 1051], [1441, 1183], [161, 1365], [162, 240], [350, 110], [82, 415]]
        var trackingList = [3, 1, 1, -10, 34, 1, 1, 1, 1, 1, 1, 1, 1, 8, 47, 10, 1, 17, 41, -2, 1, 1, -5, 3, 1, 1, 1, 1, 1, -15, 1, 3, 3, 116, -4, -11, 1, 3, 1, 8]
        var offsetList = [[2, 4], [3, 4], [2, 3], [1, 2], [0, 3], [3, 4], [3, 5], [3, 4], [1, 5], [2, 5], [3, 4], [1, 5], [2, 5], [1, 3], [2, 4], [3, 5], [3, 4], [2, 3], [2, 3], [2, 4], [1, 5], [3, 4], [2, 5], [2, 4], [1, 4], [3, 4], [3, 4], [1, 4], [1, 4], [3, 4], [2, 5], [2, 3], [1, 4], [1, 3], [1, 4], [2, 4], [1, 6], [2, 4], [1, 4], [0, 3]]
        var names = ["0.General", "1.English", "2.123456", "3.10000", "4.Appsandwebsiteswillusethefirstlanguageinthislistthattheysupport", "5.LanguageRegion", "6.Mail", "7.Privacy", "8.Wallpaper", "9.Calendar", "10.HomeScreenDock", "11.Accessibility", "12.ControlCenter", "13.ChineseSimplified", "14.FaceIDPasscode", "15.DisplayBrightness", "16.Battery", "17.PREFERREDLANGUAGEORDER", "18.iPadLanguage", "19.Gregorian", "20.AppStore", "..."]

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