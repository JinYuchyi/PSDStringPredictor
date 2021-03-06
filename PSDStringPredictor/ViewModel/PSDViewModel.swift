//
//  StringModel.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 7/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI
import CoreImage
import Vision
import Foundation

//struct StringObject: Hashable, Codable, Identifiable {
class PSDViewModel: ObservableObject{
    
    private var workItem: DispatchWorkItem?
    
    let jsMgr = JSManager()
    let pixelProcess = PixelProcess()
    let ocr = OCR()
    //let dataResp = DataRepository.shared
    @Published var psds = PSD()

    @Published var stringObjectListData: [Int:[StringObject]] = [:]
    @Published var charFrameListData: [Int:[CharFrame]] = [:]
    @Published var imageUrlDict: [Int: URL] = [:]
    @Published var stringObjectStatusDict: [Int:[UUID: Int]] = [:] //0 normal, 1 fixed, 2 ignored
    @Published var updateStringObjectList: [Int:[UUID]] = [:]
    @Published var StringObjectNameDict: [UUID:String] = [:]
    @Published var DragOffsetDict: [UUID: CGSize] = [:]
    @Published var alignmentDict: [UUID:Int] = [:]
    @Published var stringObjectOutputList: [Int:[StringObject]] = [:]
    @Published var psdColorMode : [Int:Int] = [:]
    @Published var thumbnailList: [Int: NSImage] = [:]
    
    //Global
    @Published var selectedPSDID: Int = 0
    @Published var selectedIDList: [UUID] = []
    @Published var stringOverlay: Bool = true
    @Published var frameOverlay: Bool = true
    @Published var indicatorTitle: String = ""
    @Published var warningContent: String = ""
        
    //Constant
    let fontDecentOffsetScale: CGFloat = 0.6
    let fontLeadingTable = [[34,41], [28,41], [22,28], [20,25], [17,22], [16,21], [15,20], [13,18], [12,16], [11,13]]
    

    init(){
        FetchAllData()
    }
    
    func FetchAllData(){
        //FetchStringObjectListDict()
        FetchCharFrameListDataForOnePSD(_id: selectedPSDID)
        FetchAllThumb()
        FetchAllUrl()
        //print("\(stringObjectListData.count)")
        
    }
    
    func FetchAllThumb(){
        for obj in psds.psdObjects {
            thumbnailList[obj.id] = obj.thumbnail
        }
    }
    
    func FetchAllUrl(){
        for obj in psds.psdObjects {
            imageUrlDict[obj.id] = obj.imageURL
        }
    }

    func FetchPsdColorMode(){
//        psdColorMode = [:]
//        for obj in psds.psdObjects{
//            psdColorMode[obj.id] = obj.FetchColorMode()
//        }
    }
    
    func GetFontLeading(fontSize: Float) -> Float{
        var index = 0
        var result: Float = 0
        for _ in fontLeadingTable{
            if fontLeadingTable.count > (index + 1) {
                if fontSize < Float(fontLeadingTable.last![0]){
                    result = Float(fontLeadingTable.last![1])
                }
                if fontSize > Float(fontLeadingTable.first![0]){
                    result = Float(fontLeadingTable.first![1])
                }
                if ( fontSize < Float(fontLeadingTable[index][0]) && fontSize > Float(fontLeadingTable[index + 1][0]) ) {
                    let f0 = Float(fontLeadingTable[index][0])
                    let f1 = Float(fontLeadingTable[index+1][0])
                    let z0 = Float(fontLeadingTable[index][1])
                    let z1 = Float(fontLeadingTable[index+1][1])
                    result = z0 - ((f0 - fontSize) * (z0 - z1) / (f0 - f1))
                }
                index += 1
            }
        }
        return result
    }
    
//    func indicatorTitleTest(){
//        self.indicatorTitle = ""
//    }
    
    func PredictStringObjects(FromCIImage img: CIImage) -> [StringObject] {
        
//        if img.extent.width > 0{
//            let stringObjects = ocr.CreateAllStringObjects(FromCIImage: img )
//            return stringObjects
//        }
//        else{
//            print("Load Image failed.")
//        }
        return []
    }
    
