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
    
//    func FetchStringLabelList(){
//        StringLabelListData.removeAll()
//        for element in DataStore.stringObjectList{
//            let tmpElement = StringLabelObject(position:[ element.stringRect.origin.x, element.stringRect.origin.y], height: element.stringRect.height, width: element.stringRect.width, fontsize: element.fontSize, tracking: element.tracking, content: element.content, color: element.color)
//            StringLabelListData.append(tmpElement)
//        }
//    }
    
    func UpdateSelectedStringObject(selectedStringObject: StringObject ){
        selectedCharImageListObjectList = []
        self.selectedStringObject = selectedStringObject
        for img in selectedStringObject.charImageList{
            selectedCharImageListObjectList.append(CharImageThumbnailObject(image: img))
            //print("selectedCharImageListObjectList.count: \(selectedCharImageListObjectList.count)")

        }
    }
    
}
    
 
    

    
    
    //@Published var data: DataStore = DataStore()
//    var id: UUID = UUID()
//    var content: String
//    var position: [CGFloat]
//    var width: CGFloat
//    var height: CGFloat
//    var tracking: CGFloat
//    var fontSize: CGFloat
//    var stringRect: CGRect
//    var observation : VNRecognizedTextObservation
//    var color: Color
//    var charArray: [Character]
//    var charRects: [CGRect]
//
//    @EnvironmentObject var data: DataStore
    
//

    
    
    
//    func GetCharsAndRects() -> ([CGRect], [Character]){
//        var rects: [CGRect] = []
//        var chars: [Character] = []
//
//        let candidate = observation.topCandidates(1).first!
//        
//        for offset in 0..<candidate.string.count{
//            let index_start = candidate.string.index(candidate.string.startIndex, offsetBy: offset)
//            let index_end = candidate.string.index(candidate.string.startIndex, offsetBy: offset+1)
//            let myrange = index_start..<index_end
//            let boxObservation = try? candidate.boundingBox(for: myrange)
//            
//            // Get the normalized CGRect value.
//            let boundingBox = boxObservation?.boundingBox ?? .zero
//            let Rect = VNImageRectForNormalizedRect(boundingBox, Int(myimg.extent.width), Int(myimg.extent.height))
//
//            // Convert the rectangle from normalized coordinates to image coordinates.
//            rects.append(VNImageRectForNormalizedRect(boundingBox, Int(myimg.extent.width), Int(myimg.extent.height)))
//            let char = candidate.string[index_start]
//            
//            chars.append(char)
//        }
//        return (rects, chars)
//    }
    
//    func PrintAllInfo(){
//        var output = "\nString Content: \(content), Font Size: \(fontSize), Position: \(position), color: \(color)\nCharacter including: \n"
//        for boxindex in charRects.startIndex..<charRects.endIndex{
//            var charstring = "\(charArray[boxindex]): Width - \(charRects[boxindex].width), Height - \(charRects[boxindex].height)\n"
//            output = output + charstring
//        }
//        print(output)
//    }
    


//    func GetTracking() -> CGFloat {
//        var trackingList: [Double] = []
//        for i in 0...charArray.count-2 {
//            if (charArray[i].isLowercase && charArray[i+1].isLowercase){
//                var dist = abs(charRects[i].midX - charRects[i+1].midX)
//                let t = PredictFontTracking(str1: String(charArray[i]), str2: String(charArray[i+1]), fontsize: Double(fontSize), distance: Double(dist))
//                print("Tracking of \(String(charArray[i])) and \(String(charArray[i+1])) is \(t), weight is \(fontSize)")
//
//                trackingList.append(t)
//            }
//        }
//        if (trackingList.count > 0){
//            var result: CGFloat = 0
//            for i in 0...trackingList.count - 1 {
//                result += CGFloat(trackingList[i])
//            }
//            result = result / CGFloat(trackingList.count)
//            result = result  / 1000
//            print("\(content) tracking is \(result)")
//            return result
//        }
//        else {
//            return 0
//        }
//
//    }
//
//    func GetColor() -> Color {
//        return Color.white
//    }
//
//    func CalcPosition() -> [CGFloat]{
//        if stringRect.isEmpty {
//            return [0,0]
//        }
//        else{
//            return [stringRect.minX, stringRect.minY]
//        }
//    }
//
//    func FindWeight(_ char: String, _ width: Int64, _ height: Int64) -> Int64{
//        //var objArray: [Row] = []
//        var result: Int64 = 0
//
//        if(db == nil){
//            print("DB equals null.")
//            return 0
//        }
//
//        let objList = QueryFor(char: char, width: width, height: height)
//
//
//        func Predict() -> Int64 {
//            Int64(PredictFontSize(character: char, width: Double(width), height: Double(height)))
//        }
//
//        func FindIt() -> Int64{
//            let strObj = objList[0][TABLE_CHARACTER_WIGHT]
//            result = strObj
//            return strObj
//        }
//
//        return result == 0 ? Predict() : FindIt()
//
//    }
    
//    func FillCharFrameList(){
//        for (index, char) in charArray.enumerated() {
//            let tmpFrame = CharFrame(rect: self.charRects[index], char: String(char))
//            data.charFrameList.append(tmpFrame)
//            data.charFrameIndex += 1
//        }
//    }
    
    
    


