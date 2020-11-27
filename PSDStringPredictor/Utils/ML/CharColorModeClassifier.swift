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

class CharColorModeClassifier{
    
    var result = -1
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            /*
             Use the Swift class `MobileNet` Core ML generates from the model.
             To use a different Core ML classifier model, add it to the project
             and replace `MobileNet` with that model's generated Swift class.
             */
            let model = try VNCoreMLModel(for: CharColorMode().model)

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
                //print("Predict result: \(topClassification.identifier)" )
                if (topClassification.identifier == "light"){
                    result = 1
                }
                else if (topClassification.identifier == "dark"){
                    result = 2
                }else{
                    result = -1
                }
                
//                let descriptions = topClassifications.map { classification in
//                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
//
//                   return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
//                }
                
            }
        //}
    }
    
    func Prediction(fromImage ciImage: CIImage) -> Int{
        //DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
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




