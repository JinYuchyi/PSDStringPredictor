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
    
    @Published var psdPageObjectList: [psdPage] = Array(repeating: psdPage(), count: 10)
    
    @Published var stringObjectOutputList: [StringObject] = []
    
    @Published var stringOverlay: Bool = true
    @Published var frameOverlay: Bool = true
    
    func PredictStrings()  {
        stringObjectListData = stringObject.PredictStringObjects(FromCIImage: DataStore.targetImageProcessed)
        //stringObjectListData = DataStore.stringObjectList
        DataStore.FillCharFrameList()
        FetchCharFrameListData()
        FetchCharFrameListRects()
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
        for obj in DataStore.stringObjectList{
            contentList.append(obj.content)
            var tmpColor: [Int] = []

            tmpColor = [ Int((Float(obj.color.components![0]) * 255).rounded()),
                         Int((Float(obj.color.components![1]) * 255).rounded()),
                         Int((Float(obj.color.components![2]) * 255).rounded())
            ]
            colorList.append(tmpColor)
            fontSizeList.append(Int(obj.fontSize.rounded()))
            //Calc the offset
            var keyvalues: [String: AnyObject] = [:]
            let char = (obj.content.first)
            if (char!.isNumber || char!.isLetter){
                keyvalues["char"] = String(char!) as AnyObject
                keyvalues["fontSize"] = Int(obj.fontSize.rounded()) as AnyObject
                let items = CharBoundsDataManager.FetchItems(AppDelegate().persistentContainer.viewContext, keyValues: keyvalues)
                if items.count > 0 {
                   let offset = [items[0].x1, Int16((Float(items[0].y2 - items[0].y1)/10).rounded())]
                    //let offset = [items[0].x1, ((items[0].y2 - items[0].y1))]
                    offsetList.append(offset)
                }
            }
            
            fontNameList.append(obj.CalcFontPostScriptName())
            positionList.append([Int(obj.stringRect.minX.rounded()), Int((DataStore.targetNSImage.size.height - obj.stringRect.minY).rounded())])
            trackingList.append(Int(obj.trackingPS))
        }
        
        
        
        let success = jsMgr.CreateJSFile(psdPath: psdPath, contentList: contentList, colorList: colorList, fontSizeList: fontSizeList, trackingList: trackingList, fontNameList: fontNameList, positionList: positionList, offsetList: offsetList)
        
            if success == true{
                let cmd = "open /Users/ipdesign/Documents/Development/PSDStringPredictor/PSDStringPredictor/AdobeScripts/StringCreator.jsx  -a '/Applications/Adobe Photoshop 2020/Adobe Photoshop 2020.app'"
                PythonScriptManager.RunScript(str: cmd)
            }
    }
    



    
}
    
 
    

    
    


