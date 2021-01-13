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

struct PSDObject: Identifiable{
    var id: Int
    var stringObjects: [StringObject] = []
    var imageURL: URL
    var thumbnail: NSImage = NSImage.init()
    var colorMode: MacColorMode = .light
    var dpi: Int = 0
    var commited: Bool = false

    
    fileprivate init(id: Int, imageURL: URL){
        self.id = id
        stringObjects = []
        //self.thumbnail = thumbnail
        //self.stringObjects = stringObjects
        self.imageURL = imageURL
        self.thumbnail = FetchThumbnail(size: sizeOfThumbnail)
        colorMode = PsdsUtil.shared.FetchColorMode(img: thumbnail.ToCIImage()!)
        commited = false
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
    
//    func FetchColorMode() -> MacColorMode{
//        let classifier = ColorModeClassifier(image: thumbnail.ToCIImage()!)
//        let result = classifier.output
//        if result == 1 {
//            return .light
//        }
//        else {
//            return .dark
//        }
//    }
//
//    func FetchDpi()
    
//    mutating func AppendStringObject(_ obj: StringObject) {
//        if stringObjects.contains(obj) == false{
//            stringObjects.append(obj)
//        }
//    }
    

    
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
            //Remove Old one
            psdObjects.removeAll(where: {$0.id == tmpObj.id})
            //Append new one
            psdObjects.append(tmpObj)
        }
    }
    
    mutating func UpdateStringObjectsForOnePsd(psdId: Int, objs: [StringObject]){
        if psdObjects.contains(where: {$0.id == psdId}) == false{
            return
        }else{
            var tmpObj = psdObjects.first(where: {$0.id == psdId})!
            tmpObj.stringObjects.removeAll()
            tmpObj.stringObjects += objs
            psdObjects.removeAll(where: {$0.id == tmpObj.id})
            psdObjects.append(tmpObj)
        }
    }

}

extension PSDObject {
    func CalcColorMode() -> Int{
        return 0
    }
    

}
