//
//  ThumbnailListVM.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 10/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation
import SwiftUI

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
    @Published var prograssScale: CGFloat = 0
    @Published var maskDict: [Int:[CGRect]]  = [:]
    @Published var stringIsOn: Bool = true

    
    let imageUtil = ImageUtil()
    let pixProcess = PixelProcess()
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
        TrackingDataManager.Delete(AppDelegate().persistentContainer.viewContext)
        let objArray = CSVManager.shared.ParsingCsvFileAsTrackingObjectArray(FilePath: path)
        TrackingDataManager.BatchInsert(AppDelegate().persistentContainer.viewContext, trackingObjectList: objArray)
    }
    
    func FetchStandardTable(path: String){
        OSStandardManager.DeleteAll(AppDelegate().persistentContainer.viewContext)
        let objArray = CSVManager.shared.ParsingCsvFileAsFontStandardArray(FilePath: path)
        OSStandardManager.BatchInsert(AppDelegate().persistentContainer.viewContext, FontStandardObjectList: objArray)
    }
    
    func FetchCharacterTable(path: String){
        CharDataManager.Delete(AppDelegate().persistentContainer.viewContext)
        let objArray = CSVManager.shared.ParsingCsvFileAsCharObjArray(FilePath: path)
        CharDataManager.BatchInsert(AppDelegate().persistentContainer.viewContext, CharObjectList: objArray)
    }
    
    func FetchBoundTable(path:String){
        CharBoundsDataManager.Delete(AppDelegate().persistentContainer.viewContext)
        let objArray = CSVManager.shared.ParsingCsvFileAsBoundsObjArray(FilePath: path)
        CharBoundsDataManager.BatchInsert(AppDelegate().persistentContainer.viewContext, CharBoundsList: objArray)
    }
    
    func UpdateProcessedImage(psdId: Int){
        if selectedNSImage.size.width == 0 || selectedNSImage == nil {
            return
        }
        
        let _targetImageMasked = imageUtil.ApplyBlockMasks(target: selectedNSImage.ToCIImage()!, psdId: psdId, rectDict: maskDict, colorMode: GetSelectedPsd()!.colorMode)
        processedCIImage = imageUtil.ApplyFilters(target: _targetImageMasked, gamma: gammaDict[psdId] ?? 1, exp: expDict[psdId] ?? 0)
        //print("gamma: \(gammaDict[psdId]), exp: \(expDict[psdId])")
    }
    
    func FetchStringObjects(psdId: Int){
        var result: [StringObject] = []
        //let group = DispatchGroup()
        //        let queueCalc = DispatchQueue(label: "calc")
        //        queueCalc.async {
        //print("Working on process \(psdId)")
        let tmpImageUrl = self.psdModel.GetPSDObject(psdId: psdId)?.imageURL
        var img = LoadNSImage(imageUrlPath: tmpImageUrl!.path).ToCIImage()!
        img = imageUtil.ApplyBlockMasks(target: img, psdId: psdId, rectDict: maskDict, colorMode: GetSelectedPsd()!.colorMode)
        img = imageUtil.ApplyFilters(target: img, gamma: gammaDict[psdId] ?? 1, exp: expDict[psdId] ?? 0)
        let allStrObjs = self.ocr.CreateAllStringObjects(FromCIImage: img, psdId: psdId, psdsVM: self)
        DispatchQueue.main.async{ [self] in
            var tmpList = self.psdModel.GetPSDObject(psdId: psdId)!.stringObjects.filter({$0.status != .normal}) //Filter all fixed objects
            for obj in allStrObjs {
                if tmpList.ContainsSame(obj) == false {
                    result.append(obj)
                    
                }else{
                    print("same")
                }
            }
            result += tmpList
            psdModel.UpdateStringObjectsForOnePsd(psdId: psdId, objs: result)
            IndicatorText = ""
            //print("obj count: \(psdModel.GetPSDObject(psdId: psdId)!.stringObjects.count)")
            //}
        }
    }
    
    func FetchBGColor(psdId: Int, obj: StringObject) -> [Float]{
        let targetImg = LoadNSImage(imageUrlPath: psdModel.GetPSDObject(psdId: psdId)!.imageURL.path)
        
        let color1 = pixProcess.colorAt(x: Int(obj.stringRect.origin.x), y: Int(targetImg.size.height - obj.stringRect.origin.y), img: targetImg.ToCGImage()!)
        return [Float(color1.redComponent * 255), Float(color1.greenComponent * 255), Float(color1.blueComponent * 255)]
    }
    
    
    
    
    
    //MARK: Intents
    
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
                
                let hasSame = psdModel.psdObjects.contains(where: {$0.imageURL == result})
                if hasSame == false {
                    let outId = psdModel.addPSDObject(imageURL: result)
                    InitDictForOnePsd(psdId: outId )
                    
                    if selectedNSImage.size.width == 0{
                        ThumbnailClicked(psdId: psdModel.psdObjects[0].id)
                    }
                    
                }
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    func ThumbnailClicked(psdId: Int){
        selectedPsdId = psdId
        if psdModel.psdObjects.contains(where: {psdId == $0.id}) == true {
            selectedNSImage = LoadNSImage(imageUrlPath: GetSelectedPsd()!.imageURL.path)
            UpdateProcessedImage(psdId: psdId)
            
            if psdModel.GetPSDObject(psdId: psdId)!.status == PsdStatus.processed{
                psdModel.SetStatusForPsd(psdId: psdId, value: PsdStatus.normal)
            }
        }
    }
    
    func ProcessForOnePsd(){
        
        if selectedNSImage == nil || selectedNSImage.size.width == 0 {
            return
        }
        
        let queueCalc = DispatchQueue(label: "calc")
        queueCalc.async {
            self.FetchStringObjects(psdId: self.selectedPsdId)
            DispatchQueue.main.async{
                self.psdModel.SetStatusForPsd(psdId: self.selectedPsdId, value: .processed)
            }
        }
        IndicatorText = ""
    }
    
    func ProcessForAll(){
        if  selectedNSImage == nil || selectedNSImage.size.width == 0 {
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
        
    }
    
    func CreatePSDForAll(){
        
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
            for psd in psdModel.psdObjects {
                let fileTitle = psd.imageURL.lastPathComponent.components(separatedBy: ".")[0]
                let fileName = fileTitle + ".psd"
                let saveToPath = result.appendingPathComponent(fileName).path
                //print(saveToPath)
                CreatePSDForOnePSD(_id: psd.id, saveToPath: saveToPath)
            }
            //print("psd count: \(psds.psdObjects.count)")
        } else {
            // User clicked on "Cancel"
            return
        }
        
        
    }
    
    func CreatePSDForOnePSD(_id: Int, saveToPath: String){
        guard let obj = psdModel.GetPSDObject(psdId: _id) else {return}
        let psdPath = obj.imageURL.path
        var contentList = [String]()
        var colorList = [[Int]]()
        var fontSizeList:[Float] = []
        var fontNameList: [String] = []
        var positionList = [[Int]]()
        var trackingList = [Float]()
        var offsetList = [[Int16]]()
        var alignmentList = [String]()
        var rectList = [[Float]]()
        var bgClolorList = [[Float]]()
        var isParagraphList = [Bool]()
        var descentOffset : [Float] =  []
        var updateList = psdModel.GetPSDObject(psdId: _id)!.stringObjects.filter{$0.status != .ignored}
        var saveToPath = saveToPath
        
        //        for (key,value) in stringObjectStatusDict[_id]!{
        //            if  value == 2{
        //                updateList!.removeAll(where: {$0.id == key})
        //            }
        //        }
        
        for obj in updateList{
            let newString = obj.content.replacingOccurrences(of: "\n", with: " ")
            contentList.append(newString)
            var tmpColor: [Int] = []
            
            tmpColor = [ Int((Float(obj.color.components![0]) * 255).rounded()),
                         Int((Float(obj.color.components![1]) * 255).rounded()),
                         Int((Float(obj.color.components![2]) * 255).rounded())
            ]
            colorList.append(tmpColor)
            
            isParagraphList.append(obj.isParagraph)
            
            //calc tracking and font size offset
            var o1: CGFloat = 0
            var o2: CGFloat = 0
            if DragOffsetDict[obj.id] != nil {
                o1 = DragOffsetDict[obj.id]!.width
                o2 = DragOffsetDict[obj.id]!.height
            }
            let tmpSize: CGFloat = CGFloat(obj.fontSize - o2)
            fontSizeList.append(Float(tmpSize))
            //let tmpTracking = obj.fontSize * 1000 / obj.tracking
            let tmpTracking = Float((obj.tracking + o1) * 1000 / tmpSize)
            trackingList.append(tmpTracking)
            
            //Calc the offset of String
            var keyvalues: [String: AnyObject] = [:]
            let char = (obj.content.first)
            keyvalues["char"] = String(char!) as AnyObject
            keyvalues["fontSize"] = Int(obj.fontSize.rounded()) as AnyObject
            let items = CharBoundsDataManager.FetchItems(AppDelegate().persistentContainer.viewContext, keyValues: keyvalues)
            if items.count > 0 {
                let offset = [items[0].x1, Int16((Float(items[0].y2 - items[0].y1)/10).rounded())]
                offsetList.append(offset)
            }else{
                offsetList.append([0,0])
            }
            let targetImg = LoadNSImage(imageUrlPath: psdModel.GetPSDObject(psdId: _id)!.imageURL.path)
            fontNameList.append(obj.CalcFontPostScriptName())
            positionList.append([Int(obj.stringRect.minX.rounded()), Int((targetImg.size.height - obj.stringRect.minY).rounded())])
            //Calc Descent
            let tmpDesc = Float(FontUtils.FetchStringDescent(content: obj.content, fontSize: obj.fontSize))
            descentOffset.append(tmpDesc)
            rectList.append([Float(obj.stringRect.minX), Float(obj.stringRect.minY), Float(obj.stringRect.width), Float(obj.stringRect.height)])
            
            //alignment
            if obj.alignment == nil {
                alignmentList.append("left")
            }else {
                alignmentList.append(obj.alignment.rawValue)
            }
            
            //BGColor
            let tmpBGColor = FetchBGColor(psdId: _id, obj: obj)
            bgClolorList.append(tmpBGColor)
        }

        let success = jsMgr.CreateJSFile(psdPath: psdPath, contentList: contentList, colorList: colorList, fontSizeList: fontSizeList, trackingList: trackingList, fontNameList: fontNameList, positionList: positionList, offsetList: offsetList, alignmentList: alignmentList, rectList: rectList, bgColorList: bgClolorList, isParagraphList: isParagraphList, saveToPath: saveToPath , descentOffset: descentOffset)
        
        if success == true{
            let jsPath = Bundle.main.path(forResource: "StringCreator", ofType: "jsx")!
            let cmd = "open " + jsPath + "  -a '\(settingViewModel.PSPath)'"
            PythonScriptManager.RunScript(str: cmd)
        }
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
            return  "alignLeft-round"
        }
        
        psdModel.SetAlignment(psdId: selectedPsdId, objId: _id, value: align.Next())
        //stringObjectVM.alignmentDict[id]  = (stringObjectVM.alignmentDict[id]! + 1) % 3
        switch psdModel.GetPSDObject(psdId: selectedPsdId)!.GetStringObjectFromOnePsd(objId: _id)!.alignment {
        case .left:
            return "alignLeft-round"
        case .center:
            return "alignCenter-round"
        case .right:
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
        //obj!.color = obj!.CalcColor()
        psdModel.SetColorMode(psdId: selectedPsdId, objId: selectedStrIDList.last!, value: cmode)
        //        stringObjectVM.SwapLastSelectionWithObject(obj: obj)
        
        //            if GetLastSelectObject().colorMode == 1{
        //                GetLastSelectObject().colorMode = 2
        //            }else if GetLastSelectObject().colorMode == 2{
        //                GetLastSelectObject().ToggleColorMode()
        //            }
        
    }
    
    func ToggleColorMode(psdId: Int, objId: UUID){
        var psd = psdModel.GetPSDObject(psdId: psdId)
        if psd != nil {
            var strObj = psd!.GetStringObjectFromOnePsd(objId: objId)
            if strObj != nil{
                strObj!.colorMode == .dark ? psdModel.SetColorMode(psdId: psdId, objId: objId, value: .light) : psdModel.SetColorMode(psdId: psdId, objId: objId, value: .dark)
            }
        }
    }
    
    func ToggleFontName(psdId: Int, objId: UUID){
        var psd = psdModel.GetPSDObject(psdId: psdId)
        if psd != nil {
            var strObj = psd!.GetStringObjectFromOnePsd(objId: objId)
            if strObj == nil {return }
            let fName = strObj!.FontName
            let endIndex = fName.lastIndex(of: " ")
            let startIndex = fName.startIndex
            let particialName = fName[startIndex..<endIndex!]
            let weightName = fName[endIndex!..<fName.endIndex]
            
            if weightName == " Regular"  {
                let str = particialName + " Semibold"
                psdModel.SetFontName(psdId: psdId, objId: objId, value: String(str))
                //GetLastSelectObject().FontName = particialName + " Semibold"
                //print("\(stringObjectVM.StringObjectNameDict[id])")
            }else {
                let str = particialName + " Regular"
                psdModel.SetFontName(psdId: psdId, objId: objId, value: String(str))
                //                GetLastSelectObject().FontName = particialName + " Regular"
                //print("\(stringObjectVM.StringObjectNameDict[id])")
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
        let relatedData = RelatedDataJsonObject.init(selectedPsdId: selectedPsdId, gammaDict: gammaDict, expDict: expDict, DragOffsetDict: DragOffsetDict, selectedStrIDList: selectedStrIDList, maskDict: maskDict, stringIsOn: stringIsOn)
        let str = psdModel.ConstellateJsonString(relatedDataJsonObject: relatedData)
        let panel = NSSavePanel()
        panel.nameFieldLabel = "Save File To:"
        panel.nameFieldStringValue = "filename.stringlayers"
        panel.canCreateDirectories = true
        panel.begin { response in
            if response == NSApplication.ModalResponse.OK, let fileUrl = panel.url {
                do {
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
                selectedNSImage = NSImage.init(contentsOf: targetUrl!)!
            }
            //Process Image
            UpdateProcessedImage(psdId: selectedPsdId)
            
        }
    }
    
    //TODO:
    func alignSelectionLeft(){
        
    }
    
    //TODO:
    func alignSelectionCenter(){
        
    }
    
    //TODO:
    func alignSelectionRight(){
        
    }
    
    func DeleteAll(){
        psdModel.psdObjects.removeAll()
        selectedNSImage = NSImage.init()
        processedCIImage = CIImage.init()
    }
    
    //TODO:
    func CommitAll(){
        for obj in psdModel.psdObjects{
            psdModel.SetStatusForPsd(psdId: obj.id, value: .commited)
        }
    }
    
}
