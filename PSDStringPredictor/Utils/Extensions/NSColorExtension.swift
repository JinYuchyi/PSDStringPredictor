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
    
    func ToColor()->Color{
        let c = Color.init(red: Double(self.redComponent * 255), green: Double(self.greenComponent * 255), blue: Double(self.blueComponent * 255))
        return c
    }
    
    func toCIColor() -> CIColor{
        return CIColor.init(color: self) ?? CIColor.init()
    }
    
    func getHSV() -> (CGFloat, CGFloat, CGFloat){
        let color = NSColor(red: self.redComponent, green: self.greenComponent, blue: self.blueComponent, alpha: 1)
        var hue: CGFloat = 0
        var sat: CGFloat = 0
        var brightness: CGFloat = 0
        color.getHue(&hue, saturation: &sat, brightness: &brightness, alpha: nil)
//        let s: CGFloat = color.getHue(nil, saturation: &sat, brightness: nil, alpha: nil)
//        let b: CGFloat = color.getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
        return (hue, sat, brightness)
    }
}
