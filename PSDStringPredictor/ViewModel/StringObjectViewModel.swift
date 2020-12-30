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
class StringObjectViewModel: ObservableObject{
    
    private var workItem: DispatchWorkItem?
    
    let jsMgr = JSManager()
    //var stringObject: StringObject = StringObject()
    var stringObjectZero: StringObject = StringObject()
    let pixelProcess = PixelProcess()
    let ocr = OCR()

    let fontLeadingTable = [[34,41], [28,41], [22,28], [20,25], [17,22], [16,21], [15,20], [13,18], [12,16], [11,13]]
    
    @Published var stringObjectListData: [StringObject] = []
    
    @Published var stringObjectIDList: [UUID] = []
    @Published var charFrameListData: [CharFrame] = []

    @Published var selectedIDList: [UUID] = []
    @Published var selectedCharImageListObjectList = [CharImageThumbnailObject]()
    @Published var stringObjectStatusDict: [UUID: Int] = [:] //0 normal, 1 fixed, 2 ignored
//    @Published var stringObjectIgnoreDict: [UUID: Bool] = [:]
//    @Published var stringObjectFixedDict: [UUID: Bool] = [:]
    @Published var updateStringObjectList: [UUID] = []
//    @Published var ignoreStringObjectList: [UUID] = []
//    @Published var fixedStringObjectList: [UUID] = []
    @Published var StringObjectNameDict: [UUID:String] = [:]
    
    @Published var DragOffsetDict: [UUID: CGSize] = [:]
    @Published var alignmentDict: [UUID:Int] = [:]
    @Published var psdPageObjectList: [psdPage] = Array(repeating: psdPage(), count: 10)
    @Published var stringObjectOutputList: [StringObject] = []
    
    @Published var stringOverlay: Bool = true
    @Published var frameOverlay: Bool = true
    
    @Published var indicatorTitle: String = ""
    @Published var warningContent: String = ""
    
    @Published var OKForProcess: Bool = false
    
    //    private var workItem: DispatchWorkItem?
    
