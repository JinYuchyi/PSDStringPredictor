//
//  ColorMode.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 19/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreImage

class ColorModeClassifier{
    
    static func PredictColorMode (fromImage img: CIImage) -> Int {
        var output: Int = -1
        do{
            let model = ColorMode()
            guard let predict = try? model.prediction(image: <#T##CVPixelBuffer#>)
            else {
                fatalError("Unexpected runtime error.")
            }
            
            switch predict.classLabel {
            case "light":
                output = 1
            case "dark":
                output = 2
            default:
                output = -1
            }
            
            //print("ML predict: \(output)")
        }
        catch
        {
            
        }
        
        return output
    }
}
