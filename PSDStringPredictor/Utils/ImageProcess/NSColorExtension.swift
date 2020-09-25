//
//  NSColorExtension.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 25/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import SwiftUI

extension NSColor{
    
    func ToGrayScale() -> CGFloat{
        
        let gray = 0.3 * self.redComponent + self.greenComponent * 0.59 + 0.11 * self.blueComponent
         return gray
     }
}
