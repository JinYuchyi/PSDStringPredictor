//
//  Tracking.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 15/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

func PredictFontTracking (str: String, fontSize: Double, width: Double, fontWeight: String) -> Double {
    var output: Double = 0
    do{
        let model = TrackingRegressor()
        guard let predict = try? model.prediction(chars: str, fontSize: Double(12), width: width, fontWeight: fontWeight)
            else {
            fatalError("Unexpected runtime error.")
        }
        
        output = (predict.tracking)
        //output = output / 12 * fontSize
    }
    catch
    {
        
    }
    return output
}