    func GetAllID() -> [UUID] {
        var res: [UUID] = []
        for obj in stringObjectListData{
            res.append(obj.id)
        }
        return res
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
    
    func indicatorTitleTest(){
        self.indicatorTitle = ""
    }
    
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
    
    func FetchStringObjectsInfo()  {
        let group = DispatchGroup()
        
        let queueCalc = DispatchQueue(label: "calc")
        queueCalc.async(group: group) {
            var allStrObjs = self.PredictStringObjects(FromCIImage: imageProcessViewModel.targetImageProcessed)
            allStrObjs = self.DeleteDescentForStringObjects(allStrObjs)
            
            DispatchQueue.main.async{
                //Refrash the stringobject list
                for obj in self.stringObjectListData {
                    if self.stringObjectStatusDict[obj.id] != 1 {
                        self.stringObjectListData.removeAll(where: {$0.id == obj.id})
                    }

                }
                for obj in allStrObjs {
                    if self.stringObjectListData.ContainsSame(obj) == false {
                        self.stringObjectListData.append(obj)
                        self.stringObjectStatusDict[obj.id] = 0
                    }
                }
                //self.stringObjectListData = allStrObjs
                self.stringObjectIDList = self.GetAllID()
            }
        }

        group.notify(queue: DispatchQueue.main) {
            //self.stringObjectListData = self.FiltStringObjects(originalList: self.stringObjectListData)
            self.FetchCharFrameListData()
            self.FetchStringObjectFontNameDict()
            stringObjectViewModel.indicatorTitle = ""
        }
    }
    
    func FetchStringObjectOutputIDList()-> [UUID]{
        var finalList: [UUID] = []
        for obj in stringObjectListData{
            finalList.append(obj.id)
        }
        for (k,v) in stringObjectStatusDict {
            if v == 2 {
                finalList.removeAll(where: {$0 == k})
            }
        }
        return finalList
    }
    
    func CleanAll(){
        stringObjectListData = []
        charFrameListData = []
        //charFrameListRects = []
        selectedIDList = []
        selectedCharImageListObjectList = [CharImageThumbnailObject]()
        stringObjectStatusDict = [:]
        //stringObjectFixedDict = [:]
        updateStringObjectList = []
//        ignoreStringObjectList = []
//        fixedStringObjectList = []
        stringObjectOutputList = []
        StringObjectNameDict = [:]
        stringOverlay = true
        frameOverlay = true
    }
    
    
    func FetchStringObjectFontNameDict(){
        for obj in stringObjectListData{
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
                descent = descent * 0.8
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
        for (key, value) in stringObjectViewModel.stringObjectStatusDict{
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
        updateStringObjectList = newList.map{$0.id}
        //print("UpdateList count: \(stringObjectViewModel.updateStringObjectList.count)")
        
        for (key, value) in stringObjectViewModel.stringObjectStatusDict{
            if value == 1{
                newList.append(FindStringObjectByID(id: key)! )
            }
        }
        
        stringObjectViewModel.stringObjectOutputList = newList
        
        for (key, value) in stringObjectViewModel.stringObjectStatusDict{
            if value == 2{
                newList.append(FindStringObjectByID(id: key)!)
            }
        }
        
        return (newList)
    }
    
    func CreatePSD(){
        UpdatePSD()
    }
    
    func FetchCharFrameListData() {
        //        charFrameListData.removeAll()
        //        charFrameListData.append(contentsOf: DataStore.charFrameList)
        charFrameListData.removeAll()
        for i in 0 ..< stringObjectListData.count {
            for j in 0 ..< stringObjectListData[i].charRects.count{
                let tmp = CharFrame(rect: stringObjectListData[i].charRects[j], char: String(stringObjectListData[i].charArray[j]), predictedSize: (stringObjectListData[i].charSizeList[j]))
                charFrameListData.append(tmp)
            }
        }
    }
    
//    func FetchCharFrameListRects(){
//        for element in charFrameListData{
//            charFrameListRects.append(element.rect)
//        }
//    }
    
    
    func UpdateSelectedIDList(idList: [UUID] ){
        if selectedIDList.count == 0 {
            self.selectedIDList = []
        }else{
            selectedCharImageListObjectList = []
            self.selectedIDList = idList
            
//            for (index, img) in (selectedStringObjectList.last!.charImageList).enumerated(){
//                let temp = CharImageThumbnailObject(image: img, char: String(selectedStringObjectList.last!.charArray[index]), weight: selectedStringObjectList.last!.charFontWeightList[index], size: Int(selectedStringObjectList.last!.charSizeList[index]))
//                selectedCharImageListObjectList.append( temp )
//            }
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
    
    func GetFixedObjectIDList() -> [UUID]{
        var result: [UUID] = []
        for (k, v) in stringObjectStatusDict {
            if (v == 1 && FindStringObjectByID(id: k) != nil) {
                result.append(k)
            }
        }
        return result

    }
    
    func FindStringObjectByID(id: UUID) -> StringObject?{
        return stringObjectListData.FindByID(id)
    }
    
    func CalcBGColor(obj: StringObject) -> [Float]{
        let img = imageProcessViewModel.targetCIImage.ToCGImage()!
        let color1 = pixelProcess.colorAt(x: Int(obj.stringRect.origin.x), y: Int(imageProcessViewModel.targetNSImage.size.height - obj.stringRect.origin.y), img: img)
        return [Float(color1.redComponent * 255), Float(color1.greenComponent * 255), Float(color1.blueComponent * 255)]
    }
    
    func UpdataIndicatorTitle(_ str: String){
        indicatorTitle = str
    }
    
    func UpdatePSD(){
        let psdPath = DataStore.imagePath
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
        
        var updateList = stringObjectListData
        for (key,value) in stringObjectStatusDict{
            if value == 2{
                updateList.removeAll(where: {$0.id == key})
            }
        }
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
            let cmd = "open " + GetDocumentsPath() + "/Development/PSDStringPredictor/PSDStringPredictor/AdobeScripts/StringCreator.jsx  -a '\(settingViewModel.PSPath)'"
            PythonScriptManager.RunScript(str: cmd)
        }
    }
    
    func SetSelectionToFixed(){
        var resDict = [UUID:Int]()
        for _id in selectedIDList {
            //Check if it is in ignore list
            if stringObjectStatusDict[_id] != nil && stringObjectStatusDict[_id] == 2 {
                //skip next step, go to next obj id
                continue
            }
            //Toggle the t/f status in fix list
            else {
                stringObjectStatusDict[_id] = 1
            }
        }
        //stringObjectStatusDict = resDict
    }
    
    func SetSelectionToIgnored(){
        var resDict = [UUID:Int]()
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
            }else{
                resDict[_id] = 0
            }
            //}
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










