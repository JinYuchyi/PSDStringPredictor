//
//  Weight.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 13/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import Vision


func PredictFontSize(character: String, width: Double, height: Double, fontWeight: String) -> (CGFloat) {
    var output: CGFloat = 0
    do{
        let model = TextWeightTabularRegressor()
        guard let predict = try? model.prediction(char_: character, width: width, height: height, fontWeight: fontWeight)
            else {
            fatalError("Unexpected runtime error.")
        }
        
        output = CGFloat(predict.fontSize)
        
        //print("ML predict: \(output)")
    }
    catch
    {
        
    }
    
    return output

}
