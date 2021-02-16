//
//  psdPageObject.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 26/11/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreImage
import SwiftUI



enum MacColorMode: String {
    case light = "light"
    case dark = "dark"
}

enum StringObjectStatus: String, Codable {
    case fixed, ignored, normal
}

enum PsdStatus: String, Codable {
    case normal = "normal", processed = "processed", commited = "commited"
}


struct PSDObject: Identifiable{
    var id: Int
    var stringObjects: [StringObject] = []
    var imageURL: URL
    var thumbnail: NSImage = NSImage.init()
    var colorMode: MacColorMode = .light
    var dpi: Int = 0
    var status: PsdStatus = .normal
    
    fileprivate init(id: Int, imageURL: URL, thumbnail: NSImage, colorMode: MacColorMode, dpi: Int, status: PsdStatus){
        self.id = id
        self.imageURL = imageURL
        self.colorMode = colorMode
        self.thumbnail = thumbnail
        self.dpi = dpi
        self.status = status
    }
    
    fileprivate init(id: Int, imageURL: URL){
        self.id = id
        stringObjects = []
        //self.thumbnail = thumbnail
        //self.stringObjects = stringObjects
        self.imageURL = imageURL
        self.thumbnail = FetchThumbnail(size: sizeOfThumbnail)
        colorMode = PsdsUtil.shared.FetchColorMode(img: thumbnail.ToCIImage()!)
        status = .normal
    }
    
    fileprivate func FetchThumbnail(size: Int) -> NSImage{
        let imgData = (try? Data(contentsOf: imageURL))
        if imgData != nil {
            let rowImage = NSImage.init(data: imgData!)
            return rowImage!.resize(sizeOfThumbnail)
        }
        return NSImage.init()
    }
    
    func GetStringObjectFromOnePsd(objId: UUID) -> StringObject?{
        return stringObjects.first(where: {$0.id == objId})
    }

    func FetchColorMode() -> MacColorMode{
        let classifier = ColorModeClassifier(image: thumbnail.ToCIImage()!)
        let result = classifier.output
        if result == 1 {
            return .light
        }
        else {
            return .dark
        }
    }
    
}

struct PSD {
    var psdObjects = [PSDObject]()
    
    fileprivate var uniqID = 0
    
    mutating func addPSDObject( imageURL: URL) -> Int{
        psdObjects.append(PSDObject(id: uniqID, imageURL: imageURL))
        uniqID = (uniqID + 1) % 1000000
        return uniqID
    }
    
    func GetPSDObject(psdId: Int) -> PSDObject?{
        return psdObjects.first(where: {$0.id == psdId})
    }
    

    func ConstellateJsonString(relatedDataJsonObject: RelatedDataJsonObject) -> String{
        var psdObjDictList: [PsdJsonObject] = []
        for _psd in psdObjects{
            var strObjDictList : [strObjJsonObject] = []
            for _strObj in _psd.stringObjects {
                print("Constellating data for psdObject \(_psd.id), stringObject: \(_strObj.content)")
                let strObj = strObjJsonObject.init(
                    id: _strObj.id,
                    content: _strObj.content,
                    tracking: _strObj.tracking,
                    fontSize: _strObj.fontSize,
                    fontWeight: _strObj.fontWeight,
                    stringRect: _strObj.stringRect,
                    color: _strObj.color.toArray(),
                    bgColor: _strObj.bgColor.toArray(),
                    charArray: _strObj.charArray.map({String($0)}),
                    charRects: _strObj.charRects,
                    charSizeList: _strObj.charSizeList,
                    //charImageList: [],
                    charFontWeightList: _strObj.charFontWeightList,
                    isPredictedList: _strObj.isPredictedList,
                    colorMode: _strObj.colorMode.rawValue,
                    charColorModeList: _strObj.charColorModeList,
                    fontName: _strObj.FontName,
                    alignment: _strObj.alignment.rawValue,
                    status: _strObj.status.rawValue,
                    isParagraph: _strObj.isParagraph
//                    colorPixel: _strObj.colorPixel.toData()
                )
                
                strObjDictList.append(strObj)

            }
            //psd
            let psdObj = PsdJsonObject.init(
                id: _psd.id,
                stringObjects: strObjDictList,
                imageURL: _psd.imageURL,
                thumbnail: _psd.thumbnail.pngData!,
                colorMode: _psd.colorMode.rawValue,
                dpi: _psd.dpi,
                status: _psd.status.rawValue)
   
            
            psdObjDictList.append(psdObj)
        }
        
    
        let jsonObj = JsonObject(PsdJsonObjectList: psdObjDictList, relatedDataJsonObject: relatedDataJsonObject)
        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(jsonObj)
        let jsonString = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)! as String

