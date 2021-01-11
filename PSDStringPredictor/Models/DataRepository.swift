//
//  DataRepository.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 10/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation
import SwiftUI

class DataRepository {
    var psds = PSD()

    private var stringObjectListDict: [Int:[StringObject]] = [:]
    private var charFrameListDict: [Int:[CharFrame]] = [:]
    private var imageUrlDict: [Int: URL] = [:]
    private var updateStringObjectList: [Int:[UUID]] = [:]
    private var StringObjectNameDict: [UUID:String] = [:]
    private var DragOffsetDict: [UUID: CGSize] = [:]
    private var alignmentDict: [UUID:Int] = [:]
    private var stringObjectOutputList: [Int:[StringObject]] = [:]
    private var psdColorMode : [Int:Int] = [:]
    //private var thumbnailList: [Int: NSImage] = [:]
    //private var psdCommitedList: [Int: Bool] = [:]
    //private var psdObjectList: [PSDObject] = []
    
    private var targetImageProcessed = CIImage.init() //selected
    private var targetImageMasked = CIImage.init()//selected
    private var selectedNSImage = NSImage()//selected
    
    //Global
    private var selectedPsdId: Int = 0
    private var selectedStrIDList: [UUID] = []
    private var stringOverlay: Bool = true
    private var frameOverlay: Bool = true
    private var indicatorTitle: String = ""
    private var warningContent: String = ""
        
    //Constant
    static let fontDecentOffsetScale: CGFloat = 0.6
    static let fontLeadingTable = [[34,41], [28,41], [22,28], [20,25], [17,22], [16,21], [15,20], [13,18], [12,16], [11,13]]
    
    private init(){}
    
    static let shared = DataRepository()
    
    func AppendStringObjectListDict(psdId: Int, stringObject: StringObject){
        if stringObjectListDict[psdId] == nil {
            stringObjectListDict[psdId] = []
        }
        if stringObjectListDict[psdId]!.contains(where: {$0.id == stringObject.id}) == false{
            stringObjectListDict[psdId]!.append(stringObject)
        }
    }
    
    func GetStringObject(psdId: Int, objId: UUID)->StringObject?{
        if stringObjectListDict[psdId] == nil  {
            return nil
        }else{
            return stringObjectListDict[psdId]!.FindByID(objId)
        }
    }
    
    func GetStringObjectsForOnePsd(psdId: Int)->[StringObject]{
        if stringObjectListDict[psdId] == nil  {
            return []
        }else{
            return stringObjectListDict[psdId]!
        }
    }
    
    func GetSelectedStringObject()->StringObject?{
        if selectedStrIDList.count > 0 {
            return GetStringObject(psdId: selectedPsdId, objId: selectedStrIDList.last!)
        }else{
            return nil
        }
    }
    
    func RemoveStringObject(psdId: Int, objId: UUID) -> Bool{
        if (stringObjectListDict[psdId] == nil || stringObjectListDict[psdId]!.contains(where: {$0.id == objId}) == false){
            return false
        }
        else {
            stringObjectListDict[psdId]!.removeAll(where: {$0.id == objId})
            return true
        }
    }
    
    func GetSelectedPsdId()->Int {
        return selectedPsdId
    }
    
    func SetSelectedPsdId(newId: Int) {
          selectedPsdId = newId
    }
    
    func GetSelectedNSImage() -> NSImage{
        return selectedNSImage
    }
    
    func SetSelectedNSImage(image: NSImage) {
        selectedNSImage = image
    }
    
//    func GetThumbnailDict() -> [Int:NSImage]{
//        return thumbnailList
//    }
//
//
//    func GetPsdCommitedList() -> [Int: Bool]{
//        return psdCommitedList
//    }
    
    func GetPsdObjectList() -> [PSDObject]{
        return psds.PSDObjects
    }
    
}
