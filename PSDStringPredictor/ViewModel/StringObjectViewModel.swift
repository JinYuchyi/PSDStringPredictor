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
    var stringObject: StringObject = StringObject()
    let pixelProcess = PixelProcess()
    let ocr = OCR()
    //@ObservedObject var imageViewModel: ImageProcess = ImageProcess()
    //var data: DataStore = DataStore()
    @Published var stringObjectListData: [StringObject] = []
    @Published var charFrameListData: [CharFrame] = []
    @Published var charFrameListRects: [CGRect] = []
    //@Published var StringLabelListData: [StringLabelObject] = []
    @Published var selectedStringObject: StringObject = StringObject.init()
    @Published var selectedCharImageListObjectList = [CharImageThumbnailObject]()
    //@Published var selectedStringObjectFontName: String = ""
    
    @Published var stringObjectIgnoreDict: [StringObject: Bool] = [:]
    @Published var stringObjectFixedDict: [StringObject: Bool] = [:]
    @Published var updateStringObjectList: [StringObject] = []
    @Published var ignoreStringObjectList: [StringObject] = []
    @Published var fixedStringObjectList: [StringObject] = []
    @Published var StringObjectNameDict: [UUID:String] = [:]
    
    @Published var DragOffsetDict: [StringObject: CGSize] = [:]
    @Published var alignmentDict: [UUID:Int] = [:]
    @Published var psdPageObjectList: [psdPage] = Array(repeating: psdPage(), count: 10)
    @Published var stringObjectOutputList: [StringObject] = []
    
    @Published var stringOverlay: Bool = true
    @Published var frameOverlay: Bool = true
    
    @Published var indicatorTitle: String = ""
    @Published var warningContent: String = ""
    
    @Published var OKForProcess: Bool = false
    
    //    private var workItem: DispatchWorkItem?
    
    func indicatorTitleTest(){
        self.indicatorTitle = ""
    }
    
    func PredictStringObjects(FromCIImage img: CIImage) -> [StringObject] {
        var strObjs = [StringObject]()
        
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
        //queueCalc.async(group: group) {
        let allStrObjs = self.PredictStringObjects(FromCIImage: imageProcessViewModel.targetImageProcessed)
        //}
        
        stringObjectListData = allStrObjs
        //        group.notify(queue: DispatchQueue.main) {
        //            print("all task done")
        //        }
        stringObjectListData = DeleteDescentForStringObjects(stringObjectListData)
        stringObjectListData = FiltStringObjects(originalList: stringObjectListData)
        //DataStore.FillCharFrameList()
        self.FetchCharFrameListData()
        self.FetchCharFrameListRects()
        self.FetchStringObjectFontNameDict()
        
        
        print("updateStringObjectList: \(updateStringObjectList.count)")
    }
    
    func CleanAll(){
        stringObjectListData = []
        charFrameListData = []
        charFrameListRects = []
        selectedStringObject = StringObject.init()
        selectedCharImageListObjectList = [CharImageThumbnailObject]()
        stringObjectIgnoreDict = [:]
        stringObjectFixedDict = [:]
        updateStringObjectList = []
        ignoreStringObjectList = []
        fixedStringObjectList = []
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
    
    func DeleteDescentForStringObjects(_ objs: [StringObject]) -> [StringObject] {
        var result: [StringObject] = []
        for obj in objs{
            var highLetterEvenHeight: CGFloat = 0
            var lowerLetterEvenHeight: CGFloat = 0
            var fontName: String = ""
            if (obj.fontSize >= 20) {
                fontName = "SFProDisplay-Regular"
            }
            else{
                fontName = "SFProText-Regular"
            }
            //Condition of if has p,q,g,y,j character in string,
            //We have to adjust string position and size
            var n: CGFloat = 0
            var n1: CGFloat = 0
            var hasLongTail = false
            for (index, c) in obj.charArray.enumerated() {
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
            let tmpObj = StringObject(obj.content, newStringRect, obj.observation, obj.charArray, obj.charRects, charImageList: obj.charImageList, obj.confidence)
            result.append(tmpObj)
        }
        return result
    }
    
    func FiltStringObjects(originalList objList: [StringObject]) -> ([StringObject]){
        var newList : [StringObject] = objList
        var ignoreList: [StringObject] = []
        var index = 0
        fixedStringObjectList.removeAll()
        ignoreStringObjectList.removeAll()
        
        for (key, value) in stringObjectViewModel.stringObjectFixedDict{
            if value == true {
                ignoreList.append(key)
                fixedStringObjectList.append(key)
            }
        }
        
        for (key, value) in stringObjectIgnoreDict{
            if value == true {
                ignoreList.append(key)
                ignoreStringObjectList.append(key)
            }
        }
        //TODO: Update list error.
        for obj in objList{
            //Find the ignore object
            for ignoreObj in ignoreList{
                //if value == true {
                //print("\(key.content) is fixed")
                //Compare ignore obj with new obj, if rect overlap, remove from newlist
                if ignoreObj.stringRect.IsSame(target: obj.stringRect){
                    //print("Same: \(ignoreObj.content)")
                    newList.remove(at: newList.firstIndex(of: obj)!)
                }
                //continue
                //}
            }
            index += 1
        }
        updateStringObjectList = newList
        //print("UpdateList count: \(stringObjectViewModel.updateStringObjectList.count)")
        
        for (key, value) in stringObjectViewModel.stringObjectFixedDict{
            newList.append(key)
        }
        
        stringObjectViewModel.stringObjectOutputList = newList
        
        for (key, value) in stringObjectViewModel.stringObjectIgnoreDict{
            newList.append(key)
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
    
    func FetchCharFrameListRects(){
        for element in charFrameListData{
            charFrameListRects.append(element.rect)
        }
    }
    
    
    func UpdateSelectedStringObject(selectedStringObject: StringObject ){
        selectedCharImageListObjectList = []
        self.selectedStringObject = selectedStringObject
        for (index, img) in (selectedStringObject.charImageList).enumerated(){
            let temp = CharImageThumbnailObject(image: img, char: String(selectedStringObject.charArray[index]), weight: selectedStringObject.charFontWeightList[index], size: Int(selectedStringObject.charSizeList[index]))
            selectedCharImageListObjectList.append( temp )
        }
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
        var psdPath = DataStore.imagePath
        var contentList = [String]()
        var colorList = [[Int]]()
        var fontSizeList:[Float] = []
        var fontNameList: [String] = []
        var positionList = [[Int]]()
        var trackingList = [Float]()
        var offsetList = [[Int16]]()
        var trackingOffsetList = [Float]()
        var sizeOffsetList = [Float]()
        var alignmentList = [Int]()
        var rectList = [[Float]]()
        var bgClolorList = [[Float]]()
        for obj in stringObjectListData{
            contentList.append(obj.content)
            var tmpColor: [Int] = []
            
            tmpColor = [ Int((Float(obj.color.components![0]) * 255).rounded()),
                         Int((Float(obj.color.components![1]) * 255).rounded()),
                         Int((Float(obj.color.components![2]) * 255).rounded())
            ]
            colorList.append(tmpColor)
            
            //calc tracking and font size offset
            var o1: CGFloat = 0
            var o2: CGFloat = 0
            if DragOffsetDict[obj] != nil {
                o1 = DragOffsetDict[obj]!.width
                o2 = DragOffsetDict[obj]!.height
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
        
        
        let success = jsMgr.CreateJSFile(psdPath: psdPath, contentList: contentList, colorList: colorList, fontSizeList: fontSizeList, trackingList: trackingList, fontNameList: fontNameList, positionList: positionList, offsetList: offsetList, alignmentList: alignmentList, rectList: rectList, bgColorList: bgClolorList)
        if success == true{
            let cmd = "open /Users/ipdesign/Documents/Development/PSDStringPredictor/PSDStringPredictor/AdobeScripts/StringCreator.jsx  -a '/Applications/Adobe Photoshop 2020/Adobe Photoshop 2020.app'"
            PythonScriptManager.RunScript(str: cmd)
        }
    }
    
}








