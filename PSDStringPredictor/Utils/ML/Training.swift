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
        //var contentStr: String = ""
        
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = true
        panel.allowsMultipleSelection = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let result = panel.runModal()
            if result == .OK{

            }
            
        }

    }
    
    func ParseFileName(FileName nameStr: String) -> (char: String, size: Int, tracking: Int ){
        let strGrp = nameStr.components(separatedBy: "~")
        if strGrp.count == 3 {
            return (strGrp[0], Int(strGrp[1])!, Int(strGrp[2])!)
        }
        else{
            return ("",0,0)
        }
    }
}
