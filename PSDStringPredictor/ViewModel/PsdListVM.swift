//
//  ThumbnailListVM.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 10/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation
import SwiftUI
import Vision


struct charRectObject: Codable{
    var rect: CGRect
    var color: [CGFloat]
}

struct StringObjectForStringProperty{
    var content: String
    var posX: String
    var posY: String
    var fontSize: String
    var tracking: String
    var fontName: String
    var color: CGColor
    var alignment: StringAlignment
    var width: CGFloat
    var height: CGFloat
    
    init() {
        self.content = ""
        self.fontSize = ""
        self.tracking = ""
        self.fontName = ""
        self.color = CGColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        self.alignment = defaultAlignment
        self.posX = ""
        self.posY = ""
        self.width = 0
        self.height = 0
    }
    
    init(content: String, fontSize: String, tracking: String, fontName: String, color: CGColor, stringRect: CGRect, alignment: StringAlignment, posX: CGFloat, posY: CGFloat, width: CGFloat, height: CGFloat) {
        self.content = content
        self.fontSize = fontSize
        self.tracking = tracking
        self.fontName = fontName
        self.color = color
        self.alignment = alignment
        self.posX = posX.toString()
        self.posY = posY.toString()
        self.width = width
        self.height = height
    }
    
}


class PsdsVM: ObservableObject{
    
    let ocr = OCR.shared
    
    
    //refacting
    @Published var stringObjectDict: [UUID: StringObject] = [:]
    @Published var psdStrDict: [Int: [UUID]] = [:]
    @Published var psdObjectDict: [Int: PSDObject] = [:]
    
    
    @Published var psdModel: PSD
    @Published var selectedPsdId: Int  //refacting
    @Published var gammaDict: [Int:CGFloat]//refacting
    @Published var expDict: [Int:CGFloat]//refacting
    @Published var DragOffsetDict: [UUID: CGSize] 
    
    //Selected elements
    @Published var selectedNSImage: NSImage //refacting
    @Published var maskedImage: CIImage
    @Published var processedCIImage: CIImage //refacting
    @Published var selectedStrIDList: [UUID]//refacting
    
    //Others
    @Published var IndicatorText: String = ""
    @Published var canProcess: Bool = false
    @Published var prograssScale: CGFloat = 0
    @Published var maskDict: [Int:[charRectObject]]  = [:]
    @Published var stringIsOn: Bool = true
    @Published var tmpObjectForStringProperty: StringObjectForStringProperty = StringObjectForStringProperty.init()
    @Published var viewScale: CGFloat = 1.0
    //    @Published var PSPath: String = ""
    //    @Published var selectRect: CGRect = zeroRect
    
    // UI control
    @Published var linkSizeAndTracking: Bool = true
    @Published var charDSWindowShow: Bool = false
    @Published var stringDifferenceShow: Bool = false
    
    
    //Save Char DS
    @Published var charImageDSWillBeSaved: CIImage
    
    //    @Published var tmpTracking: CGFloat = 0
    
    //For Template stringobject variable
    //The reason for extract these as individial variables is for speed issue
    //No bgColorDict, charArrayDict, contentDict, charSizeList, charImageList, charFontWeightList, isPredictedList, charColorModeList, FontName, colorPixel, because we do not need to adjust them frequently
    //    @Published var tmpStringObjectList: [StringObject] = []
    //    @Published var tmpStrIDList: [UUID] = []
    //    @Published var trackingDict: [UUID: CGFloat] = [:]
    //    @Published var fontSizeDict: [UUID: CGFloat] = [:]
    //    @Published var fontWeightDict: [UUID: String] = [:]
    //    @Published var stringRectDict: [UUID: CGRect] = [:]
    //    @Published var colorDict: [UUID: CGColor] = [:]
    //    @Published var charRectsDict: [UUID: [CGRect]] = [:]
    //    @Published var colorModeDict: [UUID: MacColorMode] = [:]
    //    @Published var alignmentDict: [UUID: StringAlignment] = [:]
    //    @Published var statusDict: [UUID: StringObjectStatus] = [:]
    //    @Published var isParagraphDict: [UUID: Bool] = [:]
    
    let imageUtil = ImageUtil.shared
    //    let pixProcess = PixelProcess()
    let jsMgr = JSManager.shared
    //    @Published var thumbnailDict: [Int:NSImage] = [:]
    //    @Published var commitedList: [Int:Bool] = [:]
    //    @Published var pathList: [Int:String] = [:]
    //@Published var psdObjectList: [PSDObject] = []
    
    init(){
        psdModel = PSD()
        selectedPsdId = 0
        selectedNSImage = NSImage.init()
        processedCIImage = DataStore.zeroCIImage
        gammaDict = [:]
        expDict = [:]
        selectedStrIDList = []
        DragOffsetDict = [:]
        maskedImage = DataStore.zeroCIImage
        charImageDSWillBeSaved = DataStore.zeroCIImage
        
        
    }
    
    //    func Refresh(){
    //        FetchPsdObjectList()
    //    }
    //
    //    func FetchPsdObjectList(){
    //        psdObjectList = DataRepository.shared.GetPsdObjectList()
    //    }
    //
    
    func addPsdObject(imageURL: URL) -> Int {
        var id = (psdObjectDict.keys.max() ?? -1)
        id = (id + 1) % Int.max
        let newPsd = PSDObject(id: id, imageURL: imageURL)
        psdObjectDict[id] = newPsd
        return id
        //        uniqID = (uniqID + 1) % Int.max
    }
    
    func fetchStringObject(strId: UUID) -> StringObject {
        guard let obj = stringObjectDict[strId] else {return zeroStringObject}
        return obj
    }
    
    func fetchPsd(psdId: Int) -> PSDObject {
        guard let obj = psdObjectDict[psdId] else {return zeroPsdObject}
        return obj
    }
    