    func SwapLastSelectionWithObject(obj: StringObject){
        let id = selectedIDList.last
        //Remove from original list
        if id != nil {
            PsdsUtil.shared.RemoveStringObject(psdId: PsdsUtil.shared.GetSelectedPsdId(), objId: id!)
            //stringObjectListData[selectedPSDID]!.removeAll(where: {$0.id == id})
        }
        PsdsUtil.shared.AppendStringObjectListDict(psdId: PsdsUtil.shared.GetSelectedPsdId(), stringObject: obj)
        //stringObjectListData[selectedPSDID]!.append(obj)
    }

    func FetchStringObjectOutputIDListOnePSD(_id: Int)-> [UUID]{
        if self.stringObjectListData[_id] == nil{
            return []
        }
        var finalList: [UUID] = self.stringObjectListData[_id]!.map{$0.id} as! [UUID]

        if stringObjectStatusDict.count > 0{
            for (k,v) in stringObjectStatusDict[_id]! {
                if v == 2 { //Ignore
                    finalList.removeAll(where: {$0 == k})
                }
            }
        }
        
        return finalList
    }
    
    func CleanAllForOnePSD(){
        stringObjectListData[selectedPSDID] = []
        charFrameListData = [:]
        selectedIDList = []
        stringObjectStatusDict = [:]
        updateStringObjectList[selectedPSDID] = []
        stringObjectOutputList = [:]
        StringObjectNameDict = [:]
        stringOverlay = true
        frameOverlay = true
    }
    
    //Obsolete
    func FetchStringObjectFontNameDictForOnePSD(){
//        if stringObjectListData[selectedPSDID] == nil {
//            stringObjectListData[selectedPSDID] = []
//        }
//        for obj in stringObjectListData[selectedPSDID]!{
//            StringObjectNameDict[obj.id] = obj.CalcFontFullName()
//            alignmentDict[obj.id] = obj.alignment
//        }
    }
    
    func DeleteDescentForStringObjects(_ objs:  [StringObject]) -> [StringObject] {
        var result: [StringObject] = []
        var index = 0
        for obj in objs{
            DispatchQueue.main.async{
                self.indicatorTitle = "Correcting strings' position \(index)/\(objs.count)"
            }
//            var highLetterEvenHeight: CGFloat = 0
//            var lowerLetterEvenHeight: CGFloat = 0
            var fontName: String = ""
            if (obj.fontSize >= 20) {
                fontName = "SFProDisplay-Regular"
            }
            else{
                fontName = "SFProText-Regular"
            }
            //Condition of if has p,q,g,y,j character in string,
            //We have to adjust string position and size
//            var n: CGFloat = 0
//            var n1: CGFloat = 0
            var hasLongTail = false
            for (_, c) in obj.charArray.enumerated() {
                if (
                    c == "p" ||
                        c == "q" ||
                        c == "g" ||
                        c == "y" ||
                        c == "j" ||
                        c == "," ||
                        c == ";"
                ) {
                    hasLongTail = true
                }
            }
            
            var descent: CGFloat = 0
            if hasLongTail == true{
                //let fontName = fontName
                descent = FontUtils.GetFontInfo(Font: fontName, Content: obj.content, Size: obj.fontSize).descent
                descent = descent * fontDecentOffsetScale
            }
            
            let newStringRect = CGRect(x: obj.stringRect.origin.x, y: obj.stringRect.origin.y + descent, width: obj.stringRect.width, height: obj.stringRect.height - descent)
            
            var tmpObj = obj
            tmpObj.stringRect = newStringRect
            //&obj.stringRect = CGRect(x: obj.stringRect.origin.x, y: obj.stringRect.origin.y + descent, width: obj.stringRect.width, height: obj.stringRect.height - descent)
            result.append(tmpObj)
            index += 1
        }
        return result
    }

    func FiltStringObjectsForUpdate(id _id: Int, originalList objList: [StringObject]) -> ([StringObject]){
        var newList : [StringObject] = objList
        var ignoreList: [UUID] = []
        var index = 0
        for (key, value) in psdViewModel.stringObjectStatusDict[_id]!{
        //for (key, value) in stringObjectViewModel.stringObjectFixedDict{
            if value == 1 && value == 2 {
                ignoreList.append(key)
            }
        }

        for obj in objList{
            indicatorTitle = "Processing on fixed and removed list \(index)/\(objList.count)"
            //Find the ignore object
            for ignoreID in ignoreList{
                if FindStringObjectByIDOnePSD(psdId: _id, objId: ignoreID)!.stringRect.IsSame(target: obj.stringRect){
                    newList.remove(at: newList.firstIndex(of: obj)!)
                }
            }
            index += 1
        }
        updateStringObjectList[selectedPSDID] = newList.map{$0.id}
        
        for (key, value) in psdViewModel.stringObjectStatusDict[_id]!{
            if value == 1{
                newList.append(FindStringObjectByIDOnePSD(psdId: _id, objId: key)! )
            }
        }
        
        psdViewModel.stringObjectOutputList[selectedPSDID] = newList
        
        for (key, value) in psdViewModel.stringObjectStatusDict[_id]!{
            if value == 2{
                newList.append(FindStringObjectByIDOnePSD(psdId: _id, objId: key)! )
            }
        }
        
        return (newList)
    }

