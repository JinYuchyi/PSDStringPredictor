//
//  DataRepository.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 10/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation
import SwiftUI

class PsdsUtil  {
    let ocr = OCR()
    //var psds: PSD
    let imageUtil = ImageUtil()

    private var stringObjectListDict: [Int:[StringObject]] = [:]
    private var charFrameListDict: [Int:[CharFrame]] = [:]
    private var imageUrlDict: [Int: URL] = [:]
    private var updateStringObjectList: [Int:[UUID]] = [:]
    private var StringObjectNameDict: [UUID:String] = [:]
    private var DragOffsetDict: [UUID: CGSize] = [:]
    private var alignmentDict: [UUID:Int] = [:]
    private var stringObjectOutputList: [Int:[StringObject]] = [:]
    private var psdColorMode : [Int:Int] = [:]
    private var blockMaskListDict: [Int: [CGRect]] = [:] //Required
    //private var thumbnailList: [Int: NSImage] = [:]
    //private var psdCommitedList: [Int: Bool] = [:]
    //private var psdObjectList: [PSDObject] = []
    
    private var targetImageProcessed = CIImage.init() //selected
    private var targetImageMasked = CIImage.init()//selected
    private var selectedNSImage = NSImage()//selected
    private var colorModeDict: [Int: Int] = [:]
    private var gammaDict: [Int: CGFloat] = [:]
    private var expDict: [Int: CGFloat] = [:]
    
    //Global
    private var selectedPsdId: Int = 0
    private var selectedStrIDList: [UUID] = []
    private var stringOverlay: Bool = true
    private var frameOverlay: Bool = true
    //private var indicatorTitle: String = ""
    //private var warningContent: String = ""
        
    //Constant
    static let fontDecentOffsetScale: CGFloat = 0.6
    static let fontLeadingTable = [[34,41], [28,41], [22,28], [20,25], [17,22], [16,21], [15,20], [13,18], [12,16], [11,13]]
    
    private init(){}
    
    static let shared = PsdsUtil()

    func AppendStringObjectListDict(psdId: Int, stringObject: StringObject){
        if stringObjectListDict[psdId] == nil {
            stringObjectListDict[psdId] = []
        }
        if stringObjectListDict[psdId]!.contains(where: {$0.id == stringObject.id}) == false{
            stringObjectListDict[psdId]!.append(stringObject)
        }
    }
    
    func SetStringObjectsForOnePsd(psdId: Int, objs: [StringObject]) {
        stringObjectListDict[psdId] = objs
    }

    func UpdateBlockMaskListDict(tappedRect: CGRect, psdId: Int){
        if blockMaskListDict[psdId] == nil{
            blockMaskListDict[psdId] = []
        }
        let contain = blockMaskListDict[psdId]!.contains(tappedRect)
        if contain == false {
            blockMaskListDict[psdId]!.append(tappedRect)

        }else{
            //Delete rect in list
            blockMaskListDict[psdId]!.removeAll(where: {$0 == tappedRect})
        }
        
        //UpdateProcessedImage(psdId: psdId)

    }
    
    func GetBlockMaskListDict() -> [Int: [CGRect]]{
        return blockMaskListDict
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
    
//    func UpdateProcessedImage(psdId: Int){
//        let _targetImageMasked = imageUtil.ApplyBlockMasks(target: selectedNSImage.ToCIImage()!, psdId: psdId)
//        targetImageProcessed = imageUtil.ApplyFilters(target: _targetImageMasked, gamma: gammaDict[psdId] ?? 1, exp: expDict[psdId] ?? 0)
//    }
//
    func GetSelectedNSImage() -> NSImage{
        return selectedNSImage
    }
    
//    func GetProcessedImage(psdId: Int) -> CIImage{
//        UpdateProcessedImage(psdId: psdId)
//        return targetImageProcessed
//    }
    
    func SetSelectedNSImage(image: NSImage) {
        selectedNSImage = image
        targetImageMasked = selectedNSImage.ToCIImage() ?? CIImage.init()
        targetImageProcessed = selectedNSImage.ToCIImage() ?? CIImage.init()
        //targetImageMasked = selectedNSImage.ToCIImage()
    }

    func FetchColorMode(img: CIImage) -> MacColorMode{
        let classifier = ColorModeClassifier(image: img)
        let result = classifier.output
        if result == 1 {
            return .light
        }
        else {
            return .dark
        }
    }
    
//    func GetPsdObjectList() -> [PSDObject]{
//        return psds.psdObjects
//    }
    
//    func GetPsdObject(psdId: Int) -> PSDObject?{
//        if psds.psdObjects.contains(where: {$0.id == psdId}) == false{
//            return nil
//        }else{
//            return psds.psdObjects.first(where: {$0.id == psdId})
//        }
//    }
    
//    func AppendPsdObjectList(url: URL) {
//        psds.addPSDObject(imageURL: url)
//    }
    
//    func GetDPIForOne(psdId: Int)->Int{
////        let obj = GetPsdObject(psdId: selectedPsdId)
////        print(obj!.imageURL.path)
////        guard let dpi = ImageUtil.GetImageProperty(keyName: "DPIWidth" , path: (obj!.imageURL.path)) else {
////            return 0
////        }
////        print("DPI:\(dpi)")
////        return dpi
//        return 1
//    }
    

    
    
    
    func SetGamma(psdId: Int, value: CGFloat){
        gammaDict[psdId] = value
    }
    
    func GetGamma(psdId: Int) -> CGFloat{
        if gammaDict[psdId] != nil {
            return gammaDict[psdId]!
        }else {
            return 1.0
        }
    }
    
    func SetExp(psdId: Int, value: CGFloat){
        expDict[psdId] = value
    }
    
    func GetExp(psdId: Int) -> CGFloat{
        if expDict[psdId] != nil {
            return expDict[psdId]!
        }else {
            return 1.0
        }
    }
    
//    func SetIndicator(title: String){
//        DataRepository.shared.SetIndicator(title: title)
//    }
    
    
    

    
}
