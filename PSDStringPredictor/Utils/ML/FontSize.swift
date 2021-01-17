//
//  Weight.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 13/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import Vision


func PredictFontSize(character: String, width: Int16, height: Int16, fontWeight: String) -> (CGFloat) {
    var output: CGFloat = 0
    do{
        //let model = FontSizeTabularRegressor()
        guard let predict = try? FontSizeTabularRegressor.shared.prediction(char_: character, width: Double(width), height: Double(height), fontWeight: fontWeight)
        else  {
            //return 0
            fatalError("Unexpected runtime error.")
            
        }
        
        output = CGFloat(predict.fontSize)
        
        //print("ML predict: \(output)")
    }
   
    
    return output

}
