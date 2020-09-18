//
//  Train.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 18/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

class MLTraining {
    
    func CreateTrackingData(FromStringObjects stringObjects: [StringObject], ToFilePath filePath: String){
        var contentStr: String = ""
        let allFilePath: [String] = getAllFilePath("/Users/ipdesign/Downloads/TrackingDataSet")!
        for  i in 0...allFilePath.count - 1 {
            if allFilePath[i].GetSuffix() == "png"{
                //let img = LoadNSImage(imageUrlPath: allFilePath[i])
                //let stringObjects = ocr.CreateAllStringObjects(FromCIImage: img.ToCIImage()! )
                for j in 0...stringObjects[0].charArray.count-2 {
                    if(String(stringObjects[0].charArray[j]).FixError().isEnglishLowerCase() && String(stringObjects[0].charArray[j+1]).FixError().isEnglishLowerCase() && String(stringObjects[0].charArray[j]).FixError() != String(stringObjects[0].charArray[j+1]).FixError()){
                        contentStr += String(stringObjects[0].charArray[j]).FixError() + ","
                        contentStr += String(stringObjects[0].charArray[j+1]).FixError() + ","
                        contentStr += allFilePath[i].GetFontSizeString() + ","
                        contentStr += allFilePath[i].GetTrackingString() + ","
                        contentStr += abs(stringObjects[0].charRects[j].midX - stringObjects[0].charRects[j + 1].midX).description + ","
                        contentStr += "\n"
                    }
                }
            }
        }
        //Save Content
        SaveStringToFile(str: contentStr, path: filePath)
    }
}
