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

    @Published var stringObjectIgnoreDict: [UUID: Bool] = [:]
    @Published var stringObjectFixedDict: [UUID: Bool] = [:]
    
    func PredictStrings()  {
        stringObject.PredictStringObjects(FromCIImage: DataStore.targetImageProcessed)
        stringObjectListData = DataStore.stringObjectList
        DataStore.FillCharFrameList()
        FetchCharFrameListData()
        FetchCharFrameListRects()
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
        var colorList = [[Float]]()
        var fontSizeList:[Int] = []
        var fontNameList: [String] = []
        var positionList = [[Int]]()
        
        for obj in DataStore.stringObjectList{
            contentList.append(obj.content)
            var tmpColor: [Float] = []
            print("Color: \(Float(obj.color.redComponent))")
            if #available(OSX 11, *) {
                //TODO: Color data incorrect.
                tmpColor = [ Float(obj.color.redComponent), Float(obj.color.greenComponent), Float(obj.color.blueComponent) ]
            } else {
                // Fallback on earlier versions
            }
            colorList.append(tmpColor)
            fontSizeList.append(Int(obj.fontSize.rounded()))
            fontNameList.append(obj.CalcFontFullName())
            positionList.append([Int(obj.stringRect.minX.rounded()), Int(obj.stringRect.minY.rounded())])
        }
        
        let success = jsMgr.CreateJSFile(psdPath: psdPath, contentList: contentList, colorList: colorList, fontSizeList: fontSizeList, fontNameList: fontNameList, positionList: positionList)
        
            if success == true{
                let cmd = "open /Users/ipdesign/Documents/Development/PSDStringPredictor/PSDStringPredictor/AdobeScripts/StringCreator.jsx  -a '/Applications/Adobe Photoshop 2020/Adobe Photoshop 2020.app'"
                PythonScriptManager.RunScript(str: cmd)
            }
    }
    


    
}
    
 
    

    
    


