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
    case light = "􀆮"
    case dark = "􀆺"
}

enum StringObjectStatus {
    case fixed, ignored, normal
}

enum PsdStatus {
    case normal, processed, commited
}


struct PSDObject: Identifiable{
    var id: Int
    var stringObjects: [StringObject] = []
    var imageURL: URL
    var thumbnail: NSImage = NSImage.init()
    var colorMode: MacColorMode = .light
    var dpi: Int = 0
    var status: PsdStatus = .normal
    
    
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
            //            psdObjects.removeAll(where: {$0.id == tmpObj.id})
            //            psdObjects.append(tmpObj)
            let _index = psdObjects.firstIndex(where: {$0.id == tmpObj.id})
            psdObjects.removeAll(where: {$0.id == tmpObj.id})
            psdObjects.insert(tmpObj, at: _index!)
        }
    }
    
}

extension PSDObject {
    func CalcColorMode() -> MacColorMode{
        //TODO:
        return .light
    }
    
    
}
