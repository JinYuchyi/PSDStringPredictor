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
    
    let ocr = OCR()
    
    @Published var psdModel: PSD //refacting
    
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
    @Published var selectRect: CGRect = CGRect.init()
    @Published var linkSizeAndTracking: Bool = true

    // UI control
    @Published var charDSWindowShow: Bool = false
    @Published var stringDifferenceShow: Bool = false
    //Save Char DS
    @Published var charImageDSWillBeSaved: CIImage = CIImage.init()
    
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
    
    let imageUtil = ImageUtil()
    //    let pixProcess = PixelProcess()
    let jsMgr = JSManager()
    //    @Published var thumbnailDict: [Int:NSImage] = [:]
    //    @Published var commitedList: [Int:Bool] = [:]
    //    @Published var pathList: [Int:String] = [:]
    //@Published var psdObjectList: [PSDObject] = []
    
    init(){
        psdModel = PSD()
        selectedPsdId = 0
        selectedNSImage = NSImage.init()
        processedCIImage = CIImage.init()
        gammaDict = [:]
        expDict = [:]
        selectedStrIDList = []
        DragOffsetDict = [:]
        maskedImage = CIImage.init()
        
    }
    
    //    func Refresh(){
    //        FetchPsdObjectList()
    //    }
    //
    //    func FetchPsdObjectList(){
    //        psdObjectList = DataRepository.shared.GetPsdObjectList()
    //    }
    //
    
    
    func InitDictForOnePsd(psdId: Int){
        gammaDict[psdId] = 1
        expDict[psdId] = 0
        processedCIImage = selectedNSImage.ToCIImage() ?? CIImage.init()
    }
    
    func GetSelectedPsd() -> PSDObject?{
        return psdModel.psdObjects.first(where: {$0.id == selectedPsdId})
    }
    
    func GetStringObjectForOnePsd(psdId: Int, objId: UUID) -> StringObject?{
        guard let _psd = psdModel.psdObjects.first(where: {$0.id == psdId}) else {
            return nil
        }
        guard let _obj = _psd.stringObjects.first(where: {$0.id == objId}) else {
            return nil
        }
        return _obj
    }
    
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
        guard let tmpPsd = psdModel.GetPSDObject(psdId: psdId) else {return [0,0]}
        guard let tmpObj = GetStringObjectForOnePsd(psdId: psdId, objId: objId) else {return [0,0]}
        let x: CGFloat = tmpObj.stringRect.minX + tmpObj.stringRect.width / 2 + tmpObj.tracking / 2 - FontUtils.GetCharFrontOffset(content: tmpObj.content, fontSize: tmpObj.fontSize)
        let y: CGFloat =  tmpPsd.height  - (tmpObj.stringRect.minY + tmpObj.stringRect.height / 2)
        return [x,y]
