//
//  ColorMode.swift
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

class FontWeightPredict{
    
    func Predict(ciimage: CIImage) -> String {
        let model = try? VNCoreMLModel(for: FontWeightClassifier().model)
        
        
        let request = VNCoreMLRequest(model: model, completionHandler: processResults)
        let handler = VNImageRequestHandler(ciImage: ciimage)
        
        guard let results = request.results as? [VNClassificationObservation] else {
            fatalError("Could not get results from ML Vision requests")
        }
        
        for classification in results {
            
            if classification.confidence > bestConfidence {
                
                bestConfidence = classification.confidence
                //bestPrediction = classification.identifier
            }
        }
        
        return classification.identifier
        
        //try! handler.perform([ request ])
    }


}

