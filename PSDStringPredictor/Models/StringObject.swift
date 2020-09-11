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
struct StringObject {
    var id: Int = 0
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
    
    init(_ content: String, _ stringRect: CGRect, _ observation: VNRecognizedTextObservation, _ charArray: [Character], _ charRacts: [CGRect]){
        ShareData.idIndex = ShareData.idIndex + 1
        self.id = (ShareData.idIndex)
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
        
        self.tracking = GetTracking()
        self.color = GetColor()
        self.position = CalcPosition()

       }
    
    func GetCharsInfo(_ myimg: CIImage) -> ([CGRect], [Character]){
        var rects: [CGRect] = []
        var chars: [Character] = []
        //let obsrs = GetMyObservations()

        //for obsr in obsrs{
        let candidate = observation.topCandidates(1).first!
        
        for offset in 0..<candidate.string.count{
            let index_start = candidate.string.index(candidate.string.startIndex, offsetBy: offset)
            let index_end = candidate.string.index(candidate.string.startIndex, offsetBy: offset+1)
            let myrange = index_start..<index_end
            let boxObservation = try? candidate.boundingBox(for: myrange)
            //let boxObservation = try? candidate.boundingBox(for: stringRange)
            
            // Get the normalized CGRect value.
            let boundingBox = boxObservation?.boundingBox ?? .zero
            let Rect = VNImageRectForNormalizedRect(boundingBox, Int(myimg.extent.width), Int(myimg.extent.height))

            //print(boundingBox)
            // Convert the rectangle from normalized coordinates to image coordinates.
            //return VNImageRectForNormalizedRect(boundingBox, 100, 100)
            rects.append(VNImageRectForNormalizedRect(boundingBox, Int(myimg.extent.width), Int(myimg.extent.height)))
            //print("\(offset) \(candidate.string[index_start]) \(boundingBox)")
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
                var tempweight = dbUtils.FindWeight(String(char), Int64(charRects[index].width), Int64(charRects[index].height))
                //print("find:\(String(char)), \(Int64(charRects[index].width)), \(Int64(charRects[index].height)). weight:\(tempweight)")
                weightArray.append(tempweight)
            }
        }
        //self.fontWeight = FindBestWeightFromWeightArray(weightArray)
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
        return 10
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
    

}