    func fetchLastStringObjectFromSelectedPsd() -> StringObject {
        guard let id = selectedStrIDList.last else {return zeroStringObject}
        guard let obj = stringObjectDict[id] else {return zeroStringObject}
        return obj
    }
    
//    func fetchLastStrIdFromSelectedPsd() ->UUID {
////        guard let idList = psdStrDict[selectedPsdId] else {return zeroUUID}
////        return idList.last!
//    }
    
//    func fetchStringObjectsFromSelectedPSD() -> [StringObject] {
//        guard let ids = psdStrDict[selectedPsdId] else {return [zeroStringObject]}
//        for id in ids {
//
//        }
//    }
    
    
    func InitDictForOnePsd(psdId: Int){
        gammaDict[psdId] = 1
        expDict[psdId] = 0
        processedCIImage = selectedNSImage.ToCIImage() ?? DataStore.zeroCIImage
    }
    
    func fetchSelectedPsd() -> PSDObject{
        //        return psdModel.psdObjects.first(where: {$0.id == selectedPsdId})
        guard let psd = psdObjectDict[selectedPsdId] else {return zeroPsdObject}
        return psd
    }
    
    //    func GetStringObjectForOnePsd(psdId: Int, objId: UUID) -> StringObject?{
    //        guard let _psd = psdModel.psdObjects.first(where: {$0.id == psdId}) else {
    //            return nil
    //        }
    //        guard let _obj = _psd.stringObjects.first(where: {$0.id == objId}) else {
    //            return nil
    //        }
    //        return _obj
    //    }
    
    func FetchTrackingData(path: String){
        TrackingDataManager.Delete(viewContext)
        let objArray = CSVManager.shared.ParsingCsvFileAsTrackingObjectArray(FilePath: path)
        TrackingDataManager.BatchInsert(viewContext, trackingObjectList: objArray)
    }
    
    func FetchStandardTable(path: String){
        OSStandardManager.DeleteAll(viewContext)
        let objArray = CSVManager.shared.ParsingCsvFileAsFontStandardArray(FilePath: path)
        OSStandardManager.BatchInsert(viewContext, FontStandardObjectList: objArray)
    }
    
    func FetchCharacterTable(path: String){
        CharDataManager.Delete(viewContext)
        let objArray = CSVManager.shared.ParsingCsvFileAsCharObjArray(FilePath: path)
        CharDataManager.BatchInsert(viewContext, CharObjectList: objArray)
    }
    
    func FetchBoundTable(path:String){
        CharBoundsDataManager.Delete(viewContext)
        let objArray = CSVManager.shared.ParsingCsvFileAsBoundsObjArray(FilePath: path)
        CharBoundsDataManager.BatchInsert(viewContext, CharBoundsList: objArray)
    }
    
    func UpdateProcessedImage(psdId: Int)->CIImage?{
        if selectedNSImage.size.width == 0 || selectedNSImage == nil {
            return nil
        }
        let _targetImageMasked = imageUtil.ApplyBlockMasks(target: selectedNSImage.ToCIImage()!, psdId: psdId, rectDict: maskDict)
        DispatchQueue.main.async{
            self.processedCIImage = self.imageUtil.ApplyFilters(target: _targetImageMasked, gamma: self.gammaDict[psdId] ?? 1, exp: self.expDict[psdId] ?? 0)
        }
        return processedCIImage
    }
    
    func calcStringPositionOnImage(psdId: Int, objId: UUID) -> [CGFloat] {
        //        var pos: [CGFloat] = []
        //        guard let tmpPsd = psdModel.GetPSDObject(psdId: psdId) else {return [0,0]}
        //        guard let tmpObj = GetStringObjectForOnePsd(psdId: psdId, objId: objId) else {return [0,0]}
        let obj = fetchStringObject(strId: objId)
        let x: CGFloat = obj.stringRect.minX + obj.stringRect.width / 2 + obj.tracking / 2 - FontUtils.GetCharFrontOffset(content: obj.content, fontSize: obj.fontSize)
        let y: CGFloat =  fetchSelectedPsd().height  - (fetchStringObject(strId: objId).stringRect.minY + fetchStringObject(strId: objId).stringRect.height / 2)
         return [x,y]
    }
    
    func FetchStringObjects(psdId: Int){
        var result: [StringObject] = []
        
        guard let tmpImageUrl = psdObjectDict[psdId]?.imageURL else {return}
        
        var img = LoadNSImage(imageUrlPath: tmpImageUrl.path).ToCIImage()!
        img = imageUtil.ApplyBlockMasks(target: img, psdId: psdId, rectDict: maskDict)
        img = imageUtil.ApplyFilters(target: img, gamma: gammaDict[psdId] ?? 1, exp: expDict[psdId] ?? 0)
        let allStrObjs = CreateAllStringObjects(rawImg: img, psdId: psdId, psdsVM: self)
//        DispatchQueue.main.async{ [self] in
//            let tmpList = Array(stringObjectDict.values.filter({$0.status != .normal}))
//            //            var tmpList = self.psdModel.GetPSDObject(psdId: psdId)!.stringObjects.filter({$0.status != .normal}) //Filter all fixed objects
//            for obj in allStrObjs {
//                if tmpList.ContainsSame(obj) == false {
//                    result.append(obj)
//
//                }else{
//                }
//            }
//            result += tmpList
//            psdModel.UpdateStringObjectsForOnePsd(psdId: psdId, objs: result)
//
//            IndicatorText = ""
//        }
        updateStringObjectsForPsd(psdId: psdId, strObjs: allStrObjs)
        
        
    }
    