        return jsonString
    }
    
    mutating func SetPosForString(psdId: Int, objId: UUID, valueX: CGFloat, valueY: CGFloat, isOnlyX: Bool, isOnlyY: Bool){
        var newRect = GetPSDObject(psdId: psdId)?.GetStringObjectFromOnePsd(objId: objId)?.stringRect
        if isOnlyX == true {
            newRect = CGRect.init(x: valueX, y: newRect!.minY, width: newRect!.width, height: newRect!.height)
        }
        else if isOnlyY == true {
            newRect = CGRect.init(x: newRect!.minX, y: valueY, width: newRect!.width, height: newRect!.height)
        }
        else if isOnlyX == false && isOnlyY == false {
            newRect = CGRect.init(x: valueX, y: valueY, width: newRect!.width, height: newRect!.height)
        }
        SetRect(psdId: psdId, objId: objId, value: newRect!)
    }
    
    mutating func SetStatusForString(psdId: Int, objId: UUID, value: StringObjectStatus){
        var psd = GetPSDObject(psdId: psdId)
        if psd != nil {
            var strObj = psd!.GetStringObjectFromOnePsd(objId: objId)
            if strObj != nil{
                strObj!.status = value
                //Replace strObj
                psd!.stringObjects.removeAll(where: {$0.id == objId})
                psd!.stringObjects.append(strObj!)
                //Replace psd
                let _index = psdObjects.firstIndex(where: {$0.id == psdId})
                psdObjects.removeAll(where: {$0.id == psdId})
                psdObjects.insert(psd!, at: _index!)
            }
        }
    }
    
    mutating func SetStatusForPsd(psdId: Int, value: PsdStatus){
        guard var psd = GetPSDObject(psdId: psdId) else {return}
        psd.status = value
        //Replace psd
        let _index = psdObjects.firstIndex(where: {$0.id == psdId})
        psdObjects.removeAll(where: {$0.id == psdId})
        psdObjects.insert(psd, at: _index!)
    }
    
    mutating func SetStringObjects(psdId: Int, value: [StringObject]){
        guard var psd = GetPSDObject(psdId: psdId) else {return}
        psd.stringObjects = value
        //Replace psd
        let _index = psdObjects.firstIndex(where: {$0.id == psdId})
        psdObjects.removeAll(where: {$0.id == psdId})
        psdObjects.insert(psd, at: _index!)
    }
    
    mutating func SetFontSize(psdId: Int, objId: UUID, value: CGFloat, offset: Bool){
        var psd = GetPSDObject(psdId: psdId)
        if psd != nil {
            var strObj = psd!.GetStringObjectFromOnePsd(objId: objId)
            if strObj != nil{
                strObj!.fontSize = value
                //Replace strObj
                psd!.stringObjects.removeAll(where: {$0.id == objId})
                psd!.stringObjects.append(strObj!)
                //Replace psd
                let _index = psdObjects.firstIndex(where: {$0.id == psdId})
                psdObjects.removeAll(where: {$0.id == psdId})
                psdObjects.insert(psd!, at: _index!)
            }
        }
    }
    
    mutating func SetContent(psdId: Int, objId: UUID, value: String){
        var psd = GetPSDObject(psdId: psdId)
        if psd != nil {
            var strObj = psd!.GetStringObjectFromOnePsd(objId: objId)
            if strObj != nil{
                strObj!.content = value
                //Replace strObj
                psd!.stringObjects.removeAll(where: {$0.id == objId})
                psd!.stringObjects.append(strObj!)
                //Replace psd
                let _index = psdObjects.firstIndex(where: {$0.id == psdId})
                psdObjects.removeAll(where: {$0.id == psdId})
                psdObjects.insert(psd!, at: _index!)
            }
        }
    }
    
    mutating func SetLastStringObject(psdId: Int, objId: UUID, value: StringObject){
        var psd = GetPSDObject(psdId: psdId)
        if psd != nil {
            psd!.stringObjects.removeAll(where: {$0.id == objId})
            psd!.stringObjects.append(value)
            //Replace psd
            let _index = psdObjects.firstIndex(where: {$0.id == psdId})
            psdObjects.removeAll(where: {$0.id == psdId})
            psdObjects.insert(psd!, at: _index!)
            
        }
    }
    
    
    mutating func SetAlignment(psdId: Int, objId: UUID, value: StringAlignment){
        var psd = GetPSDObject(psdId: psdId)
        if psd != nil {
            var strObj = psd!.GetStringObjectFromOnePsd(objId: objId)
            if strObj != nil{
                strObj!.alignment = value
                //Replace strObj
                psd!.stringObjects.removeAll(where: {$0.id == objId})
                psd!.stringObjects.append(strObj!)
                //Replace psd
                let _index = psdObjects.firstIndex(where: {$0.id == psdId})
                psdObjects.removeAll(where: {$0.id == psdId})
                psdObjects.insert(psd!, at: _index!)
            }
        }
    }
    
    mutating func SetRect(psdId: Int, objId: UUID, value: CGRect){
        var psd = GetPSDObject(psdId: psdId)
        if psd != nil {
            var strObj = psd!.GetStringObjectFromOnePsd(objId: objId)
            if strObj != nil{
                strObj!.stringRect = value
                //Replace strObj
                psd!.stringObjects.removeAll(where: {$0.id == objId})
                psd!.stringObjects.append(strObj!)
                //Replace psd
                let _index = psdObjects.firstIndex(where: {$0.id == psdId})
                psdObjects.removeAll(where: {$0.id == psdId})
                psdObjects.insert(psd!, at: _index!)
            }
        }
    }
    
    mutating func SetColorMode(psdId: Int, objId: UUID, value: MacColorMode){
        var psd = GetPSDObject(psdId: psdId)
        if psd != nil {
            var strObj = psd!.GetStringObjectFromOnePsd(objId: objId)
            if strObj != nil{
                strObj!.colorMode = value
                strObj!.CalcColor()
                //Replace strObj
                psd!.stringObjects.removeAll(where: {$0.id == objId})
                psd!.stringObjects.append(strObj!)
                //Replace psd and save to the same place
                let _index = psdObjects.firstIndex(where: {$0.id == psdId})
                psdObjects.removeAll(where: {$0.id == psdId})
                psdObjects.insert(psd!, at: _index!)
            }
        }
    }
    
    
    
    mutating func SetFontName(psdId: Int, objId: UUID, value: String){
        var psd = GetPSDObject(psdId: psdId)
        if psd != nil {
            var strObj = psd!.GetStringObjectFromOnePsd(objId: objId)
            if strObj != nil{
                strObj!.FontName = value
                //strObj!.CalcColor()
                //Replace strObj
                psd!.stringObjects.removeAll(where: {$0.id == objId})
                psd!.stringObjects.append(strObj!)
                //Replace psd
                let _index = psdObjects.firstIndex(where: {$0.id == psdId})
                psdObjects.removeAll(where: {$0.id == psdId})
                psdObjects.insert(psd!, at: _index!)
            }
        }
    }
    
    mutating func SetChar(psdId: Int, objId: UUID, charIndex: Int, value: String){
        var psd = GetPSDObject(psdId: psdId)
        if psd != nil {
            var strObj = psd!.GetStringObjectFromOnePsd(objId: objId)
            if strObj != nil{
                print("Changing \(strObj!.charArray[charIndex]) to \(Array(value)[0])")
                strObj!.charArray[charIndex] = Array(value)[0]
                strObj!.content = String(strObj!.charArray)
                //print("\(strObj!.content)")
                //Replace strObj
                psd!.stringObjects.removeAll(where: {$0.id == objId})
                psd!.stringObjects.append(strObj!)
                //Replace psd
                let _index = psdObjects.firstIndex(where: {$0.id == psdId})
                psdObjects.removeAll(where: {$0.id == psdId})
                psdObjects.insert(psd!, at: _index!)
            }
        }
    }
    
