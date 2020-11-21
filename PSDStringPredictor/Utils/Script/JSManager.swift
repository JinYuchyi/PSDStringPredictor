//
//  JSContent.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 21/11/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import AppKit

var variableStr = """
    //Variables

    var psdPath = "/Users/ipdesign/Documents/Development/PSDStringPredictor/PSDStringPredictor/Resources/TestImages/test.psd"
    var contentList = ["Hello","12345"]
    var colorList = []
    var fontSizeList = []
    var fontNameList= []
    var positionList = []

"""

var funcStr = """
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
"""

class JSManager{
    
    static func CreateJSFile(psdPath: String, contentList: [String], colorList: [[CGFloat]], fontSizeList: [Int], fontNameList: [String], positionList: [[Int]])->Bool{
        
        var jsStr = """
                var psdPath = "\(psdPath)"
                var contentList = \(contentList)
                var colorList = \(colorList)
                var fontSizeList = \(fontSizeList)
                var fontNameList= \(fontNameList)
                var positionList = \(positionList)

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
