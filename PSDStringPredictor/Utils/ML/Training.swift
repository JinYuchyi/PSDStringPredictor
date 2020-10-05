//
//  Train.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 18/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import SwiftUI

class MLTraining {
    
    let imageProcess = ImageProcess()
    let ocr = OCR()
    
    func CreateTrackingData(){
        var contentStr: String = ""
        
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = true
        panel.allowsMultipleSelection = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let result = panel.runModal()
            if result == .OK{
                //if ((?.pathExtension == "png" || panel.url?.pathExtension == "psd") )
                
                //let allFilePath: [String] = getAllFilePath(panel.url!.absoluteString)!
                //print("We have \(allFilePath.count) datasets.")
                
                for i in 0..<10{
                    print(panel.urls[i].absoluteString)
                    let nsImg = NSImage(byReferencing: panel.urls[i])
                    let ciImg = nsImg.ToCIImage()!
                    let lines = self.ocr.CreateAllStringObjects(FromCIImage: ciImg)
                    print("We have \(lines.count) linse.")
                }
            }
            
        }

        
        //for  i in 0...allFilePath.count - 1 {
   
                
//                for j in 0...stringObjects[0].charArray.count-2 {
//                    if(String(stringObjects[0].charArray[j]).FixError().isEnglishLowerCase() && String(stringObjects[0].charArray[j+1]).FixError().isEnglishLowerCase() && String(stringObjects[0].charArray[j]).FixError() != String(stringObjects[0].charArray[j+1]).FixError()){
//                        contentStr += String(stringObjects[0].charArray[j]).FixError() + ","
//                        contentStr += String(stringObjects[0].charArray[j+1]).FixError() + ","
//                        contentStr += allFilePath[i].GetFontSizeString() + ","
//                        contentStr += allFilePath[i].GetTrackingString() + ","
//                        contentStr += abs(stringObjects[0].charRects[j].midX - stringObjects[0].charRects[j + 1].midX).description + ","
//                        contentStr += "\n"
//                    }
//                }
               
                //Load Image
                //let nsImg = NSImage(imageUrlPath: allFilePath[i])
               // let ciImg = nsImg.ToCIImage()!
                //let lines = ocr.CreateAllStringObjects(FromCIImage: ciImg)
                //print("We have \(lines.count) linse.")
            

        //Save Content
        //SaveStringToFile(str: contentStr, path: filePath)
    }
}
