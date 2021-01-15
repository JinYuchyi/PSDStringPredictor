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
    @Published var processedCIImage: CIImage //refacting
    @Published var selectedStrIDList: [UUID]//refacting
    //Others
    @Published var IndicatorText: String = ""
    
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
    
    func UpdateProcessedImage(psdId: Int){
        let _targetImageMasked = imageUtil.ApplyBlockMasks(target: selectedNSImage.ToCIImage()!, psdId: psdId, colorMode: GetSelectedPsd()!.colorMode)
        processedCIImage = imageUtil.ApplyFilters(target: _targetImageMasked, gamma: gammaDict[psdId] ?? 1, exp: expDict[psdId] ?? 0)
        print("gamma: \(gammaDict[psdId]), exp: \(expDict[psdId])")
    }
    
    func FetchStringObjects(psdId: Int){
        let group = DispatchGroup()
        let queueCalc = DispatchQueue(label: "calc")
        queueCalc.async(group: group) {
            let tmpImageUrl = self.psdModel.GetPSDObject(psdId: psdId)?.imageURL
            let img = LoadNSImage(imageUrlPath: tmpImageUrl!.path).ToCIImage()!
            let allStrObjs = self.ocr.CreateAllStringObjects(FromCIImage: img, psdsVM: self)
            
            DispatchQueue.main.async{ [self] in
                var tmpList = self.psdModel.psdObjects[psdId].stringObjects.filter({$0.status == .fixed}) //Filter all fixed objects
                for obj in allStrObjs {
                    if self.psdModel.psdObjects[psdId].stringObjects.ContainsSame(obj) == false {
                        tmpList.append(obj)
                    }
                }
                psdModel.UpdateStringObjectsForOnePsd(psdId: psdId, objs: tmpList)
                IndicatorText = ""
                print("obj count: \(psdModel.GetPSDObject(psdId: psdId)!.stringObjects.count)")
            }
        }
    }
    
    func FetchBGColor(obj: StringObject) -> [Float]{
        let color1 = pixProcess.colorAt(x: Int(obj.stringRect.origin.x), y: Int(selectedNSImage.size.height - obj.stringRect.origin.y), img: selectedNSImage.ToCGImage()!)
        return [Float(color1.redComponent * 255), Float(color1.greenComponent * 255), Float(color1.blueComponent * 255)]
    }
    
//    func SwapLastSelectionWithObject(obj: StringObject){
//        let id = selectedStrIDList.last
//        //Remove from original list
//        if id != nil {
//            GetStringObjectForOnePsd(psdId: selectedPsdId, objId: id!).
//            psds.GetPSDObject(psdId: selectedPsdId)!.stringObjects.removeAll(where: {$0.id == id})
//            //PsdsUtil.shared.RemoveStringObject(psdId: PsdsUtil.shared.GetSelectedPsdId(), objId: id!)
//        }
//        PsdsUtil.shared.AppendStringObjectListDict(psdId: PsdsUtil.shared.GetSelectedPsdId(), stringObject: obj)
//        //stringObjectListData[selectedPSDID]!.append(obj)
//    }
    
    
    //MARK: Intents
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
                    //psds.psdObjects.AppendPsdObjectList(url: result)
                }
            }
            //print("psd count: \(psds.psdObjects.count)")
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
        }
    }
    
    func ProcessForOnePsd(){
        FetchStringObjects(psdId: selectedPsdId)
        print(selectedNSImage.size)
    }
    
    func ProcessForAll(){
        
    }
    
    func CreatePSDForOnePSD(_id: Int){
        let psdPath = psdModel.GetPSDObject(psdId: _id)!.imageURL.path
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
        var updateList = psdModel.GetPSDObject(psdId: _id)!.stringObjects.filter{$0.status != .ignored}
        
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
            
            fontNameList.append(obj.CalcFontPostScriptName())
            positionList.append([Int(obj.stringRect.minX.rounded()), Int((selectedNSImage.size.height - obj.stringRect.minY).rounded())])
            rectList.append([Float(obj.stringRect.minX), Float(obj.stringRect.minY), Float(obj.stringRect.width), Float(obj.stringRect.height)])
            
            //alignment
            if obj.alignment == nil {
                alignmentList.append("left")
            }else {
                alignmentList.append(obj.alignment.rawValue)
            }
            
            //BGColor
            let tmpBGColor = FetchBGColor(obj: obj)
            bgClolorList.append(tmpBGColor)
        }
        
        let success = jsMgr.CreateJSFile(psdPath: psdPath, contentList: contentList, colorList: colorList, fontSizeList: fontSizeList, trackingList: trackingList, fontNameList: fontNameList, positionList: positionList, offsetList: offsetList, alignmentList: alignmentList, rectList: rectList, bgColorList: bgClolorList, isParagraphList: isParagraphList)
        if success == true{
            let jsPath = Bundle.main.path(forResource: "StringCreator", ofType: "jsx")!
            let cmd = "open " + jsPath + "  -a '\(settingViewModel.PSPath)'"
            PythonScriptManager.RunScript(str: cmd)
        }
    }
    
    
    //func GetRealResolution(){}
    
    func FixedBtnTapped(_ _id: UUID){
        if GetStringObjectForOnePsd(psdId: selectedPsdId, objId: _id)?.status == StringObjectStatus.fixed {
            psdModel.SetStatus(psdId: selectedPsdId, objId: _id, value: .normal)
            //stringObjectVM.SetStatusForStringObject(psdId: stringObjectVM.selectedPSDID, objId: id, value: 0)
        }else {
            psdModel.SetStatus(psdId: selectedPsdId, objId: _id, value: .fixed)
            //stringObjectVM.SetStatusForStringObject(psdId: stringObjectVM.selectedPSDID, objId: id, value: 1
        }
    }
    
    func IgnoreBtnTapped(_ _id: UUID){
        if GetStringObjectForOnePsd(psdId: selectedPsdId, objId: _id)?.status == StringObjectStatus.ignored {
            psdModel.SetStatus(psdId: selectedPsdId, objId: _id, value: .normal)
        }else {
            psdModel.SetStatus(psdId: selectedPsdId, objId: _id, value: .ignored)
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
                psdModel.SetStatus(psdId: selectedPsdId, objId: sId, value: StringObjectStatus.fixed)
                allFix = false
            }
        }
        if allFix == true {
            for sId in selectedStrIDList{
                psdModel.SetStatus(psdId: selectedPsdId, objId: sId, value: StringObjectStatus.normal)
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
                psdModel.SetStatus(psdId: selectedPsdId, objId: sId, value: StringObjectStatus.ignored)
                allFix = false
            }
        }
        if allFix == true {
            for sId in selectedStrIDList{
                psdModel.SetStatus(psdId: selectedPsdId, objId: sId, value: StringObjectStatus.normal)
            }
        }
    }
    
}
