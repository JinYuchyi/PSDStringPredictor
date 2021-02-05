//
//  mlSymbolsUtil.swift
//  PSDStringGenerator
//
//  Created by Yuqi Jin on 5/2/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation
import CoreImage
import CoreML
import Vision
import ImageIO

class SymbolsPredict{
    private var result: String = ""

    lazy var detectionRequest: VNCoreMLRequest = {
        do {
            /*
             Use the Swift class `MobileNet` Core ML generates from the model.
             To use a different Core ML classifier model, add it to the project
             and replace `MobileNet` with that model's generated Swift class.
             */
            let model = try VNCoreMLModel(for: SymbolObjectDetector.shared.model)

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
    func processClassifications(for request: VNRequest, error: Error?)  {
        //DispatchQueue.main.async {
            guard let results = request.results else {
                print("Unable to predict the image.")
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let detections = results as! [VNDetectedObjectObservation]
        
            if detections.isEmpty {
                print("Nothing detected.")
            } else {
                // Display top classifications ranked by confidence in the UI.
                //let topClassifications = classifications.prefix(2)
                let topDetection = detections[0]
                
                result = String(detections.count)
                
                for result in detections {
                    print(result.boundingBox)
                }
            }
        //}

    }
    
    func Prediction(ciImage: CIImage) -> String{
        //DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
            do {
                try handler.perform([self.detectionRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform detection.\n\(error.localizedDescription)")
            }
        //}
        return result
    }
}




