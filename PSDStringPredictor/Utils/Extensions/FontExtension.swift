//
//  FontExtension.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 22/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import SwiftUI

extension Font.Weight {
    func ToString() -> String {
        if (self == Font.Weight.regular){
            return "regular"
        }
        else if (self == Font.Weight.semibold){
            return "semibold"
        }else{
            return ""
        }
        
    }
    
    func ToFullName()->String{
        if (self == Font.Weight.regular){
            return "SF Pro Text Regular"
        }
        else if (self == Font.Weight.semibold){
            return "SF Pro Text Semibold"
        }else{
            return ""
        }
    }
}