    func updateStringObjectsForPsd(psdId: Int, strObjs: [StringObject]){
//        let idList = strObjs.map({$0.id})
        let formerList = psdStrDict[psdId]
        if formerList != nil && formerList!.count > 0 {
            //Remove all
            for id in formerList! {
                stringObjectDict[id] = nil
            }
        }
        // Fill in new obj list and psdstrDict
        psdStrDict[psdId] = nil
        for obj in strObjs{
            stringObjectDict[obj.id] = obj // Assign stringobject in dict
            psdStrDict[psdId] == nil ? psdStrDict[psdId] = [obj.id] : psdStrDict[psdId]?.append(obj.id)
        }
    }

    
    func fetchRegionStringObjects(rect: CGRect, psdId: Int) -> [UUID]{
        let regionImage = processedCIImage.cropped(to: rect).premultiplyingAlpha()
        var offset = CGPoint.init(x: rect.minX, y: rect.minY)
        // Get strobj id list for selected psd
        var preIdList = psdStrDict[selectedPsdId] ?? []
//        var img = imageUtil.ApplyBlockMasks(target: regionImage, psdId: psdId, rectDict: maskDict)
        var img = imageUtil.ApplyFilters(target: regionImage, gamma: gammaDict[psdId] ?? 1, exp: expDict[psdId] ?? 0)
        let newList = CreateAllStringObjects(rawImg: img, psdId: psdId, psdsVM: self, offset: offset)
        var result = newList
        if newList.count == 0{
            print("No strings detected in the area.")
            return []
        }
        DispatchQueue.main.async{ [self] in
            //if region already have string object exist, just remove the old ones.
            if preIdList.count > 0 {
                for newObj in newList{
                    for preOneId in preIdList{
                        if fetchStringObject(strId: preOneId).stringRect.intersects(newObj.stringRect) == true{
//                            result.removeAll(where: {$0.id == newObj.id})
                            stringObjectDict[preOneId] = nil
                            psdStrDict[selectedPsdId]?.removeAll(where: {$0 == preOneId})
                        }
                    }
                }
            }
            for obj in result {
                stringObjectDict[obj.id] = obj
                (psdStrDict[selectedPsdId] == nil) ? (psdStrDict[selectedPsdId] = [obj.id]) : (psdStrDict[selectedPsdId]!.append(obj.id))
            }
            IndicatorText = ""
        }
        return newList.map({$0.id})
    }
    
    func FetchBGColor(psdId: Int, obj: StringObject) -> [Float]{
        let pad: CGFloat = 3
        let targetImg = LoadNSImage(imageUrlPath: fetchPsd(psdId: psdId).imageURL.path)
        let color1 = PixelProcess.shared.colorAt(x: Int(obj.stringRect.origin.x - pad), y: Int(targetImg.size.height - obj.stringRect.origin.y - pad), img: targetImg.ToCGImage()!)
        
        return [Float(color1.redComponent * 255), Float(color1.greenComponent * 255), Float(color1.blueComponent * 255)]
    }
    
    
    func setPsdToCommit(psdId: Int){
//        guard var psd = psdObjectDict[psdId] else {return}
        psdObjectDict[psdId]!.status = .commited
    }
    
//    func ScanAndBreakFarAwayStringObject(psdId: Int){
//        var breakIndexList : [Int] = []
//        if psdStrDict[psdId] == nil {return}
//        for id in psdStrDict[psdId]! {
//            for i in 0..<stringObjectDict[id]!.charRects.count {
//                if stringObjectDict[id]!.charArray[i] == " " && i != 0 && i != stringObjectDict[id]!.charRects.count - 1 {
//                    let dist = stringObjectDict[id]!.charRects[i+1].minX - stringObjectDict[id]!.charRects[i-1].maxX
//                    if dist > stringObjectDict[id]!.charRects[i+1].width * 1.1 {
//                        //Found a gap!
//                        breakIndexList.append(i)
//                    }
//                }
//            }
//        }
//    }
    
    func CreateAllStringObjects(rawImg: CIImage, psdId: Int, psdsVM: PsdsVM, offset: CGPoint = CGPoint.init(x: 0, y: 0 )) -> [StringObject]{
        var strobjs : [StringObject] = []
        let requestHandler = VNImageRequestHandler(ciImage: rawImg, options: [:])
        let TextRecognitionRequest = VNRecognizeTextRequest()
        TextRecognitionRequest.recognitionLevel = VNRequestTextRecognitionLevel.accurate
        TextRecognitionRequest.usesLanguageCorrection = true
        TextRecognitionRequest.recognitionLanguages = ["en_US"]
        
        DispatchQueue.main.async{
            psdsVM.prograssScale = 0
        }
        
        TextRecognitionRequest.recognitionLevel = VNRequestTextRecognitionLevel.fast
        do {
            try requestHandler.perform([TextRecognitionRequest])
        } catch {
            print(error)
        }
        
        guard let results_fast = TextRecognitionRequest.results as? [VNRecognizedTextObservation] else {return ([])}
        let stringsRects = ocr.GetRectsFromObservations(results_fast, Int(rawImg.extent.width.rounded()), Int(rawImg.extent.height.rounded()))
        let strs = ocr.GetStringArrayFromObservations(results_fast)
        
        for i in 0..<stringsRects.count where canProcess == true{
            
            DispatchQueue.main.async{
                psdsVM.prograssScale += 1/CGFloat(stringsRects.count)
                psdsVM.IndicatorText = "Processing Image ID: \(psdId), \(i+1) / \(stringsRects.count) strings"
            }
            let (charRects, chars) = ocr.GetCharsInfoFromObservation(results_fast[i], Int((rawImg.extent.width).rounded()), Int((rawImg.extent.height).rounded()))
            let charImageList = CIImage.init(contentsOf: psdObjectDict[psdId]!.imageURL)!.GetCroppedImages(rects: charRects.offset(offset: offset) )
            
            var newStrObj = StringObject.init(strs[i], stringsRects[i].offset(offset: offset) , chars, charRects.offset(offset: offset), charImageList: charImageList)

            newStrObj = ocr.DeleteFontOffset(obj: newStrObj)
            let sepObjList = newStrObj.seprateIfPossible()
            if sepObjList != nil {
                for obj in sepObjList!{
                    strobjs.append(obj)
                }
            }else {
                strobjs.append(newStrObj)
            }
        }
        
        //The reason for putting the clear indicator code here, is because I want the indicator invisible after the last process finished.
        if canProcess == false {
            DispatchQueue.main.async{
                psdsVM.IndicatorText = ""
            }
        }
        
        return strobjs
    }
    
    func CalcTrackingAfterDrag(objId: UUID, originalTracking: CGFloat) -> CGFloat {
        // var offset : CGSize = .zero
        var d : CGFloat = 0
        if DragOffsetDict[objId] != nil{
            d = DragOffsetDict[objId]!.width
            let newTracking = (originalTracking ?? 0) + d
            return newTracking
        }else{
            return 0
        }
    }
    
    func CalcSizeAfterDrag(objId: UUID, originalFontSize: CGFloat) -> CGFloat {
        var d : CGFloat = 0
        if DragOffsetDict[objId] != nil{
            d = DragOffsetDict[objId]!.height
            let newSize = originalFontSize - d
            return newSize
        }else{
            return 0
        }
    }
    
