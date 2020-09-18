//
//  CompareImage.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 15/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import Vision
import CoreImage


func ImageSimilarity(_ img1: CIImage, img2: CIImage) -> Float
{
    let v1 = featureprintObservationForImage(FromCIImage: img1)
    let v2 = featureprintObservationForImage(FromCIImage: img2)
    
    var distance1 = Float(0)
    do {
        try v1!.computeDistance(&distance1, to: v2!)
        
    }catch{
        
    }
    return distance1
    
}

func featureprintObservationForImage(FromCIImage img: CIImage) -> VNFeaturePrintObservation? {
  let requestHandler = VNImageRequestHandler(ciImage: img, options: [:])
  let request = VNGenerateImageFeaturePrintRequest()
  do {
    try requestHandler.perform([request])
    return request.results?.first as? VNFeaturePrintObservation
  } catch {
    print("Vision error: \(error)")
    return nil
  }
}
