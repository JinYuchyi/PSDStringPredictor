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
    
    static let shared = JSManager()
    
    private init(){}
    
    private func NameNormalize(name : String)->String{
        var res: String = ""
        var index = 0
        for c in name{
            if c.isLetter || c.isNumber{
                res = res + String(c)
            }
            if(index > 20) {
                res.append("...")
                return res
            }
            index += 1
        }
        if res.isEmpty {
            return "_"
        }else {
            return res
        }
        
    }
    
    private func NamesNormalize(names : [String])->[String]{
        var res: [String] = []
        var index = 0
        for c in names{
            
            let tmp = NameNormalize(name: c)
            res.append("\(index).\(tmp)")
            index += 1
//            if(index > 20) {
//                res.append("...")
//                return res
//            }
        }
        return res
    }
    
    func ReadJSToString(jsPath: String) -> String{
        var inString = ""
        let url = URL.init(fileURLWithPath: jsPath)
        do {
            inString = try String(contentsOf: url)
        } catch {
            print("Failed reading from URL: \(url), Error: " + error.localizedDescription)
        }
        
        return inString
    }
    
    func CreateJSString(psdPath: String, contentList: [String], colorList: [[Int]], fontSizeList: [Float], trackingList: [Float], fontNameList: [String], positionList: [[Float]], offsetList: [[Int16]], alignmentList: [String], rectList: [[Float]], bgColorList:[[Float]], isParagraphList: [Bool], saveToPath: String, descentOffset: [Float], frontSpace: [Float], createMask: Bool)->String{
        let names = NamesNormalize(names: contentList)
        let resourcePath = Bundle.main.resourcePath!
        let functionJSStr = ReadJSToString(jsPath: resourcePath +  "/Functions.js")
        //print(resourcePath)
        let variablesStr = """
        ////Variables
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
        var widthExtend = 3
        var saveToPath = "\(saveToPath)"
        var descentOffset = \(descentOffset)
        var frontSpace = \(frontSpace)
        var createMask = \(createMask)
        """
//        print("frontSpace: \(frontSpace)")
        let mainJSStr = ReadJSToString(jsPath: resourcePath +  "/Main.js")
        
        var outputStr: String = ""
        outputStr.append(variablesStr)
        outputStr.append(mainJSStr)
        outputStr.append(functionJSStr)
        
        return outputStr
        
        
        // Create JS file from JS string
//        do {
//            let path = jsPath //resourcePath + "/StringCreator.jsx"
//            print("Creating js: \(path)")
//            let url = URL.init(fileURLWithPath: path)
//            try FileManager.default.createDirectory(atPath: resourcePath + "/OutputScript", withIntermediateDirectories: true, attributes: nil)
//            try outputStr.write(to: url, atomically: false, encoding: .utf8)
//        }
//        catch {
//            return false
//        }
//
//        return true
        
    }
    
    func ConstellateJsonString(relatedDataJsonObject: RelatedDataJsonObject, psdStrDict: [Int:[UUID]], psdDict: [Int: PSDObject], strDict: [UUID: StringObject]) -> String{
        var psdObjDictList: [PsdJsonObject] = []
        for _psd in psdDict.values{
            let objIdList = psdStrDict[_psd.id]
            var outputList : [strObjJsonObject] = []

            if objIdList != nil {
                for objId in objIdList! {
                    let strObj = strObjJsonObject.init(
                        id: objId,
                        content: strDict[objId]!.content,
                        tracking: strDict[objId]!.tracking,
                        fontSize: strDict[objId]!.fontSize,
                        fontWeight: strDict[objId]!.fontWeight,
                        stringRect: strDict[objId]!.stringRect,
                        color: strDict[objId]!.color.toCGFloatArray(),
                        bgColor: strDict[objId]!.bgColor.toCGFloatArray(),
                        charArray: strDict[objId]!.charArray.map({String($0)}),
                        charRects: strDict[objId]!.charRects,
                        charSizeList: strDict[objId]!.charSizeList,
                        charFontWeightList: strDict[objId]!.charFontWeightList,
                        isPredictedList: strDict[objId]!.isPredictedList,
                        colorMode: strDict[objId]!.colorMode.rawValue,
                        charColorModeList: strDict[objId]!.charColorModeList,
                        fontName: strDict[objId]!.fontName,
                        alignment: strDict[objId]!.alignment.rawValue,
                        status: strDict[objId]!.status.rawValue,
                        isParagraph: strDict[objId]!.isParagraph
                    )
                    
                    outputList.append(strObj)

                }
            }
            //psd
            let psdObj = PsdJsonObject.init(
                id: _psd.id,
                stringObjects: outputList,
                imageURL: _psd.imageURL,
                thumbnail: _psd.thumbnail.pngData!,
                colorMode: _psd.colorMode.rawValue,
                dpi: _psd.dpi,
                status: _psd.status.rawValue)
   
            
            psdObjDictList.append(psdObj)
        }
        
    
        let jsonObj = JsonObject(PsdJsonObjectList: psdObjDictList, psdStrDict: psdStrDict, relatedDataJsonObject: relatedDataJsonObject)
        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(jsonObj)
        let jsonString = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)! as String

        return jsonString
    }
    
    func loadPsdJsonObject(jsonObject: JsonObject) -> (psdStrDict: [Int:[UUID]], psdDict: [Int: PSDObject], strDict: [UUID: StringObject]) {
//        var psdObjList: [PSDObject] = []
        var psdDict: [Int: PSDObject] = [:]
        var psdStrDict: [Int:[UUID]] = [:]
        var strDict: [UUID: StringObject] = [:]
        for psdJ in jsonObject.PsdJsonObjectList{
            let targetImage = CIImage.init(contentsOf: psdJ.imageURL)
            let tmpPsd = PSDObject(id: psdJ.id, imageURL: psdJ.imageURL, thumbnail: NSImage.init(data: psdJ.thumbnail) ?? NSImage.init(), colorMode: MacColorMode.init(rawValue: psdJ.colorMode)!, dpi: psdJ.dpi, status: PsdStatus.init(rawValue: psdJ.status)!)
            psdDict[psdJ.id] = tmpPsd // Recover one psd in psdDict
            for strJ in psdJ.stringObjects{
                var charImgList = [CIImage]()
                for rect in strJ.charRects{
                    let tmpImg: CIImage = targetImage?.cropped(to: rect) ?? DataStore.zeroCIImage
                    charImgList.append(tmpImg)
                }
                let tmpStrObj = StringObject.init(id: strJ.id, imagePath: psdJ.imageURL.path, content: strJ.content, tracking: strJ.tracking, fontSize: strJ.fontSize, colorMode: strJ.colorMode, fontWeight: strJ.fontWeight, charImageList: charImgList, stringRect: strJ.stringRect, color: strJ.color, bgColor: strJ.bgColor, charArray: strJ.charArray, charRacts: strJ.charRects, charSizeList: strJ.charSizeList, charFontWeightList: strJ.charFontWeightList, charColorModeList: strJ.charColorModeList, isPredictedList: strJ.isPredictedList, fontName: strJ.fontName, alignment: strJ.alignment, status: strJ.status)
                psdStrDict[psdJ.id] == nil ? psdStrDict[psdJ.id] = [tmpStrObj.id] : psdStrDict[psdJ.id]?.append(tmpStrObj.id) // Recover one psd-str in psdStrDict
                strDict[tmpStrObj.id] = tmpStrObj // Recover one str in strDict
            }
        }
        return (psdStrDict, psdDict, strDict)
    }
    
}
