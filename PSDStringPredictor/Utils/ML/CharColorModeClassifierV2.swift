//
//  CharColorMode.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 19/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreImage
import CoreML
import Vision
import ImageIO

class CharColorModeClassifierV2{
    //    static var shared = CharColorModeClassifierV2()
    var result = -1
    var letter: String = ""
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            /*
             Use the Swift class `MobileNet` Core ML generates from the model.
             To use a different Core ML classifier model, add it to the project
             and replace `MobileNet` with that model's generated Swift class.
             */
            var model = try VNCoreMLModel(for: CharColorMode.shared.model)
            switch letter {
            case "a", "A": model = try VNCoreMLModel(for: aColor.shared.model)
            case "b", "B": model = try VNCoreMLModel(for: bColor.shared.model)
            case "c", "C": model = try VNCoreMLModel(for: cColor.shared.model)
            case "d", "D": model = try VNCoreMLModel(for: dColor.shared.model)
            case "e", "E": model = try VNCoreMLModel(for: eColor.shared.model)
            case "f", "F": model = try VNCoreMLModel(for: fColor.shared.model)
            case "g", "G": model = try VNCoreMLModel(for: gColor.shared.model)
            case "h", "H": model = try VNCoreMLModel(for: hColor.shared.model)
            case "i", "I": model = try VNCoreMLModel(for: iColor.shared.model)
            case "j", "J": model = try VNCoreMLModel(for: jColor.shared.model)
            case "k", "K": model = try VNCoreMLModel(for: kColor.shared.model)
            case "l", "L": model = try VNCoreMLModel(for: lColor.shared.model)
            case "m", "M": model = try VNCoreMLModel(for: mColor.shared.model)
            case "n", "N": model = try VNCoreMLModel(for: nColor.shared.model)
            case "o", "O": model = try VNCoreMLModel(for: oColor.shared.model)
            case "p", "P": model = try VNCoreMLModel(for: pColor.shared.model)
            case "q", "Q": model = try VNCoreMLModel(for: qColor.shared.model)
            case "r", "R": model = try VNCoreMLModel(for: rColor.shared.model)
            case "s", "S": model = try VNCoreMLModel(for: sColor.shared.model)
            case "t", "T": model = try VNCoreMLModel(for: tColor.shared.model)
            case "u", "U": model = try VNCoreMLModel(for: uColor.shared.model)
            case "v", "V": model = try VNCoreMLModel(for: vColor.shared.model)
            case "w", "W": model = try VNCoreMLModel(for: wColor.shared.model)
            case "x", "X": model = try VNCoreMLModel(for: xColor.shared.model)
            case "y", "Y": model = try VNCoreMLModel(for: yColor.shared.model)
            case "z", "Z": model = try VNCoreMLModel(for: zColor.shared.model)
            case "0": model = try VNCoreMLModel(for: _0Color.shared.model)
            case "1": model = try VNCoreMLModel(for: _1Color.shared.model)
            case "2": model = try VNCoreMLModel(for: _2Color.shared.model)
            case "3": model = try VNCoreMLModel(for: _3Color.shared.model)
            case "4": model = try VNCoreMLModel(for: _4Color.shared.model)
            case "5": model = try VNCoreMLModel(for: _5Color.shared.model)
            case "6": model = try VNCoreMLModel(for: _6Color.shared.model)
            case "7": model = try VNCoreMLModel(for: _7Color.shared.model)
            case "8": model = try VNCoreMLModel(for: _8Color.shared.model)
            case "9": model = try VNCoreMLModel(for: _9Color.shared.model)
            default:
                model = try VNCoreMLModel(for: CharColorMode.shared.model)
            }
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            //request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    /// - Tag: ProcessClassifications
    private func processClassifications(for request: VNRequest, error: Error?) {
        //DispatchQueue.main.async {
        guard let results = request.results else {
            print("Unable to classify the image.")
            return
        }
        // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
        let classifications = results as! [VNClassificationObservation]
        
        if classifications.isEmpty {
            print("Nothing recognized.")
        } else {
            // Display top classifications ranked by confidence in the UI.
            //let topClassifications = classifications.prefix(2)
            let topClassification = classifications[0]
//            print("Predict result for charMode: \(topClassification.identifier)" )
            if (topClassification.identifier.last! == "l"){
                
                result = 1
            }
            else if (topClassification.identifier.last! == "d"){
                result = 2
            }else{
                result = -1
            }
            
            
        }
        //}
    }
    
    func Prediction(fromImage ciImage: CIImage, char: String) -> Int{
        letter = char
        //DispatchQueue.global(qos: .userInitiated).async {
        let handler = VNImageRequestHandler(ciImage: SetGrayScale(ciImage)!, orientation: .up)
        do {
            try handler.perform([self.classificationRequest])
        } catch {
            /*
             This handler catches general image processing errors. The `classificationRequest`'s
             completion handler `processClassifications(_:error:)` catches errors specific
             to processing that request.
             */
            print("Failed to perform classification.\n\(error.localizedDescription)")
        }
        //}
        return result
    }
}




