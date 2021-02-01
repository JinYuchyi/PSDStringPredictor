//
//  CGRectExtension.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 19/11/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreImage
extension CGRect: Hashable{

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.minX)
        hasher.combine(self.minY)
    }
    
    func IsSame(target rect: CGRect) -> Bool {
        if ( abs(self.midX - rect.midX) < 20 && abs(self.midY - rect.midY) < 20 ) {
            return true
        }
        
        if (self.maxX - rect.maxX) * (self.maxX - rect.maxX) + (self.maxY - rect.maxY) * (self.maxY - rect.maxY) < 100 {
            return true
        }
        
        if (self.minX - rect.minX) * (self.minX - rect.minX) + (self.minY - rect.minY) * (self.minY - rect.minY) < 100 {
            return true
        }
        
        return false

    }
    
    func FlipPosition( forX: Bool, forY: Bool) -> CGRect{
        var x = self.minX
        var y = self.minY
        if forX == true {
            x = imageProcessViewModel.targetNSImage.size.width - x
        }
        if forY == true {
            y = imageProcessViewModel.targetNSImage.size.height - y
        }
        
        return CGRect.init(x: x, y: y, width: self.width, height: self.height)
    }
    
    func ToCIVector() -> CIVector{
        return CIVector.init(x: self.minX, y: self.minY, z: self.width, w: self.height)
    }
}
