//
//  JSContent.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 21/11/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import AppKit



class JSManager{
    
    private func NameNormalize(name : String)->String{
        var res: String = ""
        for c in name{
            if c.isLetter || c.isNumber{
                res = res + String(c)
            }
        }
        return res
    }
    
     private func NamesNormalize(names : [String])->[String]{
        var res: [String] = []
        var index = 0
        for c in names{
            res.append("\(index).")
            let tmp = NameNormalize(name: c)
            res.append(tmp)
            index += 1
        }
        return res
    }
    
    func CreateJSFile(psdPath: String, contentList: [String], colorList: [[Float]], fontSizeList: [Int], fontNameList: [String], positionList: [[Int]])->Bool{
        let names = NamesNormalize(names: contentList)
        var jsStr = """
                var psdPath = "\(psdPath)"
                var contentList = \(contentList)
                var colorList = \(colorList)
                var fontSizeList = \(fontSizeList)
                var fontNameList= \(fontNameList)
                var positionList = \(positionList)

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
                    textItemRef.name = \(names)[i]
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
        """
        
        do {
            let path = "/Users/ipdesign/Documents/Development/PSDStringPredictor/PSDStringPredictor/AdobeScripts/StringCreator.jsx"
            let url = URL.init(fileURLWithPath: path)
            try jsStr.write(to: url, atomically: false, encoding: .utf8)
        }
        catch {
            return false
        }
        
        return true
    }
    
}