//
//  PythonScriptManager.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 20/11/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import PythonKit

class PythonScriptManager{
    static func RunScript(str: String){
        let os = try Python.import("os")
        let systemOut = os.system(str)
        //print("Python Version: \(sys.version)")
    }
}