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
    
    var stringObject: StringObject = StringObject()

    //@ObservedObject var imageViewModel: ImageProcess = ImageProcess()
    //var data: DataStore = DataStore()
    @Published var stringObjectListData: [StringObject] = []
    @Published var charFrameListData: [CharFrame] = []
    @Published var charFrameListRects: [CGRect] = []
    //@Published var StringLabelListData: [StringLabelObject] = []
    @Published var selectedStringObject: StringObject = StringObject.init()
    @Published var selectedCharImageListObjectList = [CharImageThumbnailObject]()
    
    func PredictStrings()  {
        stringObject.PredictStringObjects(FromCIImage: DataStore.targetImageProcessed)
        stringObjectListData = DataStore.stringObjectList
        DataStore.FillCharFrameList()
        FetchCharFrameListData()
        FetchCharFrameListRects()
        //FetchStringLabelList()
        
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
            //print("selectedCharImageListObjectList.count: \(selectedCharImageListObjectList.count)")

        }
    }
    


    
}
    
 
    

    
    


