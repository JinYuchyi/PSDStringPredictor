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
struct StringObject : Identifiable{
    
    var id: UUID = UUID()
    var content: String
    var position: [CGFloat]
    var width: CGFloat
    var height: CGFloat
    var tracking: CGFloat
    var fontSize: CGFloat
    var stringRect: CGRect
    var observation : VNRecognizedTextObservation
    var color: Color
    var charArray: [Character]
    var charRects: [CGRect]
    
    @EnvironmentObject var data: DataStore
//stringObjectIndex
    
    let dbUtils: DBUtils = DBUtils()
    
    init(_ content: String, _ stringRect: CGRect, _ observation: VNRecognizedTextObservation, _ charArray: [Character], _ charRacts: [CGRect]){
        self.stringRect = stringRect
        self.content = content
        self.width = stringRect.width
        self.height = stringRect.height
        self.fontSize = 0.0
        self.position = [0,0]
        self.observation = observation
        self.charArray = charArray
        self.charRects = charRacts
        self.tracking = 10
        self.color = Color.white
        self.color = GetColor()
        self.position = CalcPosition()
        self.fontSize =  CGFloat(FindBestWeightForString(dbUtils))
        self.tracking = GetTracking()
        //data.stringObjectIndex = data.stringObjectIndex + 1
        //self.id = (data.stringObjectIndex)
        
        FillCharFrameList()

       }
    
    func GetCharsInfo(_ myimg: CIImage) -> ([CGRect], [Character]){
        var rects: [CGRect] = []
        var chars: [Character] = []

        let candidate = observation.topCandidates(1).first!
        
        for offset in 0..<candidate.string.count{
            let index_start = candidate.string.index(candidate.string.startIndex, offsetBy: offset)
            let index_end = candidate.string.index(candidate.string.startIndex, offsetBy: offset+1)
            let myrange = index_start..<index_end
            let boxObservation = try? candidate.boundingBox(for: myrange)
            
            // Get the normalized CGRect value.
            let boundingBox = boxObservation?.boundingBox ?? .zero
            let Rect = VNImageRectForNormalizedRect(boundingBox, Int(myimg.extent.width), Int(myimg.extent.height))

            // Convert the rectangle from normalized coordinates to image coordinates.
            rects.append(VNImageRectForNormalizedRect(boundingBox, Int(myimg.extent.width), Int(myimg.extent.height)))
            let char = candidate.string[index_start]
            
            chars.append(char)
        }
        return (rects, chars)
    }
    
    func PrintAllInfo(){
        var output = "\nString Content: \(content), Font Size: \(fontSize), Position: \(position), color: \(color)\nCharacter including: \n"
        for boxindex in charRects.startIndex..<charRects.endIndex{
            var charstring = "\(charArray[boxindex]): Width - \(charRects[boxindex].width), Height - \(charRects[boxindex].height)\n"
            output = output + charstring
        }
        print(output)
    }
    
    func FindBestWeightForString(_ dbUtils: DBUtils)-> Float{
        var weightArray:[Int64] = []
        //Find weight for each character, and guess the best choice for the string's weight
        for (index, char) in charArray.enumerated(){
            if char.isNumber || char.isLetter{
                var tempweight = FindWeight(String(char), Int64(charRects[index].width), Int64(charRects[index].height))
                //print("find:\(String(char)), \(Int64(charRects[index].width)), \(Int64(charRects[index].height)). weight:\(tempweight)")
                if (tempweight != 0){
                    weightArray.append(tempweight)
                }
            }
        }
        return FindBestWeightFromWeightArray(FromArray: weightArray)
    }
    
    private func FindBestWeightFromWeightArray(FromArray weightArray: [Int64]) -> Float{
        var weightDict: [Int64: Int64] = [:]
        for w in weightArray{
            let keyExists = weightDict[w] != nil
            if keyExists == false { //If the weight is new
                weightDict[w] = 1
            }
            else{
                let index = weightDict[w]
                weightDict[w] = index! + 1
            }
        }
        let sortedValue = weightDict.values.sorted(by: >)
        //let filtered = sortedValue.filter { $0.value ==  sortedValue[0]} //Return the first key from sorted Dict
        let filtered = weightDict.filter { $0.1 ==  sortedValue[0] }
        var result: Float = 0.0
        for (key, value) in filtered{
            result = result + Float(key)
        }
        result = result / Float(filtered.count)
        //print("result:\(result)")
        return result
    }

    func GetTracking() -> CGFloat {
        var trackingList: [Double] = []
        for i in 0...charArray.count-2 {
            if (charArray[i].isLowercase && charArray[i+1].isLowercase){
                var dist = abs(charRects[i].midX - charRects[i+1].midX)
                let t = PredictFontTracking(str1: String(charArray[i]), str2: String(charArray[i+1]), fontsize: Double(fontSize), distance: Double(dist))
                print("Tracking of \(String(charArray[i])) and \(String(charArray[i+1])) is \(t), weight is \(fontSize)")

                trackingList.append(t)
            }
        }
        if (trackingList.count > 0){
            var result: CGFloat = 0
            for i in 0...trackingList.count - 1 {
                result += CGFloat(trackingList[i])
            }
            result = result / CGFloat(trackingList.count)
            result = result  / 1000
            print("\(content) tracking is \(result)")
            return result
        }
        else {
            return 0
        }
        
    }
    
    func GetColor() -> Color {
        return Color.white
    }
    
    func CalcPosition() -> [CGFloat]{
        if stringRect.isEmpty {
            return [0,0]
        }
        else{
            return [stringRect.minX, stringRect.minY]
        }
    }
    
    func FindWeight(_ char: String, _ width: Int64, _ height: Int64) -> Int64{
        //var objArray: [Row] = []
        var result: Int64 = 0
        
        if(db == nil){
            print("DB equals null.")
            return 0
        }
        
        let objList = QueryFor(char: char, width: width, height: height)

        
        func Predict() -> Int64 {
            Int64(PredictFontSize(character: char, width: Double(width), height: Double(height)))
        }

        func FindIt() -> Int64{
            let strObj = objList[0][TABLE_CHARACTER_WIGHT]
            result = strObj
            return strObj
        }
        
        return result == 0 ? Predict() : FindIt()

    }
    
    func FillCharFrameList(){
        for (index, char) in charArray.enumerated() {
            let tmpFrame = CharFrame(id: data.charFrameIndex, rect: self.charRects[index], char: String(char))
            data.charFrameList.append(tmpFrame)
            data.charFrameIndex += 1
        }
    }
    
    
    

}
