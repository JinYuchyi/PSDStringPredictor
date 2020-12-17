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
            
            let tmp = NameNormalize(name: c)
            res.append("\(index).\(tmp)")
            index += 1
            if(index > 20) {
                res.append("...")
                return res
            }
        }
        return res
    }
    
    func ReadJSToString(jsPath: String) -> String{
        var inString = ""
        var url = URL.init(fileURLWithPath: jsPath)
        do {
            inString = try String(contentsOf: url)
        } catch {
            print("Failed reading from URL: \(url), Error: " + error.localizedDescription)
        }
        
        return inString
    }
    
    func CreateJSFile(psdPath: String, contentList: [String], colorList: [[Int]], fontSizeList: [Float], trackingList: [Float], fontNameList: [String], positionList: [[Int]], offsetList: [[Int16]], alignmentList: [Int], rectList: [[Float]], bgColorList:[[Float]], isParagraphList: [Bool])->Bool{
        let names = NamesNormalize(names: contentList)
        let functionJSStr = ReadJSToString(jsPath: GetDocumentsPath() +  "/Development/PSDStringPredictor/PSDStringPredictor/AdobeScripts/Functions.js")
        var variablesStr = """
                var psdPath = "\(psdPath)"
                var contentList = \(contentList)
                var colorList = \(colorList)
                var fontSizeList = \(fontSizeList)
                var fontNameList= \(fontNameList)
                var positionList = \(positionList)
                var trackingList = \(trackingList)
                var offsetList = \(offsetList)
                var alignmentList = \(alignmentList)
                var rectList = \(rectList)
                var names = \(names)
                var bgColorList = \(bgColorList)
                var isParagraphList = \(isParagraphList)
        """
        //let mainJSStr = ReadJSToString(jsPath: "/Users/ipdesign/Documents/Development/PSDStringPredictor/PSDStringPredictor/AdobeScripts/Main.js")
        let mainJSStr = ReadJSToString(jsPath: GetDocumentsPath() +  "/Development/PSDStringPredictor/PSDStringPredictor/AdobeScripts/Main.js")
        
        var outputStr: String = ""
        outputStr.append(variablesStr)
        outputStr.append(mainJSStr)
        outputStr.append(functionJSStr)
        
        do {
            let path = GetDocumentsPath() + "/Development/PSDStringPredictor/PSDStringPredictor/AdobeScripts/StringCreator.jsx"
            let url = URL.init(fileURLWithPath: path)
            try outputStr.write(to: url, atomically: false, encoding: .utf8)
        }
        catch {
            return false
        }
        
        return true
        
    }
    
}