    func commitTempStringObject(){
//        guard let lastId = selectedStrIDList.last else {return }
//        guard let obj = psdModel.GetPSDObject(psdId: selectedPsdId)?.GetStringObjectFromOnePsd(objId: lastId) else {return }
        if tmpObjectForStringProperty.content.count != fetchLastStringObjectFromSelectedPsd().content.count {
            let newBound = FontUtils.GetStringBound(str: tmpObjectForStringProperty.content, fontName: tmpObjectForStringProperty.fontName, fontSize: tmpObjectForStringProperty.fontSize.toCGFloat(), tracking: tmpObjectForStringProperty.tracking.toCGFloat())
            tmpObjectForStringProperty.posX = (tmpObjectForStringProperty.posX.toCGFloat() + newBound.minX).toString()
            tmpObjectForStringProperty.width = newBound.width
        }
        else{
//            psdModel.SetLastStringObject(psdId: selectedPsdId, objId: selectedStrIDList.last!, value: tmpObjectForStringProperty.toStringObject(strObj: fetchLastStringObjectFromSelectedPsd()))
        }
        stringObjectDict[selectedStrIDList.last!] = tmpObjectForStringProperty.toStringObject(strObj: fetchLastStringObjectFromSelectedPsd())

    }
    
    func commitFontSize() {
//        for id in selectedStrIDList {
//            psdModel.SetFontSize(psdId: selectedPsdId, objId: id, value: tmpObjectForStringProperty.fontSize.toCGFloat())
//            if linkSizeAndTracking == true {
//                let newT: CGFloat = CGFloat(TrackingDataManager.FetchNearestOne(viewContext, fontSize: Int16(tmpObjectForStringProperty.fontSize.toCGFloat().rounded())).fontTrackingPoints)
//                tmpObjectForStringProperty.tracking =  newT.toString()
//                psdModel.SetTracking(psdId: selectedPsdId, objId: id, value: newT)
//            }
//        }
        for id in selectedStrIDList {
            stringObjectDict[id]!.fontSize = tmpObjectForStringProperty.fontSize.toCGFloat()
            if linkSizeAndTracking == true {
                let newT: CGFloat = CGFloat(TrackingDataManager.FetchNearestOne(viewContext, fontSize: Int16(tmpObjectForStringProperty.fontSize.toCGFloat().rounded())).fontTrackingPoints)
                tmpObjectForStringProperty.tracking =  newT.toString()
                stringObjectDict[id]!.tracking = newT
            }
        }

    }
    
    func commitFontTracking() {
        for id in selectedStrIDList {
            stringObjectDict[id]!.tracking = tmpObjectForStringProperty.tracking.toCGFloat()
        }
    }
    
    func commitPosX() {
        for id in selectedStrIDList {
            let newRect = CGRect.init(x: tmpObjectForStringProperty.posX.toCGFloat(), y: stringObjectDict[id]!.stringRect.minY, width: stringObjectDict[id]!.stringRect.width, height: stringObjectDict[id]!.stringRect.height)
            stringObjectDict[id]!.stringRect = newRect
        }
    }
    
    func commitPosY() {
        for id in selectedStrIDList {
            let newRect = CGRect.init(x: stringObjectDict[id]!.stringRect.minX, y: tmpObjectForStringProperty.posY.toCGFloat(), width: stringObjectDict[id]!.stringRect.width, height: stringObjectDict[id]!.stringRect.height)
            stringObjectDict[id]!.stringRect = newRect
        }
    }
    
    func commitRect(){
        for id in selectedStrIDList {
            let nRect = CGRect.init(x: tmpObjectForStringProperty.posX.toCGFloat(), y: tmpObjectForStringProperty.posY.toCGFloat(), width: tmpObjectForStringProperty.width, height: tmpObjectForStringProperty.height)
            stringObjectDict[id]!.stringRect = nRect
        }
    }
    
    func deleteSelectedStringObjects(){
//        if selectedStrIDList.count == 0 || fetchSelectedPsd() == nil {return }
//        let idList = selectedStrIDList
//        selectedStrIDList = []
//        var tmpResult = GetSelectedPsd()!.stringObjects
//        for id in idList {
//            tmpResult.removeAll(where: {$0.id == id})
//        }
//        psdModel.SetStringObjects(psdId: selectedPsdId, value: tmpResult)
        if selectedStrIDList.count == 0 || psdObjectDict[selectedPsdId] == nil {return }
        let idList = selectedStrIDList
        selectedStrIDList.removeAll()
        
        for id in idList {
            psdStrDict[selectedPsdId]! = psdStrDict[selectedPsdId]!.filter({$0 != id}) // Clean up in psdstrdict
            stringObjectDict[id] = nil // Clean up in strdict
         }
        
        tmpObjectForStringProperty = StringObjectForStringProperty.init()
    }
    