//    mutating func SetContent(psdId: Int, objId: UUID, value: String){
//        var psd = GetPSDObject(psdId: psdId)
//        if psd != nil {
//            var strObj = psd!.GetStringObjectFromOnePsd(objId: objId)
//            if strObj != nil{
////                print("Changing \(strObj!.charArray[charIndex]) to \(Array(value)[0])")
////                strObj!.charArray[charIndex] = Array(value)[0]
//                strObj!.content = value
//                strObj!.charArray = Array(strObj!.content)
//                //print("\(strObj!.content)")
//                //Replace strObj
//                psd!.stringObjects.removeAll(where: {$0.id == objId})
//                psd!.stringObjects.append(strObj!)
//                //Replace psd
//                let _index = psdObjects.firstIndex(where: {$0.id == psdId})
//                psdObjects.removeAll(where: {$0.id == psdId})
//                psdObjects.insert(psd!, at: _index!)
//            }
//        }
//    }
    
    
    
    
    
    mutating func removePSDObject( id: Int)  {
        let r = psdObjects.removeAll(where: {$0.id == id})
    }
    
    mutating func removePSDObject( imageUrl: URL)  {
        psdObjects.removeAll(where: {$0.imageURL == imageUrl})
    }
    
    mutating func AppendStringObjectsForOnePsd(psdId: Int, objs: [StringObject]){
        if psdObjects.contains(where: {$0.id == psdId}) == false{
            return
        }else{
            //Create temp obj
            var tmpObj = psdObjects.first(where: {$0.id == psdId})!
            tmpObj.stringObjects += objs
            //            //Remove Old one
            //            psdObjects.removeAll(where: {$0.id == tmpObj.id})
            //            //Append new one
            //            psdObjects.append(tmpObj)
            
            let _index = psdObjects.firstIndex(where: {$0.id == tmpObj.id})
            psdObjects.removeAll(where: {$0.id == tmpObj.id})
            psdObjects.insert(tmpObj, at: _index!)
        }
    }
    
    mutating func UpdateStringObjectsForOnePsd(psdId: Int, objs: [StringObject]){
        if psdObjects.contains(where: {$0.id == psdId}) == false{
            return
        }else{
            var tmpObj = psdObjects.first(where: {$0.id == psdId})!
            tmpObj.stringObjects.removeAll()
            tmpObj.stringObjects += objs
            let _index = psdObjects.firstIndex(where: {$0.id == tmpObj.id})
            psdObjects.removeAll(where: {$0.id == tmpObj.id})
            psdObjects.insert(tmpObj, at: _index!)
        }
    }
    
    mutating func LoadPsdJsonObject(jsonObject: JsonObject){
        var psdObjList: [PSDObject] = []
        for psdJ in jsonObject.PsdJsonObjectList{
            let targetImage = CIImage.init(contentsOf: psdJ.imageURL)
            var tmpPsd = PSDObject(id: psdJ.id, imageURL: psdJ.imageURL, thumbnail: NSImage.init(data: psdJ.thumbnail) ?? NSImage.init(), colorMode: MacColorMode.init(rawValue: psdJ.colorMode)!, dpi: psdJ.dpi, status: PsdStatus.init(rawValue: psdJ.status)!)
            for strJ in psdJ.stringObjects{
                var charImgList = [CIImage]()
                for rect in strJ.charRects{
                    let tmpImg: CIImage = targetImage?.cropped(to: rect) ?? CIImage.init()
                    charImgList.append(tmpImg)
                }
                let tmpStrObj = StringObject.init(id: strJ.id, content: strJ.content, tracking: strJ.tracking, fontSize: strJ.fontSize, colorMode: strJ.colorMode, fontWeight: strJ.fontWeight, charImageList: charImgList, stringRect: strJ.stringRect, color: strJ.color, bgColor: strJ.bgColor, charArray: strJ.charArray, charRacts: strJ.charRects, charSizeList: strJ.charSizeList, charFontWeightList: strJ.charFontWeightList, charColorModeList: strJ.charColorModeList, isPredictedList: strJ.isPredictedList, fontName: strJ.fontName, alignment: strJ.alignment, status: strJ.status)
                tmpPsd.stringObjects.append(tmpStrObj)
            }
            psdObjList.append(tmpPsd)
        }

        
        //Clean original
        psdObjects.removeAll()
        psdObjects = psdObjList
    }
    
}

extension PSDObject {
    func CalcColorMode() -> MacColorMode{
        //TODO:
        return .light
    }
    
    
}
