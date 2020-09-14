//
//  Weight.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 13/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import Vision
//class FontSizeML {
//    
//    
//    func Predict(character: String, width: Double, height: Double) -> (CGFloat) {
//        var output: CGFloat = 0
//        do{
//            let model = TextWeightTabularRegressor()
//            guard let predict = try? model.prediction(character: character, width: width, height: height)
//                else {
//                fatalError("Unexpected runtime error.")
//            }
//            
//            output = CGFloat(predict.weight)
//            
//            print("ML predict: \(output)")
//        }
//        catch
//        {
//            
//        }
//        return output
//
//    }
//    
//    
//}

func PredictFontSize(character: String, width: Double, height: Double) -> (CGFloat) {
    var output: CGFloat = 0
    do{
        let model = TextWeightTabularRegressor()
        guard let predict = try? model.prediction(character: character, width: width, height: height)
            else {
            fatalError("Unexpected runtime error.")
        }
        
        output = CGFloat(predict.weight)
        
        print("ML predict: \(output)")
    }
    catch
    {
        
    }
    return output

}
