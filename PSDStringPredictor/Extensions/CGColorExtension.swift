//
//  CGColorExtension.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 27/11/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import SwiftUI

extension CGColor: Comparable{
    
    public static func < (lhs: CGColor, rhs: CGColor) -> Bool {
        return  lhs.GetLightness() <  rhs.GetLightness()
    }
    
    public static func == (lhs: CGColor, rhs: CGColor) -> Bool {
        return  CGFloat(Int(lhs.GetLightness() * 100)) / 100  ==  CGFloat(Int(rhs.GetLightness() * 100)) / 100
    }
    
    
    func GetLightness() -> CGFloat{
        var min: CGFloat = 1
        var max: CGFloat = 0
        if self.numberOfComponents == 3{
            for tmp in self.components! {
                if tmp > max{
                    max = tmp
                }
                if tmp < min{
                    min = tmp
                }
            }
            
            return (min + max)/2
        }
        return 1
        //return 0
        
    }
    
    func ToColor()->Color{

        let tmpNSC = NSColor.init(cgColor: self)
        let tempC = Color.init(tmpNSC!)
        return tempC
        
        //return Color.init(red: Double(self.components![0]), green: Double(self.components![1]), blue: Double(self.components![2]))
    }
    
    func ToReversedColor()->Color{
        let newColor = CGColor.init(red: 1 - self.components![0], green: 1 - self.components![1], blue: 1 - self.components![2], alpha: 1)
        let tmpNSC = NSColor.init(cgColor: newColor)
        let tempC = Color.init(tmpNSC!)
        return tempC
        
        //return Color.init(red: Double(self.components![0]), green: Double(self.components![1]), blue: Double(self.components![2]))
    }
    
    func ToGenericRGB()->CGColor{
        let sp2 = CGColorSpace(name:CGColorSpace.genericRGBLinear)!
        let c2 = self.converted(to: sp2, intent: .relativeColorimetric, options: nil)!
        return c2
    }
    
    func ToString()->String{
        return "\(String(describing: self.colorSpace?.name)),\(self.components![0])-\(self.components![1])-\(self.components![2])"
//        let str = String(self.components[0]!) + "," + String(self.components[1]!) + "," + String(self.components[2]!)
//        return str
    }
    
    func toArray()->[CGFloat]{
        return [self.components![0],  self.components![1],  self.components![2],  self.components![3]]
    }
    func toFloatArray()->[Float]{
        return [Float(self.components![0]),  Float(self.components![1]),  Float(self.components![2]),  Float(self.components![3])]
    }
    
    func toCIColor()->CIColor{
        CIColor(red: self.components![0], green: self.components![1], blue: self.components![2], alpha: self.components![3])
    }
}
