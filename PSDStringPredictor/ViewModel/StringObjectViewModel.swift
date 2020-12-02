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
//    var id: Int
//    var content: String
//    var position: [CGFloat]
//    var width: CGFloat
//    var height: CGFloat
//    var tracking: CGFloat
//    var fontSize: CGFloat
//}

//struct StringObject: Hashable, Codable, Identifiable {
class StringObjectViewModel: ObservableObject{
    let jsMgr = JSManager()
    var stringObject: StringObject = StringObject()
    
    //@ObservedObject var imageViewModel: ImageProcess = ImageProcess()
    //var data: DataStore = DataStore()
    @Published var stringObjectListData: [StringObject] = []
    @Published var charFrameListData: [CharFrame] = []
    @Published var charFrameListRects: [CGRect] = []
    //@Published var StringLabelListData: [StringLabelObject] = []
    @Published var selectedStringObject: StringObject = StringObject.init()
    @Published var selectedCharImageListObjectList = [CharImageThumbnailObject]()
    
    @Published var stringObjectIgnoreDict: [StringObject: Bool] = [:]
    @Published var stringObjectFixedDict: [StringObject: Bool] = [:]
    @Published var updateStringObjectList: [StringObject] = []
    @Published var ignoreStringObjectList: [StringObject] = []
    @Published var fixedStringObjectList: [StringObject] = []
    
    @Published var DragOffsetDict: [StringObject: CGSize] = [:]
    
    @Published var psdPageObjectList: [psdPage] = Array(repeating: psdPage(), count: 10)
    
    @Published var stringObjectOutputList: [StringObject] = []
    
    @Published var stringOverlay: Bool = true
    @Published var frameOverlay: Bool = true
    
    //    @Published var trackingToPSDList: [Float] =  []
    //    @Published var SizeToPSDList: [Float] = []
    
    func PredictStrings()  {
        stringObjectListData = stringObject.PredictStringObjects(FromCIImage: DataStore.targetImageProcessed)
        //stringObjectListData = DataStore.stringObjectList
        DataStore.FillCharFrameList()
        FetchCharFrameListData()
        FetchCharFrameListRects()
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
        stringOverlay = true
        frameOverlay = true
    }
    
    
    
    func CreatePSD(){
        UpdatePSD()
    }
    
    func FetchCharFrameListData() {
        charFrameListData.removeAll()
        charFrameListData.append(contentsOf: DataStore.charFrameList)
        
    }
    
    func FetchCharFrameListRects(){
        for element in DataStore.charFrameList{
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
        print("Color: \(selectedStringObject.color.components![0]), \(selectedStringObject.color.components![1]), \(selectedStringObject.color.components![2])")
    }
    
    
    
    func UpdatePSD(){
        
        var psdPath = DataStore.imagePath
        var contentList = [String]()
        var colorList = [[Int]]()
        var fontSizeList:[Int] = []
        var fontNameList: [String] = []
        var positionList = [[Int]]()
        var trackingList = [Int]()
        var offsetList = [[Int16]]()
        var trackingOffsetList = [Float]()
        var sizeOffsetList = [Float]()
        
        for obj in DataStore.stringObjectList{
            contentList.append(obj.content)
            var tmpColor: [Int] = []
            
            tmpColor = [ Int((Float(obj.color.components![0]) * 255).rounded()),
                         Int((Float(obj.color.components![1]) * 255).rounded()),
                         Int((Float(obj.color.components![2]) * 255).rounded())
            ]
            colorList.append(tmpColor)
            
            //calc tracking and font size offset
//            var o1: CGFloat = 0
//            var o2: CGFloat = 0
//            if DragOffsetDict[obj] != nil {
//                o1 = DragOffsetDict[obj]!.width
//                o2 = DragOffsetDict[obj]!.height
//            }
//            let tmpSize: Float = Float(obj.fontSize - o2)
//            fontSizeList.append(Int(tmpSize.rounded()))
//            let tmpTracking = Float(obj.trackingPS + Int16(o1.rounded())) * 1000 / tmpSize
//            trackingList.append(Int(tmpTracking.rounded()))
            fontSizeList.append(Int(obj.fontSize.rounded()))
            let tmpTracking = obj.fontSize * 1000 / obj.tracking
            trackingList.append(Int(obj.tracking.rounded()))
            
            
            //Calc the offset of String
            var keyvalues: [String: AnyObject] = [:]
            let char = (obj.content.first)
            //if (char!.isNumber || char!.isLetter){
            keyvalues["char"] = String(char!) as AnyObject
            keyvalues["fontSize"] = Int(obj.fontSize.rounded()) as AnyObject
            let items = CharBoundsDataManager.FetchItems(AppDelegate().persistentContainer.viewContext, keyValues: keyvalues)
            if items.count > 0 {
                let offset = [items[0].x1, Int16((Float(items[0].y2 - items[0].y1)/10).rounded())]
                offsetList.append(offset)
            }else{
                offsetList.append([0,0])
            }
            //}
            
            fontNameList.append(obj.CalcFontPostScriptName())
            positionList.append([Int(obj.stringRect.minX.rounded()), Int((DataStore.targetNSImage.size.height - obj.stringRect.minY).rounded())])
            
        }
        
        
        
        let success = jsMgr.CreateJSFile(psdPath: psdPath, contentList: contentList, colorList: colorList, fontSizeList: fontSizeList, trackingList: trackingList, fontNameList: fontNameList, positionList: positionList, offsetList: offsetList)
        if success == true{
            let cmd = "open /Users/ipdesign/Documents/Development/PSDStringPredictor/PSDStringPredictor/AdobeScripts/StringCreator.jsx  -a '/Applications/Adobe Photoshop 2020/Adobe Photoshop 2020.app'"
            PythonScriptManager.RunScript(str: cmd)
        }
    }
    
}