    func FetchCharFrameListDataForOnePSD(_id: Int) {
        
        charFrameListData.removeAll()
        if charFrameListData[_id] == nil{
            charFrameListData[_id] = [CharFrame.init()]
        }
        if stringObjectListData[_id] != nil && charFrameListData[_id] != nil {
            for i in 0 ..< stringObjectListData[_id]!.count  {
                for j in 0 ..< stringObjectListData[_id]![i].charRects.count{
                    let tmp = CharFrame(rect: stringObjectListData[_id]![i].charRects[j], char: String(stringObjectListData[_id]![i].charArray[j]), predictedSize: (stringObjectListData[_id]![i].charSizeList[j]))
                    charFrameListData[_id]!.append(tmp)
                }
            }
        }
        
    }
    
    
    
    func FetchSelectedIDList(idList: [UUID] ){
        if selectedIDList.count == 0 {
            self.selectedIDList = []
        }else{
            self.selectedIDList = idList
        }
    }
    
    func GetIngoreObjectIDListOnePSD(psdId: Int) -> [UUID]{
        var result: [UUID] = []
        if stringObjectStatusDict[psdId] == nil {
            return []
        }
        for (k, v) in stringObjectStatusDict[psdId]! {
            if (v == 2 && FindStringObjectByIDOnePSD(psdId: psdId, objId: k) != nil) {
                result.append(k)
            }
        }
        return result
    }
    
    func GetFixedObjectIDListForOnePSD(psdId: Int) -> [UUID]{
        var result: [UUID] = []
        if stringObjectStatusDict[psdId] == nil {
            return []
        }
        for (k, v) in stringObjectStatusDict[psdId]! {
            if (v == 1 && FindStringObjectByIDOnePSD(psdId: psdId, objId: k) != nil) {
                result.append(k)
            }
        }
        return result

    }
    
    func FindStringObjectByIDOnePSD(psdId: Int, objId: UUID) -> StringObject?{
        for _ in 0..<stringObjectListData[psdId]!.count{
            let find = stringObjectListData[psdId]!.FindByID(objId)
            if find != nil{
               return find
            }
        }
        return nil
    }
    
    func CalcBGColor(obj: StringObject) -> [Float]{
        let img = imageProcessViewModel.targetNSImage.ToCGImage()!
        let color1 = pixelProcess.colorAt(x: Int(obj.stringRect.origin.x), y: Int(imageProcessViewModel.targetNSImage.size.height - obj.stringRect.origin.y), img: img)
        return [Float(color1.redComponent * 255), Float(color1.greenComponent * 255), Float(color1.blueComponent * 255)]
    }
    
    func UpdataIndicatorTitle(_ str: String){
        indicatorTitle = str
    }
    
    
    

    
    func SetSelectionToIgnoredOnePSD(psdId: Int){
        var allIgnored = true
        var resDict = stringObjectStatusDict[psdId]!
        for _id in selectedIDList {
            if stringObjectStatusDict[psdId]![_id] != 2{
                resDict[_id] = 2
                allIgnored = false
            }else{}
        }
        
        if allIgnored == true{
            for _id in selectedIDList {
                resDict[_id] = 0
            }
        }
        
        stringObjectStatusDict[psdId]! = resDict
    }
    
//    func SetStatusForStringObject(psdId: Int, objId: UUID, value: Int) {
//        stringObjectStatusDict[psdId]![objId] = value
//    }
    
