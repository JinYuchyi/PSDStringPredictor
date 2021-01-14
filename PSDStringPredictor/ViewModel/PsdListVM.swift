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
    }
    
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
