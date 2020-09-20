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
            rects.append(VNImageRectForNormalizedRect(boundingBox, width, height))
            //print("\(offset) \(candidate.string[index_start]) \(boundingBox)")
            let char = candidate.string[index_start]
            
            chars.append(char)
        }

        return (rects, chars)
    }
    
    func CreateAllStringObjects(FromCIImage ciImage: CIImage) -> [StringObject]{
        var strobjs : [StringObject] = []
        
        //Get Observations
        let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        let TextRecognitionRequest = VNRecognizeTextRequest()
        TextRecognitionRequest.recognitionLevel = VNRequestTextRecognitionLevel.fast
        TextRecognitionRequest.usesLanguageCorrection = true
        TextRecognitionRequest.recognitionLanguages = ["en_US"]
        //TextRecognitionRequest.customWords = ["Photos"]
        do {
            try requestHandler.perform([TextRecognitionRequest])
        } catch {
            print(error)
        }
        guard let results = TextRecognitionRequest.results as? [VNRecognizedTextObservation] else {return ([])}
        
        //let stringsResults = GetObservations(fromImage: ciImage, withRecognitionLevel: VNRequestTextRecognitionLevel.fast, usesLanguageCorrection: true)
        let stringsRects = GetRectsFromObservations(results, Int((ciImage.extent.width)), Int((ciImage.extent.height)))
        let strs = GetStringArrayFromObservations(results)
        for i in 0..<stringsRects.count{
            let (charRects, chars) = GetCharsInfoFromObservation(results[i], Int((ciImage.extent.width)), Int((ciImage.extent.height)))
            //ciImage.ToPNG(stringsRects[i], ToPath: "/Users/ipdesign/Downloads/Test/", FileName: "test\(i).png",CreatePath: true) //Save the string image
            
            let newStrContent = StringObject(strs[i], stringsRects[i], results[i], chars, charRects)
            strobjs.append(newStrContent)

        }
        return strobjs
    }
    
}
