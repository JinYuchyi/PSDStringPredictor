//
//  OCRUtils.swift
//  StringObjectCreator
//
//  Created by ipdesign on 20/7/2020.
//  Copyright © 2020 yuqi_jin. All rights reserved.
//

import Foundation
import CoreImage
import Vision
import SwiftUI

let fontDecentOffsetScale: CGFloat = 0.8

class OCR{
    
    static let shared = OCR()
    
    private init(){}
    
    func GetRectsFromObservations(_ observations : [VNRecognizedTextObservation], _ width : Int, _ height : Int)->[CGRect]{
        var rects : [CGRect] = []
        //var total = observations.count
        var index = 0
        for observation in observations{
            
            // Find the top observation.
            guard let candidate = observation.topCandidates(1).first else { continue }
            // Find the bounding-box observation for the string range.
            let stringRange = candidate.string.startIndex..<candidate.string.endIndex
            
            let boxObservation = try? candidate.boundingBox(for: stringRange)
            //let boxObservation = try? candidate.boundingBox(for: stringRange)
            
            // Get the normalized CGRect value.
            let boundingBox = boxObservation?.boundingBox ?? .zero
            
            // Convert the rectangle from normalized coordinates to image coordinates.
            //return VNImageRectForNormalizedRect(boundingBox, 100, 100)
            let normBox = VNImageRectForNormalizedRect(boundingBox, width, height)
            let newBox = CGRect.init(x: Int(normBox.origin.x.rounded()), y: Int(normBox.origin.y.rounded()), width: Int(normBox.width.rounded()), height: Int(normBox.height.rounded()))
            rects.append(newBox)
            index += 1
            //return VNImageRectForNormalizedRect(boundingBox, width, height)
        }
        return rects
    }
    
    func StopBackendWork(){
        print("Try to Stop")
        //        workItem?.cancel()
    }
    
    func GetStringArrayFromObservations(_ observations : [VNRecognizedTextObservation])->[String]{
        var strs:[String] = []
        for visionResult in observations{
            let maximumCandidates = 1
            guard let candidate = visionResult.topCandidates(maximumCandidates).first else {continue}
            strs.append(candidate.string)
        }
        return strs
    }
    
    func GetCharsInfoFromObservation(_ observation: VNRecognizedTextObservation, _ width: Int, _ height: Int) -> ([CGRect], [Character]){
        var rects: [CGRect] = []
        var chars: [Character] = []

        //for obsr in obsrs{
        let candidate = observation.topCandidates(1).first!
        
        for offset in 0..<candidate.string.count{
            let index_start = candidate.string.index(candidate.string.startIndex, offsetBy: offset)
            let index_end = candidate.string.index(candidate.string.startIndex, offsetBy: offset+1)
            let myrange = index_start..<index_end
            let boxObservation = try? candidate.boundingBox(for: myrange)
            
            // Get the normalized CGRect value.
            let boundingBox = boxObservation?.boundingBox ?? .zero

            let _x = (VNImageRectForNormalizedRect(boundingBox, width, height).minX).rounded()
            let _y = (VNImageRectForNormalizedRect(boundingBox, width, height).minY).rounded()
            let _w = (VNImageRectForNormalizedRect(boundingBox, width, height).width).rounded()
            let _h = (VNImageRectForNormalizedRect(boundingBox, width, height).height).rounded()
            let fixRect = CGRect.init(x: _x, y: _y, width: _w, height: _h)
            
            rects.append(fixRect)
            let char = candidate.string[index_start]
            //            if (char == "B"){
            //                print("B: \(VNImageRectForNormalizedRect(boundingBox, width, height))")
            //            }
            chars.append(char)
        }
        
        return (rects, chars)
    }
    

    
    func DeleteFontOffset(obj: StringObject) -> StringObject{
        //Delete the decent height
        let fontOffset = FontUtils.calcFontTailLength(content: obj.content, size: obj.fontSize)
//        let newStringRect = CGRect(x: obj.stringRect.origin.x, y: obj.stringRect.origin.y + fontOffset, width: obj.stringRect.width, height: obj.stringRect.height - fontOffset)
        let newStringRect = CGRect(x: obj.stringRect.minX, y: obj.stringRect.minY + fontOffset  , width: obj.stringRect.width, height: obj.stringRect.height - fontOffset )


        var tmpObj = StringObject.init(imagePath: obj.imagePath, obj.content, newStringRect, obj.charArray, obj.charRects, charImageList: obj.charImageList)
        //tmpObj.stringRect = newStringRect
        return tmpObj
    }
    
 
  
    
    
    
    
    
}
