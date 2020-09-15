//
//  Tracking.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 15/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

func PredictFontTracking (str1: String, str2: String, fontsize: Double, distance: Double) -> Double {
    var output: Double = 0
    do{
        let model = TrackingRegressor()
        guard let predict = try? model.prediction(First: str1, Second: str2, Fontsize: fontsize, Distance: distance)
            else {
            fatalError("Unexpected runtime error.")
        }
        
        output = Double(predict.Tracking)
        
        //print("ML predict: \(output)")
    }
    catch
    {
        
    }
    return output
}
