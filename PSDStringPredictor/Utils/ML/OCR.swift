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

let fontDecentOffsetScale: CGFloat = 0.6

class OCR: ObservableObject{
    //private var workItem: DispatchWorkItem?
    //@EnvironmentObject var warningVM: WarningVM
    //Constant
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
            //let boxObservation = try? candidate.boundingBox(for: stringRange)
            
            // Get the normalized CGRect value.
            let boundingBox = boxObservation?.boundingBox ?? .zero
            //let Rect = VNImageRectForNormalizedRect(boundingBox, width, height)
            
            //print(boundingBox)
            // Convert the rectangle from normalized coordinates to image coordinates.
            //return VNImageRectForNormalizedRect(boundingBox, 100, 100)
            
            let _x = (VNImageRectForNormalizedRect(boundingBox, width, height).minX).rounded()
            let _y = (VNImageRectForNormalizedRect(boundingBox, width, height).minY).rounded()
            let _w = (VNImageRectForNormalizedRect(boundingBox, width, height).width).rounded()
            let _h = (VNImageRectForNormalizedRect(boundingBox, width, height).height).rounded()
            let fixRect = CGRect.init(x: _x, y: _y, width: _w, height: _h)
            
            rects.append(fixRect)
            //print("\(offset) \(candidate.string[index_start]) \(boundingBox)")
            let char = candidate.string[index_start]
            //            if (char == "B"){
            //                print("B: \(VNImageRectForNormalizedRect(boundingBox, width, height))")
            //            }
            chars.append(char)
        }
        
        return (rects, chars)
    }
    

    
    func DeleteDecent(obj: StringObject) -> StringObject{
        //Delete the decent height
        let descent = FontUtils.FetchStringDescent(content: obj.content, fontSize: obj.fontSize)
        
        let newStringRect = CGRect(x: obj.stringRect.origin.x, y: obj.stringRect.origin.y + descent, width: obj.stringRect.width, height: obj.stringRect.height - descent)
        //let newStringRect = CGRect(x: obj.stringRect.origin.x, y: obj.stringRect.origin.y  , width: obj.stringRect.width, height: obj.stringRect.height )

        var tmpObj = StringObject.init(obj.content, newStringRect, obj.charArray, obj.charRects, charImageList: obj.charImageList)
        //tmpObj.stringRect = newStringRect
        return tmpObj
    }
    
    func CreateAllStringObjects(rawNSImage: NSImage, processedCIImage ciImage: CIImage, psdId: Int, psdsVM: PsdsVM, offset: CGPoint = CGPoint.init(x: 0, y: 0 )) -> [StringObject]{
        var strobjs : [StringObject] = []
        let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        let TextRecognitionRequest = VNRecognizeTextRequest()
        TextRecognitionRequest.recognitionLevel = VNRequestTextRecognitionLevel.accurate
        TextRecognitionRequest.usesLanguageCorrection = true
        TextRecognitionRequest.recognitionLanguages = ["en_US"]
        
        DispatchQueue.main.async{
            psdsVM.prograssScale = 0
        }
        
        TextRecognitionRequest.recognitionLevel = VNRequestTextRecognitionLevel.fast
        do {
            try requestHandler.perform([TextRecognitionRequest])
        } catch {
            print(error)
        }

        guard let results_fast = TextRecognitionRequest.results as? [VNRecognizedTextObservation] else {return ([])}
        let stringsRects = self.GetRectsFromObservations(results_fast, Int(ciImage.extent.width.rounded()), Int(ciImage.extent.height.rounded()))
        let strs = self.GetStringArrayFromObservations(results_fast)
        for i in 0..<stringsRects.count{
            DispatchQueue.main.async{
                psdsVM.prograssScale += 1/CGFloat(stringsRects.count)
                psdsVM.IndicatorText = "Processing Image ID: \(psdId), \(i+1) / \(stringsRects.count) strings"
            }
            let (charRects, chars) = self.GetCharsInfoFromObservation(results_fast[i], Int((ciImage.extent.width).rounded()), Int((ciImage.extent.height).rounded()))
            let charImageList = rawNSImage.ToCIImage()!.GetCroppedImages(rects: charRects.offset(offset: offset))
//            var index = 0
//            for img in charImageList {
//                let urlPath = "/Users/ipdesign/Downloads/test" + String(index) + ".bmp"
//                img.ToPNG(url: URL.init(fileURLWithPath: urlPath))
//                index += 1
//            }
            var newStrObj = StringObject.init(strs[i], stringsRects[i].offset(offset: offset), chars, charRects.offset(offset: offset), charImageList: charImageList)
            print(charImageList.count)
            newStrObj = DeleteDecent(obj: newStrObj)
//            strobjs.append(newStrObj)
            
            let sepObjList = newStrObj.seprateIfPossible()
            if sepObjList != nil {
                for obj in sepObjList!{
                    strobjs.append(obj)
                }
            }else {
                strobjs.append(newStrObj)
            }
        }
        return strobjs
    }
    
  
    
    
    
    
    
}