    //MARK: Intensions
    func ProcessOnePSD(_id: Int)  {
        let group = DispatchGroup()
        
        let queueCalc = DispatchQueue(label: "calc")
        queueCalc.async(group: group) {
            var allStrObjs = self.PredictStringObjects(FromCIImage: imageProcessViewModel.targetImageProcessed)
            //allStrObjs = self.DeleteDescentForStringObjects(allStrObjs)
            
            DispatchQueue.main.async{ [self] in
                //Refrash the stringobject list
                if self.stringObjectListData[_id] == nil {
                    self.stringObjectListData[_id] = []
                }
                if self.stringObjectStatusDict[_id] == nil {
                    self.stringObjectStatusDict[_id] = [:]
                }
                var tmpList = self.stringObjectListData[_id]!
                for obj in self.stringObjectListData[_id]! {
                    if  self.stringObjectStatusDict[_id]![obj.id] != 1 {
                        tmpList.removeAll(where: {$0.id == obj.id})
                    }
                }
                for obj in allStrObjs {
                    if self.stringObjectListData[_id]!.ContainsSame(obj) == false {
                        tmpList.append(obj)
                        self.stringObjectStatusDict[_id]![obj.id] = 0
                    }
                }
                self.stringObjectListData[_id]! = tmpList
                
            }
        }

        group.notify(queue: DispatchQueue.main) {
            self.FetchCharFrameListDataForOnePSD(_id: self.selectedPSDID)
            print(self.stringObjectListData.count)
            self.FetchStringObjectFontNameDictForOnePSD()
            psdViewModel.indicatorTitle = ""
        }
    }
    
    func CombineStringsOnePSD(psdId: Int){
        //var newObj: StringObject
        var orderedYList: [UUID:CGFloat] = [:]
        var content: String = ""
        var rect: CGRect = CGRect.init()
        var color: CGColor = CGColor.white
        var fontSize: CGFloat = 0
        var fontTracking: CGFloat = 0
       // var fontLeading: Int = 0
        var resultObj: StringObject = StringObject()
        
        if selectedIDList.count > 0{
            //If have selection, we get the first object's information as the paragraph infomation
            rect = stringObjectListData[psdId]!.FindByID(selectedIDList[0])!.stringRect
            color = stringObjectListData[psdId]!.FindByID(selectedIDList[0])!.color
            fontSize = stringObjectListData[psdId]!.FindByID(selectedIDList[0])!.fontSize
            fontTracking = stringObjectListData[psdId]!.FindByID(selectedIDList[0])!.tracking
            resultObj = stringObjectListData[psdId]!.FindByID(selectedIDList[0])!
        }
        
        //Calc and sort each object's Y position, for gettomg the order of string
        for id in selectedIDList{
            let obj = stringObjectListData[psdId]!.FindByID(id)!
            rect = rect.union(obj.stringRect)
            orderedYList[obj.id] = obj.stringRect.minY
        }
        let resultIDList = orderedYList.sorted {$0.1 > $1.1}
        var index = 0
        for (_key, _) in resultIDList{
            let str = stringObjectListData[psdId]!.FindByID(_key)!.content
            content += (index == 0 ? "" : "\n") + str
            index += 1
        }

        resultObj.stringRect = rect //CGRect.init(x: rect.minX, y: rect.minY - rect.height, width: rect.width, height: rect.height)
        resultObj.color = color
        resultObj.fontSize = fontSize
        resultObj.tracking = fontTracking
        resultObj.content = content
        resultObj.isParagraph = true
                
        selectedIDList.removeAll()
        selectedIDList.append(resultObj.id)
        
        for d in resultIDList{
            stringObjectListData[psdId]!.removeAll(where: {$0.id == d.key})
        }
        
        stringObjectListData[psdId]!.append(resultObj)
        selectedIDList.append(resultObj.id)
        updateStringObjectList[psdId]!.append(resultObj.id)
    }

    func LoadImageBtnPressed(){
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
                    psds.addPSDObject(imageURL: result)
                }
            }
        } else {
            // User clicked on "Cancel"
            return
        }
        
        //After load images, process images
        FetchAllData()
    }
    
    func PsdSelected(psdId: Int){
        selectedPSDID = psdId
        FetchAllData()
        let targetObj = psds.psdObjects.first(where: {$0.id == psdId})
        if targetObj != nil {
            imageProcessViewModel.SetTargetNSImage(LoadNSImage(imageUrlPath: targetObj!.imageURL.path))
            imageProcessViewModel.showImage = true
            //print(imageProcessViewModel.targetNSImage.size)
        }
    }
    
    
    
}