//        x: getObject().stringRect.minX + getObject().stringRect.width / 2 + getObject().tracking / 2 - FontUtils.GetCharFrontOffset(content: getObject().content, fontSize: getObject().fontSize), y: (psdsVM.GetSelectedPsd()?.height ?? 0) - (getObject().stringRect.minY + getObject().stringRect.height / 2)
    }
    
    func FetchStringObjects(psdId: Int){
        var result: [StringObject] = []
        
        let tmpImageUrl = self.psdModel.GetPSDObject(psdId: psdId)?.imageURL
        var img = LoadNSImage(imageUrlPath: tmpImageUrl!.path).ToCIImage()!
        img = imageUtil.ApplyBlockMasks(target: img, psdId: psdId, rectDict: maskDict)
        img = imageUtil.ApplyFilters(target: img, gamma: gammaDict[psdId] ?? 1, exp: expDict[psdId] ?? 0)
        let allStrObjs = CreateAllStringObjects(rawImg: img, psdId: psdId, psdsVM: self)
        DispatchQueue.main.async{ [self] in
            var tmpList = self.psdModel.GetPSDObject(psdId: psdId)!.stringObjects.filter({$0.status != .normal}) //Filter all fixed objects
            for obj in allStrObjs {
                if tmpList.ContainsSame(obj) == false {
                    result.append(obj)
                    
                }else{
                }
            }
            result += tmpList
            psdModel.UpdateStringObjectsForOnePsd(psdId: psdId, objs: result)
            IndicatorText = ""
        }
    }
    
    func fetchRegionStringObjects(rect: CGRect, psdId: Int) -> [UUID]{
        //        let tmpPath = GetDocumentsPath().appending("/test1.bmp")
        //        regionImage.ToPNG(url: URL.init(fileURLWithPath: tmpPath))
        
//        var idList: [UUID] = []
        let regionImage = processedCIImage.cropped(to: rect).premultiplyingAlpha()
        var offset = CGPoint.init(x: rect.minX, y: rect.minY)
        //                let tmpPath = GetDocumentsPath().appending("/test1.bmp")
        //                regionImage.ToPNG(url: URL.init(fileURLWithPath: tmpPath))
        var result: [StringObject] = self.psdModel.GetPSDObject(psdId: psdId)!.stringObjects.filter({$0.status == .normal})
        var img = imageUtil.ApplyBlockMasks(target: regionImage, psdId: psdId, rectDict: maskDict)
        img = imageUtil.ApplyFilters(target: img, gamma: gammaDict[psdId] ?? 1, exp: expDict[psdId] ?? 0)
        //        let tmpPath = GetDocumentsPath().appending("/test1.bmp")
        //        regionImage.ToPNG(url: URL.init(fileURLWithPath: tmpPath))
        let newList = CreateAllStringObjects(rawImg: img, psdId: psdId, psdsVM: self, offset: offset)
        if newList.count == 0{
            print("No strings detected in the area.")
            return []
        }
        DispatchQueue.main.async{ [self] in
            //if region already have string object exist, just remove the old ones.
            for newObj in newList{
                for preObj in result{
                    if preObj.stringRect.intersects(newObj.stringRect) == true{
                        result.removeAll(where: {$0.id == preObj.id})
                    }
                }
            }
            result += newList
            psdModel.UpdateStringObjectsForOnePsd(psdId: psdId, objs: result)
            
            IndicatorText = ""
        }
        return newList.map({$0.id})
    }
    
    func FetchBGColor(psdId: Int, obj: StringObject) -> [Float]{
        var pad: CGFloat = 3
        let targetImg = LoadNSImage(imageUrlPath: psdModel.GetPSDObject(psdId: psdId)!.imageURL.path)
        let color1 = PixelProcess.shared.colorAt(x: Int(obj.stringRect.origin.x - pad), y: Int(targetImg.size.height - obj.stringRect.origin.y - pad), img: targetImg.ToCGImage()!)
//        print("Fetch image color at: \(Int(obj.stringRect.origin.x)), \(Int(targetImg.size.height - obj.stringRect.origin.y)). The Color is \(color1)")

        return [Float(color1.redComponent * 255), Float(color1.greenComponent * 255), Float(color1.blueComponent * 255)]
    }
    
    //    func UnpackPsdObject(psdId: Int) -> Bool {
    //        guard let psd = GetSelectedPsd() else {return false}
    //        tmpStringObjectList = psd.stringObjects
    //        return true
    //    }
    //
    //    func packPsdObject(psdId: Int) -> Bool {
    //        if selectedPsdId != nil && psdModel.GetPSDObject(psdId: psdId) != nil {
    //            psdModel.SetStringObjects(psdId: psdId, value: tmpStringObjectList)
    //            tmpStringObjectList = []
    //            return true
    //        }
    //        return true
    //    }
    
    func SetCommit(psdId: Int){
        psdModel.SetStatusForPsd(psdId: psdId, value: .commited)
        //        packPsdObject(psdId: psdId)
    }
    
    func ScanAndBreakFarAwayStringObject(psdId: Int){
        var newList: [StringObject] = []
        var breakIndexList : [Int] = []
        guard let psd = psdModel.GetPSDObject(psdId: psdId) else {return}
        for strObj in psd.stringObjects {
            for i in 0..<strObj.charRects.count {
                if strObj.charArray[i] == " " && i != 0 && i != strObj.charRects.count - 1 {
                    let dist = strObj.charRects[i+1].minX - strObj.charRects[i-1].maxX
                    if dist > strObj.charRects[i+1].width * 1.1 {
                        //Found a gap!
                        breakIndexList.append(i)
                    }
                }
            }
        }
        
        
    }
    
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
            let charImageList = CIImage.init(contentsOf: psdModel.GetPSDObject(psdId: psdId)!.imageURL)!.GetCroppedImages(rects: charRects.offset(offset: offset) )
            
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
        guard let lastId = selectedStrIDList.last else {return }
        guard let obj = psdModel.GetPSDObject(psdId: selectedPsdId)?.GetStringObjectFromOnePsd(objId: lastId) else {return }
        if tmpObjectForStringProperty.content.count != obj.content.count {
            let newBound = FontUtils.GetStringBound(str: tmpObjectForStringProperty.content, fontName: tmpObjectForStringProperty.fontName, fontSize: tmpObjectForStringProperty.fontSize.toCGFloat(), tracking: tmpObjectForStringProperty.tracking.toCGFloat())
            tmpObjectForStringProperty.posX = (tmpObjectForStringProperty.posX.toCGFloat() + newBound.minX).toString()
            tmpObjectForStringProperty.width = newBound.width
            psdModel.SetLastStringObject(psdId: selectedPsdId, objId: selectedStrIDList.last!, value: tmpObjectForStringProperty.toStringObject(strObj: obj))
        }
        else{
            psdModel.SetLastStringObject(psdId: selectedPsdId, objId: selectedStrIDList.last!, value: tmpObjectForStringProperty.toStringObject(strObj: obj))
        }
    }
    
    func commitFontSize() {
        for id in selectedStrIDList {
            psdModel.SetFontSize(psdId: selectedPsdId, objId: id, value: tmpObjectForStringProperty.fontSize.toCGFloat())
            if linkSizeAndTracking == true {
                let newT: CGFloat = CGFloat(TrackingDataManager.FetchNearestOne(viewContext, fontSize: Int16(tmpObjectForStringProperty.fontSize.toCGFloat().rounded())).fontTrackingPoints)
                tmpObjectForStringProperty.tracking =  newT.toString()
                psdModel.SetTracking(psdId: selectedPsdId, objId: id, value: newT)
            }
        }
    }
    
    func commitFontTracking() {
        for id in selectedStrIDList {
            psdModel.SetTracking(psdId: selectedPsdId, objId: id, value: tmpObjectForStringProperty.tracking.toCGFloat())
        }
    }
    
    func commitPosX() {
        for id in selectedStrIDList {
            psdModel.SetPosForString(psdId: selectedPsdId, objId: id, valueX: tmpObjectForStringProperty.posX.toCGFloat(), valueY: tmpObjectForStringProperty.posY.toCGFloat(), isOnlyX: true, isOnlyY: false)
        }
    }
    
    func commitPosY() {
        for id in selectedStrIDList {
            psdModel.SetPosForString(psdId: selectedPsdId, objId: id, valueX: tmpObjectForStringProperty.posX.toCGFloat(), valueY: tmpObjectForStringProperty.posY.toCGFloat(), isOnlyX: false, isOnlyY: true)
        }
    }
    
    func commitRect(){
        //        let newRect = CGRect.init(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: tmpObjectForStringProperty.stringRect, height: <#T##CGFloat#>)
        for id in selectedStrIDList {
            
            psdModel.SetRect(psdId: selectedPsdId, objId: id, value: CGRect.init(x: tmpObjectForStringProperty.posX.toCGFloat(), y: tmpObjectForStringProperty.posY.toCGFloat(), width: tmpObjectForStringProperty.width, height: tmpObjectForStringProperty.height))
        }
    }
    
    func deleteSelectedStringObjects(){
        if selectedStrIDList.count == 0 || GetSelectedPsd() == nil {return }
        let idList = selectedStrIDList
        selectedStrIDList = []
        var tmpResult = GetSelectedPsd()!.stringObjects
        for id in idList {
            tmpResult.removeAll(where: {$0.id == id})
        }
        psdModel.SetStringObjects(psdId: selectedPsdId, value: tmpResult)
        tmpObjectForStringProperty = StringObjectForStringProperty.init()
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
        if selectedStrIDList.count == 0 {return }
        
        var orderedYList: [UUID:CGFloat] = [:]
        var content: String = ""
        var rect: CGRect = CGRect.init()
        var color: CGColor = CGColor.white
        var fontSize: CGFloat = 0
        var fontTracking: CGFloat = 0
        // var fontLeading: Int = 0
        var resultObj: StringObject = StringObject()
        
        if selectedStrIDList.count > 0{
            //If have selection, we get the first object's information as the paragraph infomation
            let strObj = GetStringObjectForOnePsd(psdId: selectedPsdId, objId: selectedStrIDList.first!)!
            rect = strObj.stringRect
            color = strObj.color
            fontSize = strObj.fontSize
            fontTracking = strObj.tracking
            resultObj = strObj
        }
        
        //Calc and sort each object's Y position, for gettomg the order of string
        for id in selectedStrIDList{
            let obj = GetStringObjectForOnePsd(psdId: selectedPsdId, objId: id)!
            rect = rect.union(obj.stringRect)
            orderedYList[obj.id] = obj.stringRect.minY
        }
        let resultIDList = orderedYList.sorted {$0.1 > $1.1}
        var index = 0
        for (_key, _) in resultIDList{
            let str = GetStringObjectForOnePsd(psdId: selectedPsdId, objId: _key)!.content
            content += (index == 0 ? "" : "\n") + str
            index += 1
        }
        
        resultObj.stringRect = rect //CGRect.init(x: rect.minX, y: rect.minY - rect.height, width: rect.width, height: rect.height)
        resultObj.color = color
        resultObj.fontSize = fontSize
        resultObj.tracking = fontTracking
        resultObj.content = content
        resultObj.isParagraph = true
        
        selectedStrIDList.removeAll()
        //selectedStrIDList.append(resultObj.id)
        
        var tmpPsd = GetSelectedPsd()!
        
        for d in resultIDList{
            tmpPsd.stringObjects.removeAll(where: {$0.id == d.key})
            
        }
        
        tmpPsd.stringObjects.append(resultObj)
        selectedStrIDList.append(resultObj.id)
        psdModel.psdObjects.removeAll(where: {$0.id == psdId})
        psdModel.psdObjects.append(tmpPsd)
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
                
                let hasSame = psdModel.psdObjects.map({$0.imageURL}).contains(result)
                if hasSame == false {
                    let outId = psdModel.addPSDObject(imageURL: result)
                    InitDictForOnePsd(psdId: outId )
                    
                    if selectedNSImage.size.width == 0{
                        thumbnailClicked(psdId: psdModel.psdObjects[0].id)
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
        //        if selectedPsdId != nil {
        //            packPsdObject(psdId: selectedPsdId)
        //        }
        selectedPsdId = psdId
        //        UnpackPsdObject(psdId: psdId)
        if psdModel.psdObjects.contains(where: {psdId == $0.id}) == true {
            selectedNSImage = LoadNSImage(imageUrlPath: GetSelectedPsd()!.imageURL.path)
            UpdateProcessedImage(psdId: psdId)
            
            if psdModel.GetPSDObject(psdId: psdId)!.status == PsdStatus.processed{
                psdModel.SetStatusForPsd(psdId: psdId, value: PsdStatus.normal)
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
                self.psdModel.SetStatusForPsd(psdId: processOn, value: .processed)
            }
        }
        //        canProcess = false
        IndicatorText = ""
    }
    
    func ProcessForAll(){
        canProcess = true
        if   selectedNSImage.size.width == 0 {
            return
        }
        
        let _list = psdModel.psdObjects.filter({$0.status == .commited})
        if _list.count > 0{
            let queueCalc = DispatchQueue(label: "calc")
            
            var c: CGFloat = 0
            for psd in _list {
                queueCalc.async {
                    
                    self.FetchStringObjects(psdId: psd.id)
                    DispatchQueue.main.async{
                        self.prograssScale = 0
                        self.psdModel.SetStatusForPsd(psdId: psd.id, value: .processed)
                    }
                    c += 1
                }
            }
            IndicatorText = ""
        }
        //        canProcess = false
        
    }
    
    func CreatePSDForCommited(){
        
        if  selectedNSImage == nil || selectedNSImage.size.width == 0 {
            return
        }
        
        if psdModel.psdObjects.count == 0{
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
            for psd in psdModel.psdObjects.filter({$0.status == .commited}) {
//                print("Processing on \(psd.imageURL)")

                let fileTitle = psd.imageURL.lastPathComponent.components(separatedBy: ".")[0]
                let fileName = fileTitle + ".psd"
                let saveToPath = result.appendingPathComponent(fileName).path
                let jsPath = Bundle.main.resourcePath! + "/OutputScript/" + String(psd.id) + ".jsx"
//                CreatePSDForOnePSD(_id: psd.id, saveToPath: saveToPath )
                createJSForOnePSD(_id: psd.id, jsPath: jsPath, savePSDToPath: saveToPath)
            }
        } else {
            // User clicked on "Cancel"
            return
        }
        
        
    }
    
    private func createJS(idList: [Int], jsPath: String, savePSDToPath: String ){
        var finalStr : String = ""
        for _id in idList{
            guard let obj = psdModel.GetPSDObject(psdId: _id) else {return}
            let psdPath = obj.imageURL.path
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
            var updateList = psdModel.GetPSDObject(psdId: _id)!.stringObjects.filter{$0.status != .ignored}
            var saveToPath = savePSDToPath
            var frontSpaceList: [Float] = []
            
            for obj in updateList{
                var newString = obj.content.replacingOccurrences(of: "\n", with: " ")
                if newString.isEmpty || newString == nil {
                    newString = "_"
                }
                contentList.append(newString)
                var tmpColor: [Int] = []
                
                tmpColor = [ Int((Float(obj.color.components![0]) * 255).rounded()),
                             Int((Float(obj.color.components![1]) * 255).rounded()),
                             Int((Float(obj.color.components![2]) * 255).rounded())
                ]
                colorList.append(tmpColor)
                
                isParagraphList.append(obj.isParagraph)

                
                let tmpSize: CGFloat = CGFloat(obj.fontSize)
                fontSizeList.append(Float(tmpSize))
                //let tmpTracking = obj.fontSize * 1000 / obj.tracking
                let tmpTracking = Float((obj.tracking) * 1000 / tmpSize)
                trackingList.append(tmpTracking)
                
                //Calc the offset of String
                var keyvalues: [String: AnyObject] = [:]
                let char = (obj.content.first)
                keyvalues["char"] = String(char!) as AnyObject
                keyvalues["fontSize"] = Int(obj.fontSize.rounded()) as AnyObject

                let targetImg = LoadNSImage(imageUrlPath: psdModel.GetPSDObject(psdId: _id)!.imageURL.path)
                fontNameList.append(obj.CalcFontPostScriptName())
                //Calc Descent
                let tmpDesc = Float(FontUtils.calcFontTailLength(content: obj.content, size: obj.fontSize))

                descentOffset.append(tmpDesc)
                let newRect = FontUtils.GetStringBound(str: obj.content, fontName: obj.fontName, fontSize: obj.fontSize, tracking: obj.tracking)
                
                let offset = [Int16(newRect.minX), 0]
                offsetList.append(offset)

                //alignment
                if obj.alignment == nil {
                    alignmentList.append("center")
                }else {
                    alignmentList.append(obj.alignment.rawValue)
                }
                
                //Front space
                let frontSpaceWidth = FontUtils.getFrontSpace(content: obj.content, fontSize: obj.fontSize)
                frontSpaceList.append(Float(frontSpaceWidth))
                
                // Re-Calc the string box
                if obj.alignment == .center {
                    rectList.append([Float(newRect.minX), Float(newRect.minY), Float(newRect.width), Float(newRect.height)])
                    // Append Position
    //                let newX =  Float(obj.stringRect.minX + newRect.minX )
                    let newX =  Float(obj.stringRect.minX )
                    let newY =  Float(targetImg.size.height - obj.stringRect.minY )
    //                print("\(obj.stringRect.midX), \(newRect.minX), \(frontSpace)")
                    positionList.append([newX, newY])

                }else if obj.alignment == .left {
                    rectList.append([Float(newRect.minX), Float(newRect.minY), Float(newRect.width), Float(newRect.height)])
                    // Append Position
    //                let newX = Int(obj.stringRect.minX + newRect.minX - frontSpace)
                    let newX = Float(obj.stringRect.minX )

                    let newY =  Float((targetImg.size.height - obj.stringRect.minY ) )
                    positionList.append([newX, newY])


                }else if obj.alignment == .right {
                    rectList.append([Float(newRect.minX), Float(newRect.minY), Float(obj.stringRect.width), Float(newRect.height)])
                    // Append Position
                    let newX = Float(obj.stringRect.minX + newRect.minX )
                    let newY = Float((targetImg.size.height - obj.stringRect.minY ))
                    positionList.append([newX, newY])

                }

                //BGColor
                let tmpBGColor = FetchBGColor(psdId: _id, obj: obj)
                bgClolorList.append(tmpBGColor)
            }
            
            let jsStr = jsMgr.CreateJSString( psdPath: psdPath, contentList: contentList, colorList: colorList, fontSizeList: fontSizeList, trackingList: trackingList, fontNameList: fontNameList, positionList: positionList, offsetList: offsetList, alignmentList: alignmentList, rectList: rectList, bgColorList: bgClolorList, isParagraphList: isParagraphList, saveToPath: saveToPath , descentOffset: descentOffset, frontSpace: frontSpaceList)
            
            finalStr.append(jsStr)
        }
        
        // Create JS file from JS string
        do {
            let path = Bundle.main.resourcePath! + "/StringCreator.jsx"
            print("Creating js: \(path)")
            let url = URL.init(fileURLWithPath: path)
//            try FileManager.default.createDirectory(atPath: resourcePath + "/OutputScript", withIntermediateDirectories: true, attributes: nil)
            try finalStr.write(to: url, atomically: false, encoding: .utf8)
        }
        catch {
            return
        }
        
    }
    
    func runJS(jsPath: String){
 
//             let jsPath = Bundle.main.path(forResource: "StringCreator", ofType: "jsx")!
            let cmd = "open " + jsPath + "  -a '\(DataStore.PSPath)'"
            PythonScriptManager.RunScript(str: cmd)
     }
    
    
    //func GetRealResolution(){}
    
    func FixedBtnTapped(_ _id: UUID){
        if GetStringObjectForOnePsd(psdId: selectedPsdId, objId: _id)?.status == StringObjectStatus.fixed {
            psdModel.SetStatusForString(psdId: selectedPsdId, objId: _id, value: .normal)
            //stringObjectVM.SetStatusForStringObject(psdId: stringObjectVM.selectedPSDID, objId: id, value: 0)
        }else {
            psdModel.SetStatusForString(psdId: selectedPsdId, objId: _id, value: .fixed)
            //stringObjectVM.SetStatusForStringObject(psdId: stringObjectVM.selectedPSDID, objId: id, value: 1
        }
    }
    
    func IgnoreBtnTapped(_ _id: UUID){
        if GetStringObjectForOnePsd(psdId: selectedPsdId, objId: _id)?.status == StringObjectStatus.ignored {
            psdModel.SetStatusForString(psdId: selectedPsdId, objId: _id, value: .normal)
        }else {
            psdModel.SetStatusForString(psdId: selectedPsdId, objId: _id, value: .ignored)
        }
    }
    
    func alignmentTapped(_ _id: UUID) -> String {
        guard let align = psdModel.GetPSDObject(psdId: selectedPsdId)?.GetStringObjectFromOnePsd(objId: _id)?.alignment else {
            return  "alignCenter-round"
        }
        
        psdModel.SetAlignment(psdId: selectedPsdId, objId: _id, value: align.Next())
        switch psdModel.GetPSDObject(psdId: selectedPsdId)!.GetStringObjectFromOnePsd(objId: _id)!.alignment {
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
    
    func ColorModeTapped(){
        if selectedStrIDList.count == 0 {
            return
        }
        var obj = GetStringObjectForOnePsd(psdId: selectedPsdId, objId: selectedStrIDList.last!)
        if obj == nil {
            return
        }
        //var preId = GetLastSelectObject().id
        var cmode = MacColorMode.dark
        if obj!.colorMode == .light {
            cmode = .dark
        }else if obj!.colorMode == .dark{
            cmode = .light
        }
        psdModel.SetColorMode(psdId: selectedPsdId, objId: selectedStrIDList.last!, value: cmode)
        
    }
    
    func ToggleColorMode(psdId: Int){
        guard let psd = psdModel.GetPSDObject(psdId: psdId) else {return }
        if selectedStrIDList.count <= 0 {return}
        guard let lastObj  = psd.stringObjects.last  else {return }
        guard let lastId = selectedStrIDList.last else {return}
        let newCMode: MacColorMode
        lastObj.colorMode == .dark ? (newCMode = .light) : (newCMode = .dark)
        psdModel.SetColorMode(psdId: psdId, objId: lastId, value: newCMode)
        tmpObjectForStringProperty = lastObj.toObjectForStringProperty()
//        tmpObjectForStringProperty.color = lastObj.color
//        commitTempStringObject()
    }
    
    func ToggleFontName(psdId: Int, objId: UUID?){
        if objId == nil {return}
        var psd = psdModel.GetPSDObject(psdId: psdId)
        if psd != nil {
            for objId in selectedStrIDList{}
            var strObj = psd!.GetStringObjectFromOnePsd(objId: objId!)
            if strObj == nil {return }
            let fName = strObj!.fontName
            let endIndex = fName.lastIndex(of: " ")
            let startIndex = fName.startIndex
            let particialName = fName[startIndex..<endIndex!]
            let weightName = fName[endIndex!..<fName.endIndex]
            var str = ""
            if weightName == " Regular"  {
                 str = particialName + " Semibold"
            }else {
                 str = particialName + " Regular"
            }
            tmpObjectForStringProperty.fontName = str
            
            let tmp  = FontUtils.GetStringBound(str: tmpObjectForStringProperty.content, fontName: tmpObjectForStringProperty.fontName, fontSize: tmpObjectForStringProperty.fontSize.toCGFloat(), tracking: tmpObjectForStringProperty.tracking.toCGFloat())
            tmpObjectForStringProperty.width = tmp.width
            tmpObjectForStringProperty.height = tmp.height - FontUtils.FetchTailOffset(content: tmpObjectForStringProperty.content, fontSize: tmpObjectForStringProperty.fontSize.toCGFloat())
            tmpObjectForStringProperty.posX = (tmpObjectForStringProperty.posX.toCGFloat() + tmp.minX).toString()
//            tmpObjectForStringProperty.posY = (tmpObjectForStringProperty.posY.toCGFloat() + tmp.minY).toString()
            
            commitTempStringObject()

            //Set fontName for all selected
            for id in selectedStrIDList {
                psdModel.SetFontName(psdId: psdId, objId: id, value: str)
            }
        }
        
    }
    
    func SetSelectionToFixed(){
        var allFix = true
        if selectedStrIDList.count == 0 {
            return
        }
        for sId in selectedStrIDList{
            if GetStringObjectForOnePsd(psdId: selectedPsdId, objId: sId)?.status != StringObjectStatus.fixed {
                psdModel.SetStatusForString(psdId: selectedPsdId, objId: sId, value: StringObjectStatus.fixed)
                allFix = false
            }
        }
        if allFix == true {
            for sId in selectedStrIDList{
                psdModel.SetStatusForString(psdId: selectedPsdId, objId: sId, value: StringObjectStatus.normal)
            }
        }
    }
    
    func SetSelectionToIgnored(){
        var allFix = true
        if selectedStrIDList.count == 0 {
            return
        }
        for sId in selectedStrIDList{
            if GetStringObjectForOnePsd(psdId: selectedPsdId, objId: sId)?.status != StringObjectStatus.ignored {
                psdModel.SetStatusForString(psdId: selectedPsdId, objId: sId, value: StringObjectStatus.ignored)
                allFix = false
            }
        }
        if allFix == true {
            for sId in selectedStrIDList{
                psdModel.SetStatusForString(psdId: selectedPsdId, objId: sId, value: StringObjectStatus.normal)
            }
        }
    }
    
    func psdStatusTapped(psdId: Int){
        var st = PsdStatus.normal
        guard let _psd = psdModel.GetPSDObject(psdId: psdId) else {return}
        switch _psd.status{
        case .normal:
            st = .commited
        case .commited:
            st = .normal
        case .processed:
            st = .commited
        }
        
        psdModel.SetStatusForPsd(psdId: psdId, value: st)
    }
    
    func removePsd(psdId: Int){
        //Check selected image
        //Check selected id
        //        if selectedPsdId == 0 && psdModel.psdObjects.count == 1 {
        //            //psdModel.addPSDObject(imageURL: )
        //            selectedNSImage == NSImage.init()
        //            //UpdateProcessedImage(psdId: 0)
        //        }
        psdModel.removePSDObject(id: psdId)
        selectedNSImage = NSImage.init()
        processedCIImage = CIImage.init()
        
    }
    
    
    func SaveDocument(){
        //        packPsdObject(psdId: selectedPsdId)
        if psdModel.psdObjects.count < 1 {
            return
        }
        let panel = NSSavePanel()
        panel.nameFieldLabel = "Save File To:"
        panel.nameFieldStringValue = "filename.stringlayers"
        panel.canCreateDirectories = true
        panel.begin { response in
            if response == NSApplication.ModalResponse.OK, let fileUrl = panel.url {
                do {
                    let relatedData = RelatedDataJsonObject.init(selectedPsdId: self.selectedPsdId, gammaDict: self.gammaDict, expDict: self.expDict, DragOffsetDict: self.DragOffsetDict, selectedStrIDList: self.selectedStrIDList, maskDict: self.maskDict, stringIsOn: self.stringIsOn)
                    let str = self.psdModel.ConstellateJsonString(relatedDataJsonObject: relatedData)
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
            
            psdModel.LoadPsdJsonObject(jsonObject: json)
            
            //Load NSImage
            let targetUrl = psdModel.GetPSDObject(psdId: selectedPsdId)?.imageURL
            if FileManager.default.fileExists(atPath: targetUrl!.path) == true {
//                selectedNSImage = NSImage.init(contentsOf: targetUrl!)!
                selectedNSImage = LoadNSImage(imageUrlPath: targetUrl!.path)
            }
            //Process Image
            UpdateProcessedImage(psdId: selectedPsdId)
            
            //            UnpackPsdObject(psdId: selectedPsdId)
        }
    }
    
    func alignSelection(orientation: String){
        var objList: [StringObject] = []
        for objId in selectedStrIDList {
            guard let obj = GetStringObjectForOnePsd(psdId: selectedPsdId, objId: objId) else {return}
            objList.append(obj)
        }
        
        if orientation == "horizontal-left" {
            
            let posXList = objList.map({$0.stringRect.minX})
            let minX = posXList.min()
            if minX != nil {
                for obj in objList {
                    let rect: CGRect = CGRect.init(x: minX!, y: obj.stringRect.minY, width: obj.stringRect.width, height: obj.stringRect.height)
                    psdModel.SetRect(psdId: selectedPsdId, objId: obj.id, value: rect)
                    psdModel.SetAlignment(psdId: selectedPsdId, objId: obj.id, value: .left)
                }
            }
        }else if orientation == "horizontal-center" {
//            let posXList = objList.map({$0.stringRect.minX})
//            let minX = posXList.min() ?? posXList[0]
//            let maxX = posXList.max() ?? posXList[0]
//            guard let midX: CGFloat? = ((minX + maxX) / 2) else {return}
            guard let lastId = selectedStrIDList.last else {return }
            let lasMidX = GetStringObjectForOnePsd(psdId: selectedPsdId, objId: lastId)!.stringRect.midX
            for obj in objList {
                let offset = obj.stringRect.midX - lasMidX
//                let rect: CGRect = CGRect.init(x: minX, y: obj.stringRect.minY, width: obj.stringRect.width, height: obj.stringRect.height)
                psdModel.SetPosForString(psdId: selectedPsdId, objId: obj.id, valueX: obj.stringRect.minX - offset, valueY: obj.stringRect.minY, isOnlyX: true, isOnlyY: false)
                psdModel.SetAlignment(psdId: selectedPsdId, objId: obj.id, value: .center)
                
            }
            
        }else if orientation == "horizontal-right" {
            let posXList = objList.map({$0.stringRect.maxX})
            let maxX = posXList.max()
            if maxX != nil {
                for obj in objList {
                    let rect: CGRect = CGRect.init(x: maxX! - obj.stringRect.width, y: obj.stringRect.minY, width: obj.stringRect.width, height: obj.stringRect.height)
                    psdModel.SetRect(psdId: selectedPsdId, objId: obj.id, value: rect)
                    psdModel.SetAlignment(psdId: selectedPsdId, objId: obj.id, value: .right)
                }
            }
        }else if orientation == "vertical-bottom" {
            let posYList = objList.map({$0.stringRect.maxY})
            let maxY = posYList.max()
            if maxY != nil {
                for obj in objList {
                    let rect: CGRect = CGRect.init(x: obj.stringRect.origin.x, y: maxY! - obj.stringRect.width, width: obj.stringRect.width, height: obj.stringRect.height)
                    psdModel.SetRect(psdId: selectedPsdId, objId: obj.id, value: rect)
//                    psdModel.SetAlignment(psdId: selectedPsdId, objId: obj.id, value: .center)
                }
            }
        }else if orientation == "vertical-center" {
            let posYList = objList.map({$0.stringRect.minY})
//            let posYMaxList = objList.map({$0.stringRect.maxY})
            let minY = posYList.min() ?? posYList[0]
            let maxY = posYList.max() ?? posYList[0]
            guard let midY: CGFloat? = ((minY + maxY) / 2) else {return}
            for obj in objList {
                let rect: CGRect = CGRect.init(x: obj.stringRect.minX, y: midY!, width: obj.stringRect.width, height: obj.stringRect.height)
                psdModel.SetRect(psdId: selectedPsdId, objId: obj.id, value: rect)
//                psdModel.SetAlignment(psdId: selectedPsdId, objId: obj.id, value: .center)
                
            }
        }else if orientation == "vertical-top" {
            let posYList = objList.map({$0.stringRect.maxY})
            let maxY = posYList.max()
            if maxY != nil {
                for obj in objList {
                    let rect: CGRect = CGRect.init(x: obj.stringRect.minX , y: maxY! - obj.stringRect.height, width: obj.stringRect.width, height: obj.stringRect.height)
                    psdModel.SetRect(psdId: selectedPsdId, objId: obj.id, value: rect)
//                    psdModel.SetAlignment(psdId: selectedPsdId, objId: obj.id, value: .center)
                }
            }
        }
        
        
    }
    
    
    
    func DeleteAll(){
        psdModel.psdObjects.removeAll()
        selectedNSImage = NSImage.init()
        processedCIImage = CIImage.init()
    }
    
    func CommitAll(){
        for obj in psdModel.psdObjects{
            SetCommit(psdId: obj.id)
        }
    }
    
}
