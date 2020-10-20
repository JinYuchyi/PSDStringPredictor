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
    //var topResult: VNClassificationObservation = VNClassificationObservation.init()
    var predictResult: String = ""

    func detectImage(img: CIImage)  {
        //var topResult: VNClassificationObservation = VNClassificationObservation.init()
        // 1. Try and load the model
        guard let model = try? VNCoreMLModel(for: FontWeightClassifier().model) else {
            fatalError("Failed to load model")
        }
        
        // 2. Create a vision request
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first
            else {
                fatalError("Unexpected results")
            }
            
            self!.predictResult = topResult.identifier
            // 3. Update the Main UI Thread with our result
            //                DispatchQueue.main.async { [weak self] in
            //                    self?.lblResult.text = "\(topResult.identifier) with \(Int(topResult.confidence * 100))% confidence"
            //                }
        }
        
        //            guard let ciImage = CIImage(image: self.myPhoto.image!)
        //                else { fatalError("Cant create CIImage from UIImage") }
        
        // 4. Run the googlenetplaces classifier
        let handler = VNImageRequestHandler(ciImage: img)
        DispatchQueue.global().async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
        //request.results!.first

    }
    
}

