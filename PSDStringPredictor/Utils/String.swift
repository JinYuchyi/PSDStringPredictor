//
//  FileUtils.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 15/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

extension String{
    func GetSuffix() -> String{
        let substrs = self.components(separatedBy: ".")
        if(substrs.count > 1){
            return substrs[substrs.count-1]
        }
        else{
            return ""
        }
    }
    
    func GetFileName() ->String{
        let substrs = self.components(separatedBy: "/")
        if(substrs.count > 1){
            let filename = substrs[substrs.count-1]
            let name = filename.components(separatedBy: ".")[0]
            return name
        }
        else{
            return ""
        }
    }
}
