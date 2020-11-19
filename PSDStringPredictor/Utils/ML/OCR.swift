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

class OCR: ObservableObject{
    
    let imageProcess = ImageProcess()
    
//    func GetObservations(fromImage image: CIImage, withRecognitionLevel recognitionLevel: VNRequestTextRecognitionLevel, usesLanguageCorrection: Bool)->[VNRecognizedTextObservation]{
//        let requestHandler = VNImageRequestHandler(ciImage: image, options: [:])
//        let TextRecognitionRequest = VNRecognizeTextRequest()
//        TextRecognitionRequest.recognitionLevel = recognitionLevel
//        TextRecognitionRequest.usesLanguageCorrection = true
//        TextRecognitionRequest.recognitionLanguages = ["en_US"]
//        //TextRecognitionRequest.customWords = ["Photos"]
//        //Send request to request handler
//        do {
//            try requestHandler.perform([TextRecognitionRequest])
//        } catch {
//            print(error)
//        }
//        guard let results = TextRecognitionRequest.results as? [VNRecognizedTextObservation] else {return ([])}
//        return results
//    }
    
    func GetRectsFromObservations(_ observations : [VNRecognizedTextObservation], _ width : Int, _ height : Int)->[CGRect]{
        var rects : [CGRect] = []
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
            rects.append(VNImageRectForNormalizedRect(boundingBox, width, height))
            //return VNImageRectForNormalizedRect(boundingBox, width, height)
        }
        return rects
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
            if (char == "B"){
                print("B: \(VNImageRectForNormalizedRect(boundingBox, width, height))")
            }
            chars.append(char)
        }

        return (rects, chars)
    }
    
    func CreateAllStringObjects(FromCIImage ciImage: CIImage) -> [StringObject]{
        var strobjs : [StringObject] = []
        
        //Get Observations
        let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        let TextRecognitionRequest = VNRecognizeTextRequest()
        TextRecognitionRequest.recognitionLevel = VNRequestTextRecognitionLevel.accurate
        TextRecognitionRequest.usesLanguageCorrection = true
        TextRecognitionRequest.recognitionLanguages = ["en_US"]
        TextRecognitionRequest.customWords = ["iCloud","FaceTime"]
        do {
            try requestHandler.perform([TextRecognitionRequest])
        } catch {
            print(error)
        }
        guard let results_accurate = TextRecognitionRequest.results as? [VNRecognizedTextObservation] else {return ([])}
        
        TextRecognitionRequest.recognitionLevel = VNRequestTextRecognitionLevel.fast
        do {
            try requestHandler.perform([TextRecognitionRequest])
        } catch {
            print(error)
        }
        guard let results_fast = TextRecognitionRequest.results as? [VNRecognizedTextObservation] else {return ([])}
        
        //let stringsResults = GetObservations(fromImage: ciImage, withRecognitionLevel: VNRequestTextRecognitionLevel.fast, usesLanguageCorrection: true)
        let stringsRects = GetRectsFromObservations(results_fast, Int((ciImage.extent.width).rounded()), Int((ciImage.extent.height).rounded()))
        let strs = GetStringArrayFromObservations(results_fast)
        for i in 0..<stringsRects.count{
            let (charRects, chars) = GetCharsInfoFromObservation(results_fast[i], Int((ciImage.extent.width).rounded()), Int((ciImage.extent.height).rounded()))
            
            var newStrObj = StringObject(strs[i], stringsRects[i], results_fast[i], chars, charRects, charImageList: DataStore.targetImageProcessed.GetCroppedImages(rects: charRects), CGFloat(results_fast[i].confidence))
            newStrObj.DeleteDescentForRect()
            strobjs.append(newStrObj)
            
            //Init blackdict
            
        }
        return strobjs
    }
    
    func FiltOutIgnoredRect(targetList rects: [CGRect]){
        for rect in rects{
            for ignoreRect in stringObjectViewModel.stringObjectIgnoreDict{
                if rect.
            }
        }
    }
    

    
}