    private func createJS(idList: [Int], savePSDToPathList: [String] ){
        var finalStr : String = ""
        var index: Int = 0
        for (psdId) in idList{
//            guard let obj = psdModel.GetPSDObject(psdId: _id) else {return}
            let psdPath = psdObjectDict[psdId]!.imageURL.path
            var contentList = [String]()
            var colorList = [[Int]]()
            var fontSizeList:[Float] = []
            var fontNameList: [String] = []
            var positionList = [[Float]]()
            var trackingList = [Float]()
            var offsetList = [[Int16]]()
            var alignmentList = [String]()
            var rectList = [[Float]]()
            var bgClolorList = [[Float]]()
            var isParagraphList = [Bool]()
            var descentOffset : [Float] =  []
            var updateList = psdStrDict[psdId]!
            var saveToPath = savePSDToPathList
            var frontSpaceList: [Float] = []
            
            for objId in updateList{
                var newString = stringObjectDict[objId]!.content.replacingOccurrences(of: "\n", with: " ")
                if newString.isEmpty || newString == nil {
                    newString = "_"
                }
                contentList.append(newString)
                var tmpColor: [Int] = []
                
                tmpColor = [ Int((Float(stringObjectDict[objId]!.color.components![0]) * 255).rounded()),
                             Int((Float(stringObjectDict[objId]!.color.components![1]) * 255).rounded()),
                             Int((Float(stringObjectDict[objId]!.color.components![2]) * 255).rounded())
                ]
                colorList.append(tmpColor)
                
                isParagraphList.append(stringObjectDict[objId]!.isParagraph)
                
                
                let tmpSize: CGFloat = CGFloat(stringObjectDict[objId]!.fontSize)
                fontSizeList.append(Float(tmpSize))
                //let tmpTracking = obj.fontSize * 1000 / obj.tracking
                let tmpTracking = Float((stringObjectDict[objId]!.tracking) * 1000 / (tmpSize == 0 ? 1 : tmpSize))
                trackingList.append(tmpTracking)
                
                //Calc the offset of String
                var keyvalues: [String: AnyObject] = [:]
                let char = (stringObjectDict[objId]!.content.first)
                keyvalues["char"] = String(char!) as AnyObject
                keyvalues["fontSize"] = Int(stringObjectDict[objId]!.fontSize.rounded()) as AnyObject
                
                let targetImg = LoadNSImage(imageUrlPath: psdObjectDict[psdId]!.imageURL.path)
                if (stringObjectDict[objId]!.content == "Do Not Disturb") {
                    print(stringObjectDict[objId]!.fontName + ", " + stringObjectDict[objId]!.fontWeight)
                }
                fontNameList.append(stringObjectDict[objId]!.CalcFontPostScriptName())
                print(stringObjectDict[objId]!.CalcFontPostScriptName())
                //Calc Descent
                let tmpDesc = Float(FontUtils.calcFontTailLength(content: stringObjectDict[objId]!.content, size: stringObjectDict[objId]!.fontSize))
                
                descentOffset.append(tmpDesc)
                let newRect = FontUtils.GetStringBound(str: stringObjectDict[objId]!.content, fontName: stringObjectDict[objId]!.fontName, fontSize: stringObjectDict[objId]!.fontSize, tracking: stringObjectDict[objId]!.tracking)
                
                let offset = [Int16(newRect.minX), 0]
                offsetList.append(offset)
                
                //alignment
                if stringObjectDict[objId]!.alignment == nil {
                    alignmentList.append("center")
                }else {
                    alignmentList.append(stringObjectDict[objId]!.alignment.rawValue)
                }
                
                //Front space
                let frontSpaceWidth = FontUtils.getFrontSpace(content: stringObjectDict[objId]!.content, fontSize: stringObjectDict[objId]!.fontSize)
                frontSpaceList.append(Float(frontSpaceWidth))
                
                // Re-Calc the string box
                if stringObjectDict[objId]!.alignment == .center {
                    rectList.append([Float(newRect.minX), Float(newRect.minY), Float(newRect.width), Float(newRect.height)])
                    // Append Position
                    //                let newX =  Float(obj.stringRect.minX + newRect.minX )
                    let newX =  Float(stringObjectDict[objId]!.stringRect.minX )
                    let newY =  Float(targetImg.size.height - stringObjectDict[objId]!.stringRect.minY )
                    //                print("\(obj.stringRect.midX), \(newRect.minX), \(frontSpace)")
                    positionList.append([newX, newY])
                    
                }else if stringObjectDict[objId]!.alignment == .left {
                    rectList.append([Float(newRect.minX), Float(newRect.minY), Float(newRect.width), Float(newRect.height)])
                    // Append Position
                    //                let newX = Int(obj.stringRect.minX + newRect.minX - frontSpace)
                    let newX = Float(stringObjectDict[objId]!.stringRect.minX )
                    
                    let newY =  Float((targetImg.size.height - stringObjectDict[objId]!.stringRect.minY ) )
                    positionList.append([newX, newY])
                    
                    
                }else if stringObjectDict[objId]!.alignment == .right {
                    rectList.append([Float(newRect.minX), Float(newRect.minY), Float(stringObjectDict[objId]!.stringRect.width), Float(newRect.height)])
                    // Append Position
                    let newX = Float(stringObjectDict[objId]!.stringRect.minX + newRect.minX )
                    let newY = Float((targetImg.size.height - stringObjectDict[objId]!.stringRect.minY ))
                    positionList.append([newX, newY])
                    
                }
                
                //BGColor
                let tmpBGColor = FetchBGColor(psdId: psdId, obj: stringObjectDict[objId]!)
                bgClolorList.append(tmpBGColor)
            }
            
            // Create js file
            let jsStr = jsMgr.CreateJSString( psdPath: psdPath, contentList: contentList, colorList: colorList, fontSizeList: fontSizeList, trackingList: trackingList, fontNameList: fontNameList, positionList: positionList, offsetList: offsetList, alignmentList: alignmentList, rectList: rectList, bgColorList: bgClolorList, isParagraphList: isParagraphList, saveToPath: savePSDToPathList[index] , descentOffset: descentOffset, frontSpace: frontSpaceList)
            
            finalStr.append(jsStr)
            
            index += 1
        }
        
        // Create JS file from JS string
        do {
            let path = Bundle.main.resourcePath! + "/StringCreator.jsx"
            print("Creating js: \(path)")
            let url = URL.init(fileURLWithPath: path)
            try finalStr.write(to: url, atomically: false, encoding: .utf8)
        }
        catch {
            return
        }
        
    }
    
    func runJS(){
        
        let jsPath = Bundle.main.path(forResource: "StringCreator", ofType: "jsx")!
        
        let cmd = "open " + jsPath + "  -a '\(DataStore.PSPath)'"
        print("cmd: \(cmd)")
        PythonScriptManager.RunScript(str: cmd)
    }
    
    //    func FetchTrackingFromDB(_ size: CGFloat) -> (CGFloat, Int16){
    //        let item = TrackingDataManager.FetchNearestOne(viewContext, fontSize: Int16(size.rounded()))
    //        return (CGFloat(item.fontTrackingPoints), item.fontTracking)
    //    }
    
    
    //MARK: Intents
    
    func saveCharDS(img: CIImage, str: String){
        saveCharDataset(img: img, str: str)
        charDSWindowShow = false
    }
    
