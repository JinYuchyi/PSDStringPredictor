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
    
    @Published var psds = PSD()

    @Published var stringObjectListData: [Int:[StringObject]] = [:]
    @Published var charFrameListData: [Int:[CharFrame]] = [:]
    @Published var stringObjectStatusDict: [Int:[UUID: Int]] = [:] //0 normal, 1 fixed, 2 ignored
    @Published var updateStringObjectList: [Int:[UUID]] = [:]
    @Published var StringObjectNameDict: [UUID:String] = [:]
    @Published var DragOffsetDict: [UUID: CGSize] = [:]
    @Published var alignmentDict: [UUID:Int] = [:]
    @Published var stringObjectOutputList: [Int:[StringObject]] = [:]
    
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

    //    private var workItem: DispatchWorkItem?
    
//    func GetAllID() -> [UUID] {
//        var res: [UUID] = []
//        for obj in stringObjectListData{
//            res.append(obj.id)
//        }
//        return res
//    }
    
    func FetchStringObjectListDict(){
        stringObjectListData = [:]
        for obj in psds.PSDObjects{
            stringObjectListData[obj.id] = obj.stringObjects
        }
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
        //var strObjs = [StringObject]()
        
        if img.extent.width > 0{
            let stringObjects = ocr.CreateAllStringObjects(FromCIImage: img )
            return stringObjects
        }
        else{
            print("Load Image failed.")
        }
        return []
    }
    
    func SwapLastSelectionWithObject(obj: StringObject){
        //psds.PSDObjects[]
        let id = selectedIDList.last
        //Add to original list
        
        //selectedIDList.append(obj.id)
        //Remove from original list
        if id != nil {
            stringObjectListData[selectedPSDID]!.removeAll(where: {$0.id == id})
            //selectedIDList.removeAll(where: {$0 == id})
        }
        stringObjectListData[selectedPSDID]!.append(obj)
        
    }
    
    //Intention
    
    func ProcessOnePSD(_id: Int)  {
        let group = DispatchGroup()
        
        let queueCalc = DispatchQueue(label: "calc")
        queueCalc.async(group: group) {
            var allStrObjs = self.PredictStringObjects(FromCIImage: imageProcessViewModel.targetImageProcessed)
            allStrObjs = self.DeleteDescentForStringObjects(allStrObjs)
            
            DispatchQueue.main.async{ [self] in
                //Refrash the stringobject list
                var tmpList = self.stringObjectListData[_id]!
                for obj in self.stringObjectListData[_id]! {
                    if self.stringObjectStatusDict[_id]![obj.id] != 1 {
                        tmpList.removeAll(where: {$0.id == obj.id})
                        //self.stringObjectListData.removeAll(where: {$0.id == obj.id})
                    }
                }
                for obj in allStrObjs {
                    if self.stringObjectListData[_id]!.ContainsSame(obj) == false {
                        tmpList.append(obj)
                        self.stringObjectStatusDict[obj.id] = 0
                    }
                }
                self.stringObjectListData[self.selectedPSDID]! = allStrObjs
                self.FetchStringObjectListDict()
            }
        }

        group.notify(queue: DispatchQueue.main) {
            self.FetchCharFrameListDataForOnePSD()
            self.FetchStringObjectFontNameDictForOnePSD()
            psdViewModel.indicatorTitle = ""
        }
    }
    
    func FetchStringObjectOutputIDListOnePSD(_id: Int)-> [UUID]{
        var finalList: [UUID] = self.stringObjectListData[_id]!.map({$0.id})
//        for obj in stringObjectListData{
//            finalList.append(obj.id)
//        }
        for (k,v) in stringObjectStatusDict[_id]! {
            if v == 2 { //Ignore
                finalList.removeAll(where: {$0 == k})
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
    
    
    func FetchStringObjectFontNameDictForOnePSD(){
        for obj in stringObjectListData[selectedPSDID]!{
            StringObjectNameDict[obj.id] = obj.CalcFontFullName()
            alignmentDict[obj.id] = obj.alignment
        }
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
    
//    func FiltStringObjects1(originalList objList: [StringObject]) -> (updateL: [StringObject], redrawList: [StringObject]){
//
//    }
    
    func FiltStringObjectsForUpdate(originalList objList: [StringObject]) -> ([StringObject]){
        var newList : [StringObject] = objList
        var ignoreList: [UUID] = []
        var index = 0
        for (key, value) in psdViewModel.stringObjectStatusDict{
        //for (key, value) in stringObjectViewModel.stringObjectFixedDict{
            if value == 1 && value == 2 {
                ignoreList.append(key)
            }
        }

        for obj in objList{
            indicatorTitle = "Processing on fixed and removed list \(index)/\(objList.count)"
            //Find the ignore object
            for ignoreID in ignoreList{
                //if value == true {
                //print("\(key.content) is fixed")
                //Compare ignore obj with new obj, if rect overlap, remove from newlist
                //if ignoreID == obj.id{
                if FindStringObjectByID(id: ignoreID)!.stringRect.IsSame(target: obj.stringRect){
                    //print("Same: \(ignoreObj.content)")
                    newList.remove(at: newList.firstIndex(of: obj)!)
                }
                //continue
                //}
            }
            index += 1
        }
        updateStringObjectList[selectedPSDID] = newList.map{$0.id}
        
        for (key, value) in psdViewModel.stringObjectStatusDict{
            if value == 1{
                newList.append(FindStringObjectByID(id: key)! )
            }
        }
        
        psdViewModel.stringObjectOutputList[selectedPSDID] = newList
        
        for (key, value) in psdViewModel.stringObjectStatusDict{
            if value == 2{
                newList.append(FindStringObjectByID(id: key)!)
            }
        }
        
        return (newList)
    }
    
//    func CreatePSD(){
//        UpdatePSD()
//    }
    
    func FetchCharFrameListDataForOnePSD() {
        charFrameListData.removeAll()
        for i in 0 ..< stringObjectListData[selectedPSDID]!.count {
            for j in 0 ..< stringObjectListData[selectedPSDID]![i].charRects.count{
                let tmp = CharFrame(rect: stringObjectListData[selectedPSDID]![i].charRects[j], char: String(stringObjectListData[selectedPSDID]![i].charArray[j]), predictedSize: (stringObjectListData[selectedPSDID]![i].charSizeList[j]))
                charFrameListData[selectedPSDID]!.append(tmp)
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
    
    func GetIngoreObjectIDList() -> [UUID]{
        var result: [UUID] = []
        for (k, v) in stringObjectStatusDict {
            if (v == 2 && FindStringObjectByID(id: k) != nil) {
                result.append(k)
            }
        }
        return result
    }
    
    func GetFixedObjectIDListForOnePSD(_id: Int) -> [UUID]{
        var result: [UUID] = []
        for (k, v) in stringObjectStatusDict {
            if (v == 1 && FindStringObjectByID(id: k) != nil) {
                result.append(k)
            }
        }
        return result

    }
    
    func FindStringObjectByID(id: UUID) -> StringObject?{
        for i in 0..<stringObjectListData.count{
            let find = stringObjectListData[i]?.FindByID(id)
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
    
    func CreatePSDForOnePSD(_id: Int){
        let psdPath = psds.PSDObjects[_id].imageURL.path
        var contentList = [String]()
        var colorList = [[Int]]()
        var fontSizeList:[Float] = []
        var fontNameList: [String] = []
        var positionList = [[Int]]()
        var trackingList = [Float]()
        var offsetList = [[Int16]]()
        var alignmentList = [Int]()
        var rectList = [[Float]]()
        var bgClolorList = [[Float]]()
        var isParagraphList = [Bool]()
        
        var updateList = stringObjectListData[_id]
        
        for (key,value) in stringObjectStatusDict[_id]{
            if  value == 2{
                updateList!.removeAll(where: {$0.id == key})
            }
        }
        
        for obj in updateList!{
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
            positionList.append([Int(obj.stringRect.minX.rounded()), Int((imageProcessViewModel.targetNSImage.size.height - obj.stringRect.minY).rounded())])
            rectList.append([Float(obj.stringRect.minX), Float(obj.stringRect.minY), Float(obj.stringRect.width), Float(obj.stringRect.height)])
            
            //alignment
            if alignmentDict[obj.id] == nil {
                alignmentList.append(0)
            }else {
                alignmentList.append(alignmentDict[obj.id]!)
            }
            
            //BGColor
            let tmpBGColor = CalcBGColor(obj: obj)
            bgClolorList.append(tmpBGColor)
        }
        
        let success = jsMgr.CreateJSFile(psdPath: psdPath, contentList: contentList, colorList: colorList, fontSizeList: fontSizeList, trackingList: trackingList, fontNameList: fontNameList, positionList: positionList, offsetList: offsetList, alignmentList: alignmentList, rectList: rectList, bgColorList: bgClolorList, isParagraphList: isParagraphList)
        if success == true{
            let jsPath = Bundle.main.path(forResource: "StringCreator", ofType: "jsx")!
            let cmd = "open " + jsPath + "  -a '\(settingViewModel.PSPath)'"
            PythonScriptManager.RunScript(str: cmd)
        }
    }
    
    func SetSelectionToFixed(){
        var allFix = true
        var resDict = stringObjectStatusDict
        for _id in selectedIDList {
//            if resDict[_id] == 1{
//                allFix = false
//            }
            
            //Check if it is in ignore list
            if stringObjectStatusDict[_id] != 1 {
                //skip next step, go to next obj id
                resDict[_id] = 1
                allFix = false
            }
            //Toggle the t/f status in fix list
            else {
                
               
            }
        }
        
        if allFix == true{
            for _id in selectedIDList {
                resDict[_id] = 0
            }
        }
        
        stringObjectStatusDict = resDict
    }
    
    func SetSelectionToIgnored(){
        var allIgnored = true
        var resDict = stringObjectStatusDict
        for _id in selectedIDList {
            

            //Check if it is in ignore list
//            if stringObjectStatusDict[_id] != nil && stringObjectStatusDict[_id] == 1 {
//                //skip next step, go to next obj id
//                continue
//            }
            //Toggle the t/f status in fix list
            //else {
            if stringObjectStatusDict[_id] != 2{
                resDict[_id] = 2
                allIgnored = false
            }else{
                
                //resDict[_id] = 0
            }
            
            //}
        }
        
        if allIgnored == true{
            for _id in selectedIDList {
                resDict[_id] = 0
            }
        }
        
        stringObjectStatusDict = resDict
    }
    
    func CombineStrings(){
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
            rect = stringObjectListData.FindByID(selectedIDList[0])!.stringRect
            color = stringObjectListData.FindByID(selectedIDList[0])!.color
            fontSize = stringObjectListData.FindByID(selectedIDList[0])!.fontSize
            fontTracking = stringObjectListData.FindByID(selectedIDList[0])!.tracking
            resultObj = stringObjectListData.FindByID(selectedIDList[0])!
        }
        
        //Calc and sort each object's Y position, for gettomg the order of string
        for id in selectedIDList{
            let obj = stringObjectListData.FindByID(id)!
            rect = rect.union(obj.stringRect)
            orderedYList[obj.id] = obj.stringRect.minY
        }
        let resultIDList = orderedYList.sorted {$0.1 > $1.1}
        var index = 0
        for (_key, _) in resultIDList{
            let str = stringObjectListData.FindByID(_key)!.content
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
            stringObjectListData.removeAll(where: {$0.id == d.key})
        }
        
        stringObjectListData.append(resultObj)
        selectedIDList.append(resultObj.id)
        updateStringObjectList.append(resultObj.id)
    }
    
}










