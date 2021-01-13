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
    
    @Published var psds: PSD //refacting
    
    @Published var selectedPsdId: Int  //refacting
    @Published var gammaDict: [Int:CGFloat]//refacting
    @Published var expDict: [Int:CGFloat]//refacting
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
        psds = PSD()
        selectedPsdId = 0
        selectedNSImage = NSImage.init()
        processedCIImage = CIImage.init()
        gammaDict = [:]
        expDict = [:]
        selectedStrIDList = []
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
        return psds.psdObjects.first(where: {$0.id == selectedPsdId})
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
            let tmpImageUrl = self.psds.GetPSDObject(psdId: psdId)?.imageURL
            let img = LoadNSImage(imageUrlPath: tmpImageUrl!.path).ToCIImage()!
            let allStrObjs = self.ocr.CreateAllStringObjects(FromCIImage: img)
            
            DispatchQueue.main.async{ [self] in

                var tmpList = self.psds.psdObjects[psdId].stringObjects.filter({$0.status == 1}) //Filter all fixed objects
                
                for obj in allStrObjs {
                    if self.psds.psdObjects[psdId].stringObjects.ContainsSame(obj) == false {
                        tmpList.append(obj)
                    }
                }
                
                psds.UpdateStringObjectsForOnePsd(psdId: psdId, objs: tmpList)
                //self.stringObjectListDict[selectedPsdId]! = tmpList
                
            }
        }
        
        print("obj count: \(psds.GetPSDObject(psdId: psdId)!.stringObjects.count)")
    }
    
    //    //MARK: Intents
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
                
                let hasSame = psds.psdObjects.contains(where: {$0.imageURL == result})
                if hasSame == false {
                    let outId = psds.addPSDObject(imageURL: result)
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
        if psds.psdObjects.contains(where: {psdId == $0.id}) == true {
            selectedNSImage = LoadNSImage(imageUrlPath: GetSelectedPsd()!.imageURL.path)
            UpdateProcessedImage(psdId: psdId)
        }
    }
    
    func ProcessForOnePsd(){
        FetchStringObjects(psdId: selectedPsdId)
    }
    
    
    
}