    func CombineStringsOnePSD(psdId: Int){
//        if selectedStrIDList.count == 0 {return }
//
//        var orderedYList: [UUID:CGFloat] = [:]
//        var content: String = ""
//        var rect: CGRect = zeroRect
//        var color: CGColor = CGColor.white
//        var fontSize: CGFloat = 0
//        var fontTracking: CGFloat = 0
//        var resultObj: StringObject = StringObject()
//
//        if selectedStrIDList.count > 0{
//            //If have selection, we get the first object's information as the paragraph infomation
//            let strObj = stringObjectDict[selectedStrIDList.first!]!
//            rect = strObj.stringRect
//            color = strObj.color
//            fontSize = strObj.fontSize
//            fontTracking = strObj.tracking
//            resultObj = strObj
//        }
//
//        //Calc and sort each object's Y position, for gettomg the order of string
//        for id in selectedStrIDList{
//            let obj = stringObjectDict[id]!
//            rect = rect.union(obj.stringRect)
//            orderedYList[obj.id] = obj.stringRect.minY
//        }
//        let resultIDList = orderedYList.sorted {$0.1 > $1.1}
//        var index = 0
//        for (_key, _) in resultIDList{
//            let str = stringObjectDict[_key]!.content
//            content += (index == 0 ? "" : "\n") + str
//            index += 1
//        }
//
//        resultObj.stringRect = rect
//        resultObj.color = color
//        resultObj.fontSize = fontSize
//        resultObj.tracking = fontTracking
//        resultObj.content = content
//        resultObj.isParagraph = true
//
//        selectedStrIDList.removeAll()
//
//        for d in resultIDList{
//            tmpPsd.stringObjects.removeAll(where: {$0.id == d.key})
//            psdStrDict[]
//        }
//
//        tmpPsd.stringObjects.append(resultObj)
//        selectedStrIDList.append(resultObj.id)
//        psdModel.psdObjects.removeAll(where: {$0.id == psdId})
//        psdModel.psdObjects.append(tmpPsd)
    }
    
    func LoadImage(){
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.allowedFileTypes = ["png", "PNG", "psd", "PSD"]
        
        if (panel.runModal() ==  NSApplication.ModalResponse.OK) {
            // Results contains an array with all the selected paths
            let results = panel.urls
            // Do whatever you need with every selected file
            // in this case, print on the terminal every path
            for result in results {
                
                let hasSame = psdObjectDict.values.map({$0.imageURL}).contains(result)
                if hasSame == false {
                    let outId = addPsdObject(imageURL: result)
                    InitDictForOnePsd(psdId: outId )
                    
                    if selectedNSImage.size.width == 0{
                        thumbnailClicked(psdId: psdObjectDict.first!.key)
                    }
                    
                }
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    func thumbnailClicked(psdId: Int){
        //When clicking other psd, before jump to that psd, pack string objects first
        selectedStrIDList.removeAll()
        
        selectedPsdId = psdId
        if psdObjectDict.keys.contains(psdId) == true {
            selectedNSImage = LoadNSImage(imageUrlPath: fetchPsd(psdId: psdId).imageURL.path)
            UpdateProcessedImage(psdId: psdId)
            
            if fetchPsd(psdId: psdId).status == PsdStatus.processed{
                psdObjectDict[psdId]!.status = .normal
            }
        }
    }
    
    func ProcessForOnePsd(){
        let processOn: Int = selectedPsdId
        canProcess = true
        if  selectedNSImage.size.width == 0 {
            return
        }
        let queueCalc = DispatchQueue(label: "calc")
        queueCalc.async {
            self.FetchStringObjects(psdId: self.selectedPsdId)
            DispatchQueue.main.async{
                self.psdObjectDict[processOn]!.status = .processed
                self.IndicatorText = ""
            }
        }
    }
    
    func ProcessForAll(){
        canProcess = true
        if   selectedNSImage.size.width == 0 {
            return
        }
        
        let _list = psdObjectDict.values.filter({$0.status == .commited})
        if _list.count > 0{
            let queueCalc = DispatchQueue(label: "calc")
            
            var c: CGFloat = 0
            for psd in _list {
                queueCalc.async {
                    
                    self.FetchStringObjects(psdId: psd.id)
                    DispatchQueue.main.async{
                        self.prograssScale = 0
                        self.psdObjectDict[psd.id]!.status = .processed
                    }
                    c += 1
                }
            }
            IndicatorText = ""
        }
        //        canProcess = false
        
    }
    
    func createPSDForOne(){
        if selectedPsdId != nil {
            createJS(idList: [selectedPsdId], savePSDToPathList: [""])
            //            let path = Bundle.main.resourcePath! + "/StringCreator.jsx"
            runJS()
        }
    }
    
    func CreatePSDForCommited(){
        
        if  selectedNSImage == nil || selectedNSImage.size.width == 0 {
            return
        }
        
        if psdObjectDict.count == 0{
            return 
        }
        
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        //panel.allowsMultipleSelection = true
        //panel.allowedFileTypes = ["png", "PNG", "psd", "PSD"]
        
        if (panel.runModal() ==  NSApplication.ModalResponse.OK) {
            // Results contains an array with all the selected paths
            let result = panel.url!
            // Do whatever you need with every selected file
            // in this case, print on the terminal every path
            var savePSDToPathList: [String] = []
            for psd in psdObjectDict.values.filter({$0.status == .commited}) {
                let fileTitle = psd.imageURL.lastPathComponent.components(separatedBy: ".")[0]
                let fileName = fileTitle + ".psd"
                let saveToPath = result.appendingPathComponent(fileName).path
                savePSDToPathList.append(saveToPath)
                //                let jsPath = Bundle.main.resourcePath! + "/StringCreator.jsx"
                
            }
            //Collect all psd id
            let idList: [Int] = psdObjectDict.values.filter({$0.status == .commited}).map({$0.id})
            if idList.count > 0 {
                createJS(idList: idList, savePSDToPathList: savePSDToPathList)
                runJS()
            }
        } else {
            // User clicked on "Cancel"
            return
        }
        
        
    }
    
    
    
    
    //func GetRealResolution(){}
    
//    func FixedBtnTapped(_ _id: UUID){
//        if GetStringObjectForOnePsd(psdId: selectedPsdId, objId: _id)?.status == StringObjectStatus.fixed {
//            psdModel.SetStatusForString(psdId: selectedPsdId, objId: _id, value: .normal)
//        }else {
//            psdModel.SetStatusForString(psdId: selectedPsdId, objId: _id, value: .fixed)
//        }
//    }
//
//    func IgnoreBtnTapped(_ _id: UUID){
//        if GetStringObjectForOnePsd(psdId: selectedPsdId, objId: _id)?.status == StringObjectStatus.ignored {
//            psdModel.SetStatusForString(psdId: selectedPsdId, objId: _id, value: .normal)
//        }else {
//            psdModel.SetStatusForString(psdId: selectedPsdId, objId: _id, value: .ignored)
//        }
//    }
    
    func alignmentTapped(_ _id: UUID) -> String {
        guard let align = stringObjectDict[_id]?.alignment else {
            return  "alignCenter-round"
        }
        
        stringObjectDict[_id]!.alignment = align.Next()
        switch stringObjectDict[_id]!.alignment {
        case .left:
            tmpObjectForStringProperty.alignment = .left
            commitTempStringObject()
            return "alignLeft-round"
        case .center:
            tmpObjectForStringProperty.alignment = .center
            commitTempStringObject()
            return "alignCenter-round"
        case .right:
            tmpObjectForStringProperty.alignment = .right
            commitTempStringObject()
            return "alignRight-round"
        }
    }
    
//    func ColorModeTapped(){
//        if selectedStrIDList.count == 0 {
//            return
//        }
//        let id = fetchLastStrIdFromSelectedPsd()
//        //var preId = GetLastSelectObject().id
//        var cmode = MacColorMode.dark
//        if stringObjectDict[id]!.colorMode == .light {
//            cmode = .dark
//        }else if stringObjectDict[id]!.colorMode == .dark{
//            cmode = .light
//        }
//        stringObjectDict[id]!.colorMode = cmode
//        tmpObjectForStringProperty = stringObjectDict[id]!.toObjectForStringProperty()
//    }
    
    func ToggleColorMode(psdId: Int){
        if selectedStrIDList.count <= 0 {return}
        let newCMode: MacColorMode
        fetchLastStringObjectFromSelectedPsd().colorMode == .dark ? (newCMode = .light) : (newCMode = .dark)
        stringObjectDict[selectedStrIDList.last!]!.colorMode = newCMode
        stringObjectDict[selectedStrIDList.last!]!.CalcColor()
        tmpObjectForStringProperty = fetchLastStringObjectFromSelectedPsd().toObjectForStringProperty()
    }
    
    func ToggleFontName(objId: UUID?){
        if objId == nil {return}
//        var psd = stringObjectDict[psdId]
//        if psdObjectDict[psdId] != nil {
//            for objId in selectedStrIDList{}
            guard let strObj = stringObjectDict[objId!] else {return}
            let fName = strObj.fontName
            let endIndex = fName.lastIndex(of: " ")
            let startIndex = fName.startIndex
            let particialName = fName[startIndex..<endIndex!]
            var weightName = fName[endIndex!..<fName.endIndex]
            var str = ""
            if weightName == " Regular"  {
                weightName = "Semibold"
                str = particialName + " Semibold"
            }else {
                weightName = "Regular"
                str = particialName + " Regular"
            }
            tmpObjectForStringProperty.fontName = str
            
            let tmp  = FontUtils.GetStringBound(str: tmpObjectForStringProperty.content, fontName: tmpObjectForStringProperty.fontName, fontSize: tmpObjectForStringProperty.fontSize.toCGFloat(), tracking: tmpObjectForStringProperty.tracking.toCGFloat())
            tmpObjectForStringProperty.width = tmp.width
            tmpObjectForStringProperty.height = tmp.height - FontUtils.FetchTailOffset(content: tmpObjectForStringProperty.content, fontSize: tmpObjectForStringProperty.fontSize.toCGFloat())
            //            tmpObjectForStringProperty.posX = (tmpObjectForStringProperty.posX.toCGFloat() + tmp.minX).toString()
            
            commitTempStringObject()
            stringObjectDict[objId!]?.fontWeight = String(weightName)
            
            //Set fontName for all selected
            for id in selectedStrIDList {
                stringObjectDict[id]!.fontName = str
            }
//        }
        
    }
    
    func SetSelectionToFixed(){
        var allFix = true
        if selectedStrIDList.count == 0 {
            return
        }
        for sId in selectedStrIDList{
            if stringObjectDict[sId]!.status != StringObjectStatus.fixed {
                stringObjectDict[sId]!.status = .fixed
                allFix = false
            }
        }
        if allFix == true {
            for sId in selectedStrIDList{
                stringObjectDict[sId]!.status = .normal
            }
        }
    }
    
    func SetSelectionToIgnored(){
        var allFix = true
        if selectedStrIDList.count == 0 {
            return
        }
        for sId in selectedStrIDList{
            if stringObjectDict[sId]!.status != StringObjectStatus.ignored {
                stringObjectDict[sId]!.status = .ignored
                allFix = false
            }
        }
        if allFix == true {
            for sId in selectedStrIDList{
                stringObjectDict[sId]!.status = .normal
            }
        }
    }
    
    func psdStatusTapped(psdId: Int){
        var st = PsdStatus.normal
        guard let _psd = psdObjectDict[psdId] else {return}
        switch _psd.status{
        case .normal:
            st = .commited
        case .commited:
            st = .normal
        case .processed:
            st = .commited
        }
        
        psdObjectDict[psdId]?.status = st
    }
    
    func removePsd(psdId: Int){
        psdStrDict[psdId] = nil
        psdObjectDict[psdId] = nil
        selectedNSImage = NSImage.init()
        processedCIImage = DataStore.zeroCIImage
    }
    
    
    func SaveDocument(){
        //        packPsdObject(psdId: selectedPsdId)
        if psdObjectDict.count < 1 {
            return
        }
        let panel = NSSavePanel()
        panel.nameFieldLabel = "Save File To:"
        panel.nameFieldStringValue = "filename.stringlayers"
        panel.canCreateDirectories = true
        panel.begin { [self] response in
            if response == NSApplication.ModalResponse.OK, let fileUrl = panel.url {
                do {
                    let relatedData = RelatedDataJsonObject.init(selectedPsdId: self.selectedPsdId, gammaDict: self.gammaDict, expDict: self.expDict, DragOffsetDict: self.DragOffsetDict, selectedStrIDList: self.selectedStrIDList, maskDict: self.maskDict, stringIsOn: self.stringIsOn)
                    let str = self.jsMgr.ConstellateJsonString(relatedDataJsonObject: relatedData, psdStrDict: psdStrDict, psdDict: psdObjectDict, strDict: self.stringObjectDict)
                    try str.write(to: fileUrl, atomically: false, encoding: .utf8)
                }
                catch {/* error handling here */}
            }
        }
    }
    
    
    func OpenDocument(){
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["stringlayers"]
        
        if (panel.runModal() ==  NSApplication.ModalResponse.OK) {
            let url = panel.url!
            let decoder = JSONDecoder()
            guard let data = try? Data(contentsOf: url),
                  let json = try? decoder.decode(JsonObject.self, from: data)
            
            else {
                return
            }
            
            DragOffsetDict = json.relatedDataJsonObject.DragOffsetDict
            expDict = json.relatedDataJsonObject.expDict
            gammaDict = json.relatedDataJsonObject.gammaDict
            maskDict = json.relatedDataJsonObject.maskDict
            selectedPsdId = json.relatedDataJsonObject.selectedPsdId
            selectedStrIDList = json.relatedDataJsonObject.selectedStrIDList
            stringIsOn = json.relatedDataJsonObject.stringIsOn

            let loadContent = jsMgr.loadPsdJsonObject(jsonObject: json)
            stringObjectDict = loadContent.strDict
            psdObjectDict = loadContent.psdDict
            psdStrDict = loadContent.psdStrDict
            
            //Load NSImage
            let targetUrl = fetchSelectedPsd().imageURL
            if FileManager.default.fileExists(atPath: targetUrl.path) == true {
                selectedNSImage = LoadNSImage(imageUrlPath: targetUrl.path)
            }
            //Process Image
            UpdateProcessedImage(psdId: selectedPsdId)
            selectedStrIDList.removeAll()

        }
    }
    
    func alignSelection(orientation: String){
        var objList: [StringObject] = []
        for objId in selectedStrIDList {
//            guard let obj = GetStringObjectForOnePsd(psdId: selectedPsdId, objId: objId) else {return}
            objList.append(stringObjectDict[objId]!)
        }
        
        if orientation == "horizontal-left" {
            
            let posXList = objList.map({$0.stringRect.minX})
            let minX = posXList.min()
            if minX != nil {
                for obj in objList {
                    let rect: CGRect = CGRect.init(x: minX!, y: obj.stringRect.minY, width: obj.stringRect.width, height: obj.stringRect.height)
                    stringObjectDict[obj.id]?.stringRect = rect
                    stringObjectDict[obj.id]?.alignment = .left
                }
            }
        }else if orientation == "horizontal-center" {
            guard let lastId = selectedStrIDList.last else {return }
//            let lasMidX = fetchLastStringObjectFromSelectedPsd().stringRect.midX
            for obj in objList {
//                let offset = obj.stringRect.midX - lasMidX
                //                let rect: CGRect = CGRect.init(x: minX, y: obj.stringRect.minY, width: obj.stringRect.width, height: obj.stringRect.height)
//                psdModel.SetPosForString(psdId: selectedPsdId, objId: obj.id, valueX: obj.stringRect.minX - offset, valueY: obj.stringRect.minY, isOnlyX: true, isOnlyY: false)
                stringObjectDict[obj.id]?.alignment = .center
                
            }
            
        }else if orientation == "horizontal-right" {
//            let posXList = objList.map({$0.stringRect.maxX})
//            let maxX = posXList.max()
//            if maxX != nil {
                for obj in objList {
//                    let rect: CGRect = CGRect.init(x: maxX! - obj.stringRect.width, y: obj.stringRect.minY, width: obj.stringRect.width, height: obj.stringRect.height)
//                    psdModel.SetRect(psdId: selectedPsdId, objId: obj.id, value: rect)
                    stringObjectDict[obj.id]?.alignment = .right
                }
//            }
        }
//        else if orientation == "vertical-bottom" {
//            let posYList = objList.map({$0.stringRect.maxY})
//            let maxY = posYList.max()
//            if maxY != nil {
//                for obj in objList {
//                    let rect: CGRect = CGRect.init(x: obj.stringRect.origin.x, y: maxY! - obj.stringRect.width, width: obj.stringRect.width, height: obj.stringRect.height)
//                    psdModel.SetRect(psdId: selectedPsdId, objId: obj.id, value: rect)
//                    //                    psdModel.SetAlignment(psdId: selectedPsdId, objId: obj.id, value: .center)
//                }
//            }
//        }else if orientation == "vertical-center" {
//            let posYList = objList.map({$0.stringRect.minY})
//            //            let posYMaxList = objList.map({$0.stringRect.maxY})
//            let minY = posYList.min() ?? posYList[0]
//            let maxY = posYList.max() ?? posYList[0]
//            guard let midY: CGFloat? = ((minY + maxY) / 2) else {return}
//            for obj in objList {
//                let rect: CGRect = CGRect.init(x: obj.stringRect.minX, y: midY!, width: obj.stringRect.width, height: obj.stringRect.height)
//                psdModel.SetRect(psdId: selectedPsdId, objId: obj.id, value: rect)
//                //                psdModel.SetAlignment(psdId: selectedPsdId, objId: obj.id, value: .center)
//
//            }
//        }else if orientation == "vertical-top" {
//            let posYList = objList.map({$0.stringRect.maxY})
//            let maxY = posYList.max()
//            if maxY != nil {
//                for obj in objList {
//                    let rect: CGRect = CGRect.init(x: obj.stringRect.minX , y: maxY! - obj.stringRect.height, width: obj.stringRect.width, height: obj.stringRect.height)
//                    psdModel.SetRect(psdId: selectedPsdId, objId: obj.id, value: rect)
//                    //                    psdModel.SetAlignment(psdId: selectedPsdId, objId: obj.id, value: .center)
//                }
//            }
//        }
        
        
    }
    
    
    
    func DeleteAll(){
        psdStrDict.removeAll()
        stringObjectDict.removeAll()
        psdObjectDict.removeAll()
        selectedNSImage = NSImage.init()
        processedCIImage = DataStore.zeroCIImage
    }
    
    func CommitAll(){
//        psdObjectDict.mapValues({value in return value.status = .commited})
        for (key, obj) in psdObjectDict {
//            var tmpOjb = obj
            psdObjectDict[key]?.status = .commited
//            obj.status = PsdStatus.commited
        }
    }
    
}
